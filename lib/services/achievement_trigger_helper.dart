import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';

/// 成就触发辅助 — 从 Provider 快照构建 AchievementEvalContext 并触发评估。
/// 各 Screen 在关键操作后调用此方法。
Future<void> triggerAchievementEvaluation(
  WidgetRef ref,
  AchievementTrigger trigger, {
  int? lastSessionMinutes,
}) async {
  final uid = ref.read(currentUidProvider);
  if (uid == null) return;

  final habits = ref.read(habitsProvider).value ?? [];
  final allCats = ref.read(allCatsProvider).value ?? [];
  final unlockedIds = ref.read(unlockedIdsProvider);
  final inventory = ref.read(inventoryProvider).value ?? [];
  final todayMap = ref.read(todayMinutesPerHabitProvider);

  final activeHabits = habits.where((h) => h.isActive).toList();
  final allHabitsDoneToday =
      activeHabits.isNotEmpty &&
      activeHabits.every((h) => (todayMap[h.id] ?? 0) >= h.goalMinutes);

  // 猫咪状态计算
  final activeCats = allCats.where((c) => c.state == 'active').toList();
  final allCatsHappy =
      activeCats.isNotEmpty &&
      activeCats.every((c) => c.computedMood == 'happy');

  final context = AchievementEvalContext(
    totalSessionCount: habits.fold(0, (sum, h) => sum + h.totalCheckInDays) + 1,
    activeHabitCount: activeHabits.length,
    habitCheckInDays: habits.map((h) => h.totalCheckInDays).toList(),
    habitTotalMinutes: habits.map((h) => h.totalMinutes).toList(),
    catStages: allCats.map((c) => c.displayStage).toList(),
    catProgresses: allCats.map((c) => c.growthProgress).toList(),
    totalCatCount: allCats.length,
    graduatedCatCount: allCats.where((c) => c.state == 'graduated').length,
    accessoryCount: inventory.length,
    equippedAccessories: allCats
        .where(
          (c) => c.equippedAccessory != null && c.equippedAccessory!.isNotEmpty,
        )
        .map((c) => c.equippedAccessory!)
        .toList(),
    allCatsHappy: allCatsHappy,
    allHabitsDoneToday: allHabitsDoneToday,
    lastSessionMinutes: lastSessionMinutes,
    hasCompletedGoalOnTime: _checkGoalOnTime(habits),
    hasCompletedGoalAhead: _checkGoalAhead(habits),
    unlockedIds: unlockedIds,
  );

  final newlyUnlocked = await ref
      .read(achievementServiceProvider)
      .evaluate(uid: uid, trigger: trigger, context: context);

  if (newlyUnlocked.isNotEmpty) {
    // 通知 UI 显示解锁提示
    ref.read(newlyUnlockedProvider.notifier).addAll(newlyUnlocked);

    // 记录 analytics
    final analytics = ref.read(analyticsServiceProvider);
    for (final id in newlyUnlocked) {
      analytics.logAchievementUnlocked(achievementId: id);
    }
  }
}

/// 检查是否有 habit 在截止日期前达成了目标
bool _checkGoalOnTime(List<Habit> habits) {
  return habits.any(
    (h) => h.targetCompleted && h.deadlineDate != null && h.targetHours != null,
  );
}

/// 检查是否有 habit 在截止日期前 7+ 天达成了目标
bool _checkGoalAhead(List<Habit> habits) {
  final now = DateTime.now();
  return habits.any(
    (h) =>
        h.targetCompleted &&
        h.deadlineDate != null &&
        h.targetHours != null &&
        h.deadlineDate!.difference(now).inDays >= 7,
  );
}
