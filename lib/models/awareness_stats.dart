/// 觉知统计数据模型 — 聚合觉知模块的关键指标。
class AwarenessStats {
  final int totalLightDays;
  final int totalWeeklyReviews;
  final int totalWorriesResolved;
  final int totalWorriesAll;

  const AwarenessStats({
    required this.totalLightDays,
    required this.totalWeeklyReviews,
    required this.totalWorriesResolved,
    required this.totalWorriesAll,
  });

  /// 解忧率（百分比），分母为 0 时返回 0。
  double get worryResolutionRate {
    if (totalWorriesAll == 0) return 0;
    return totalWorriesResolved / totalWorriesAll * 100;
  }

  /// 从 Repository 返回的 Map 构造。
  factory AwarenessStats.fromMap(Map<String, int> map) {
    return AwarenessStats(
      totalLightDays: map['totalLightDays'] ?? 0,
      totalWeeklyReviews: map['totalWeeklyReviews'] ?? 0,
      totalWorriesResolved: map['totalWorriesResolved'] ?? 0,
      totalWorriesAll: map['totalWorriesAll'] ?? 0,
    );
  }
}
