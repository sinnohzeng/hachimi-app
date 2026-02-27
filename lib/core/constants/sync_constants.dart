/// 同步引擎相关常量。
class SyncConstants {
  SyncConstants._();

  /// 台账变更后延迟同步的时间（防抖）。
  static const syncDebounceInterval = Duration(seconds: 2);

  /// 每次同步批量拉取的最大条数。
  static const syncBatchSize = 20;

  // ─── 物化状态键名 ───

  static const keyCoins = 'coins';
  static const keyLastCheckInDate = 'last_check_in_date';
  static const keyInventory = 'inventory';
  static const keyAvatarId = 'avatar_id';
  static const keyDisplayName = 'display_name';
  static const keyCurrentTitle = 'current_title';
  static const keyUnlockedTitles = 'unlocked_titles';
}
