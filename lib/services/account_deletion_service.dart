import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/local_database_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// 账号删除服务 — 负责重新认证、Firestore 全量清理、Auth 删除、本地清理。
class AccountDeletionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// 获取用户数据摘要（Quest 数、Cat 数、累计小时数）。
  Future<({int questCount, int catCount, int totalHours})> getUserDataSummary(
    String uid,
  ) async {
    final userRef = _db.collection('users').doc(uid);
    final habitsSnap = await userRef.collection('habits').get();
    final catsSnap = await userRef.collection('cats').get();

    int totalMinutes = 0;
    for (final doc in habitsSnap.docs) {
      final data = doc.data();
      totalMinutes += (data['totalMinutes'] as int?) ?? 0;
    }

    return (
      questCount: habitsSnap.docs.length,
      catCount: catsSnap.docs.length,
      totalHours: totalMinutes ~/ 60,
    );
  }

  /// 重新认证 Google 用户。如果用户取消或失败，返回 false。
  Future<bool> reauthenticateWithGoogle() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _googleSignIn.initialize(); // 幂等
      final googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await user.reauthenticateWithCredential(credential);
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      rethrow;
    }
  }

  /// 全量删除：Auth 先删（失败则中止，数据完好）→ Firestore → 本地清理。
  /// [onProgress] 可选回调，报告进度（0.0 ~ 1.0）。
  Future<void> deleteEverything(
    String uid, {
    void Function(double progress, String step)? onProgress,
  }) async {
    // 1: 先删 Auth 账号 — 失败则整个流程中止，Firestore 数据不受影响
    onProgress?.call(0.0, 'Deleting account...');
    await _auth.currentUser?.delete();
    await _googleSignIn.signOut();

    // Auth 已删除，后续 Firestore 清理失败不影响用户（孤儿数据无害）
    final userRef = _db.collection('users').doc(uid);

    // 2: 删除 habits 及其 sessions 子集合
    onProgress?.call(0.15, 'Deleting quests...');
    final habitsSnap = await userRef.collection('habits').get();
    for (final habitDoc in habitsSnap.docs) {
      await _deleteSubcollection(habitDoc.reference.collection('sessions'));
      await habitDoc.reference.delete();
    }

    // 3: 删除 cats
    onProgress?.call(0.35, 'Deleting cats...');
    await _deleteSubcollection(userRef.collection('cats'));

    // 4: 删除 achievements
    onProgress?.call(0.5, 'Deleting achievements...');
    await _deleteSubcollection(userRef.collection('achievements'));

    // 5: 删除 monthlyCheckIns + 旧 checkIns
    onProgress?.call(0.6, 'Deleting check-in history...');
    await _deleteSubcollection(userRef.collection('monthlyCheckIns'));
    final checkInsSnap = await userRef.collection('checkIns').get();
    for (final dateDoc in checkInsSnap.docs) {
      await _deleteSubcollection(dateDoc.reference.collection('entries'));
      await dateDoc.reference.delete();
    }

    // 6: 删除用户文档
    onProgress?.call(0.75, 'Deleting user profile...');
    await userRef.delete();

    // 7: 本地清理
    onProgress?.call(0.9, 'Cleaning local data...');
    await _cleanLocalData();

    onProgress?.call(1.0, 'Done');
  }

  /// 清理本地数据：SQLite、SharedPreferences、通知、计时器状态。
  Future<void> _cleanLocalData() async {
    // SQLite
    try {
      final localDb = LocalDatabaseService();
      await localDb.close();
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'hachimi_local.db');
      await deleteDatabase(path);
    } catch (e) {
      debugPrint('[AccountDeletion] SQLite cleanup failed: $e');
    }

    // SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('[AccountDeletion] SharedPreferences cleanup failed: $e');
    }

    // 通知
    try {
      await NotificationService().cancelAll();
    } catch (e) {
      debugPrint('[AccountDeletion] Notification cleanup failed: $e');
    }

    // 计时器状态
    try {
      await FocusTimerNotifier.clearSavedState();
    } catch (e) {
      debugPrint('[AccountDeletion] Timer state cleanup failed: $e');
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
          source: 'AccountDeletionService',
          operation: '_deleteSubcollection',
        );
        rethrow;
      }
    } while (snapshot.docs.length == batchSize);
  }
}
