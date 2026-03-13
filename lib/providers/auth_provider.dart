import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/providers/service_providers.dart';

// Re-export service_providers so existing imports continue to work.
export 'package:hachimi_app/providers/service_providers.dart';

/// Auth state — SSOT for current user authentication.
/// Streams from AuthBackend auth state changes.
final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authBackendProvider).authStateChanges;
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
        prefs.getString(AppPrefsKeys.localGuestUid) ??
        prefs.getString(AppPrefsKeys.cachedUid),
    loading: () => prefs.getString(AppPrefsKeys.cachedUid),
    error: (_, _) =>
        prefs.getString(AppPrefsKeys.localGuestUid) ??
        prefs.getString(AppPrefsKeys.cachedUid),
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
  final AuthUser? user = ref.watch(authStateProvider).value;
  if (user != null) return user.isAnonymous;
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getString(AppPrefsKeys.localGuestUid) != null;
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
  void complete() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool(AppPrefsKeys.onboardingComplete, true);
    prefs.setBool(AppPrefsKeys.hasOnboardedBefore, true);
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
