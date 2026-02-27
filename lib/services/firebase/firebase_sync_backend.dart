import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/backend/sync_backend.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';

/// Firebase Firestore 同步后端实现。
///
/// 将 [SyncOperation] 列表翻译为 Firestore [WriteBatch] 操作。
class FirebaseSyncBackend implements SyncBackend {
  final FirebaseFirestore _db;

  FirebaseSyncBackend({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  @override
  String get id => 'firebase';

  @override
  Future<HydrationData> hydrate(String uid) async {
    try {
      final userRef = _db.collection('users').doc(uid);

      // 拉取 habits
      final habitsSnap = await userRef.collection('habits').get();
      final habits = habitsSnap.docs.map((doc) {
        final habit = Habit.fromFirestore(doc);
        return habit.toSqlite(uid);
      }).toList();

      // 拉取 cats
      final catsSnap = await userRef.collection('cats').get();
      final cats = catsSnap.docs.map((doc) {
        final cat = Cat.fromFirestore(doc);
        return cat.toSqlite(uid);
      }).toList();

      // 拉取用户文档
      final userDoc = await userRef.get();
      final userProfile = <String, dynamic>{};
      if (userDoc.exists) {
        final data = userDoc.data()!;
        userProfile['coins'] = data['coins'] as int? ?? 0;
        userProfile['lastCheckInDate'] = data['lastCheckInDate'] as String?;
        userProfile['avatarId'] = data['avatarId'] as String?;
        userProfile['displayName'] = data['displayName'] as String?;
        userProfile['currentTitle'] = data['currentTitle'] as String?;

        final inventory = data['inventory'] as List<dynamic>?;
        if (inventory != null) {
          userProfile['inventory'] = jsonEncode(
            inventory.whereType<String>().toList(),
          );
        }

        final unlockedTitles = data['unlockedTitles'] as List<dynamic>?;
        if (unlockedTitles != null) {
          userProfile['unlockedTitles'] = jsonEncode(
            unlockedTitles.whereType<String>().toList(),
          );
        }
      }

      return HydrationData(
        habits: habits,
        cats: cats,
        userProfile: userProfile,
      );
    } catch (e) {
      debugPrint('FirebaseSyncBackend: hydration failed: $e');
      return const HydrationData();
    }
  }

  @override
  Future<void> writeBatch(String uid, List<SyncOperation> operations) async {
    if (operations.isEmpty) return;

    final batch = _db.batch();
    final userRef = _db.collection('users').doc(uid);

    for (final op in operations) {
      final docRef = _resolveDocRef(userRef, op.collection, op.docId);
      _applyOperation(batch, docRef, op);
    }

    await batch.commit();
  }

  /// 将集合路径解析为 Firestore 文档引用。
  DocumentReference _resolveDocRef(
    DocumentReference userRef,
    String collection,
    String docId,
  ) {
    // 支持嵌套路径如 'habits/{habitId}/sessions'
    final segments = collection.split('/');
    CollectionReference col = userRef.collection(segments.first);
    for (var i = 1; i < segments.length; i += 2) {
      if (i + 1 < segments.length) {
        col = col.doc(segments[i]).collection(segments[i + 1]);
      }
    }
    return col.doc(docId);
  }

  /// 将 SyncOperation 应用到 WriteBatch。
  void _applyOperation(
    WriteBatch batch,
    DocumentReference docRef,
    SyncOperation op,
  ) {
    switch (op.type) {
      case SyncOpType.set:
        batch.set(docRef, op.data);
      case SyncOpType.merge:
        batch.set(docRef, op.data, SetOptions(merge: true));
      case SyncOpType.update:
        batch.update(docRef, op.data);
      case SyncOpType.increment:
        final field = op.data['field'] as String;
        final value = op.data['value'] as num;
        batch.update(docRef, {field: FieldValue.increment(value)});
      case SyncOpType.arrayAdd:
        final field = op.data['field'] as String;
        final value = op.data['value'];
        batch.update(docRef, {
          field: FieldValue.arrayUnion([value]),
        });
      case SyncOpType.arrayRemove:
        final field = op.data['field'] as String;
        final value = op.data['value'];
        batch.update(docRef, {
          field: FieldValue.arrayRemove([value]),
        });
      case SyncOpType.serverTimestamp:
        final field = op.data['field'] as String;
        batch.update(docRef, {field: FieldValue.serverTimestamp()});
    }
  }
}
