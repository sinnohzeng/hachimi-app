import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// FocusTimerService — manages the Android foreground service for focus sessions.
/// Keeps the timer alive when the app is minimized via a persistent notification.
class FocusTimerService {
  /// Initialize the foreground task configuration.
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'hachimi_focus',
        channelName: 'Focus Timer',
        channelDescription: 'Shows focus timer progress',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        onlyAlertOnce: true,
        showWhen: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  /// Start the foreground task with initial timer data.
  ///
  /// Returns [ServiceRequestResult] so callers can detect and handle failures
  /// (e.g. show a permission banner) instead of silently losing the notification.
  static Future<ServiceRequestResult> start({
    required String habitName,
    required String catEmoji,
    required int totalSeconds,
    required bool isCountdown,
  }) async {
    try {
      return await FlutterForegroundTask.startService(
        serviceTypes: [ForegroundServiceTypes.specialUse],
        notificationTitle: '$catEmoji $habitName',
        notificationText: 'Focus session starting...',
        notificationButtons: [
          const NotificationButton(id: 'pause', text: 'Pause'),
          const NotificationButton(id: 'end_session', text: 'End'),
        ],
        callback: _startCallback,
      );
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'FocusTimerService',
        operation: 'start',
      );
      return ServiceRequestFailure(error: e);
    }
  }

  /// Update the notification text (called from main isolate).
  static void updateNotification({
    required String title,
    required String text,
  }) {
    FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: text,
    );
  }

  /// Stop the foreground task.
  static Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }

  /// Listen for notification button actions from the background isolate.
  /// The [_TimerTaskHandler.onNotificationButtonPressed] sends data via
  /// [FlutterForegroundTask.sendDataToMain], and this stream receives it
  /// in the main isolate.
  static void addActionListener(void Function(Object data) callback) {
    FlutterForegroundTask.addTaskDataCallback(callback);
  }

  /// Remove a previously registered action listener.
  static void removeActionListener(void Function(Object data) callback) {
    FlutterForegroundTask.removeTaskDataCallback(callback);
  }
}

/// Entry point for the foreground task isolate.
@pragma('vm:entry-point')
void _startCallback() {
  FlutterForegroundTask.setTaskHandler(_TimerTaskHandler());
}

/// Task handler that runs in a separate isolate.
/// The actual timer logic runs in the main isolate via FocusTimerNotifier;
/// this handler just keeps the service alive and responds to events.
class _TimerTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Service started — main isolate handles timer logic
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // The main isolate manages the actual timer state and updates
    // the notification via FocusTimerService.updateNotification().
    // This handler just keeps the foreground service alive.
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    // Cleanup when service is stopped
  }

  @override
  void onReceiveData(Object data) {
    if (data is Map<String, dynamic>) {
      if (data['action'] == 'stop') {
        FlutterForegroundTask.stopService();
      }
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'end_session') {
      FlutterForegroundTask.sendDataToMain({'action': 'end'});
    } else if (id == 'pause') {
      FlutterForegroundTask.sendDataToMain({'action': 'pause'});
    }
  }

  @override
  void onNotificationDismissed() {
    // Notification was dismissed — service continues running
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }
}
