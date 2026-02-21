import 'package:cloud_firestore/cloud_firestore.dart';

/// 月度签到记录 — 对应 Firestore 文档 users/{uid}/monthlyCheckIns/{YYYY-MM}。
class MonthlyCheckIn {
  /// 月份标识，格式 "YYYY-MM"。
  final String month;

  /// 本月已签到的日期号列表（1-based），如 [1, 2, 5, 8]。
  final List<int> checkedDays;

  /// 本月签到累计获得的金币（每日奖励 + 里程碑奖励）。
  final int totalCoins;

  /// 已领取的里程碑天数阈值，如 [7, 14]。
  final List<int> milestonesClaimed;

  const MonthlyCheckIn({
    required this.month,
    required this.checkedDays,
    required this.totalCoins,
    required this.milestonesClaimed,
  });

  /// 从 Firestore 文档构建。
  factory MonthlyCheckIn.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MonthlyCheckIn(
      month: doc.id,
      checkedDays: List<int>.from(data['checkedDays'] as List<dynamic>? ?? []),
      totalCoins: data['totalCoins'] as int? ?? 0,
      milestonesClaimed: List<int>.from(
        data['milestonesClaimed'] as List<dynamic>? ?? [],
      ),
    );
  }

  /// 空记录（新月份首次签到前）。
  factory MonthlyCheckIn.empty(String month) {
    return MonthlyCheckIn(
      month: month,
      checkedDays: const [],
      totalCoins: 0,
      milestonesClaimed: const [],
    );
  }

  /// 序列化为 Firestore Map。
  Map<String, dynamic> toMap() {
    return {
      'checkedDays': checkedDays,
      'totalCoins': totalCoins,
      'milestonesClaimed': milestonesClaimed,
    };
  }

  /// 指定日期是否已签到。
  bool isCheckedOn(int day) => checkedDays.contains(day);

  /// 本月已签到天数。
  int get checkedCount => checkedDays.length;
}

/// 签到操作结果。
class CheckInResult {
  /// 每日签到金币（工作日 10 / 周末 15）。
  final int dailyCoins;

  /// 里程碑奖励总额（0 或里程碑值）。
  final int milestoneBonus;

  /// 本次新达成的里程碑阈值列表。
  final List<int> newMilestones;

  const CheckInResult({
    required this.dailyCoins,
    required this.milestoneBonus,
    required this.newMilestones,
  });

  /// 本次签到总获得金币。
  int get totalCoins => dailyCoins + milestoneBonus;
}
