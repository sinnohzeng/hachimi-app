import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// MigrationService — 旧版本数据检测 + 清除。
///
/// [A3] 迁移结果缓存到 SharedPreferences，已检查过则直接跳过。
class MigrationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const _kSchemaCheckedKey = 'migration_schema_checked_v1';
  static const _kAccessoriesCheckedKey = 'migration_accessories_checked_v1';

  /// 检测是否需要数据迁移。
  /// 条件：存在猫文档且包含旧 schema 字段 `breed` 但无 `appearance`。
  /// [A3] 结果缓存，已确认无需迁移后跳过 Firestore 查询。
  Future<bool> checkNeedsMigration(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kSchemaCheckedKey) == true) {
      return false;
    }

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

    // 无需迁移，缓存结果
    await prefs.setBool(_kSchemaCheckedKey, true);
    return false;
  }

  /// 迁移旧版 per-cat accessories 到 user-level inventory。
  /// 幂等：若所有猫的 accessories 已为空，则不执行任何操作。
  /// [A3] 结果缓存，已确认无需迁移后跳过 Firestore 查询。
  Future<bool> migrateAccessoriesToInventory(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kAccessoriesCheckedKey) == true) {
      return false;
    }

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
        data['accessories'] as List<dynamic>? ?? [],
      );
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

    // 无需迁移，缓存结果
    if (catUpdates.isEmpty) {
      await prefs.setBool(_kAccessoriesCheckedKey, true);
      return false;
    }

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
      batch.update(catRef, {'accessories': <String>[]});
    }

    await batch.commit();

    // 迁移完成，缓存结果
    await prefs.setBool(_kAccessoriesCheckedKey, true);
    return true;
  }

  /// 清除用户全部业务数据（习惯、猫、签到记录）。
  /// 用户确认后调用，重新进入 onboarding 流程。
  /// [R2] 同步清除迁移缓存 key，确保数据重置后迁移检查可重新执行。
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
      await userRef.update({'coins': 0, 'lastCheckInDate': null});

      // [R2] 清除迁移缓存 key
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kSchemaCheckedKey);
      await prefs.remove(_kAccessoriesCheckedKey);
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'MigrationService',
        operation: 'clearAllUserData',
      );
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
      } catch (e, stack) {
        ErrorHandler.record(
          e,
          stackTrace: stack,
          source: 'MigrationService',
          operation: '_deleteSubcollection',
        );
        rethrow;
      }
    } while (snapshot.docs.length == batchSize);
  }
}
