import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/local_database_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// 删除前的数据摘要。
class AccountDeletionSummary {
  final int questCount;
  final int catCount;
  final int totalHours;

  const AccountDeletionSummary({
    required this.questCount,
    required this.catCount,
    required this.totalHours,
  });
}

/// 本地数据删除服务。
///
/// 职责固定：
/// 1. 读取本地数据摘要；
/// 2. 清理 SQLite、SharedPreferences、通知、计时状态。
///
/// 云端/Auth 删除由 AccountDeletionOrchestrator + Cloud Functions 负责。
class AccountDeletionService {
  final LocalDatabaseService _localDb;
  final NotificationService _notifications;

  AccountDeletionService({
    required LocalDatabaseService localDb,
    required NotificationService notifications,
  }) : _localDb = localDb,
       _notifications = notifications;

  Future<AccountDeletionSummary> getUserDataSummary(String uid) async {
    final db = await _localDb.database;
    final habits = await db.rawQuery(
      'SELECT COUNT(*) AS count, COALESCE(SUM(total_minutes), 0) AS minutes '
      'FROM local_habits WHERE uid = ?',
      [uid],
    );
    final cats = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM local_cats WHERE uid = ?',
      [uid],
    );

    final minutes = _toInt(habits.first['minutes']);
    return AccountDeletionSummary(
      questCount: _toInt(habits.first['count']),
      catCount: _toInt(cats.first['count']),
      totalHours: minutes ~/ 60,
    );
  }

  Future<void> cleanLocalData({
    Map<String, Object?> preservePrefs = const {},
  }) async {
    await _cleanSqlite();
    await _cleanPreferences(preservePrefs);
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
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AccountDeletionService',
        operation: 'cleanLocalData(sqlite)',
      );
    }
  }

  Future<void> _cleanPreferences(Map<String, Object?> preservePrefs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      for (final entry in preservePrefs.entries) {
        await _restorePref(prefs, entry.key, entry.value);
      }
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AccountDeletionService',
        operation: 'cleanLocalData(prefs)',
      );
    }
  }

  Future<void> _restorePref(
    SharedPreferences prefs,
    String key,
    Object? value,
  ) async {
    if (value == null) {
      await prefs.remove(key);
      return;
    }
    if (value is bool) {
      await prefs.setBool(key, value);
      return;
    }
    if (value is int) {
      await prefs.setInt(key, value);
      return;
    }
    if (value is double) {
      await prefs.setDouble(key, value);
      return;
    }
    if (value is String) {
      await prefs.setString(key, value);
      return;
    }
    if (value is List<String>) {
      await prefs.setStringList(key, value);
      return;
    }
    throw ArgumentError(
      'Unsupported SharedPreferences type: ${value.runtimeType}',
    );
  }

  Future<void> _cleanNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AccountDeletionService',
        operation: 'cleanLocalData(notifications)',
      );
    }
  }

  Future<void> _cleanTimerState() async {
    try {
      await FocusTimerNotifier.clearSavedState();
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AccountDeletionService',
        operation: 'cleanLocalData(timer)',
      );
    }
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }
}
