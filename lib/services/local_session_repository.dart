import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:intl/intl.dart';

final _dayFormat = DateFormat('yyyy-MM-dd');

DateTime _todayStart() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// 本地会话仓库 — local_sessions 表 CRUD + 台账写入。
class LocalSessionRepository {
  final LedgerService _ledger;

  LocalSessionRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── 查询 ───

  /// 获取今天的已完成会话。
  Future<List<FocusSession>> getTodaySessions(String uid) async {
    final db = await _ledger.database;
    final todayStart = _todayStart();
    final rows = await db.query(
      'local_sessions',
      where: "uid = ? AND started_at >= ? AND status = 'completed'",
      whereArgs: [uid, todayStart.millisecondsSinceEpoch],
      orderBy: 'started_at DESC',
    );
    return rows.map(FocusSession.fromSqlite).toList();
  }

  /// 获取指定习惯的今天已完成会话总分钟数。
  Future<int> getTodayMinutesForHabit(String uid, String habitId) async {
    final db = await _ledger.database;
    final todayStart = _todayStart();
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(duration_minutes), 0) as total '
      'FROM local_sessions '
      "WHERE uid = ? AND habit_id = ? AND started_at >= ? AND status = 'completed'",
      [uid, habitId, todayStart.millisecondsSinceEpoch],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  /// 获取最近 N 天每日分钟数（用于活动热力图）。
  Future<Map<String, int>> getDailyMinutes(String uid, int days) async {
    final db = await _ledger.database;
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    final rows = await db.rawQuery(
      'SELECT started_at, duration_minutes '
      'FROM local_sessions '
      "WHERE uid = ? AND started_at >= ? AND status = 'completed'",
      [uid, cutoff],
    );

    final result = <String, int>{};
    for (final row in rows) {
      final ts = row['started_at'] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(ts);
      final key = _dayFormat.format(date);
      result[key] = (result[key] ?? 0) + (row['duration_minutes'] as int);
    }
    return result;
  }

  /// 获取指定习惯最近 N 天每日分钟数（用于单 habit 活动热力图）。
  Future<Map<String, int>> getDailyMinutesForHabit(
    String uid,
    String habitId, {
    int days = 91,
  }) async {
    final db = await _ledger.database;
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    final rows = await db.rawQuery(
      'SELECT started_at, duration_minutes '
      'FROM local_sessions '
      "WHERE uid = ? AND habit_id = ? AND started_at >= ? AND status = 'completed'",
      [uid, habitId, cutoff],
    );

    final result = <String, int>{};
    for (final row in rows) {
      final ts = row['started_at'] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(ts);
      final key = _dayFormat.format(date);
      result[key] = (result[key] ?? 0) + (row['duration_minutes'] as int);
    }
    return result;
  }

  /// 获取最近 N 条会话。
  Future<List<FocusSession>> getRecentSessions(
    String uid, {
    int limit = 5,
  }) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_sessions',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'started_at DESC',
      limit: limit,
    );
    return rows.map(FocusSession.fromSqlite).toList();
  }

  /// 获取指定习惯的分页会话历史。
  Future<List<FocusSession>> getSessionHistory(
    String uid, {
    String? habitId,
    String? month,
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await _ledger.database;
    final query = _buildHistoryQuery(uid, habitId: habitId, month: month);

    final rows = await db.query(
      'local_sessions',
      where: query.where,
      whereArgs: query.args,
      orderBy: 'started_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(FocusSession.fromSqlite).toList();
  }

  /// 构建历史查询的 WHERE + 参数。
  ({String where, List<dynamic> args}) _buildHistoryQuery(
    String uid, {
    String? habitId,
    String? month,
  }) {
    final where = StringBuffer('uid = ?');
    final args = <dynamic>[uid];

    if (habitId != null) {
      where.write(' AND habit_id = ?');
      args.add(habitId);
    }

    final range = month != null ? _parseMonthRange(month) : null;
    if (range != null) {
      where.write(' AND started_at >= ? AND started_at < ?');
      args.addAll([range.startMs, range.endMs]);
    }

    return (where: where.toString(), args: args);
  }

  /// 解析 "yyyy-MM" 格式月份为毫秒时间范围，格式无效返回 null。
  ({int startMs, int endMs})? _parseMonthRange(String month) {
    final parts = month.split('-');
    if (parts.length != 2) return null;
    final year = int.tryParse(parts[0]);
    final mon = int.tryParse(parts[1]);
    if (year == null || mon == null || mon < 1 || mon > 12) return null;
    return (
      startMs: DateTime(year, mon).millisecondsSinceEpoch,
      endMs: DateTime(year, mon + 1).millisecondsSinceEpoch,
    );
  }

  /// 获取用户的总会话数。
  Future<int> getTotalSessionCount(String uid) async {
    final db = await _ledger.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM local_sessions '
      "WHERE uid = ? AND status = 'completed'",
      [uid],
    );
    return (result.first['count'] as int?) ?? 0;
  }

  // ─── 写入 ───

  /// 记录会话并写入台账（原子操作）。
  Future<void> logSession(String uid, FocusSession session) async {
    final db = await _ledger.database;
    final actionType = session.isCompleted
        ? ActionType.focusComplete
        : ActionType.focusAbandon;

    await db.transaction((txn) async {
      await txn.insert('local_sessions', session.toSqlite(uid));

      await _ledger.appendInTxn(
        txn,
        type: actionType,
        uid: uid,
        startedAt: session.startedAt,
        endedAt: session.endedAt,
        payload: {
          'habitId': session.habitId,
          'catId': session.catId,
          'minutes': session.durationMinutes,
          'mode': session.mode,
        },
        result: {'coins': session.coinsEarned, 'xp': session.xpEarned},
      );
    });

    _ledger.notifyChange(
      LedgerChange(
        type: actionType.value,
        affectedIds: [session.habitId, session.catId],
      ),
    );
  }
}
