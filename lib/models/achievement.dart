import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 成就定义 — 静态元数据，客户端常量。
/// 所有 163 个成就的定义在 achievement_constants.dart 中。
class AchievementDef {
  final String id;
  final String category; // 'quest' | 'streak' | 'cat' | 'persist'
  final String nameKey; // l10n ARB key
  final String descKey; // l10n ARB key
  final IconData icon;
  final int? targetValue; // 进度类成就的目标值
  final int coinReward;
  final String? titleReward; // 解锁的称号 ID（null = 无称号）
  final bool isHidden;

  const AchievementDef({
    required this.id,
    required this.category,
    required this.nameKey,
    required this.descKey,
    required this.icon,
    this.targetValue,
    required this.coinReward,
    this.titleReward,
    this.isHidden = false,
  });
}

/// 已解锁成就 — Firestore 文档模型。
/// 映射到 users/{uid}/achievements/{achievementId}。
class UnlockedAchievement {
  final String id;
  final DateTime unlockedAt;
  final bool rewardClaimed;
  final Map<String, dynamic>? context;

  const UnlockedAchievement({
    required this.id,
    required this.unlockedAt,
    required this.rewardClaimed,
    this.context,
  });

  factory UnlockedAchievement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UnlockedAchievement(
      id: doc.id,
      unlockedAt:
          (data['unlockedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rewardClaimed: data['rewardClaimed'] as bool? ?? false,
      context: data['context'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'unlockedAt': FieldValue.serverTimestamp(),
      'rewardClaimed': rewardClaimed,
      if (context != null) 'context': context,
    };
  }
}

/// 成就评估触发器类型
enum AchievementTrigger {
  sessionCompleted,
  habitCreated,
  checkInCompleted,
  accessoryEquipped,
  appStartup,
}

/// 成就评估上下文 — 传递给评估引擎的快照数据
class AchievementEvalContext {
  final int totalSessionCount;
  final int activeHabitCount;
  final List<int> habitStreaks; // 所有 habit 的 currentStreak
  final List<int> habitBestStreaks; // 所有 habit 的 bestStreak
  final List<int> habitCheckInDays; // 所有 habit 的 totalCheckInDays
  final List<String> catStages; // 所有 cat 的 displayStage
  final List<double> catProgresses; // 所有 cat 的 growthProgress
  final int totalCatCount;
  final int graduatedCatCount;
  final int accessoryCount;
  final List<String> equippedAccessories;
  final bool allCatsHappy;
  final bool allHabitsDoneToday;
  final int? lastSessionMinutes;
  final Set<String> unlockedIds;

  const AchievementEvalContext({
    required this.totalSessionCount,
    required this.activeHabitCount,
    required this.habitStreaks,
    required this.habitBestStreaks,
    required this.habitCheckInDays,
    required this.catStages,
    this.catProgresses = const [],
    required this.totalCatCount,
    required this.graduatedCatCount,
    required this.accessoryCount,
    required this.equippedAccessories,
    required this.allCatsHappy,
    required this.allHabitsDoneToday,
    this.lastSessionMinutes,
    required this.unlockedIds,
  });
}
