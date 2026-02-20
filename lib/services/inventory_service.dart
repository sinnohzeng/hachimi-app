// ---
// 📘 文件说明：
// InventoryService — 用户级道具箱服务。
// 管理配饰的装备、卸下、道具箱监听。
//
// 📋 程序整体伪代码：
// 1. watchInventory：实时监听用户 inventory 字段；
// 2. equipAccessory：transaction 将配饰从 inventory 移到猫；
// 3. unequipAccessory：transaction 将配饰从猫移回 inventory；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// InventoryService — 道具箱装备/卸下操作。
/// 所有写操作使用 transaction 保证原子性。
class InventoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _userRef(String uid) =>
      _db.collection('users').doc(uid);

  DocumentReference _catRef(String uid, String catId) =>
      _db.collection('users').doc(uid).collection('cats').doc(catId);

  /// 实时监听道具箱。
  Stream<List<String>> watchInventory(String uid) {
    return _userRef(uid).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final list = data?['inventory'] as List<dynamic>?;
      return list?.cast<String>() ?? const [];
    });
  }

  /// 装备配饰到猫。
  /// 从 inventory 移除 accessoryId → 设置到 cat.equippedAccessory。
  /// 若猫已有装备，旧配饰自动返回 inventory。
  Future<void> equipAccessory({
    required String uid,
    required String catId,
    required String accessoryId,
  }) async {
    final userRef = _userRef(uid);
    final catRef = _catRef(uid, catId);

    try {
      await _db.runTransaction((tx) async {
        final catDoc = await tx.get(catRef);
        if (!catDoc.exists) {
          throw StateError('Cat document $catId not found for user $uid');
        }

        final catData = catDoc.data() as Map<String, dynamic>? ?? {};
        final oldEquipped = catData['equippedAccessory'] as String?;

        // 从 inventory 移除新配饰
        tx.update(userRef, {
          'inventory': FieldValue.arrayRemove([accessoryId]),
        });

        // 若猫已有装备，旧配饰返回 inventory
        if (oldEquipped != null && oldEquipped.isNotEmpty) {
          tx.update(userRef, {
            'inventory': FieldValue.arrayUnion([oldEquipped]),
          });
        }

        // 设置新装备
        tx.update(catRef, {
          'equippedAccessory': accessoryId,
        });
      });
    } catch (e) {
      debugPrint('[InventoryService] equipAccessory failed: $e');
      rethrow;
    }
  }

  /// 卸下猫的配饰，返回道具箱。
  Future<void> unequipAccessory({
    required String uid,
    required String catId,
  }) async {
    final userRef = _userRef(uid);
    final catRef = _catRef(uid, catId);

    try {
      await _db.runTransaction((tx) async {
        final catDoc = await tx.get(catRef);
        if (!catDoc.exists) {
          throw StateError('Cat document $catId not found for user $uid');
        }

        final catData = catDoc.data() as Map<String, dynamic>? ?? {};
        final equipped = catData['equippedAccessory'] as String?;

        if (equipped == null || equipped.isEmpty) return;

        // 返回 inventory
        tx.update(userRef, {
          'inventory': FieldValue.arrayUnion([equipped]),
        });

        // 清除装备
        tx.update(catRef, {
          'equippedAccessory': null,
        });
      });
    } catch (e) {
      debugPrint('[InventoryService] unequipAccessory failed: $e');
      rethrow;
    }
  }
}
