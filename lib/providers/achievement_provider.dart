import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/models/unlocked_achievement.dart';
import 'package:hachimi_app/services/achievement_evaluator.dart';
export 'package:hachimi_app/services/achievement_evaluator.dart'
    show AchievementEvaluator;
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

/// 已解锁成就列表 — 从 SQLite local_achievements 读取。
final unlockedAchievementsProvider = StreamProvider<List<LocalAchievement>>((
  ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<LocalAchievement>[]);

  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == 'achievement_unlocked' ||
        c.type == 'achievement_claimed',
    read: () => _readUnlockedAchievements(ledger, uid),
  );
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

/// ID → LocalAchievement 映射，用于 O(1) 查找 unlockedAt 等详情。
final unlockedAchievementMapProvider = Provider<Map<String, LocalAchievement>>((
  ref,
) {
  final unlocked = ref.watch(unlockedAchievementsProvider).value ?? [];
  return {for (final a in unlocked) a.id: a};
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

/// 成就评估器工厂 — 用于 app.dart 启动引擎，避免直接导入 Service。
AchievementEvaluator createAchievementEvaluator(Ref ref) {
  return AchievementEvaluator(
    ledger: ref.read(ledgerServiceProvider),
    onUnlocked: (ids) {
      ref.read(newlyUnlockedProvider.notifier).addAll(ids);
    },
  );
}

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
