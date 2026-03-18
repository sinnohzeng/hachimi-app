import 'dart:convert';

import 'package:sqflite/sqflite.dart' show Transaction;

import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/json_helpers.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// InventoryService — 道具箱装备/卸下操作，委托 LedgerService。
class InventoryService {
  final LedgerService _ledger;

  InventoryService({required LedgerService ledger}) : _ledger = ledger;

  /// 装备配饰到猫。
  /// 从 inventory 移除 accessoryId → 设置到 cat equipped_accessory。
  /// 若猫已有装备，旧配饰自动返回 inventory。
  Future<void> equipAccessory({
    required String uid,
    required String catId,
    required String accessoryId,
  }) async {
    final db = await _ledger.database;
    try {
      await db.transaction(
        (txn) => _executeEquipTxn(txn, uid, catId, accessoryId),
      );
      _ledger.notifyChange(
        LedgerChange(type: ActionType.equip, affectedIds: [catId]),
      );
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'InventoryService',
        operation: 'equipAccessory',
      );
      rethrow;
    }
  }

  /// 卸下猫的配饰，返回道具箱。
  Future<void> unequipAccessory({
    required String uid,
    required String catId,
  }) async {
    final db = await _ledger.database;
    try {
      await db.transaction((txn) => _executeUnequipTxn(txn, uid, catId));
      _ledger.notifyChange(
        LedgerChange(type: ActionType.unequip, affectedIds: [catId]),
      );
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'InventoryService',
        operation: 'unequipAccessory',
      );
      rethrow;
    }
  }

  /// 装备事务：读取猫装备 → 交换 inventory → 设置新装备 → 写台账。
  Future<void> _executeEquipTxn(
    Transaction txn,
    String uid,
    String catId,
    String accessoryId,
  ) async {
    final catRows = await txn.query(
      'local_cats',
      columns: ['equipped_accessory'],
      where: 'id = ?',
      whereArgs: [catId],
      limit: 1,
    );
    if (catRows.isEmpty) throw StateError('Cat $catId not found');

    final oldEquipped = catRows.first['equipped_accessory'] as String?;
    final invRaw = await _ledger.getMaterializedInTxn(txn, uid, 'inventory');
    final inventory = decodeJsonStringList(invRaw);

    inventory.remove(accessoryId);
    if (oldEquipped != null && oldEquipped.isNotEmpty) {
      inventory.add(oldEquipped);
    }

    await _ledger.setMaterializedInTxn(
      txn,
      uid,
      'inventory',
      jsonEncode(inventory),
    );
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
      startedAt: DateTime.now(),
      payload: {
        'catId': catId,
        'accessoryId': accessoryId,
        'previousId': oldEquipped,
      },
    );
  }

  /// 卸下事务：读取猫装备 → 返回 inventory → 清除装备 → 写台账。
  Future<void> _executeUnequipTxn(
    Transaction txn,
    String uid,
    String catId,
  ) async {
    final catRows = await txn.query(
      'local_cats',
      columns: ['equipped_accessory'],
      where: 'id = ?',
      whereArgs: [catId],
      limit: 1,
    );
    if (catRows.isEmpty) throw StateError('Cat $catId not found');

    final equipped = catRows.first['equipped_accessory'] as String?;
    if (equipped == null || equipped.isEmpty) return;

    final invRaw = await _ledger.getMaterializedInTxn(txn, uid, 'inventory');
    final inventory = decodeJsonStringList(invRaw);
    inventory.add(equipped);
    await _ledger.setMaterializedInTxn(
      txn,
      uid,
      'inventory',
      jsonEncode(inventory),
    );
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
      startedAt: DateTime.now(),
      payload: {'catId': catId, 'accessoryId': equipped},
    );
  }
}
