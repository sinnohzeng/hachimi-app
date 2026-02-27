import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/local_database_service.dart';

const _uuid = Uuid();

/// 行为台账核心服务。
/// 职责：action_ledger 写入 + materialized_state CRUD + 变更广播。
/// 领域 Repository 通过此服务在 SQLite 事务中同时写台账和更新物化状态。
class LedgerService {
  final LocalDatabaseService _localDb;
  final _changeController = StreamController<LedgerChange>.broadcast();

  LedgerService({required LocalDatabaseService localDb}) : _localDb = localDb;

  /// 变更事件流 — Provider 和 AchievementEvaluator 监听此流。
  Stream<LedgerChange> get changes => _changeController.stream;

  /// 获取数据库实例（透传给 Repository 用于事务）。
  Future<Database> get database => _localDb.database;

  // ─── 台账写入 ───

  /// 追加一条台账记录（在已有事务内执行）。
  Future<void> appendInTxn(
    Transaction txn, {
    required ActionType type,
    required String uid,
    required DateTime startedAt,
    DateTime? endedAt,
    Map<String, dynamic> payload = const {},
    Map<String, dynamic> result = const {},
  }) async {
    final now = DateTime.now();
    await txn.insert('action_ledger', {
      'id': _uuid.v4(),
      'type': type.value,
      'uid': uid,
      'started_at': startedAt.millisecondsSinceEpoch,
      'ended_at': (endedAt ?? startedAt).millisecondsSinceEpoch,
      'payload': jsonEncode(payload),
      'result': jsonEncode(result),
      'synced': 0,
      'sync_attempts': 0,
      'created_at': now.millisecondsSinceEpoch,
    });
  }

  /// 追加台账并广播变更（独立事务，适用于简单操作）。
  Future<void> append({
    required ActionType type,
    required String uid,
    required DateTime startedAt,
    DateTime? endedAt,
    Map<String, dynamic> payload = const {},
    Map<String, dynamic> result = const {},
    List<String> affectedIds = const [],
  }) async {
    final db = await database;
    await db.transaction((txn) async {
      await appendInTxn(
        txn,
        type: type,
        uid: uid,
        startedAt: startedAt,
        endedAt: endedAt,
        payload: payload,
        result: result,
      );
    });
    _changeController.add(
      LedgerChange(type: type.value, affectedIds: affectedIds),
    );
  }

  /// 广播变更事件（供 Repository 在事务完成后调用）。
  void notifyChange(LedgerChange change) {
    _changeController.add(change);
  }

  // ─── Materialized State CRUD ───

  /// 获取物化状态值（事务内）。
  Future<String?> getMaterializedInTxn(
    Transaction txn,
    String uid,
    String key,
  ) async {
    final rows = await txn.query(
      'materialized_state',
      columns: ['value'],
      where: 'uid = ? AND key = ?',
      whereArgs: [uid, key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  /// 设置物化状态值（事务内）。
  Future<void> setMaterializedInTxn(
    Transaction txn,
    String uid,
    String key,
    String value,
  ) async {
    await txn.insert('materialized_state', {
      'uid': uid,
      'key': key,
      'value': value,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// 获取物化状态（非事务）。
  Future<String?> getMaterialized(String uid, String key) async {
    final db = await database;
    final rows = await db.query(
      'materialized_state',
      columns: ['value'],
      where: 'uid = ? AND key = ?',
      whereArgs: [uid, key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  /// 获取物化状态（整型）。
  Future<int?> getMaterializedInt(String uid, String key) async {
    final raw = await getMaterialized(uid, key);
    if (raw == null) return null;
    return int.tryParse(raw);
  }

  /// 设置物化状态（非事务）。
  Future<void> setMaterialized(String uid, String key, String value) async {
    final db = await database;
    await db.insert('materialized_state', {
      'uid': uid,
      'key': key,
      'value': value,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ─── 台账查询 ───

  /// 获取待同步的台账记录（synced=0，按创建时间正序）。
  Future<List<LedgerAction>> getUnsyncedActions({int limit = 20}) async {
    final db = await database;
    final rows = await db.query(
      'action_ledger',
      where: 'synced = 0',
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return rows
        .map(LedgerAction.fromSqliteSafe)
        .whereType<LedgerAction>()
        .toList();
  }

  /// 标记台账为已同步。
  Future<void> markSynced(String actionId) async {
    final db = await database;
    await db.update(
      'action_ledger',
      {'synced': 1, 'synced_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [actionId],
    );
  }

  /// 标记台账同步失败。
  Future<void> markSyncFailed(
    String actionId,
    String error,
    int attempts,
  ) async {
    final db = await database;
    final synced = attempts >= 5 ? 2 : 0; // 超过 5 次标记永久失败
    await db.update(
      'action_ledger',
      {'synced': synced, 'sync_attempts': attempts, 'sync_error': error},
      where: 'id = ?',
      whereArgs: [actionId],
    );
  }

  /// 清理已同步超过 90 天的台账记录。
  Future<int> cleanOldSyncedActions() async {
    final db = await database;
    final cutoff = DateTime.now()
        .subtract(const Duration(days: 90))
        .millisecondsSinceEpoch;
    return db.delete(
      'action_ledger',
      where: 'synced = 1 AND synced_at < ?',
      whereArgs: [cutoff],
    );
  }

  /// 批量更新台账和本地表中的 uid（访客→正式用户迁移用）。
  Future<void> migrateUid(String oldUid, String newUid) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final table in [
        'action_ledger',
        'local_habits',
        'local_cats',
        'local_sessions',
        'local_monthly_checkins',
        'materialized_state',
        'local_achievements',
      ]) {
        await txn.update(
          table,
          {'uid': newUid},
          where: 'uid = ?',
          whereArgs: [oldUid],
        );
      }
    });
  }

  /// 释放资源。
  void dispose() {
    _changeController.close();
  }
}
