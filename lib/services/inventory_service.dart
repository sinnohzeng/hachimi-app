import 'dart:convert';

import 'package:hachimi_app/core/utils/error_handler.dart';
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
    final now = DateTime.now();

    try {
      await db.transaction((txn) async {
        // 读取猫当前装备
        final catRows = await txn.query(
          'local_cats',
          columns: ['equipped_accessory'],
          where: 'id = ?',
          whereArgs: [catId],
          limit: 1,
        );
        if (catRows.isEmpty) {
          throw StateError('Cat $catId not found');
        }

        final oldEquipped = catRows.first['equipped_accessory'] as String?;

        // 读取 inventory
        final invRaw = await _ledger.getMaterializedInTxn(
          txn,
          uid,
          'inventory',
        );
        final inventory = _decodeInventory(invRaw);

        // 从 inventory 移除新配饰
        inventory.remove(accessoryId);

        // 若猫已有装备，旧配饰返回 inventory
        if (oldEquipped != null && oldEquipped.isNotEmpty) {
          inventory.add(oldEquipped);
        }

        // 更新 inventory
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'inventory',
          jsonEncode(inventory),
        );

        // 设置新装备
        await txn.update(
          'local_cats',
          {'equipped_accessory': accessoryId},
          where: 'id = ?',
          whereArgs: [catId],
        );

        // 写台账
        await _ledger.appendInTxn(
          txn,
          type: ActionType.equip,
          uid: uid,
          startedAt: now,
          payload: {
            'catId': catId,
            'accessoryId': accessoryId,
            'previousId': oldEquipped,
          },
        );
      });

      _ledger.notifyChange(LedgerChange(type: 'equip', affectedIds: [catId]));
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'InventoryService',
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
    final now = DateTime.now();

    try {
      await db.transaction((txn) async {
        // 读取猫当前装备
        final catRows = await txn.query(
          'local_cats',
          columns: ['equipped_accessory'],
          where: 'id = ?',
          whereArgs: [catId],
          limit: 1,
        );
        if (catRows.isEmpty) {
          throw StateError('Cat $catId not found');
        }

        final equipped = catRows.first['equipped_accessory'] as String?;
        if (equipped == null || equipped.isEmpty) return;

        // 返回 inventory
        final invRaw = await _ledger.getMaterializedInTxn(
          txn,
          uid,
          'inventory',
        );
        final inventory = _decodeInventory(invRaw);
        inventory.add(equipped);
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'inventory',
          jsonEncode(inventory),
        );

        // 清除装备
        await txn.update(
          'local_cats',
          {'equipped_accessory': null},
          where: 'id = ?',
          whereArgs: [catId],
        );

        // 写台账
        await _ledger.appendInTxn(
          txn,
          type: ActionType.unequip,
          uid: uid,
          startedAt: now,
          payload: {'catId': catId, 'accessoryId': equipped},
        );
      });

      _ledger.notifyChange(LedgerChange(type: 'unequip', affectedIds: [catId]));
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'InventoryService',
        operation: 'unequipAccessory',
      );
      rethrow;
    }
  }

  List<String> _decodeInventory(String? raw) {
    if (raw == null) return [];
    final decoded = jsonDecode(raw);
    if (decoded is List) return decoded.whereType<String>().toList();
    return [];
  }
}
