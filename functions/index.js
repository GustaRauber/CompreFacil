const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteUserData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated",
    );
  }

  const uid = context.auth.uid;
  const db = admin.firestore();
  const userDocRef = db.doc(`users/${uid}`);

  try {
    // Attempt recursive delete if available (may require updated Admin SDK)
    if (db.recursiveDelete) {
      await db.recursiveDelete(userDocRef);
    } else if (admin.firestore().recursiveDelete) {
      await admin.firestore().recursiveDelete(userDocRef);
    } else {
      // Fallback: delete the user document only
      await userDocRef.delete();
    }
  } catch (err) {
    console.error("Error deleting user data:", err);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to delete user data",
    );
  }

  try {
    await admin.auth().deleteUser(uid);
  } catch (err) {
    console.error("Error deleting auth user:", err);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to delete auth user",
    );
  }

  return { success: true };
});
