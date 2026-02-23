import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 本地猫仓库 — local_cats 表 CRUD + 台账写入。
class LocalCatRepository {
  final LedgerService _ledger;

  LocalCatRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── 查询 ───

  /// 获取用户所有活跃猫。
  Future<List<Cat>> getActiveCats(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_cats',
      where: "uid = ? AND state = 'active'",
      whereArgs: [uid],
      orderBy: 'created_at ASC',
    );
    return rows.map(Cat.fromSqlite).toList();
  }

  /// 获取用户所有猫（含毕业/休眠）。
  Future<List<Cat>> getAllCats(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_cats',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'created_at ASC',
    );
    return rows.map(Cat.fromSqlite).toList();
  }

  /// 按 ID 获取猫。
  Future<Cat?> getCat(String catId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_cats',
      where: 'id = ?',
      whereArgs: [catId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Cat.fromSqlite(rows.first);
  }

  /// 按习惯 ID 获取猫。
  Future<Cat?> getCatByHabit(String uid, String habitId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_cats',
      where: 'uid = ? AND bound_habit_id = ?',
      whereArgs: [uid, habitId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Cat.fromSqlite(rows.first);
  }

  // ─── 写入 ───

  /// 创建猫（通常和习惯一起创建）。
  Future<void> create(String uid, Cat cat) async {
    final db = await _ledger.database;
    await db.insert('local_cats', cat.toSqlite(uid));
    // 台账由习惯创建时统一写入（habit_create payload 包含 catId）
  }

  /// 更新猫。
  Future<void> update(String uid, Cat cat) async {
    final db = await _ledger.database;
    await db.update(
      'local_cats',
      cat.toSqlite(uid),
      where: 'id = ?',
      whereArgs: [cat.id],
    );
  }

  /// 更新猫的累计分钟数和最后会话时间（计时完成时调用）。
  Future<void> updateProgress(
    String uid,
    String catId, {
    required int addMinutes,
    required DateTime sessionAt,
  }) async {
    final db = await _ledger.database;
    await db.transaction((txn) async {
      final rows = await txn.query(
        'local_cats',
        columns: ['total_minutes', 'highest_stage'],
        where: 'id = ?',
        whereArgs: [catId],
        limit: 1,
      );
      if (rows.isEmpty) return;

      final oldMinutes = rows.first['total_minutes'] as int? ?? 0;
      final newMinutes = oldMinutes + addMinutes;

      // 阶段计算：0/20/100/200h → kitten/adolescent/adult/senior
      final newStage = _computeStage(newMinutes);
      final oldHighest = rows.first['highest_stage'] as String?;
      final highestStage = _higherStage(oldHighest, newStage);

      await txn.update(
        'local_cats',
        {
          'total_minutes': newMinutes,
          'last_session_at': sessionAt.millisecondsSinceEpoch,
          'highest_stage': highestStage,
        },
        where: 'id = ?',
        whereArgs: [catId],
      );
    });
    // 由调用方负责广播
  }

  /// 装备配饰。
  Future<void> equipAccessory(
    String uid,
    String catId,
    String accessoryId,
  ) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      // 读取当前装备
      final rows = await txn.query(
        'local_cats',
        columns: ['equipped_accessory'],
        where: 'id = ?',
        whereArgs: [catId],
        limit: 1,
      );
      final previousId = rows.isNotEmpty
          ? rows.first['equipped_accessory'] as String?
          : null;

      await txn.update(
        'local_cats',
        {'equipped_accessory': accessoryId},
        where: 'id = ?',
        whereArgs: [catId],
      );

      await _ledger.appendInTxn(
        txn,
        type: ActionType.equip,
        uid: uid,
        startedAt: now,
        payload: {
          'catId': catId,
          'accessoryId': accessoryId,
          'previousId': previousId,
        },
      );
    });
    _ledger.notifyChange(LedgerChange(type: 'equip', affectedIds: [catId]));
  }

  /// 卸下配饰。
  Future<void> unequipAccessory(
    String uid,
    String catId,
    String accessoryId,
  ) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.update(
        'local_cats',
        {'equipped_accessory': null},
        where: 'id = ?',
        whereArgs: [catId],
      );

      await _ledger.appendInTxn(
        txn,
        type: ActionType.unequip,
        uid: uid,
        startedAt: now,
        payload: {'catId': catId, 'accessoryId': accessoryId},
      );
    });
    _ledger.notifyChange(LedgerChange(type: 'unequip', affectedIds: [catId]));
  }

  /// 将猫设为毕业状态。
  Future<void> graduate(String uid, String catId) async {
    final db = await _ledger.database;
    await db.update(
      'local_cats',
      {'state': 'graduated'},
      where: 'id = ?',
      whereArgs: [catId],
    );
  }

  // ─── 内部工具 ───

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
}
