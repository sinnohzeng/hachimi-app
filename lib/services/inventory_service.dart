import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// InventoryService — 道具箱装备/卸下操作。
/// 所有写操作使用 transaction 保证原子性。
class InventoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _userRef(String uid) => _db.collection('users').doc(uid);

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
        tx.update(catRef, {'equippedAccessory': accessoryId});
      });
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
        tx.update(catRef, {'equippedAccessory': null});
      });
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
}
