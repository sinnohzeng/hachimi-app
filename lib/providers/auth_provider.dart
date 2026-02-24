import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/services/auth_service.dart';

// Re-export service_providers so existing imports continue to work.
export 'package:hachimi_app/providers/service_providers.dart';

/// Auth service — singleton
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Auth state — SSOT for current user authentication.
/// Streams from Firebase Auth state changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Current user UID — convenience provider.
/// [A4] 在 auth loading/error 状态下使用缓存 UID 实现乐观认证。
/// 增加本地访客 UID 回退，保证离线首次安装也能获取 UID。
final currentUidProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  final prefs = ref.read(sharedPreferencesProvider);

  return authState.when(
    data: (user) =>
        user?.uid ??
        prefs.getString('local_guest_uid') ??
        prefs.getString('cached_uid'),
    loading: () => prefs.getString('cached_uid'),
    error: (_, _) =>
        prefs.getString('local_guest_uid') ?? prefs.getString('cached_uid'),
  );
});

/// 当前用户是否为访客（未关联正式凭证）。
///
/// 覆盖三种场景：
/// 1. 本地访客 — Firebase 未认证，local_guest_uid 存在
/// 2. Firebase 匿名 — signInAnonymously 成功，尚未关联凭证
/// 3. 已注册用户 — 关联了 Google/Email 凭证 → 返回 false
///
/// 监听 [authStateProvider]，auth 状态变化时自动重算。
final isGuestProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) return user.isAnonymous;
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getString('local_guest_uid') != null;
});
