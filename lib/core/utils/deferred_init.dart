import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/auth_service.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/services/notification_service.dart';

/// 延迟初始化管理器 — 将非关键的启动任务推迟到首帧渲染后执行。
///
/// 幂等：多次调用 `run()` 只会执行一次初始化。
/// 每个子任务独立 try-catch，单个失败不影响其他。
class DeferredInit {
  static Completer<void>? _completer;
  static bool _done = false;

  /// 执行延迟初始化。幂等，多次调用安全。
  static Future<void> run() async {
    if (_done) return;

    // 如果已有调用正在进行，等待其完成
    if (_completer != null) {
      return _completer!.future;
    }

    _completer = Completer<void>();

    try {
      await Future.wait([
        _initGoogleSignIn(),
        _initNotifications(),
        _initFocusTimer(),
      ]);
    } finally {
      _done = true;
      _completer!.complete();
    }
  }

  static Future<void> _initGoogleSignIn() async {
    try {
      await AuthService().initializeGoogleSignIn();
    } catch (e, stack) {
      debugPrint('[DeferredInit] GoogleSignIn init failed: $e');
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'DeferredInit',
        operation: 'initGoogleSignIn',
      );
    }
  }

  static Future<void> _initNotifications() async {
    try {
      await NotificationService().initializePlugins();
    } catch (e, stack) {
      debugPrint('[DeferredInit] Notification init failed: $e');
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'DeferredInit',
        operation: 'initNotifications',
      );
    }
  }

  static Future<void> _initFocusTimer() async {
    try {
      FocusTimerService.init();
    } catch (e, stack) {
      debugPrint('[DeferredInit] FocusTimer init failed: $e');
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'DeferredInit',
        operation: 'initFocusTimer',
      );
    }
  }

  /// 重置状态（仅用于测试）。
  @visibleForTesting
  static void reset() {
    _done = false;
    _completer = null;
  }
}
