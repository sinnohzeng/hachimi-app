import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/cat.dart';

/// CatFirestoreService — 猫 CRUD 操作独立服务。
/// 所有方法均直接操作 Firestore，不依赖其他 Service。
class CatFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _catsRef(String uid) =>
      _db.collection('users').doc(uid).collection('cats');

  /// 监听所有 active 猫。
  Stream<List<Cat>> watchCats(String uid) {
    return _catsRef(uid)
        .where('state', isEqualTo: CatState.active)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Cat.fromFirestore).toList());
  }

  /// 监听所有猫（含 graduated / dormant），用于猫图鉴。
  Stream<List<Cat>> watchAllCats(String uid) {
    return _catsRef(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Cat.fromFirestore).toList());
  }

  /// 获取单只猫。
  Future<Cat?> getCat(String uid, String catId) async {
    final doc = await _catsRef(uid).doc(catId).get();
    if (!doc.exists) return null;
    return Cat.fromFirestore(doc);
  }

  /// 增量更新猫的 totalMinutes（专注完成后调用）。
  Future<void> updateCatProgress({
    required String uid,
    required String catId,
    required int minutesDelta,
  }) async {
    try {
      await _catsRef(uid).doc(catId).update({
        'totalMinutes': FieldValue.increment(minutesDelta),
        'lastSessionAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'CatFirestoreService', operation: 'updateCatProgress');
      rethrow;
    }
  }

  /// 重命名猫。
  Future<void> renameCat({
    required String uid,
    required String catId,
    required String newName,
  }) async {
    try {
      await _catsRef(uid).doc(catId).update({'name': newName});
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'CatFirestoreService', operation: 'renameCat');
      rethrow;
    }
  }

  /// 更新猫的饰品列表。
  Future<void> updateCatAccessories({
    required String uid,
    required String catId,
    required List<String> accessories,
  }) async {
    await _catsRef(uid).doc(catId).update({'accessories': accessories});
  }

  /// 装备饰品到猫。
  Future<void> equipAccessory({
    required String uid,
    required String catId,
    required String accessoryId,
  }) async {
    await _catsRef(uid).doc(catId).update({'equippedAccessory': accessoryId});
  }

  /// 卸下猫的饰品。
  Future<void> unequipAccessory({
    required String uid,
    required String catId,
  }) async {
    await _catsRef(uid).doc(catId).update({'equippedAccessory': null});
  }

  /// 毕业（习惯完成或删除时调用）。
  Future<void> graduateCat({required String uid, required String catId}) async {
    try {
      await _catsRef(uid).doc(catId).update({'state': CatState.graduated});
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'CatFirestoreService', operation: 'graduateCat');
      rethrow;
    }
  }

  /// 休眠（手动归档）。
  Future<void> archiveCat({required String uid, required String catId}) async {
    try {
      await _catsRef(uid).doc(catId).update({'state': CatState.dormant});
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'CatFirestoreService', operation: 'archiveCat');
      rethrow;
    }
  }
}
