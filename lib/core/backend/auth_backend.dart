/// 认证后端抽象接口 — 策略模式。
///
/// 每个云平台（Firebase、CloudBase 等）实现此接口。
/// [AuthService] 仅依赖此抽象，永远不直接导入具体实现。
abstract class AuthBackend {
  /// 后端标识名（如 'firebase'、'cloudbase'）。
  String get id;

  /// 当前用户 UID，未登录时返回 null。
  String? get currentUid;

  /// 当前用户邮箱。
  String? get currentEmail;

  /// 当前用户显示名称。
  String? get currentDisplayName;

  /// 是否已登录。
  bool get isSignedIn;

  /// 是否匿名用户。
  bool get isAnonymous;

  /// 监听认证状态变更。
  Stream<AuthUser?> get authStateChanges;

  /// 初始化第三方登录 SDK（如 GoogleSignIn）。
  Future<void> initializeSocialLogin();

  /// 邮箱注册。
  Future<AuthResult> signUp({required String email, required String password});

  /// 邮箱登录。
  Future<AuthResult> signIn({required String email, required String password});

  /// Google 登录。用户取消时返回 null。
  Future<AuthResult?> signInWithGoogle();

  /// 匿名登录。
  Future<AuthResult> signInAnonymously();

  /// 将匿名账号关联 Google 凭证。用户取消时返回 null。
  Future<AuthResult?> linkWithGoogle();

  /// 将匿名账号关联 Email/Password 凭证。
  Future<AuthResult> linkWithEmail({
    required String email,
    required String password,
  });

  /// 更新显示名称。
  Future<void> updateDisplayName(String name);

  /// 登出。
  Future<void> signOut();

  /// 删除当前用户账号。
  Future<void> deleteAccount();
}

/// 认证结果 — 平台无关的用户信息。
class AuthResult {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isNewUser;

  const AuthResult({
    required this.uid,
    this.email,
    this.displayName,
    this.isNewUser = false,
  });
}

/// 认证用户 — 平台无关的用户快照。
class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isAnonymous;

  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.isAnonymous = false,
  });
}
