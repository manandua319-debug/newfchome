// Simple script to grant admin access
// Run this in your browser console on the Firebase Console page

// 1. Go to Firebase Console → Authentication → Users
// 2. Find your user account and copy the UID
// 3. Open browser console (F12)
// 4. Paste this code and run it:

const admin = require('firebase-admin');

// You'll need to download the service account key from:
// Firebase Console → Project Settings → Service Accounts → Generate new private key
// Save it as 'serviceAccountKey.json' in this directory

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'fchome-472b6'
});

async function grantAdminAccess(userUid) {
  try {
    // Set custom claim for admin
    await admin.auth().setCustomUserClaims(userUid, { admin: true });
    console.log(`✅ Admin privileges granted to user: ${userUid}`);
    console.log('⚠️  User must sign out and sign back in for changes to take effect.');
  } catch (error) {
    console.error('❌ Error granting admin privileges:', error);
  }
}

// Replace 'YOUR_USER_UID' with your actual UID from Firebase Console
const userUid = 'YOUR_USER_UID'; // <-- Replace this with your UID

grantAdminAccess(userUid).then(() => {
  console.log('Done!');
  process.exit(0);
});

