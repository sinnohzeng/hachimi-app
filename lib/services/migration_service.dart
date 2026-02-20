// ---
// 📘 文件说明：
// MigrationService — 版本门控数据检测与清除。
// 检测旧 schema 猫文档（有 breed 无 appearance），提供全量清除。
//
// 📋 程序整体伪代码：
// 1. checkNeedsMigration：读取猫集合，检测旧 schema 标记；
// 2. clearAllUserData：batch 删除 habits、cats、checkIns 全部文档；
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// MigrationService — 旧版本数据检测 + 清除。
class MigrationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 检测是否需要数据迁移。
  /// 条件：存在猫文档且包含旧 schema 字段 `breed` 但无 `appearance`。
  Future<bool> checkNeedsMigration(String uid) async {
    final catsSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('cats')
        .limit(5)
        .get();

    for (final doc in catsSnapshot.docs) {
      final data = doc.data();
      if (data.containsKey('breed') && !data.containsKey('appearance')) {
        return true;
      }
    }
    return false;
  }

  /// 迁移旧版 per-cat accessories 到 user-level inventory。
  /// 幂等：若所有猫的 accessories 已为空，则不执行任何操作。
  Future<bool> migrateAccessoriesToInventory(String uid) async {
    final catsSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('cats')
        .get();

    // 收集所有猫的 accessories（排除各猫已装备的 equippedAccessory）
    final inventoryIds = <String>{};
    final catUpdates = <String, List<String>>{}; // catId → old accessories

    for (final doc in catsSnapshot.docs) {
      final data = doc.data();
      final accessories = List<String>.from(
          data['accessories'] as List<dynamic>? ?? []);
      if (accessories.isEmpty) continue;

      final equipped = data['equippedAccessory'] as String?;

      // 未装备的配饰进入 inventory
      for (final id in accessories) {
        if (id != equipped) {
          inventoryIds.add(id);
        }
      }
      catUpdates[doc.id] = accessories;
    }

    // 无需迁移
    if (catUpdates.isEmpty) return false;

    // 单个 batch 操作：写入 inventory + 清空各猫 accessories
    final batch = _db.batch();
    final userRef = _db.collection('users').doc(uid);

    if (inventoryIds.isNotEmpty) {
      batch.update(userRef, {
        'inventory': FieldValue.arrayUnion(inventoryIds.toList()),
      });
    }

    for (final catId in catUpdates.keys) {
      final catRef = _db
          .collection('users')
          .doc(uid)
          .collection('cats')
          .doc(catId);
      batch.update(catRef, {
        'accessories': <String>[],
      });
    }

    await batch.commit();
    return true;
  }

  /// 清除用户全部业务数据（习惯、猫、签到记录）。
  /// 用户确认后调用，重新进入 onboarding 流程。
  Future<void> clearAllUserData(String uid) async {
    try {
      final userRef = _db.collection('users').doc(uid);

      // 逐集合删除（Firestore 不支持递归删除子集合）
      await _deleteSubcollection(userRef.collection('cats'));
      await _deleteSubcollection(userRef.collection('habits'));

      // checkIns 是按日期分的嵌套子集合
      final checkInsSnapshot = await userRef.collection('checkIns').get();
      for (final dateDoc in checkInsSnapshot.docs) {
        await _deleteSubcollection(dateDoc.reference.collection('entries'));
        await dateDoc.reference.delete();
      }

      // 重置用户 profile 字段（保留账号）
      await userRef.update({
        'coins': 0,
        'lastCheckInDate': null,
      });
    } catch (e) {
      debugPrint('[MigrationService] clearAllUserData failed: $e');
      rethrow;
    }
  }

  /// 批量删除一个集合下的所有文档。
  Future<void> _deleteSubcollection(CollectionReference ref) async {
    const batchSize = 100;
    QuerySnapshot snapshot;
    do {
      snapshot = await ref.limit(batchSize).get();
      if (snapshot.docs.isEmpty) break;

      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      try {
        await batch.commit();
      } catch (e) {
        debugPrint('[MigrationService] _deleteSubcollection batch failed: $e');
        rethrow;
      }
    } while (snapshot.docs.length == batchSize);
  }
}
