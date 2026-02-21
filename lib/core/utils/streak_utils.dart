/// Streak 计算工具 — 统一连续打卡天数的判定逻辑。
abstract final class StreakUtils {
  /// 根据上次打卡日期计算新的 streak 值。
  ///
  /// - 今天已打卡 → streak 不变
  /// - 昨天打卡 → streak +1
  /// - 超过一天未打卡或从未打卡 → streak 重置为 1
  static int calculateNewStreak({
    required String? lastCheckInDate,
    required String today,
    required String yesterday,
    required int currentStreak,
  }) {
    if (lastCheckInDate == today) return currentStreak;
    if (lastCheckInDate == yesterday) return currentStreak + 1;
    return 1;
  }
}
