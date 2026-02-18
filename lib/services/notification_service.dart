import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// NotificationService — wraps Firebase Cloud Messaging (FCM) and
/// flutter_local_notifications for scheduled local notifications.
///
/// Notification types (per PRD Section 3.5):
/// 1. Scheduled daily — at user-set reminder time per habit
/// 2. Streak-at-risk — at 20:00 if no session today and streak ≥ 3
/// 3. Win-back — 48h with no session (server-triggered via FCM)
/// 4. Celebration — after level-up
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'hachimi_reminders';
  static const String _channelName = 'Habit Reminders';
  static const String _channelDesc = 'Daily habit and streak reminders';

  static const String _focusChannelId = 'hachimi_focus';
  static const String _focusChannelName = 'Focus Timer';
  static const String _focusChannelDesc = 'Focus session notifications';

  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels (Android)
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.defaultImportance,
        ),
      );
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _focusChannelId,
          _focusChannelName,
          description: _focusChannelDesc,
          importance: Importance.high,
        ),
      );
    }

    // Request FCM permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _messaging.getToken();
      if (token != null) {
        // In production, save token to Firestore for targeted messaging
      }
    }

    // Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background FCM message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle local notification taps — navigate based on payload
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification for FCM messages received in foreground
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
          ),
        ),
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Navigate to relevant screen based on message data
  }

  /// Schedule a daily reminder for a habit.
  Future<void> scheduleDailyReminder({
    required String habitId,
    required String habitName,
    required String catName,
    required int hour,
    required int minute,
  }) async {
    final id = habitId.hashCode.abs() % 100000;

    await _localNotifications.zonedSchedule(
      id,
      '$catName misses you!',
      "Time for $habitName — your cat is waiting!",
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'habit:$habitId',
    );
  }

  /// Cancel a habit's daily reminder.
  Future<void> cancelDailyReminder(String habitId) async {
    final id = habitId.hashCode.abs() % 100000;
    await _localNotifications.cancel(id);
  }

  /// Schedule a streak-at-risk notification for 20:00 today.
  Future<void> scheduleStreakAtRisk({
    required String habitId,
    required String catName,
    required int streak,
  }) async {
    final id = (habitId.hashCode.abs() % 100000) + 100000;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20, // 8 PM
    );

    // If 8 PM has already passed, don't schedule
    if (scheduledDate.isBefore(now)) return;

    await _localNotifications.zonedSchedule(
      id,
      '$catName is worried!',
      "Your $streak-day streak is at risk. A quick session will save it!",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'streak:$habitId',
    );
  }

  /// Show a celebration notification after level-up.
  Future<void> showCelebration({
    required String catName,
    required String newStageName,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000 + 200000,
      '$catName evolved!',
      '$catName grew into a $newStageName! Keep up the great work!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
        ),
      ),
    );
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Compute the next instance of a given time (today or tomorrow).
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
