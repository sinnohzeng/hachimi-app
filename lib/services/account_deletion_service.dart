import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static const _kDeletionInProgress = 'deletion_in_progress';
  static const _kDeletionUid = 'deletion_uid';
  static const _kDeletionStep = 'deletion_step';

  /// 获取用户数据摘要（Quest 数、Cat 数、累计小时数）。
  /// 优先从 SQLite 读取（本地优先架构），Firestore 作为兜底。
  Future<({int questCount, int catCount, int totalHours})> getUserDataSummary(
    String uid, {
    LedgerService? ledger,
  }) async {
    if (ledger != null) {
      try {
        return await _getLocalSummary(ledger, uid);
      } catch (e, stack) {
        ErrorHandler.record(
          e,
          stackTrace: stack,
          source: 'AccountDeletionService',
          operation: 'getUserDataSummary(local)',
        );
      }
    }
    return _getFirestoreSummary(uid);
  }

  /// 从 SQLite 聚合查询用户数据摘要。
  Future<({int questCount, int catCount, int totalHours})> _getLocalSummary(
    LedgerService ledger,
    String uid,
  ) async {
    final db = await ledger.database;
    final minutesResult = await db.rawQuery(
      'SELECT COALESCE(SUM(total_minutes), 0) as total '
      'FROM local_habits WHERE uid = ? AND is_active = 1',
      [uid],
    );
    final questResult = await db.rawQuery(
      'SELECT COUNT(*) as count '
      'FROM local_habits WHERE uid = ? AND is_active = 1',
      [uid],
    );
    final catResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM local_cats WHERE uid = ?',
      [uid],
    );

    return (
      questCount: (questResult.first['count'] as int?) ?? 0,
      catCount: (catResult.first['count'] as int?) ?? 0,
      totalHours: ((minutesResult.first['total'] as int?) ?? 0) ~/ 60,
    );
  }

  /// Firestore 兜底获取用户数据摘要。
  Future<({int questCount, int catCount, int totalHours})> _getFirestoreSummary(
    String uid,
  ) async {
    final userRef = _db.collection('users').doc(uid);
    final habitsSnap = await userRef.collection('habits').get();
    final catsSnap = await userRef.collection('cats').get();

    int totalMinutes = 0;
    for (final doc in habitsSnap.docs) {
      totalMinutes += (doc.data()['totalMinutes'] as int?) ?? 0;
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
  /// 使用 SharedPreferences 标记删除进度，崩溃后可通过 [resumeIfNeeded] 恢复。
  Future<void> deleteEverything(
    String uid, {
    void Function(double progress, String step)? onProgress,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDeletionInProgress, true);
    await prefs.setString(_kDeletionUid, uid);
    await prefs.setInt(_kDeletionStep, 0);

    // Step 1: Firestore 全量清理（认证态下）
    onProgress?.call(0.0, 'Deleting quests...');
    await _deleteFirestoreData(uid, onProgress: onProgress);
    await prefs.setInt(_kDeletionStep, 1);

    // Step 2: 本地清理（SQLite + SharedPreferences + 通知 + 计时器）
    onProgress?.call(0.7, 'Cleaning local data...');
    await cleanLocalData();
    // cleanLocalData 会清空 SharedPreferences，需重设标记
    await prefs.setBool(_kDeletionInProgress, true);
    await prefs.setInt(_kDeletionStep, 2);

    // Step 3: 删除 Auth 账号
    onProgress?.call(0.9, 'Deleting account...');
    await _auth.currentUser?.delete();

    // Step 4: Google 登出 + 清除标记
    await _googleSignIn.signOut();
    await _clearDeletionMarkers(prefs);
    onProgress?.call(1.0, 'Done');
  }

  /// 清理访客数据：如为 Firebase 匿名用户，先清理 Firestore 数据并删除匿名账号；
  /// 最后清理本地数据。
  Future<void> deleteGuestData(String uid) async {
    final user = _auth.currentUser;

    // Firebase anonymous 用户：清理 Firestore + 删除 Auth 匿名账号
    if (user != null && user.isAnonymous) {
      await _deleteFirestoreData(uid);
      await user.delete();
    }

    await cleanLocalData();
  }

  /// 清理 Firestore 用户数据：habits（含 sessions 子集合）、cats、achievements、
  /// monthlyCheckIns、legacy checkIns，最后删除用户文档本身。
  Future<void> _deleteFirestoreData(
    String uid, {
    void Function(double progress, String step)? onProgress,
  }) async {
    final userRef = _db.collection('users').doc(uid);

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
  }

  /// 清理本地数据：SQLite、SharedPreferences、通知、计时器状态。
  Future<void> cleanLocalData() async {
    // SQLite
    try {
      final localDb = LocalDatabaseService();
      await localDb.close();
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'hachimi_local.db');
      await deleteDatabase(path);
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionService',
        operation: 'cleanLocalData(sqlite)',
      );
    }

    // SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionService',
        operation: 'cleanLocalData(prefs)',
      );
    }

    // 通知
    try {
      await NotificationService().cancelAll();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionService',
        operation: 'cleanLocalData(notifications)',
      );
    }

    // 计时器状态
    try {
      await FocusTimerNotifier.clearSavedState();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionService',
        operation: 'cleanLocalData(timer)',
      );
    }
  }

  // ─── 删除恢复 ───

  /// 检查并恢复未完成的账号删除（app 启动时调用）。
  /// 返回 true 表示检测到并处理了未完成删除。
  static Future<bool> resumeIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_kDeletionInProgress) ?? false)) return false;

    try {
      await _executeDeletionResume(prefs);
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionService',
        operation: 'resumeIfNeeded',
      );
    } finally {
      await _clearDeletionMarkers(prefs);
    }
    return true;
  }

  /// 从中断处继续执行删除。所有步骤都是幂等的。
  static Future<void> _executeDeletionResume(SharedPreferences prefs) async {
    final step = prefs.getInt(_kDeletionStep) ?? 0;
    final uid = prefs.getString(_kDeletionUid);
    final service = AccountDeletionService();

    // Step 0: Firestore 可能未完成 — 需认证态
    if (step < 1 && uid != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await service._deleteFirestoreData(uid);
      }
    }
    // Step 1: 本地清理
    if (step < 2) {
      await service.cleanLocalData();
      await prefs.setBool(_kDeletionInProgress, true);
      await prefs.setInt(_kDeletionStep, 2);
    }
    // Step 2: Auth + Google 登出
    await FirebaseAuth.instance.currentUser?.delete();
    await GoogleSignIn.instance.signOut();
  }

  static Future<void> _clearDeletionMarkers(SharedPreferences prefs) async {
    await prefs.remove(_kDeletionInProgress);
    await prefs.remove(_kDeletionUid);
    await prefs.remove(_kDeletionStep);
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
          operation: '_deleteSubcollection(${ref.path})',
        );
        rethrow;
      }
    } while (snapshot.docs.length == batchSize);
  }
}
