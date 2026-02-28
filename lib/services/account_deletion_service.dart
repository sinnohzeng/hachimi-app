import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/local_database_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// 删除阶段枚举 — 替代魔法数字 0/1/2。
enum DeletionPhase {
  firestore,
  local,
  auth,
  done;

  static DeletionPhase fromIndex(int index) =>
      DeletionPhase.values.elementAtOrNull(index) ?? DeletionPhase.firestore;
}

/// 账号删除服务 — 负责 Firestore 全量清理、本地清理。
///
/// 重认证职责已归 [AuthBackend]，本服务仅负责数据删除。
/// 构造注入依赖，支持测试时 mock。
class AccountDeletionService {
  final FirebaseFirestore _db;
  final LocalDatabaseService _localDb;
  final NotificationService _notifications;

  AccountDeletionService({
    required LocalDatabaseService localDb,
    required NotificationService notifications,
    FirebaseFirestore? db,
  }) : _localDb = localDb,
       _notifications = notifications,
       _db = db ?? FirebaseFirestore.instance;

  static const _kDeletionInProgress = 'deletion_in_progress';
  static const _kDeletionUid = 'deletion_uid';
  static const _kDeletionStep = 'deletion_step';

  /// Firestore 用户数据拓扑 — 新增集合只需在此注册。
  /// 格式：(集合名, [嵌套子集合名])
  static const _userCollections = [
    ('habits', ['sessions']),
    ('cats', <String>[]),
    ('achievements', <String>[]),
    ('monthlyCheckIns', <String>[]),
    ('checkIns', ['entries']),
  ];

  /// 获取用户数据摘要（Quest 数、Cat 数、累计小时数）。
  Future<({int questCount, int catCount, int totalHours})> getUserDataSummary(
    String uid,
  ) async {
    return _getFirestoreSummary(uid);
  }

  /// Firestore 获取用户数据摘要。
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

  /// 全量删除：Firestore → 本地清理。
  /// Auth 删除和 Google 登出由调用方负责（DeleteAccountFlow）。
  /// 使用 SharedPreferences 标记删除进度，崩溃后可恢复。
  Future<void> deleteEverything(
    String uid, {
    void Function(double progress, String step)? onProgress,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDeletionInProgress, true);
    await prefs.setString(_kDeletionUid, uid);
    await prefs.setInt(_kDeletionStep, DeletionPhase.firestore.index);

    // Phase 1: Firestore 全量清理
    onProgress?.call(0.0, 'firestore');
    await _deleteFirestoreData(uid, onProgress: onProgress);
    await prefs.setInt(_kDeletionStep, DeletionPhase.local.index);

    // Phase 2: 本地清理
    onProgress?.call(0.7, 'local');
    await cleanLocalData();
    // cleanLocalData 清空 SharedPreferences，需重设标记
    await prefs.setBool(_kDeletionInProgress, true);
    await prefs.setInt(_kDeletionStep, DeletionPhase.auth.index);

    onProgress?.call(1.0, 'done');
  }

  /// 清理访客数据：Firestore（匿名用户）+ 本地。
  Future<void> deleteGuestData(String uid) async {
    await _deleteFirestoreData(uid);
    await cleanLocalData();
  }

  /// 声明式遍历引擎 — 按拓扑自动删除所有用户集合和嵌套子集合。
  Future<void> _deleteFirestoreData(
    String uid, {
    void Function(double progress, String step)? onProgress,
  }) async {
    final userRef = _db.collection('users').doc(uid);
    final total = _userCollections.length;

    for (var i = 0; i < total; i++) {
      final (name, nested) = _userCollections[i];
      final snap = await userRef.collection(name).get();
      for (final doc in snap.docs) {
        for (final sub in nested) {
          await _deleteSubcollection(doc.reference.collection(sub));
        }
        await doc.reference.delete();
      }
      onProgress?.call((i + 1) / (total + 1), name);
    }

    await userRef.delete();
    onProgress?.call(1.0, 'user');
  }

  /// 清理本地数据 — 拆分为 4 个子函数。
  Future<void> cleanLocalData() async {
    await _cleanSqlite();
    await _cleanPreferences();
    await _cleanNotifications();
    await _cleanTimerState();
  }

  Future<void> _cleanSqlite() async {
    try {
      await _localDb.close();
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
  }

  Future<void> _cleanPreferences() async {
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
  }

  Future<void> _cleanNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionService',
        operation: 'cleanLocalData(notifications)',
      );
    }
  }

  Future<void> _cleanTimerState() async {
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
  Future<bool> resumeIfNeeded() async {
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
  Future<void> _executeDeletionResume(SharedPreferences prefs) async {
    final phase = DeletionPhase.fromIndex(prefs.getInt(_kDeletionStep) ?? 0);
    final uid = prefs.getString(_kDeletionUid);

    if (phase.index < DeletionPhase.local.index && uid != null) {
      await _deleteFirestoreData(uid);
    }
    if (phase.index < DeletionPhase.auth.index) {
      await cleanLocalData();
      await prefs.setBool(_kDeletionInProgress, true);
      await prefs.setInt(_kDeletionStep, DeletionPhase.auth.index);
    }
    // Auth 删除由调用方（app 启动逻辑）负责
  }

  Future<void> _clearDeletionMarkers(SharedPreferences prefs) async {
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
