import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// 1️⃣ User requests a Token Transit pass
export const createTTRequest = functions.https.onCall(async (data, context) => {
  const { phone, agencyId, destination } = data || {};

  if (!phone || typeof phone !== "string") {
    throw new functions.https.HttpsError("invalid-argument", "Phone number required");
  }

  const docRef = await db.collection("tt_requests").add({
    uid: context.auth?.uid ?? null,
    phone,
    agencyId: agencyId || "default_agency",
    destination: destination || "unknown",
    status: "pending",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true, requestId: docRef.id };
});

// 2️⃣ Admin approves and issues the pass
export const approveTTRequest = functions.https.onCall(async (data, context) => {
  if (!context.auth?.token?.admin) {
    throw new functions.https.HttpsError("permission-denied", "Admin access only");
  }

  const { requestId } = data || {};
  if (!requestId) {
    throw new functions.https.HttpsError("invalid-argument", "Missing requestId");
  }

  await db.collection("tt_requests").doc(requestId).update({
    status: "approved",
    approvedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true };
});
