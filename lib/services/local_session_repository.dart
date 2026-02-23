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
    final where = StringBuffer('uid = ?');
    final args = <dynamic>[uid];

    if (habitId != null) {
      where.write(' AND habit_id = ?');
      args.add(habitId);
    }
    if (month != null) {
      final parts = month.split('-');
      if (parts.length == 2) {
        final year = int.parse(parts[0]);
        final mon = int.parse(parts[1]);
        final start = DateTime(year, mon);
        final end = DateTime(year, mon + 1);
        where.write(' AND started_at >= ? AND started_at < ?');
        args.addAll([start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
      }
    }

    final rows = await db.query(
      'local_sessions',
      where: where.toString(),
      whereArgs: args,
      orderBy: 'started_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(FocusSession.fromSqlite).toList();
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
