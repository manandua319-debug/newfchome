const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  await firestore.collection("users").doc(user.uid).delete();
});

// Create transit ticket request function
exports.createTTRequest = functions.https.onCall(async (data, context) => {
  try {
    // Verify user is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Validate required parameters
    const { phone, agencyId, destination, fareLabel } = data;
    
    if (!phone || !agencyId || !destination || !fareLabel) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing required parameters');
    }

    // Validate phone number format (basic validation)
    const phoneRegex = /^\+?[\d\s\-\(\)]+$/;
    if (!phoneRegex.test(phone)) {
      throw new functions.https.HttpsError('invalid-argument', 'Invalid phone number format');
    }

    // Validate agency
    const validAgencies = ['VTA', 'Muni', 'SamTrans', 'Caltrain', 'BART'];
    if (!validAgencies.includes(agencyId)) {
      throw new functions.https.HttpsError('invalid-argument', 'Invalid transit agency');
    }

    // Create the request document
    const firestore = admin.firestore();
    const requestData = {
      phone: phone,
      agencyId: agencyId,
      destination: destination,
      fareLabel: fareLabel,
      userId: context.auth.uid,
      status: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };

    // Add to requests collection
    const docRef = await firestore.collection('ttRequests').add(requestData);

    // Return the request ID
    return {
      id: docRef.id,
      message: 'Transit ticket request created successfully'
    };

  } catch (error) {
    console.error('Error creating TT request:', error);
    
    // If it's already an HttpsError, re-throw it 
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    
    // Otherwise, wrap it in an HttpsError
    throw new functions.https.HttpsError('internal', 'An internal error occurred while creating the request');
  }
});
