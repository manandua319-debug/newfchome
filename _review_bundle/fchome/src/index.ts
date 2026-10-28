import * as admin from "firebase-admin";
import { onRequest, onCall, HttpsError } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2/options";
import * as logger from "firebase-functions/logger";

// keep this EXACT call (spacing doesn’t matter)
setGlobalOptions({ maxInstances: 10 });

admin.initializeApp();
const db = admin.firestore();

/* ------------------------------------------------------------------ */
/* Health check (uses onRequest + logger so those imports are in use)  */
/* GET https://<region>-<project>.cloudfunctions.net/healthcheck       */
/* ------------------------------------------------------------------ */
export const healthcheck = onRequest((request, response) => {
  if (request.method !== "GET") {
    logger.warn("Unsupported method for healthcheck", { method: request.method });
    response.set("Allow", "GET");
    response.status(405).send("Method Not Allowed");
    return;
  }

  logger.info("Healthcheck ping", { ip: request.ip || request.headers["x-forwarded-for"] });
  response.status(200).json({ status: "ok", timestamp: new Date().toISOString() });
});

/* ------------------------------------------------------------------ */
/* Callable (v2): user creates a Token Transit request                 */
/* request.data: { phone, agencyId, destination?, fareLabel? }         */
/* ------------------------------------------------------------------ */
export const createTTRequest = onCall(async (request) => {
  const auth = request.auth;
  if (!auth) {
    throw new HttpsError("unauthenticated", "Sign in required");
  }

  const data = (request.data || {}) as {
    phone?: string;
    agencyId?: string;
    destination?: string;
    fareLabel?: string;
  };

  const phone = typeof data.phone === "string" ? data.phone.trim() : "";
  const agencyId = typeof data.agencyId === "string" ? data.agencyId.trim() : "";
  const destination = typeof data.destination === "string" ? data.destination.trim() : "unknown";
  const fareLabel = typeof data.fareLabel === "string" ? data.fareLabel.trim() : "Single Ride";

  if (!phone || !agencyId) {
    throw new HttpsError("invalid-argument", "phone & agencyId required");
  }

  const doc = await db.collection("tt_requests").add({
    uid: auth.uid,
    phone,
    agencyId,
    destination,
    fareLabel,
    status: "pending",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { id: doc.id };
});

/* ------------------------------------------------------------------ */
/* Callable (v2): admins approve a request                             */
/* request.data: { requestId }                                         */
/* ------------------------------------------------------------------ */
export const approveTTRequest = onCall(async (request) => {
  const auth = request.auth;
  const isAdmin = !!(auth && auth.token && (auth.token as any).admin === true);
  if (!isAdmin) {
    throw new HttpsError("permission-denied", "Admin only");
  }

  const data = (request.data || {}) as { requestId?: string };
  const requestId = typeof data.requestId === "string" ? data.requestId.trim() : "";
  if (!requestId) {
    throw new HttpsError("invalid-argument", "requestId required");
  }

  await db.doc(`tt_requests/${requestId}`).update({
    status: "approved",
    approvedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true };
});
