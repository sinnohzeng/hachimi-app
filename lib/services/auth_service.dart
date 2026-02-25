import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  /// 更新当前用户的显示名称。
  /// 更新 Firebase Auth profile 后 reload，确保 authStateChanges 发出更新后的 User。
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateDisplayName(name);
    await user.reload();
  }

  /// 是否是匿名用户（访客模式）。
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  /// 匿名登录（访客模式）。
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// 确保存在 Firebase 匿名用户。
  /// 乐观认证下 _autoSignInAnonymously 可能尚未完成，此方法作为保底。
  Future<User> _ensureCurrentUser() async {
    final existing = _auth.currentUser;
    if (existing != null) return existing;
    debugPrint(
      '[AUTH] currentUser is null, signing in anonymously before link',
    );
    final cred = await _auth.signInAnonymously();
    return cred.user!;
  }

  /// 将匿名账号关联 Google 凭证，升级为正式用户。
  /// 关联成功后 isAnonymous 变为 false。
  /// 返回 null 仅当用户取消 Google 登录。
  Future<UserCredential?> linkWithGoogle() async {
    final user = await _ensureCurrentUser();
    try {
      await _googleSignIn.initialize();
      final googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await user.linkWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  /// 将匿名账号关联 Email/Password 凭证，升级为正式用户。
  Future<UserCredential> linkWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await _ensureCurrentUser();
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    return await user.linkWithCredential(credential);
  }

  /// Delete the current user's account.
  /// May throw a FirebaseAuthException requiring re-authentication.
  Future<void> deleteAccount() async {
    await _googleSignIn.signOut();
    await _auth.currentUser?.delete();
  }
}
