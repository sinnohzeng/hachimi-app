import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/ledger_service.dart';
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
  /// 优先从 SQLite 读取（本地优先架构），Firestore 作为兜底。
  Future<({int questCount, int catCount, int totalHours})> getUserDataSummary(
    String uid, {
    LedgerService? ledger,
  }) async {
    // 优先从本地 SQLite 读取
    if (ledger != null) {
      try {
        final db = await ledger.database;
        final habitRows = await db.query(
          'local_habits',
          where: 'uid = ? AND is_active = 1',
          whereArgs: [uid],
        );
        final catRows = await db.query(
          'local_cats',
          where: 'uid = ?',
          whereArgs: [uid],
        );

        int totalMinutes = 0;
        for (final row in habitRows) {
          totalMinutes += (row['total_minutes'] as int?) ?? 0;
        }

        return (
          questCount: habitRows.length,
          catCount: catRows.length,
          totalHours: totalMinutes ~/ 60,
        );
      } catch (_) {
        // 本地读取失败，降级到 Firestore
      }
    }

    // Firestore 兜底
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

  /// 全量删除：Firestore（认证态下）→ 本地清理 → Auth 删除（最后）→ Google 登出。
  /// [onProgress] 可选回调，报告进度（0.0 ~ 1.0）。
  Future<void> deleteEverything(
    String uid, {
    void Function(double progress, String step)? onProgress,
  }) async {
    // 1: Firestore 全量清理（必须在认证态下执行，否则 permission-denied）
    final userRef = _db.collection('users').doc(uid);

    onProgress?.call(0.0, 'Deleting quests...');
    final habitsSnap = await userRef.collection('habits').get();
    for (final habitDoc in habitsSnap.docs) {
      await _deleteSubcollection(habitDoc.reference.collection('sessions'));
      await habitDoc.reference.delete();
    }

    onProgress?.call(0.2, 'Deleting cats...');
    await _deleteSubcollection(userRef.collection('cats'));

    onProgress?.call(0.35, 'Deleting achievements...');
    await _deleteSubcollection(userRef.collection('achievements'));

    onProgress?.call(0.45, 'Deleting check-in history...');
    await _deleteSubcollection(userRef.collection('monthlyCheckIns'));
    final checkInsSnap = await userRef.collection('checkIns').get();
    for (final dateDoc in checkInsSnap.docs) {
      await _deleteSubcollection(dateDoc.reference.collection('entries'));
      await dateDoc.reference.delete();
    }

    onProgress?.call(0.6, 'Deleting user profile...');
    await userRef.delete();

    // 2: 本地清理（SQLite + SharedPreferences + 通知 + 计时器）
    onProgress?.call(0.7, 'Cleaning local data...');
    await _cleanLocalData();

    // 3: 删除 Auth 账号（最后执行 — Firestore 已清理完毕）
    onProgress?.call(0.9, 'Deleting account...');
    await _auth.currentUser?.delete();

    // 4: Google 登出
    await _googleSignIn.signOut();

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
