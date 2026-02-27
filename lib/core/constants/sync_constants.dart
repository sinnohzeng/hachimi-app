/// 同步引擎相关常量。
class SyncConstants {
  SyncConstants._();

  /// 台账变更后延迟同步的时间（防抖）。
  static const syncDebounceInterval = Duration(seconds: 2);

  /// 每次同步批量拉取的最大条数。
  static const syncBatchSize = 20;
}
