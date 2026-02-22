import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/achievement.dart';

/// AchievementService — 成就评估引擎 + Firestore CRUD。
/// 评估成就条件，解锁成就并发放奖励。
class AchievementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _achievementsRef(String uid) =>
      _db.collection('users').doc(uid).collection('achievements');

  // ─── Firestore 读写 ───

  /// 监听已解锁成就列表
  Stream<List<UnlockedAchievement>> watchUnlocked(String uid) {
    return _achievementsRef(uid).snapshots().map(
      (snapshot) =>
          snapshot.docs.map(UnlockedAchievement.fromFirestore).toList(),
    );
  }

  /// 获取已解锁成就 ID 集合
  Future<Set<String>> getUnlockedIds(String uid) async {
    final snapshot = await _achievementsRef(uid).get();
    return snapshot.docs.map((d) => d.id).toSet();
  }

  // ─── 成就评估引擎 ───

  /// 评估所有成就条件，返回新解锁的成就 ID 列表。
  /// 在调用方的 batch/transaction 之外执行，自带 batch 写入。
  Future<List<String>> evaluate({
    required String uid,
    required AchievementTrigger trigger,
    required AchievementEvalContext context,
  }) async {
    try {
      final newlyUnlocked = <String>[];
      final batch = _db.batch();
      final userRef = _db.collection('users').doc(uid);

      for (final def in AchievementDefinitions.all) {
        if (context.unlockedIds.contains(def.id)) continue;
        if (!_checkCondition(def, trigger, context)) continue;

        // 解锁成就
        final achievementRef = _achievementsRef(uid).doc(def.id);
        batch.set(achievementRef, {
          'unlockedAt': FieldValue.serverTimestamp(),
          'rewardClaimed': true,
        });

        // 发放金币奖励
        if (def.coinReward > 0) {
          batch.update(userRef, {
            'coins': FieldValue.increment(def.coinReward),
          });
        }

        // 解锁称号
        if (def.titleReward != null) {
          batch.update(userRef, {
            'unlockedTitles': FieldValue.arrayUnion([def.titleReward]),
          });
        }

        newlyUnlocked.add(def.id);
      }

      if (newlyUnlocked.isNotEmpty) {
        await batch.commit();
      }

      return newlyUnlocked;
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AchievementService',
        operation: 'evaluate',
      );
      return [];
    }
  }

  /// 检查单个成就是否满足解锁条件
  bool _checkCondition(
    AchievementDef def,
    AchievementTrigger trigger,
    AchievementEvalContext ctx,
  ) {
    switch (def.id) {
      // ─── 任务成就 ───
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

      // ─── 累计小时成就 ───
      case 'hours_100':
        return ctx.habitTotalMinutes.any((m) => m >= 6000); // 100h
      case 'hours_1000':
        return ctx.habitTotalMinutes.any((m) => m >= 60000); // 1000h
      case 'goal_on_time':
        return ctx.hasCompletedGoalOnTime;
      case 'goal_ahead':
        return ctx.hasCompletedGoalAhead;

      // ─── 猫咪成就 ───
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
        // 任一猫达到 200h (growthProgress >= 1.0)
        return ctx.catProgresses.any((p) => p >= 1.0);

      case 'cat_graduated':
        return ctx.graduatedCatCount >= 1;

      case 'cat_accessory':
        return ctx.equippedAccessories.isNotEmpty;

      case 'cat_5_accessories':
        return ctx.accessoryCount >= 5;

      case 'cat_all_happy':
        return ctx.allCatsHappy && ctx.totalCatCount > 0;

      // ─── 坚持成就 ───
      default:
        if (def.category == AchievementCategory.persist) {
          final target = def.targetValue ?? 0;
          return ctx.habitCheckInDays.any((days) => days >= target);
        }
        return false;
    }
  }

  /// 更新用户当前佩戴的称号
  Future<void> updateCurrentTitle({
    required String uid,
    required String? titleId,
  }) async {
    try {
      await _db.collection('users').doc(uid).update({'currentTitle': titleId});
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AchievementService',
        operation: 'updateCurrentTitle',
      );
      rethrow;
    }
  }
}
