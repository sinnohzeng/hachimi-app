/// 应用认证状态 — sealed class 替代 boolean isGuest。
///
/// 用模式匹配消除"登出过渡态"盲区：
/// - [GuestState] — 本地访客，无 Firebase 用户，纯离线
/// - [AuthenticatedState] — Firebase 已认证（Google / Email）
sealed class AppAuthState {
  const AppAuthState();

  /// 当前用户 UID（guest_xxxx 或 Firebase UID）。
  String get uid;

  /// 是否为访客。
  bool get isGuest;
}

/// 本地访客 — 无 Firebase 用户，纯离线可用。
class GuestState extends AppAuthState {
  @override
  final String uid;

  const GuestState({required this.uid});

  @override
  bool get isGuest => true;
}

/// 已认证用户 — Firebase Google/Email 登录。
class AuthenticatedState extends AppAuthState {
  @override
  final String uid;
  final String? email;
  final String? displayName;

  const AuthenticatedState({required this.uid, this.email, this.displayName});

  @override
  bool get isGuest => false;
}
