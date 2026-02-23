import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/models/unlocked_achievement.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';

/// 已解锁成就列表 — 从 SQLite local_achievements 读取。
final unlockedAchievementsProvider = StreamProvider<List<LocalAchievement>>((
  ref,
) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield [];
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);
  yield await _readUnlockedAchievements(ledger, uid);

  await for (final change in ledger.changes) {
    if (change.type == 'achievement_unlocked' ||
        change.type == 'achievement_claimed') {
      yield await _readUnlockedAchievements(ledger, uid);
    }
  }
});

Future<List<LocalAchievement>> _readUnlockedAchievements(
  LedgerService ledger,
  String uid,
) async {
  final db = await ledger.database;
  final rows = await db.query(
    'local_achievements',
    where: 'uid = ? AND unlocked_at IS NOT NULL',
    whereArgs: [uid],
    orderBy: 'unlocked_at DESC',
  );
  return rows.map(LocalAchievement.fromSqlite).toList();
}

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

  final activeHabits = habits.where((h) => h.isActive).toList();
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

    int current = 0;
    int target = def.targetValue ?? 1;

    switch (def.category) {
      case AchievementCategory.quest:
        switch (def.id) {
          case 'quest_3_habits':
            current = activeHabits.length;
          case 'quest_5_habits':
            current = activeHabits.length;
          case 'hours_100':
          case 'hours_1000':
            final maxMinutes = habits.fold(
              0,
              (m, h) => h.totalMinutes > m ? h.totalMinutes : m,
            );
            current = maxMinutes;
          case 'quest_marathon':
            current = 0;
          default:
            current = 0;
            target = 1;
        }
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
