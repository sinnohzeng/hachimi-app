import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 觉知仓库 — DailyLight + WeeklyReview + 觉知统计 CRUD + 台账写入。
/// 所有写操作在 SQLite 事务中同时更新领域表和行为台账。
class AwarenessRepository {
  final LedgerService _ledger;

  AwarenessRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── DailyLight 查询 ───

  /// 获取今日的每日一光记录。
  Future<DailyLight?> getTodayLight(String uid, String todayDate) async {
    return getLightByDate(uid, todayDate);
  }

  /// 按日期获取每日一光记录。
  Future<DailyLight?> getLightByDate(String uid, String date) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      where: 'uid = ? AND date = ?',
      whereArgs: [uid, date],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DailyLight.fromSqlite(rows.first);
  }

  /// 获取指定月份的所有每日一光记录（month 格式：'YYYY-MM'）。
  Future<List<DailyLight>> getLightsForMonth(String uid, String month) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      where: 'uid = ? AND date LIKE ?',
      whereArgs: [uid, '$month%'],
      orderBy: 'date ASC',
    );
    return rows.map(DailyLight.fromSqlite).toList();
  }

  /// 获取日期范围内的每日一光记录。
  Future<List<DailyLight>> getLightsInRange(
    String uid,
    String startDate,
    String endDate,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      where: 'uid = ? AND date >= ? AND date <= ?',
      whereArgs: [uid, startDate, endDate],
      orderBy: 'date ASC',
    );
    return rows.map(DailyLight.fromSqlite).toList();
  }

  /// 获取用户累计记录天数（从统计表读取）。
  Future<int> getTotalLightDays(String uid) async {
    final stats = await getAwarenessStats(uid);
    return stats['totalLightDays'] ?? 0;
  }

  // ─── DailyLight 写入（台账 + 领域表原子操作）───

  /// 保存每日一光（新增或更新）。
  Future<void> saveDailyLight(String uid, DailyLight light) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      final isNew = await _isNewDailyLight(txn, uid, light.date);

      await txn.insert(
        'local_daily_lights',
        light.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _ledger.appendInTxn(
        txn,
        type: ActionType.lightRecorded,
        uid: uid,
        startedAt: now,
        payload: {
          'date': light.date,
          'mood': light.mood.value,
          'hasTags': light.hasTags,
        },
      );

      if (isNew) {
        await _incrementLightDaysInTxn(txn, uid, light.date);
      }
    });
    _ledger.notifyChange(
      LedgerChange(type: 'light_recorded', affectedIds: [light.id]),
    );
  }

  /// 删除指定日期的每日一光。
  Future<void> deleteDailyLight(String uid, String date) async {
    final db = await _ledger.database;
    await db.transaction((txn) async {
      final deleted = await txn.delete(
        'local_daily_lights',
        where: 'uid = ? AND date = ?',
        whereArgs: [uid, date],
      );
      if (deleted > 0) {
        await _decrementLightDaysInTxn(txn, uid);
      }
    });
    _ledger.notifyChange(
      LedgerChange(type: 'light_deleted', affectedIds: [date]),
    );
  }

  // ─── WeeklyReview 查询 ───

  /// 获取当前周的周回顾。
  Future<WeeklyReview?> getCurrentWeekReview(
    String uid,
    String currentWeekId,
  ) async {
    return getReviewByWeekId(uid, currentWeekId);
  }

  /// 按 weekId 获取周回顾。
  Future<WeeklyReview?> getReviewByWeekId(String uid, String weekId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_weekly_reviews',
      where: 'uid = ? AND week_id = ?',
      whereArgs: [uid, weekId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return WeeklyReview.fromSqlite(rows.first);
  }

  /// 获取 weekId 范围内的周回顾列表。
  Future<List<WeeklyReview>> getReviewsInRange(
    String uid,
    String startWeekId,
    String endWeekId,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_weekly_reviews',
      where: 'uid = ? AND week_id >= ? AND week_id <= ?',
      whereArgs: [uid, startWeekId, endWeekId],
      orderBy: 'week_id ASC',
    );
    return rows.map(WeeklyReview.fromSqlite).toList();
  }

  /// 获取用户累计周回顾次数（从统计表读取）。
  Future<int> getTotalReviewCount(String uid) async {
    final stats = await getAwarenessStats(uid);
    return stats['totalWeeklyReviews'] ?? 0;
  }

  // ─── WeeklyReview 写入（台账 + 领域表原子操作）───

  /// 保存周回顾（新增或更新），仅在完成时写入台账。
  Future<void> saveWeeklyReview(String uid, WeeklyReview review) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      final isNew = await _isNewWeeklyReview(txn, uid, review.weekId);

      await txn.insert(
        'local_weekly_reviews',
        review.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 仅在完成时写入台账和更新统计
      if (review.isComplete) {
        await _ledger.appendInTxn(
          txn,
          type: ActionType.weeklyReviewCompleted,
          uid: uid,
          startedAt: now,
          payload: {
            'weekId': review.weekId,
            'filledMoments': review.filledMomentCount,
          },
        );
        if (isNew) {
          await _incrementWeeklyReviewsInTxn(txn, uid);
        }
      }
    });
    // 完成的回顾发 'weekly_review_completed'，草稿发 'weekly_review_saved'
    final changeType = review.isComplete
        ? 'weekly_review_completed'
        : 'weekly_review_saved';
    _ledger.notifyChange(
      LedgerChange(type: changeType, affectedIds: [review.id]),
    );
  }

  // ─── 统计 ───

  /// 获取觉知统计数据。
  Future<Map<String, int>> getAwarenessStats(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_awareness_stats',
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) {
      return {
        'totalLightDays': 0,
        'totalWeeklyReviews': 0,
        'totalWorriesResolved': 0,
      };
    }
    final row = rows.first;
    return {
      'totalLightDays': row['total_light_days'] as int? ?? 0,
      'totalWeeklyReviews': row['total_weekly_reviews'] as int? ?? 0,
      'totalWorriesResolved': row['total_worries_resolved'] as int? ?? 0,
    };
  }

  // ─── 标签分析（Track 5 欢乐地图）───

  /// 获取标签频率分布（需要至少 minRecords 条有标签的记录）。
  Future<Map<String, int>> getTagFrequency(
    String uid, {
    int minRecords = 30,
  }) async {
    final db = await _ledger.database;

    // 先统计有标签的记录数
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) AS cnt FROM local_daily_lights '
      "WHERE uid = ? AND tags IS NOT NULL AND tags != '[]'",
      [uid],
    );
    final taggedCount = Sqflite.firstIntValue(countResult) ?? 0;
    if (taggedCount < minRecords) return {};

    // 读取所有有标签的行，手动解析聚合
    final rows = await db.query(
      'local_daily_lights',
      columns: ['tags'],
      where: "uid = ? AND tags IS NOT NULL AND tags != '[]'",
      whereArgs: [uid],
    );

    final frequency = <String, int>{};
    for (final row in rows) {
      final raw = row['tags'] as String?;
      if (raw == null) continue;
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        for (final tag in decoded) {
          if (tag is String && tag.isNotEmpty) {
            frequency[tag] = (frequency[tag] ?? 0) + 1;
          }
        }
      }
    }

    // 按频率降序排序
    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted);
  }

  // ─── 私有辅助 ───

  /// 检查指定日期是否为新记录（UNIQUE(uid, date) 不存在）。
  /// 接受 [DatabaseExecutor] 以便在事务内调用，避免竞态条件。
  Future<bool> _isNewDailyLight(
    DatabaseExecutor db,
    String uid,
    String date,
  ) async {
    final rows = await db.query(
      'local_daily_lights',
      columns: ['id'],
      where: 'uid = ? AND date = ?',
      whereArgs: [uid, date],
      limit: 1,
    );
    return rows.isEmpty;
  }

  /// 检查指定 weekId 是否为新记录。
  /// 接受 [DatabaseExecutor] 以便在事务内调用，避免竞态条件。
  Future<bool> _isNewWeeklyReview(
    DatabaseExecutor db,
    String uid,
    String weekId,
  ) async {
    final rows = await db.query(
      'local_weekly_reviews',
      columns: ['id'],
      where: 'uid = ? AND week_id = ?',
      whereArgs: [uid, weekId],
      limit: 1,
    );
    return rows.isEmpty;
  }

  /// 增加每日一光天数统计（事务内）。
  Future<void> _incrementLightDaysInTxn(
    Transaction txn,
    String uid,
    String date,
  ) async {
    await txn.rawInsert(
      'INSERT INTO local_awareness_stats '
      '(uid, total_light_days, total_weekly_reviews, total_worries_resolved, '
      'last_light_date, updated_at) '
      'VALUES (?, 1, 0, 0, ?, ?) '
      'ON CONFLICT(uid) DO UPDATE SET '
      'total_light_days = total_light_days + 1, '
      'last_light_date = excluded.last_light_date, '
      'updated_at = excluded.updated_at',
      [uid, date, DateTime.now().millisecondsSinceEpoch],
    );
  }

  /// 减少每日一光天数统计（事务内）。
  Future<void> _decrementLightDaysInTxn(Transaction txn, String uid) async {
    await txn.rawUpdate(
      'UPDATE local_awareness_stats SET '
      'total_light_days = MAX(total_light_days - 1, 0), '
      'updated_at = ? '
      'WHERE uid = ?',
      [DateTime.now().millisecondsSinceEpoch, uid],
    );
  }

  /// 增加周回顾次数统计（事务内）。
  Future<void> _incrementWeeklyReviewsInTxn(Transaction txn, String uid) async {
    await _ensureStatsRow(txn, uid);
    await txn.rawUpdate(
      'UPDATE local_awareness_stats SET '
      'total_weekly_reviews = total_weekly_reviews + 1, '
      'updated_at = ? '
      'WHERE uid = ?',
      [DateTime.now().millisecondsSinceEpoch, uid],
    );
  }

  /// 确保统计行存在（事务内）。
  Future<void> _ensureStatsRow(Transaction txn, String uid) async {
    await txn.rawInsert(
      'INSERT OR IGNORE INTO local_awareness_stats '
      '(uid, total_light_days, total_weekly_reviews, '
      'total_worries_resolved, updated_at) '
      'VALUES (?, 0, 0, 0, ?)',
      [uid, DateTime.now().millisecondsSinceEpoch],
    );
  }
}
