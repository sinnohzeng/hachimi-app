import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 月度目标项 — 带完成状态的文本条目。
class MonthlyGoal {
  final String text;
  final bool completed;

  const MonthlyGoal({required this.text, this.completed = false});

  Map<String, dynamic> toJson() => {'text': text, 'completed': completed};

  factory MonthlyGoal.fromJson(Map<String, dynamic> json) {
    return MonthlyGoal(
      text: json['text'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  MonthlyGoal copyWith({String? text, bool? completed}) {
    return MonthlyGoal(
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }
}

/// 月计划 — 每月目标、挑战习惯、自我关怀活动等。
///
/// 对应 SQLite 表 `local_monthly_plans`，
/// Firestore 路径 `users/{uid}/monthlyPlans/{monthId}`。
///
/// monthId 格式：`'yyyy-MM'`。
class MonthlyPlan {
  final String id;
  final String monthId; // 'yyyy-MM'
  final List<MonthlyGoal> goals;
  final String? challengeHabitName; // 30 天挑战习惯
  final String? challengeReward; // 挑战奖励
  final List<String> selfCareActivities; // 自我关怀活动
  final String? memory; // 月度回忆
  final String? achievement; // 月度成就
  final DateTime createdAt;
  final DateTime updatedAt;

  const MonthlyPlan({
    required this.id,
    required this.monthId,
    this.goals = const [],
    this.challengeHabitName,
    this.challengeReward,
    this.selfCareActivities = const [],
    this.memory,
    this.achievement,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'month_id': monthId,
      'goals': jsonEncode(goals.map((g) => g.toJson()).toList()),
      'challenge_habit_name': challengeHabitName,
      'challenge_reward': challengeReward,
      'self_care_activities': jsonEncode(selfCareActivities),
      'memory': memory,
      'achievement': achievement,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory MonthlyPlan.fromSqlite(Map<String, dynamic> map) {
    return MonthlyPlan(
      id: map['id'] as String,
      monthId: map['month_id'] as String,
      goals: _decodeGoalsFromSqlite(map['goals']),
      challengeHabitName: map['challenge_habit_name'] as String?,
      challengeReward: map['challenge_reward'] as String?,
      selfCareActivities: _decodeStringListFromSqlite(
        map['self_care_activities'],
      ),
      memory: map['memory'] as String?,
      achievement: map['achievement'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updated_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'goals': goals.map((g) => g.toJson()).toList(),
      'challengeHabitName': challengeHabitName,
      'challengeReward': challengeReward,
      'selfCareActivities': selfCareActivities,
      'memory': memory,
      'achievement': achievement,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory MonthlyPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MonthlyPlan(
      id: doc.id,
      monthId: doc.id,
      goals: _decodeGoalsFromFirestore(data['goals']),
      challengeHabitName: data['challengeHabitName'] as String?,
      challengeReward: data['challengeReward'] as String?,
      selfCareActivities:
          (data['selfCareActivities'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [],
      memory: data['memory'] as String?,
      achievement: data['achievement'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  MonthlyPlan copyWith({
    String? id,
    String? monthId,
    List<MonthlyGoal>? goals,
    String? challengeHabitName,
    bool clearChallengeHabitName = false,
    String? challengeReward,
    bool clearChallengeReward = false,
    List<String>? selfCareActivities,
    String? memory,
    bool clearMemory = false,
    String? achievement,
    bool clearAchievement = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MonthlyPlan(
      id: id ?? this.id,
      monthId: monthId ?? this.monthId,
      goals: goals ?? this.goals,
      challengeHabitName: clearChallengeHabitName
          ? null
          : (challengeHabitName ?? this.challengeHabitName),
      challengeReward: clearChallengeReward
          ? null
          : (challengeReward ?? this.challengeReward),
      selfCareActivities: selfCareActivities ?? this.selfCareActivities,
      memory: clearMemory ? null : (memory ?? this.memory),
      achievement: clearAchievement ? null : (achievement ?? this.achievement),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── 私有辅助 ───

  static List<MonthlyGoal> _decodeGoalsFromSqlite(dynamic raw) {
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(MonthlyGoal.fromJson)
              .toList();
        }
      } on FormatException {
        // 损坏数据静默降级
      }
    }
    return [];
  }

  static List<MonthlyGoal> _decodeGoalsFromFirestore(dynamic raw) {
    if (raw is List<dynamic>) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(MonthlyGoal.fromJson)
          .toList();
    }
    return [];
  }

  static List<String> _decodeStringListFromSqlite(dynamic raw) {
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.whereType<String>().toList();
      } on FormatException {
        // 损坏数据静默降级
      }
    }
    return [];
  }
}
