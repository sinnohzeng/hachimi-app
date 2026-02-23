import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 本地习惯仓库 — local_habits 表 CRUD + 台账写入。
/// 所有写操作在 SQLite 事务中同时更新领域表和行为台账。
class LocalHabitRepository {
  final LedgerService _ledger;

  LocalHabitRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── 查询 ───

  /// 获取用户所有活跃习惯。
  Future<List<Habit>> getActiveHabits(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_habits',
      where: 'uid = ? AND is_active = 1',
      whereArgs: [uid],
      orderBy: 'created_at ASC',
    );
    return rows.map(Habit.fromSqlite).toList();
  }

  /// 获取用户所有习惯（含非活跃）。
  Future<List<Habit>> getAllHabits(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_habits',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'created_at ASC',
    );
    return rows.map(Habit.fromSqlite).toList();
  }

  /// 按 ID 获取习惯。
  Future<Habit?> getHabit(String habitId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_habits',
      where: 'id = ?',
      whereArgs: [habitId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Habit.fromSqlite(rows.first);
  }

  // ─── 写入（台账 + 领域表原子操作）───

  /// 创建习惯。
  Future<void> create(String uid, Habit habit) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert('local_habits', habit.toSqlite(uid));
      await _ledger.appendInTxn(
        txn,
        type: ActionType.habitCreate,
        uid: uid,
        startedAt: now,
        payload: {
          'habitId': habit.id,
          'catId': habit.catId,
          'name': habit.name,
        },
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: 'habit_create', affectedIds: [habit.id]),
    );
  }

  /// 更新习惯。
  Future<void> update(String uid, Habit habit) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.update(
        'local_habits',
        habit.toSqlite(uid),
        where: 'id = ?',
        whereArgs: [habit.id],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.habitUpdate,
        uid: uid,
        startedAt: now,
        payload: {'habitId': habit.id, 'name': habit.name},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: 'habit_update', affectedIds: [habit.id]),
    );
  }

  /// 删除习惯（软删除：is_active = 0）。
  Future<void> delete(String uid, String habitId) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.update(
        'local_habits',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [habitId],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.habitDelete,
        uid: uid,
        startedAt: now,
        payload: {'habitId': habitId},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: 'habit_delete', affectedIds: [habitId]),
    );
  }

  /// 更新习惯的累计分钟数和签到天数（计时完成时调用）。
  Future<void> updateProgress(
    String uid,
    String habitId, {
    required int addMinutes,
    required String checkInDate,
  }) async {
    final db = await _ledger.database;
    await db.transaction((txn) async {
      final rows = await txn.query(
        'local_habits',
        columns: ['total_minutes', 'total_check_in_days', 'last_check_in_date'],
        where: 'id = ?',
        whereArgs: [habitId],
        limit: 1,
      );
      if (rows.isEmpty) return;

      final current = rows.first;
      final oldMinutes = current['total_minutes'] as int? ?? 0;
      final oldDays = current['total_check_in_days'] as int? ?? 0;
      final lastDate = current['last_check_in_date'] as String?;
      final isNewDay = lastDate != checkInDate;

      await txn.update(
        'local_habits',
        {
          'total_minutes': oldMinutes + addMinutes,
          'last_check_in_date': checkInDate,
          if (isNewDay) 'total_check_in_days': oldDays + 1,
        },
        where: 'id = ?',
        whereArgs: [habitId],
      );
    });
    // 由调用方负责广播（通常和 session 写入合并广播）
  }
}
