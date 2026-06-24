import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AuthService {
  AuthService._();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> authStateChanges() => _auth.authStateChanges();
  static Stream<User?> userChanges() => _auth.userChanges();

  static Future<User?> signUp(
      {required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  static Future<User?> signIn(
      {required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  static Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
    }
  }

  static Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Calls a callable Cloud Function `deleteUserData` which should remove
  /// the user's Firestore documents and delete the Auth user server-side.
  static Future<void> deleteAccount() async {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('deleteUserData');
    await callable.call();
    // After server-side deletion, sign out locally.
    try {
      await signOut();
    } catch (_) {}
  }
}
