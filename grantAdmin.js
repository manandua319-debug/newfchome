const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./firebase/serviceAccountKey.json'); // You'll need to download this from Firebase Console
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'fchome-472b6'
});

async function grantAdmin(uid) {
  try {
    // Set custom claim for admin
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    console.log(`✅ Admin privileges granted to user: ${uid}`);
    console.log('⚠️  User must sign out and sign back in for changes to take effect.');
  } catch (error) {
    console.error('❌ Error granting admin privileges:', error);
  }
}

// Usage: node grantAdmin.js <uid>
const uid = process.argv[2];
if (!uid) {
  console.log('Usage: node grantAdmin.js <user-uid>');
  console.log('To get user UID: Check Firebase Console > Authentication > Users');
  process.exit(1);
}

grantAdmin(uid).then(() => {
  console.log('Done!');
  process.exit(0);
});