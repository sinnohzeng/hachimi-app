import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';

/// 已解锁成就实时流
final unlockedAchievementsProvider = StreamProvider<List<UnlockedAchievement>>((
  ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(achievementServiceProvider).watchUnlocked(uid);
});

/// 已解锁成就 ID 集合（同步快速查询）
final unlockedIdsProvider = Provider<Set<String>>((ref) {
  final unlocked = ref.watch(unlockedAchievementsProvider).value ?? [];
  return unlocked.map((a) => a.id).toSet();
});

/// 成就进度计算 — 每个成就的进度值
final achievementProgressProvider = Provider<Map<String, AchievementProgress>>((
  ref,
) {
  final habits = ref.watch(habitsProvider).value ?? [];
  final allCats = ref.watch(allCatsProvider).value ?? [];
  final unlockedIds = ref.watch(unlockedIdsProvider);
  final inventory = ref.watch(inventoryProvider).value ?? <String>[];

  final result = <String, AchievementProgress>{};

  // 汇总数据
  final activeHabits = habits.where((h) => h.isActive).toList();
  final maxStreak = habits.fold(
    0,
    (max, h) => h.currentStreak > max ? h.currentStreak : max,
  );
  final maxBestStreak = habits.fold(
    0,
    (max, h) => h.bestStreak > max ? h.bestStreak : max,
  );
  final maxCheckInDays = habits.fold(
    0,
    (max, h) => h.totalCheckInDays > max ? h.totalCheckInDays : max,
  );

  for (final def in AchievementDefinitions.all) {
    final isUnlocked = unlockedIds.contains(def.id);

    if (isUnlocked) {
      result[def.id] = AchievementProgress(
        current: def.targetValue ?? 1,
        target: def.targetValue ?? 1,
        isUnlocked: true,
      );
      continue;
    }

    // 计算各类成就的进度
    int current = 0;
    int target = def.targetValue ?? 1;

    switch (def.category) {
      case AchievementCategory.quest:
        switch (def.id) {
          case 'quest_3_habits':
            current = activeHabits.length;
          case 'quest_5_habits':
            current = activeHabits.length;
          case 'quest_marathon':
            current = 0; // 无法预计，由单次 session 触发
          default:
            current = 0;
            target = 1;
        }
      case AchievementCategory.streak:
        current = maxBestStreak > maxStreak ? maxBestStreak : maxStreak;
      case AchievementCategory.cat:
        switch (def.id) {
          case 'cat_3_adopted':
            current = allCats.length;
          case 'cat_5_accessories':
            current = inventory.length;
          default:
            current = 0;
            target = 1;
        }
      case AchievementCategory.persist:
        current = maxCheckInDays;
    }

    result[def.id] = AchievementProgress(
      current: current,
      target: target,
      isUnlocked: false,
    );
  }

  return result;
});

/// 新解锁成就通知 — Notifier 版（Riverpod 3.x）
class NewlyUnlockedNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  /// 添加新解锁的成就 ID 列表。
  void addAll(List<String> ids) {
    state = [...state, ...ids];
  }

  /// 消费完毕后清空。
  void clear() {
    state = [];
  }
}

final newlyUnlockedProvider =
    NotifierProvider<NewlyUnlockedNotifier, List<String>>(
      NewlyUnlockedNotifier.new,
    );

/// 成就进度数据
class AchievementProgress {
  final int current;
  final int target;
  final bool isUnlocked;

  const AchievementProgress({
    required this.current,
    required this.target,
    required this.isUnlocked,
  });

  double get percent => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
}
