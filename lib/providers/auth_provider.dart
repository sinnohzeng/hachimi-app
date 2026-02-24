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

/// 当前用户是否为本地访客（尚未完成 Firebase 认证）。
final isLocalGuestProvider = Provider<bool>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getString('local_guest_uid') != null;
});

/// 当前用户是否为匿名（访客模式）。
final isAnonymousProvider = Provider<bool>((ref) {
  return ref.watch(authServiceProvider).isAnonymous;
});
