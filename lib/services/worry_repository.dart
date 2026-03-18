import 'package:sqflite/sqflite.dart';

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/services/awareness_repository.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 烦恼仓库 — local_worries 表 CRUD + 台账写入。
/// 所有写操作在 SQLite 事务中同时更新领域表和行为台账。
class WorryRepository {
  final LedgerService _ledger;

  WorryRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── 查询 ───

  /// 获取用户所有进行中的烦恼（按创建时间倒序）。
  Future<List<Worry>> getActiveWorries(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: "uid = ? AND status = 'ongoing'",
      whereArgs: [uid],
      orderBy: 'created_at DESC',
    );
    return rows.map(Worry.fromSqlite).toList();
  }

  /// 获取用户所有已终结的烦恼（按解决时间倒序）。
  Future<List<Worry>> getResolvedWorries(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: "uid = ? AND status IN ('resolved', 'disappeared')",
      whereArgs: [uid],
      orderBy: 'resolved_at DESC',
    );
    return rows.map(Worry.fromSqlite).toList();
  }

  /// 获取用户所有烦恼（按创建时间倒序）。
  Future<List<Worry>> getAllWorries(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'created_at DESC',
    );
    return rows.map(Worry.fromSqlite).toList();
  }

  /// 按 ID 获取烦恼。
  Future<Worry?> getWorry(String uid, String worryId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: 'uid = ? AND id = ?',
      whereArgs: [uid, worryId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Worry.fromSqlite(rows.first);
  }

  /// 获取用户累计已解决烦恼数（从统计表读取）。
  Future<int> getResolvedCount(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_awareness_stats',
      columns: ['total_worries_resolved'],
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return rows.first['total_worries_resolved'] as int? ?? 0;
  }

  // ─── 写入（台账 + 领域表原子操作）───

  /// 创建烦恼。
  Future<void> create(String uid, Worry worry) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert('local_worries', worry.toSqlite(uid));
      await _ledger.appendInTxn(
        txn,
        type: ActionType.worryCreated,
        uid: uid,
        startedAt: now,
        payload: {'worryId': worry.id},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.worryCreated, affectedIds: [worry.id]),
    );
  }

  /// 更新烦恼。
  Future<void> update(String uid, Worry worry) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.update(
        'local_worries',
        worry.toSqlite(uid),
        where: 'id = ? AND uid = ?',
        whereArgs: [worry.id, uid],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.worryUpdated,
        uid: uid,
        startedAt: now,
        payload: {'worryId': worry.id},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.worryUpdated, affectedIds: [worry.id]),
    );
  }

  /// 解决烦恼（更新状态 + 记录解决时间 + 更新统计）。
  Future<void> resolve(
    String uid,
    String worryId,
    WorryStatus newStatus,
  ) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.update(
        'local_worries',
        {
          'status': newStatus.value,
          'resolved_at': now.millisecondsSinceEpoch,
          'updated_at': now.millisecondsSinceEpoch,
        },
        where: 'id = ? AND uid = ?',
        whereArgs: [worryId, uid],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.worryResolved,
        uid: uid,
        startedAt: now,
        payload: {'worryId': worryId, 'newStatus': newStatus.value},
      );
      await _incrementWorriesResolvedInTxn(txn, uid);
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.worryResolved, affectedIds: [worryId]),
    );
  }

  /// 删除烦恼。
  Future<void> delete(String uid, String worryId) async {
    final db = await _ledger.database;
    await db.transaction((txn) async {
      await txn.delete(
        'local_worries',
        where: 'id = ? AND uid = ?',
        whereArgs: [worryId, uid],
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.worryDeleted, affectedIds: [worryId]),
    );
  }

  // ─── 私有辅助 ───

  /// 增加已解决烦恼数统计（事务内）。
  Future<void> _incrementWorriesResolvedInTxn(
    Transaction txn,
    String uid,
  ) async {
    await AwarenessRepository.incrementStatInTxn(
      txn,
      uid,
      'total_worries_resolved',
    );
  }
}
