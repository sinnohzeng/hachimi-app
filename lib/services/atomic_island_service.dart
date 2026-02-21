import 'package:flutter/services.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// AtomicIslandService — platform channel wrapper for vivo Atomic Island
/// rich notification. Silently falls back to flutter_foreground_task's
/// basic notification if the native call fails.
class AtomicIslandService {
  static const _channel = MethodChannel('com.hachimi.notification');

  /// Update the rich timer notification for Atomic Island display.
  static Future<void> updateNotification({
    required String title,
    required String text,
    required bool isCountdown,
    required bool isPaused,
    int? endTimeMs,
    int? startTimeMs,
  }) async {
    try {
      await _channel.invokeMethod('updateTimerNotification', {
        'title': title,
        'text': text,
        'subText': 'Hachimi',
        'isCountdown': isCountdown,
        'isPaused': isPaused,
        'endTimeMs': endTimeMs,
        'startTimeMs': startTimeMs,
      });
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AtomicIslandService',
        operation: 'updateNotification',
      );
    }
  }

  /// Cancel the rich timer notification.
  static Future<void> cancel() async {
    try {
      await _channel.invokeMethod('cancelTimerNotification');
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AtomicIslandService',
        operation: 'cancel',
      );
    }
  }
}
