// ---
// 📘 文件说明：
// CatFirestoreService — 猫相关 Firestore CRUD 操作。
// 从 firestore_service.dart 提取，适配像素猫新 schema。
//
// 📋 程序整体伪代码：
// 1. 提供猫数据的实时监听（active / all）；
// 2. 单猫查询、重命名、饰品更新；
// 3. 成长进度增量更新（totalMinutes）；
// 4. 猫状态流转（active → graduated / dormant）；
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:cloud_firestore/cloud_firestore.dart';
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
        .where('state', isEqualTo: 'active')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Cat.fromFirestore(doc)).toList());
  }

  /// 监听所有猫（含 graduated / dormant），用于猫图鉴。
  Stream<List<Cat>> watchAllCats(String uid) {
    return _catsRef(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Cat.fromFirestore(doc)).toList());
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
    await _catsRef(uid).doc(catId).update({
      'totalMinutes': FieldValue.increment(minutesDelta),
      'lastSessionAt': FieldValue.serverTimestamp(),
    });
  }

  /// 重命名猫。
  Future<void> renameCat({
    required String uid,
    required String catId,
    required String newName,
  }) async {
    await _catsRef(uid).doc(catId).update({'name': newName});
  }

  /// 更新猫的饰品列表。
  Future<void> updateCatAccessories({
    required String uid,
    required String catId,
    required List<String> accessories,
  }) async {
    await _catsRef(uid).doc(catId).update({'accessories': accessories});
  }

  /// 毕业（习惯完成或删除时调用）。
  Future<void> graduateCat({
    required String uid,
    required String catId,
  }) async {
    await _catsRef(uid).doc(catId).update({'state': 'graduated'});
  }

  /// 休眠（手动归档）。
  Future<void> archiveCat({
    required String uid,
    required String catId,
  }) async {
    await _catsRef(uid).doc(catId).update({'state': 'dormant'});
  }
}
