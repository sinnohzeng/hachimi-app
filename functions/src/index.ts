import * as admin from "firebase-admin";
import { HttpsError, onCall } from "firebase-functions/v2/https";

admin.initializeApp();

const db = admin.firestore();

export const deleteAccountV1 = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  await deleteUserData(uid);
  await deleteAuthUser(uid);
  return { ok: true };
});

export const wipeUserDataV1 = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  await deleteUserData(uid);
  return { ok: true };
});

function requireAuthUid(uid: string | undefined): string {
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  return uid;
}

async function deleteUserData(uid: string): Promise<void> {
  const userRef = db.collection("users").doc(uid);
  const snapshot = await userRef.get();
  if (!snapshot.exists) return;
  await deleteDocumentRecursively(userRef);
}

async function deleteDocumentRecursively(
  docRef: FirebaseFirestore.DocumentReference,
): Promise<void> {
  const collections = await docRef.listCollections();
  for (const collection of collections) {
    await deleteCollectionRecursively(collection);
  }
  await deleteDocument(docRef);
}

async function deleteCollectionRecursively(
  collection: FirebaseFirestore.CollectionReference,
): Promise<void> {
  const batchSize = 200;
  while (true) {
    const snapshot = await collection.limit(batchSize).get();
    if (snapshot.empty) return;
    for (const doc of snapshot.docs) {
      await deleteDocumentRecursively(doc.ref);
    }
  }
}

async function deleteDocument(
  docRef: FirebaseFirestore.DocumentReference,
): Promise<void> {
  try {
    await docRef.delete();
  } catch (error) {
    if (isFirestoreNotFound(error)) return;
    throw error;
  }
}

function isFirestoreNotFound(error: unknown): boolean {
  if (typeof error !== "object" || error == null) return false;
  const maybeCode = (error as { code?: unknown }).code;
  return maybeCode == 5 || maybeCode == "not-found";
}

async function deleteAuthUser(uid: string): Promise<void> {
  try {
    await admin.auth().deleteUser(uid);
  } catch (error) {
    if (isAuthUserNotFound(error)) return;
    throw error;
  }
}

function isAuthUserNotFound(error: unknown): boolean {
  if (typeof error !== "object" || error == null) return false;
  const maybeCode = (error as { code?: unknown }).code;
  return maybeCode == "auth/user-not-found";
}

export const __test__ = {
  isAuthUserNotFound,
  isFirestoreNotFound,
  requireAuthUid,
};
