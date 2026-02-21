import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// AuthService — wraps Firebase Auth operations.
/// SSOT for authentication is FirebaseAuth.instance.authStateChanges().
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Must be called once at app startup (after Firebase.initializeApp).
  Future<void> initializeGoogleSignIn() async {
    await _googleSignIn.initialize();
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign in with Google. Returns null if the user cancelled the sign-in flow.
  /// [A2] 保底初始化：若 DeferredInit 尚未完成，确保 GoogleSignIn 已初始化。
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(); // 幂等，多次调用安全
      final googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null; // User cancelled
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    // signOut() is safe to call even if not signed in with Google
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Delete the current user's account.
  /// May throw a FirebaseAuthException requiring re-authentication.
  Future<void> deleteAccount() async {
    await _googleSignIn.signOut();
    await _auth.currentUser?.delete();
  }
}
