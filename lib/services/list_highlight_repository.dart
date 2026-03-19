import 'package:sqflite/sqflite.dart';

import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 清单与高光仓库 — UserList + HighlightEntry CRUD + 台账写入。
/// 所有写操作在 SQLite 事务中同时更新领域表和行为台账。
class ListHighlightRepository {
  final LedgerService _ledger;

  ListHighlightRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── UserList 查询 ───

  /// 按年份获取所有清单。
  Future<List<UserList>> getListsByYear(String uid, int year) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_user_lists',
      where: 'uid = ? AND year = ?',
      whereArgs: [uid, year],
      orderBy: 'created_at DESC',
    );
    return rows.map(UserList.fromSqlite).toList();
  }

  /// 按 ID 获取清单。
  Future<UserList?> getList(String uid, String listId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_user_lists',
      where: 'uid = ? AND id = ?',
      whereArgs: [uid, listId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserList.fromSqlite(rows.first);
  }

  /// 保存清单（新增或更新）。
  Future<void> saveList(String uid, UserList list) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_user_lists',
        list.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.listUpdated,
        uid: uid,
        startedAt: now,
        payload: {'listId': list.id, 'type': list.type.value},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.listUpdated, affectedIds: [list.id]),
    );
  }

  // ─── HighlightEntry 查询 ───

  /// 按年份和类型获取高光时刻。
  Future<List<HighlightEntry>> getHighlightsByYear(
    String uid,
    int year,
    HighlightType type,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_highlight_entries',
      where: 'uid = ? AND year = ? AND type = ?',
      whereArgs: [uid, year, type.value],
      orderBy: 'date DESC',
    );
    return rows.map(HighlightEntry.fromSqlite).toList();
  }

  /// 保存高光时刻（新增或更新）。
  Future<void> saveHighlight(String uid, HighlightEntry entry) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_highlight_entries',
        entry.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.highlightRecorded,
        uid: uid,
        startedAt: now,
        payload: {
          'highlightId': entry.id,
          'type': entry.type.value,
          'year': entry.year,
        },
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.highlightRecorded, affectedIds: [entry.id]),
    );
  }
}
