import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// FocusTimerService — manages the Android foreground service for focus sessions.
/// Keeps the timer alive when the app is minimized via a persistent notification.
class FocusTimerService {
  /// Initialize the foreground task configuration.
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'hachimi_focus_timer',
        channelName: 'Focus Timer',
        channelDescription: 'Shows focus timer progress',
        channelImportance: NotificationChannelImportance.DEFAULT,
        priority: NotificationPriority.DEFAULT,
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
  static Future<void> start({
    required String habitName,
    required String catEmoji,
    required int totalSeconds,
    required bool isCountdown,
  }) async {
    await FlutterForegroundTask.startService(
      notificationTitle: '$catEmoji $habitName',
      notificationText: 'Focus session starting...',
      callback: _startCallback,
    );
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
