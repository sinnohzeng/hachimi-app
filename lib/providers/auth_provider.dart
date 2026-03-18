import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/models/app_auth_state.dart';
import 'package:hachimi_app/providers/service_providers.dart';

// Re-export service_providers so existing imports continue to work.
export 'package:hachimi_app/providers/service_providers.dart';

/// Auth state — SSOT for current user authentication.
/// Streams from AuthBackend auth state changes.
final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authBackendProvider).authStateChanges;
});

/// 应用认证状态 — 单一 SSOT，替代原来的 5 层身份回退链。
///
/// 组合 Firebase Auth stream + 本地访客 UID，输出 sealed class：
/// - [AuthenticatedState] — Firebase 已认证（Google / Email）
/// - [GuestState] — 本地访客（uid 非空）或未初始化（uid 为空）
final appAuthStateProvider = Provider<AppAuthState>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return AuthenticatedState(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
  final guestUid = ref
      .read(sharedPreferencesProvider)
      .getString(AppPrefsKeys.localGuestUid);
  return GuestState(uid: guestUid ?? '');
});

/// Current user UID — 向后兼容派生 provider。
///
/// 从 [appAuthStateProvider] 单一来源派生，26+ 文件无需改动。
final currentUidProvider = Provider<String?>((ref) {
  final state = ref.watch(appAuthStateProvider);
  return state.uid.isEmpty ? null : state.uid;
});

/// 当前用户是否为访客 — 向后兼容派生 provider。
///
/// 从 [appAuthStateProvider] 单一来源派生，5 文件无需改动。
final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(appAuthStateProvider).isGuest;
});

/// 引导完成状态 — 响应式，AuthGate 通过 watch 自动切换。
///
/// 遵循 NotifierProvider + SharedPreferences 持久化模式。
class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .read(sharedPreferencesProvider)
            .getBool(AppPrefsKeys.onboardingComplete) ??
        false;
  }

  /// 引导完成 — 更新状态 + 持久化。
  ///
  /// 同时设置 [AppPrefsKeys.hasOnboardedBefore] 永久标记，
  /// 使登出后的返回用户跳过引导教程。
  Future<void> complete() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppPrefsKeys.onboardingComplete, true);
    await prefs.setBool(AppPrefsKeys.hasOnboardedBefore, true);
    state = true;
  }

  /// 登出/删号后重置 — 仅更新状态，SharedPreferences 由调用方清理。
  void reset() {
    state = false;
  }
}

final onboardingCompleteProvider = NotifierProvider<OnboardingNotifier, bool>(
  OnboardingNotifier.new,
);
