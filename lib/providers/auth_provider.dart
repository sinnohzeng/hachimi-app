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
/// [A4] 在 auth loading 状态下使用缓存 UID 实现乐观认证。
final currentUidProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user?.uid,
    loading: () {
      // 乐观认证：auth stream 尚未 emit 时使用缓存 UID
      final prefs = ref.read(sharedPreferencesProvider);
      return prefs.getString('cached_uid');
    },
    error: (_, _) => null,
  );
});
