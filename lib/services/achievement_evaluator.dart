import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart' show Database, Transaction;

import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';

const _uuid = Uuid();

/// 台账 action.type → 成就触发器映射。
const _triggerMap = {
  'focus_complete': AchievementTrigger.sessionCompleted,
  'habit_create': AchievementTrigger.habitCreated,
  'check_in': AchievementTrigger.checkInCompleted,
  'equip': AchievementTrigger.accessoryEquipped,
  'purchase': AchievementTrigger.accessoryEquipped,
};

/// 事件驱动成就评估器 — 监听台账变更自动检查成就。
/// 替代原来散落在各屏幕的 triggerAchievementEvaluation 调用。
class AchievementEvaluator {
  final LedgerService _ledger;
  final void Function(List<String> newlyUnlocked) _onUnlocked;
  StreamSubscription<LedgerChange>? _sub;

  AchievementEvaluator({
    required LedgerService ledger,
    required void Function(List<String> newlyUnlocked) onUnlocked,
  }) : _ledger = ledger,
       _onUnlocked = onUnlocked;

  /// 开始监听台账变更。
  void start(String uid) {
    _sub?.cancel();
    _sub = _ledger.changes.listen((change) {
      final trigger = _triggerMap[change.type];
      if (trigger != null) {
        _evaluate(uid, trigger, change);
      }
    });
  }

  /// 停止监听。
  void stop() {
    _sub?.cancel();
    _sub = null;
  }

  Future<void> _evaluate(
    String uid,
    AchievementTrigger trigger,
    LedgerChange change,
  ) async {
    try {
      final ctx = await _buildContext(uid);
      final newlyUnlocked = <String>[];
      final db = await _ledger.database;

      await db.transaction((txn) async {
        for (final def in AchievementDefinitions.all) {
          if (ctx.unlockedIds.contains(def.id)) continue;
          if (!_checkCondition(def, trigger, ctx)) continue;
          await _unlockAchievement(txn, uid, def, trigger, change);
          newlyUnlocked.add(def.id);
        }
      });

      if (newlyUnlocked.isNotEmpty) {
        _ledger.notifyChange(
          LedgerChange(
            type: 'achievement_unlocked',
            affectedIds: newlyUnlocked,
          ),
        );
        _onUnlocked(newlyUnlocked);
      }
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AchievementEvaluator',
        operation: '_evaluate',
      );
    }
  }

  /// 解锁单个成就：写本地表 + 发放金币 + 写台账。
  Future<void> _unlockAchievement(
    Transaction txn,
    String uid,
    AchievementDef def,
    AchievementTrigger trigger,
    LedgerChange change,
  ) async {
    final actionId = _uuid.v4();
    final now = DateTime.now();

    await txn.insert('local_achievements', {
      'id': def.id,
      'uid': uid,
      'unlocked_at': now.millisecondsSinceEpoch,
      'reward_coins': def.coinReward,
      'reward_claimed': 1,
      'reward_claimed_at': now.millisecondsSinceEpoch,
      'title_reward': def.titleReward,
      'trigger_action_id': actionId,
      'context': jsonEncode(_buildSnapshotContext(change)),
    });

    if (def.coinReward > 0) {
      final raw = await _ledger.getMaterializedInTxn(txn, uid, 'coins');
      final coins = (int.tryParse(raw ?? '0') ?? 0) + def.coinReward;
      await _ledger.setMaterializedInTxn(txn, uid, 'coins', coins.toString());
    }

    await _ledger.appendInTxn(
      txn,
      type: ActionType.achievementUnlocked,
      uid: uid,
      startedAt: now,
      payload: {
        'achievementId': def.id,
        'trigger': trigger.name,
        'triggerActionId': actionId,
      },
      result: {
        if (def.coinReward > 0) 'coins': def.coinReward,
        if (def.titleReward != null) 'title': def.titleReward,
      },
    );
  }

  /// 从本地表构建评估上下文。
  Future<AchievementEvalContext> _buildContext(String uid) async {
    final db = await _ledger.database;
    final habitData = await _queryHabitData(db, uid);
    final catData = await _queryCatData(db, uid);
    final sessionCount = await _ledger.getMaterializedInt(
      uid,
      'total_session_count',
    );
    final allDoneToday = await _checkAllHabitsDoneToday(
      db,
      uid,
      habitData.rows,
    );
    final invRaw = await _ledger.getMaterialized(uid, 'inventory');
    final unlockedIds = await _queryUnlockedIds(db, uid);

    return AchievementEvalContext(
      totalSessionCount: sessionCount ?? 0,
      activeHabitCount: habitData.rows.length,
      habitCheckInDays: habitData.checkInDays,
      habitTotalMinutes: habitData.minutes,
      catStages: catData.stages,
      catProgresses: catData.progresses,
      totalCatCount: catData.totalCount,
      graduatedCatCount: catData.graduatedCount,
      accessoryCount:
          _decodeInventory(invRaw).length + catData.equippedAccessories.length,
      equippedAccessories: catData.equippedAccessories,
      allCatsHappy: catData.allHappy,
      allHabitsDoneToday: allDoneToday,
      unlockedIds: unlockedIds,
    );
  }

  /// 查询活跃习惯的累计数据。
  Future<_HabitData> _queryHabitData(Database db, String uid) async {
    final rows = await db.query(
      'local_habits',
      where: 'uid = ? AND is_active = 1',
      whereArgs: [uid],
    );
    final minutes = <int>[];
    final checkInDays = <int>[];
    for (final row in rows) {
      minutes.add(row['total_minutes'] as int? ?? 0);
      checkInDays.add(row['total_check_in_days'] as int? ?? 0);
    }
    return _HabitData(rows: rows, minutes: minutes, checkInDays: checkInDays);
  }

  /// 查询猫进度、阶段、配饰、心情等聚合数据。
  Future<_CatData> _queryCatData(Database db, String uid) async {
    final rows = await db.query(
      'local_cats',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    final stages = <String>[];
    final progresses = <double>[];
    final equipped = <String>[];
    int graduated = 0;
    bool allHappy = rows.isNotEmpty;

    for (final row in rows) {
      final totalMin = row['total_minutes'] as int? ?? 0;
      progresses.add((totalMin / 12000.0).clamp(0.0, 1.0));
      stages.add(
        _higherStage(row['highest_stage'] as String?, _computeStage(totalMin)),
      );
      final eq = row['equipped_accessory'] as String?;
      if (eq != null && eq.isNotEmpty) equipped.add(eq);
      if (row['state'] == 'graduated') graduated++;
      final lastAt = row['last_session_at'] as int?;
      if (lastAt != null) {
        final hours = DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(lastAt))
            .inHours;
        if (hours > 24) allHappy = false;
      }
    }

    return _CatData(
      stages: stages,
      progresses: progresses,
      equippedAccessories: equipped,
      graduatedCount: graduated,
      allHappy: allHappy,
      totalCount: rows.length,
    );
  }

  /// 检查今日所有习惯是否都已完成每日目标。
  Future<bool> _checkAllHabitsDoneToday(
    Database db,
    String uid,
    List<Map<String, Object?>> habitRows,
  ) async {
    if (habitRows.isEmpty) return false;
    final now = DateTime.now();
    final todayMs = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final rows = await db.rawQuery(
      'SELECT habit_id, SUM(duration_minutes) as total '
      'FROM local_sessions '
      "WHERE uid = ? AND started_at >= ? AND status = 'completed' "
      'GROUP BY habit_id',
      [uid, todayMs],
    );
    final todayMap = <String, int>{};
    for (final row in rows) {
      todayMap[row['habit_id'] as String] = row['total'] as int? ?? 0;
    }
    return habitRows.every((h) {
      final goal = h['goal_minutes'] as int? ?? 25;
      final done = todayMap[h['id'] as String] ?? 0;
      return done >= goal;
    });
  }

  /// 查询已解锁成就 ID 集合。
  Future<Set<String>> _queryUnlockedIds(Database db, String uid) async {
    final rows = await db.query(
      'local_achievements',
      columns: ['id'],
      where: 'uid = ? AND unlocked_at IS NOT NULL',
      whereArgs: [uid],
    );
    return rows.map((r) => r['id'] as String).toSet();
  }

  /// 检查单个成就的解锁条件。
  bool _checkCondition(
    AchievementDef def,
    AchievementTrigger trigger,
    AchievementEvalContext ctx,
  ) {
    switch (def.id) {
      case 'quest_first_session':
        return ctx.totalSessionCount >= 1;
      case 'quest_100_sessions':
        return ctx.totalSessionCount >= 100;
      case 'quest_3_habits':
        return ctx.activeHabitCount >= 3;
      case 'quest_5_habits':
        return ctx.activeHabitCount >= 5;
      case 'quest_all_done':
        return ctx.allHabitsDoneToday && ctx.activeHabitCount > 0;
      case 'quest_5_workdays':
        return ctx.habitCheckInDays.any((d) => d >= 5);
      case 'quest_first_checkin':
        return trigger == AchievementTrigger.checkInCompleted;
      case 'quest_marathon':
        return ctx.lastSessionMinutes != null && ctx.lastSessionMinutes! >= 120;
      case 'hours_100':
        return ctx.habitTotalMinutes.any((m) => m >= 6000);
      case 'hours_1000':
        return ctx.habitTotalMinutes.any((m) => m >= 60000);
      case 'goal_on_time':
        return ctx.hasCompletedGoalOnTime;
      case 'goal_ahead':
        return ctx.hasCompletedGoalAhead;
      case 'cat_first_adopt':
        return ctx.totalCatCount >= 1;
      case 'cat_3_adopted':
        return ctx.totalCatCount >= 3;
      case 'cat_adolescent':
        return ctx.catStages.contains('adolescent') ||
            ctx.catStages.contains('adult');
      case 'cat_adult':
        return ctx.catStages.contains('adult');
      case 'cat_senior':
        return ctx.catProgresses.any((p) => p >= 1.0);
      case 'cat_graduated':
        return ctx.graduatedCatCount >= 1;
      case 'cat_accessory':
        return ctx.equippedAccessories.isNotEmpty;
      case 'cat_5_accessories':
        return ctx.accessoryCount >= 5;
      case 'cat_all_happy':
        return ctx.allCatsHappy && ctx.totalCatCount > 0;
      default:
        if (def.category == AchievementCategory.persist) {
          final target = def.targetValue ?? 0;
          return ctx.habitCheckInDays.any((days) => days >= target);
        }
        return false;
    }
  }

  Map<String, dynamic> _buildSnapshotContext(LedgerChange change) {
    return {'affectedIds': change.affectedIds};
  }

  static String _computeStage(int totalMinutes) {
    final hours = totalMinutes / 60.0;
    if (hours >= 200) return 'senior';
    if (hours >= 100) return 'adult';
    if (hours >= 20) return 'adolescent';
    return 'kitten';
  }

  static const _stageOrder = {
    'kitten': 0,
    'adolescent': 1,
    'adult': 2,
    'senior': 3,
  };

  static String _higherStage(String? a, String b) {
    if (a == null) return b;
    return (_stageOrder[a] ?? 0) >= (_stageOrder[b] ?? 0) ? a : b;
  }

  static List<String> _decodeInventory(String? raw) {
    if (raw == null) return [];
    final decoded = jsonDecode(raw);
    if (decoded is List) return decoded.cast<String>();
    return [];
  }
}

/// 习惯聚合数据（内部使用）。
class _HabitData {
  final List<Map<String, Object?>> rows;
  final List<int> minutes;
  final List<int> checkInDays;

  const _HabitData({
    required this.rows,
    required this.minutes,
    required this.checkInDays,
  });
}

/// 猫聚合数据（内部使用）。
class _CatData {
  final List<String> stages;
  final List<double> progresses;
  final List<String> equippedAccessories;
  final int graduatedCount;
  final bool allHappy;
  final int totalCount;

  const _CatData({
    required this.stages,
    required this.progresses,
    required this.equippedAccessories,
    required this.graduatedCount,
    required this.allHappy,
    required this.totalCount,
  });
}
