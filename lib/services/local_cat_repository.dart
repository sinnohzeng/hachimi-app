import 'package:hachimi_app/core/constants/cat_constants.dart' show CatState;
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show CatStage;
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
      where: 'uid = ? AND state = ?',
      whereArgs: [uid, CatState.active.value],
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
    _ledger.notifyChange(LedgerChange(type: ActionType.equip, affectedIds: [catId]));
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
    _ledger.notifyChange(LedgerChange(type: ActionType.unequip, affectedIds: [catId]));
  }

  /// 更新猫的姿势偏好（纯本地，不写台账）。
  Future<void> updateDisplayPose(String catId, int pose) async {
    final db = await _ledger.database;
    await db.update(
      'local_cats',
      {'display_pose': pose},
      where: 'id = ?',
      whereArgs: [catId],
    );
    _ledger.notifyChange(
      LedgerChange(type: ActionType.catUpdate, affectedIds: [catId]),
    );
  }

  /// 归档猫猫 — 原子事务：猫归档 + 习惯软删除 + 台账 + 通知。
  ///
  /// 跨表操作说明：此方法同时写 local_cats 和 local_habits，
  /// 与 LocalHabitRepository.delete() 的软删除逻辑一致。
  /// 如果 delete() 的行为发生变化，此处需同步更新。
  Future<void> archive(String uid, String catId, String habitId) async {
    final db = await _ledger.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      await txn.update(
        'local_cats',
        {'state': CatState.graduated.value},
        where: 'id = ?',
        whereArgs: [catId],
      );
      if (habitId.isNotEmpty) {
        await txn.update(
          'local_habits',
          {'is_active': 0},
          where: 'id = ?',
          whereArgs: [habitId],
        );
      }
      await _ledger.appendInTxn(
        txn,
        type: ActionType.habitDelete,
        uid: uid,
        startedAt: now,
        payload: {'habitId': habitId, 'catId': catId, 'reason': 'archive'},
      );
    });

    _ledger.notifyChange(
      LedgerChange(type: ActionType.habitDelete, affectedIds: [habitId, catId]),
    );
  }

  /// 重新激活已归档的猫猫 — 恢复猫状态 + 习惯活跃 + 台账。
  ///
  /// 跨表操作说明：同 archive()。
  /// 习惯行可能因数据损坏不存在 — UPDATE 0 rows 是安全的。
  Future<void> reactivate(String uid, String catId, String habitId) async {
    final db = await _ledger.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      await txn.update(
        'local_cats',
        {'state': CatState.active.value},
        where: 'id = ?',
        whereArgs: [catId],
      );
      if (habitId.isNotEmpty) {
        await txn.update(
          'local_habits',
          {'is_active': 1},
          where: 'id = ?',
          whereArgs: [habitId],
        );
      }
      await _ledger.appendInTxn(
        txn,
        type: ActionType.habitRestore,
        uid: uid,
        startedAt: now,
        payload: {'habitId': habitId, 'catId': catId},
      );
    });

    _ledger.notifyChange(
      LedgerChange(type: ActionType.habitRestore, affectedIds: [habitId, catId]),
    );
  }

  // ─── 内部工具 ───

  /// 阶段计算 — 委托到 [CatStage] 枚举。
  static String _computeStage(int totalMinutes) =>
      CatStage.computeFromMinutes(totalMinutes).value;

  static String _higherStage(String? a, String b) {
    if (a == null) return b;
    return CatStage.higher(CatStage.fromValue(a), CatStage.fromValue(b)).value;
  }
}
