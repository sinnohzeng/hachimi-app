/// SharedPreferences 键名常量 — 认证与应用状态。
///
/// 集中管理所有 SharedPreferences 键名，消除散落在各文件中的字符串字面量。
/// 参照 [SyncConstants] 模式。
class AppPrefsKeys {
  AppPrefsKeys._();

  // ─── 认证 ───
  static const cachedUid = 'cached_uid';
  static const localGuestUid = 'local_guest_uid';

  // ─── 引导 ───
  static const onboardingComplete = 'onboarding_complete';

  // ─── 同步 ───
  static const dataHydrated = 'local_data_hydrated_v1';

  // ─── 账号删除恢复 ───
  static const deletionInProgress = 'deletion_in_progress';
  static const deletionUid = 'deletion_uid';
  static const deletionStep = 'deletion_step';

  // ─── 应用生命周期 ───
  static const lastAppOpen = 'last_app_open';
  static const consecutiveDays = 'consecutive_days';
}
