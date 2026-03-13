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
  static const hasOnboardedBefore = 'has_onboarded_before';

  // ─── 同步 ───
  static const dataHydrated = 'local_data_hydrated_v1';

  // ─── 账号删除队列 ───
  static const pendingDeletionJob = 'pending_deletion_job';
  static const deletionTombstone = 'deletion_tombstone';
  static const deletionRetryCount = 'deletion_retry_count';

  // ─── 应用生命周期 ───
  static const lastAppOpen = 'last_app_open';
  static const consecutiveDays = 'consecutive_days';

  // ─── AI 日记重试队列 ───
  static const diaryPendingRetries = 'diary_pending_retries';
}
