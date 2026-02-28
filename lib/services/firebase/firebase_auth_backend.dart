import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';

/// Firebase 认证后端实现。
class FirebaseAuthBackend implements AuthBackend {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  String get id => 'firebase';

  @override
  String? get currentUid => _auth.currentUser?.uid;

  @override
  String? get currentEmail => _auth.currentUser?.email;

  @override
  String? get currentDisplayName => _auth.currentUser?.displayName;

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  @override
  Stream<AuthUser?> get authStateChanges =>
      _auth.authStateChanges().map(_mapUser);

  @override
  Future<void> initializeSocialLogin() async {
    await _googleSignIn.initialize();
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapResult(result);
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapResult(result);
  }

  @override
  Future<AuthResult?> signInWithGoogle() async {
    try {
      final credential = await _getGoogleCredential();
      final result = await _auth.signInWithCredential(credential);
      return _mapResult(result);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return _mapResult(result);
  }

  @override
  Future<AuthResult?> linkWithGoogle() async {
    try {
      final credential = await _getGoogleCredential();
      final user = _auth.currentUser;
      if (user != null) {
        final result = await user.linkWithCredential(credential);
        return _mapResult(result);
      }
      final result = await _auth.signInWithCredential(credential);
      return _mapResult(result);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<AuthResult> linkWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    final user = _auth.currentUser;
    if (user != null) {
      final result = await user.linkWithCredential(credential);
      return _mapResult(result);
    }
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapResult(result);
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateDisplayName(name);
    await user.reload();
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _googleSignIn.signOut();
    await _auth.currentUser?.delete();
  }

  @override
  List<String> get providerIds =>
      _auth.currentUser?.providerData.map((i) => i.providerId).toList() ?? [];

  @override
  Future<bool> reauthenticateWithGoogle() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final credential = await _getGoogleCredential();
      await user.reauthenticateWithCredential(credential);
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      rethrow;
    }
  }

  @override
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  /// Google 初始化 + 认证 + credential 获取（共享逻辑）。
  Future<AuthCredential> _getGoogleCredential() async {
    await _googleSignIn.initialize();
    final googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;
    return GoogleAuthProvider.credential(idToken: idToken);
  }

  AuthResult _mapResult(UserCredential result) {
    return AuthResult(
      uid: result.user!.uid,
      email: result.user?.email,
      displayName: result.user?.displayName,
      isNewUser: result.additionalUserInfo?.isNewUser ?? false,
    );
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isAnonymous: user.isAnonymous,
    );
  }
}
