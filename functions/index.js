const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");

initializeApp();

// Valid agencies (verify Token Transit supports each before going live)
const VALID_AGENCIES = ['VTA', 'Muni', 'SamTrans', 'Caltrain', 'BART'];

// Rate limiting: 1 request per 24 hours per user per agency
const RATE_LIMIT_HOURS = 24;

// MANUAL FULFILLMENT: Create pending request for staff to fulfill via Token Transit app
exports.createTTRequest = onCall(async (request) => {
  try {
    // Verify user is authenticated
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Validate required parameters
    const { phone, agencyId, destination, fareLabel, accessCode } = request.data;
    
    if (!phone || !agencyId || !destination || !fareLabel || !accessCode) {
      throw new HttpsError('invalid-argument', 'Missing required parameters');
    }

    // Validate access code
    if (accessCode !== 'FCHOME') {
      throw new HttpsError('invalid-argument', 'Invalid access code');
    }

    // Validate phone number format (basic validation)
    const phoneRegex = /^\+?[\d\s\-()]+$/;
    if (!phoneRegex.test(phone)) {
      throw new HttpsError('invalid-argument', 'Invalid phone number format');
    }

    // Normalize phone to digits only for display
    const cleanPhone = phone.replace(/\D/g, '');
    if (cleanPhone.length < 10) {
      throw new HttpsError('invalid-argument', 'Phone number must have at least 10 digits');
    }

    // Validate agency
    if (!VALID_AGENCIES.includes(agencyId)) {
      throw new HttpsError('invalid-argument', 'Invalid transit agency');
    }

    const firestore = getFirestore();
    const userId = request.auth.uid;

    // ===== RATE LIMITING =====
    // Check if user already has a recent request for this agency
    const rateLimitQuery = await firestore
      .collection('ttRequests')
      .where('uid', '==', userId)
      .where('agencyId', '==', agencyId)
      .where('createdAt', '>', new Date(Date.now() - RATE_LIMIT_HOURS * 60 * 60 * 1000))
      .limit(1)
      .get();

    if (!rateLimitQuery.empty) {
      const existingDoc = rateLimitQuery.docs[0];
      const existingData = existingDoc.data();
      
      return {
        id: existingDoc.id,
        message: 'You already have a pending request for this agency. We will send your pass shortly.',
        status: existingData.status,
        isExisting: true
      };
    }

    // ===== TRUST SCORE EVALUATION =====
    // Evaluate user behavior using AI model before approving transport request
    let trustScoreResult;
    try {
      // Get behavior summary from last 7 days
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - 7);
      const cutoffTimestamp = Timestamp.fromDate(cutoffDate);

      const behaviorsQuery = await firestore
        .collection('userBehaviors')
        .where('uid', '==', userId)
        .where('timestamp', '>', cutoffTimestamp)
        .orderBy('timestamp', descending: true)
        .get();

      const behaviors = behaviorsQuery.docs.map(doc => doc.data());

      // Calculate behavior summary
      const behaviorCounts = {};
      const serviceViews = new Set();
      const destinationsSelected = new Set();
      const times = [];
      let hasDirectionsUsed = false;
      let hasServiceCalls = false;

      for (const behavior of behaviors) {
        const type = behavior.behaviorType || '';
        behaviorCounts[type] = (behaviorCounts[type] || 0) + 1;

        if (type === 'service_detail_view') {
          const serviceName = behavior.metadata?.serviceName;
          if (serviceName) serviceViews.add(serviceName);
        }

        if (type === 'destination_selected') {
          const dest = behavior.metadata?.destinationAddress;
          if (dest) destinationsSelected.add(dest);
        }

        if (type === 'directions_used') hasDirectionsUsed = true;
        if (type === 'service_call') hasServiceCalls = true;

        if (behavior.hour != null) times.push(behavior.hour);
      }

      // Calculate timing metrics
      const hourDistribution = {};
      for (const hour of times) {
        hourDistribution[hour] = (hourDistribution[hour] || 0) + 1;
      }

      const uniqueHours = Object.keys(hourDistribution).length;
      const totalBehaviors = behaviors.length;
      const spamThreshold = Math.ceil(totalBehaviors * 0.7);
      let hasSpamPattern = false;

      for (const count of Object.values(hourDistribution)) {
        if (count > spamThreshold) {
          hasSpamPattern = true;
          break;
        }
      }

      const behaviorSummary = {
        totalBehaviors,
        behaviorCounts,
        uniqueServiceViews: serviceViews.size,
        uniqueDestinations: destinationsSelected.size,
        hasDirectionsUsed,
        hasServiceCalls,
        timingMetrics: {
          uniqueHours,
          hourDistribution,
          hasSpamPattern,
          totalBehaviors,
        },
      };

      // Evaluate trust score using AI model (MOCK - currently always approves)
      let score = 0;
      const factors = [];

      if (behaviorSummary.uniqueServiceViews >= 3) {
        score += 20;
        factors.push('viewed_multiple_services');
      } else if (behaviorSummary.uniqueServiceViews >= 1) {
        score += 10;
        factors.push('viewed_services');
      }

      if (hasDirectionsUsed) {
        score += 15;
        factors.push('used_directions');
      }

      if (hasServiceCalls) {
        score += 20;
        factors.push('called_services');
      }

      if (behaviorSummary.uniqueDestinations >= 1) {
        score += 15;
        factors.push('selected_destinations');
      }

      if (behaviorSummary.timingMetrics && !behaviorSummary.timingMetrics.hasSpamPattern) {
        score += 20;
        factors.push('realistic_timing');
      } else if (totalBehaviors === 0) {
        score = 50;
        factors.push('first_time_user');
      }

      if (destination && behaviorSummary.uniqueDestinations > 0) {
        score += 10;
        factors.push('destination_alignment');
      }

      if (totalBehaviors === 0) {
        score = Math.max(score, 50);
      }

      score = Math.min(score, 100);

      // THRESHOLD: 50+ = approved (set low for testing, can increase in production)
      const approved = score >= 50;

      trustScoreResult = {
        approved,
        trustScore: score,
        factors,
        reasoning: approved 
          ? `Approved based on: ${factors.length > 0 ? factors.join(', ') : 'baseline trust'}. Trust score: ${score}/100`
          : `Not approved. Trust score ${score}/100. Insufficient engagement signals.`,
        modelVersion: '1.0.0-mock',
      };

    } catch (trustError) {
      console.error('Trust score evaluation error (non-blocking):', trustError);
      // For now, allow request even if trust evaluation fails
      trustScoreResult = {
        approved: true,
        trustScore: 50,
        reasoning: 'Trust evaluation failed, allowing request',
        factors: ['evaluation_error'],
        modelVersion: '1.0.0-mock',
      };
    }

    // Check if AI approved the request
    if (!trustScoreResult.approved) {
      console.log(`❌ Trust score rejection for ${userId}: ${trustScoreResult.reasoning}`);
      throw new HttpsError(
        'permission-denied',
        `Request not approved by trust score system. ${trustScoreResult.reasoning || 'Insufficient engagement signals.'}`
      );
    }

    console.log(`✅ Trust score approved for ${userId}: Score ${trustScoreResult.trustScore}/100`);

    // ===== CREATE PENDING REQUEST =====
    const requestData = {
      uid: userId,
      phone: phone,
      phoneDigits: cleanPhone, // For easier staff lookup
      agencyId: agencyId,
      destination: destination,
      fareLabel: fareLabel,
      status: 'pending', // Awaiting staff fulfillment
      createdAt: new Date(),
      
      // Trust score fields
      trustScore: trustScoreResult.trustScore,
      trustScoreFactors: trustScoreResult.factors || [],
      trustScoreReasoning: trustScoreResult.reasoning,
      trustScoreModelVersion: trustScoreResult.modelVersion || '1.0.0-mock',
      
      // Fields to be filled by staff after fulfillment
      purchasedAt: null,
      sentAt: null,
      purchaseAmount: null,
      actualProduct: null, // What fare was actually purchased
      fulfilledBy: null, // Staff user ID
      staffNotes: null,
      closedAt: null
    };

    const docRef = await firestore.collection('ttRequests').add(requestData);

    console.log(`✅ Pass request created: ${docRef.id} for ${agencyId} to phone ${cleanPhone}`);

    // ===== RETURN SUCCESS =====
    return {
      id: docRef.id,
      message: "We'll text your mobile pass shortly via Token Transit. If you don't have Token Transit installed, the link will prompt you to install it.",
      status: 'pending',
      isExisting: false
    };

  } catch (error) {
    console.error('Error creating TT request:', error);
    
    // If it's already an HttpsError, re-throw it
    if (error instanceof HttpsError) {
      throw error;
    }
    
    // Otherwise, wrap it in an HttpsError
    throw new HttpsError('internal', 'An internal error occurred while creating the request');
  }
});

// Mark request as purchased (staff bought pass in Token Transit app)
exports.markPassPurchased = onCall(async (request) => {
  try {
    // Verify user is authenticated
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Check if user has admin claim
    const adminClaim = request.auth.token.admin;
    if (!adminClaim) {
      throw new HttpsError('permission-denied', 'Admin access required');
    }

    // Validate required parameters
    const { requestId, purchaseAmount, actualProduct, staffNotes } = request.data;
    
    if (!requestId) {
      throw new HttpsError('invalid-argument', 'Request ID is required');
    }

    const firestore = getFirestore();
    const requestRef = firestore.collection('ttRequests').doc(requestId);

    // Get the current request
    const requestDoc = await requestRef.get();
    if (!requestDoc.exists) {
      throw new HttpsError('not-found', 'Request not found');
    }

    const requestData = requestDoc.data();
    if (requestData.status !== 'pending') {
      throw new HttpsError('invalid-argument', 'Request is not pending');
    }

    // Update the request to purchased
    await requestRef.update({
      status: 'purchased',
      purchasedAt: new Date(),
      purchaseAmount: purchaseAmount || null,
      actualProduct: actualProduct || requestData.fareLabel,
      fulfilledBy: request.auth.uid,
      staffNotes: staffNotes || null
    });

    console.log(`✅ Pass marked as purchased: ${requestId} by ${request.auth.uid}`);

    return {
      id: requestId,
      message: 'Pass marked as purchased. Remember to send it via Token Transit app!',
      status: 'purchased'
    };

  } catch (error) {
    console.error('Error marking pass as purchased:', error);
    
    if (error instanceof HttpsError) {
      throw error;
    }
    
    throw new HttpsError('internal', 'An internal error occurred');
  }
});

// Mark request as sent (staff sent pass via Token Transit app)
exports.markPassSent = onCall(async (request) => {
  try {
    // Verify user is authenticated
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Check if user has admin claim
    const adminClaim = request.auth.token.admin;
    if (!adminClaim) {
      throw new HttpsError('permission-denied', 'Admin access required');
    }

    // Validate required parameters
    const { requestId, staffNotes } = request.data;
    
    if (!requestId) {
      throw new HttpsError('invalid-argument', 'Request ID is required');
    }

    const firestore = getFirestore();
    const requestRef = firestore.collection('ttRequests').doc(requestId);

    // Get the current request
    const requestDoc = await requestRef.get();
    if (!requestDoc.exists) {
      throw new HttpsError('not-found', 'Request not found');
    }

    const requestData = requestDoc.data();
    if (requestData.status !== 'purchased' && requestData.status !== 'pending') {
      throw new HttpsError('invalid-argument', 'Request must be purchased or pending to mark as sent');
    }

    // Update the request to sent
    const updateData = {
      status: 'sent',
      sentAt: new Date(),
      fulfilledBy: request.auth.uid
    };

    // If going straight from pending to sent (combined step)
    if (requestData.status === 'pending') {
      updateData.purchasedAt = new Date();
    }

    if (staffNotes) {
      updateData.staffNotes = staffNotes;
    }

    await requestRef.update(updateData);

    console.log(`✅ Pass marked as sent: ${requestId} by ${request.auth.uid}`);

    return {
      id: requestId,
      message: 'Pass marked as sent! User should receive Token Transit SMS shortly.',
      status: 'sent'
    };

  } catch (error) {
    console.error('Error marking pass as sent:', error);
    
    if (error instanceof HttpsError) {
      throw error;
    }
    
    throw new HttpsError('internal', 'An internal error occurred');
  }
});

// Close request (mark as completed or cancelled)
exports.closePassRequest = onCall(async (request) => {
  try {
    // Verify user is authenticated
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Check if user has admin claim
    const adminClaim = request.auth.token.admin;
    if (!adminClaim) {
      throw new HttpsError('permission-denied', 'Admin access required');
    }

    // Validate required parameters
    const { requestId, finalStatus, staffNotes } = request.data;
    
    if (!requestId || !finalStatus) {
      throw new HttpsError('invalid-argument', 'Request ID and final status are required');
    }

    if (!['closed', 'cancelled'].includes(finalStatus)) {
      throw new HttpsError('invalid-argument', 'Final status must be closed or cancelled');
    }

    const firestore = getFirestore();
    const requestRef = firestore.collection('ttRequests').doc(requestId);

    // Get the current request
    const requestDoc = await requestRef.get();
    if (!requestDoc.exists) {
      throw new HttpsError('not-found', 'Request not found');
    }

    // Update the request
    await requestRef.update({
      status: finalStatus,
      closedAt: new Date(),
      staffNotes: staffNotes || null
    });

    console.log(`✅ Pass request closed: ${requestId} as ${finalStatus}`);

    return {
      id: requestId,
      message: `Request ${finalStatus}`,
      status: finalStatus
    };

  } catch (error) {
    console.error('Error closing pass request:', error);
    
    if (error instanceof HttpsError) {
      throw error;
    }
    
    throw new HttpsError('internal', 'An internal error occurred');
  }
});
