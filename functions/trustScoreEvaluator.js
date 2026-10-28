/**
 * Trust Score Evaluation Function
 * Evaluates user behavior to determine if transport request should be approved
 * 
 * This is a PREMIUM AI MODEL - currently using mock logic that always approves
 * In production, replace with actual ML model
 */

const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");

initializeApp();

/**
 * Mock AI Model for Trust Score Evaluation
 * 
 * In production, replace this with:
 * - TensorFlow.js model
 * - Google Cloud AI Platform
 * - Custom ML model endpoint
 * - Anomaly detection algorithm
 */
function evaluateTrustScore(behaviorSummary, transportRequestData) {
  // MOCK IMPLEMENTATION - Currently always approves
  // This is where you'd integrate your real AI model
  
  const {
    totalBehaviors,
    behaviorCounts,
    uniqueServiceViews,
    uniqueDestinations,
    hasDirectionsUsed,
    hasServiceCalls,
    timingMetrics,
  } = behaviorSummary;

  // Calculate trust score (0-100)
  let score = 0;
  const factors = [];

  // Factor 1: Service Detail Views (shows engagement)
  // +20 points if viewed multiple services
  if (uniqueServiceViews >= 3) {
    score += 20;
    factors.push('viewed_multiple_services');
  } else if (uniqueServiceViews >= 1) {
    score += 10;
    factors.push('viewed_services');
  }

  // Factor 2: Used Directions (shows intent to visit)
  // +15 points
  if (hasDirectionsUsed) {
    score += 15;
    factors.push('used_directions');
  }

  // Factor 3: Called Services (high engagement signal)
  // +20 points
  if (hasServiceCalls) {
    score += 20;
    factors.push('called_services');
  }

  // Factor 4: Selected Eligible Destinations
  // +15 points if selected destinations match service locations
  if (uniqueDestinations >= 1) {
    score += 15;
    factors.push('selected_destinations');
  }

  // Factor 5: Realistic Timing Patterns
  // +20 points if behavior timing is realistic (not spamming)
  if (timingMetrics && !timingMetrics.hasSpamPattern) {
    score += 20;
    factors.push('realistic_timing');
  } else if (totalBehaviors === 0) {
    // First-time user - give baseline score
    score = 50;
    factors.push('first_time_user');
  }

  // Factor 6: Destination Alignment
  // +10 points if transport request aligns with previously viewed services
  const requestedDestination = transportRequestData?.destinationAddress || '';
  if (requestedDestination && uniqueDestinations > 0) {
    score += 10;
    factors.push('destination_alignment');
  }

  // Minimum score for first-time users
  if (totalBehaviors === 0) {
    score = Math.max(score, 50); // Baseline trust for new users
  }

  // Cap at 100
  score = Math.min(score, 100);

  // Determine approval
  // THRESHOLD: 50+ = approved (currently set low for testing)
  // In production, you might want 70+ or higher
  const approved = score >= 50;

  return {
    approved,
    trustScore: score,
    factors,
    reasoning: _generateReasoning(approved, score, factors, behaviorSummary),
    modelVersion: '1.0.0-mock', // Update when you add real AI
  };
}

function _generateReasoning(approved, score, factors, behaviorSummary) {
  if (approved) {
    if (factors.length === 0) {
      return 'Baseline trust score for new user. Request approved.';
    }
    return `Approved based on: ${factors.join(', ')}. Trust score: ${score}/100`;
  } else {
    return `Not approved. Trust score ${score}/100. Insufficient engagement signals.`;
  }
}

/**
 * Cloud Function: Evaluate Trust Score for Transport Request
 */
exports.evaluateTrustScore = onCall(async (request) => {
  try {
    // Verify user is authenticated
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    const userId = request.auth.uid;
    const { destinationAddress, agencyId, fareLabel } = request.data || {};

    if (!destinationAddress || !agencyId) {
      throw new HttpsError('invalid-argument', 'destinationAddress and agencyId required');
    }

    const firestore = getFirestore();

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

    // Calculate behavior summary (server-side for security)
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

    // Evaluate trust score using AI model
    const evaluation = evaluateTrustScore(behaviorSummary, {
      destinationAddress,
      agencyId,
      fareLabel,
    });

    console.log(`Trust score evaluation for ${userId}:`, {
      approved: evaluation.approved,
      score: evaluation.trustScore,
      factors: evaluation.factors,
    });

    return {
      approved: evaluation.approved,
      trustScore: evaluation.trustScore,
      factors: evaluation.factors,
      reasoning: evaluation.reasoning,
      modelVersion: evaluation.modelVersion,
      behaviorSummary: {
        totalBehaviors: behaviorSummary.totalBehaviors,
        uniqueServiceViews: behaviorSummary.uniqueServiceViews,
        uniqueDestinations: behaviorSummary.uniqueDestinations,
        hasDirectionsUsed: behaviorSummary.hasDirectionsUsed,
        hasServiceCalls: behaviorSummary.hasServiceCalls,
      },
    };

  } catch (error) {
    console.error('Error evaluating trust score:', error);
    
    if (error instanceof HttpsError) {
      throw error;
    }
    
    throw new HttpsError('internal', 'An internal error occurred while evaluating trust score');
  }
});
