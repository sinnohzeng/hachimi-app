import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

/// NotificationService — singleton wrapping Firebase Cloud Messaging (FCM) and
/// flutter_local_notifications for scheduled local notifications.
///
/// Notification types (per PRD Section 3.5):
/// 1. Scheduled daily — at user-set reminder time per habit
/// 2. Streak-at-risk — at 20:00 if no session today and streak >= 3
/// 3. Win-back — 48h with no session (server-triggered via FCM)
/// 4. Celebration — after level-up
class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'hachimi_reminders';
  static const String _channelName = 'Habit Reminders';
  static const String _channelDesc = 'Daily habit and streak reminders';

  static const String _focusChannelId = 'hachimi_focus_complete';
  static const String _focusChannelName = 'Focus Complete';
  static const String _focusChannelDesc = 'Focus session completion alerts';

  bool _pluginsInitialized = false;

  /// 待处理的导航路由（通知点击后存储，由 UI 层消费）。
  String? _pendingNavigation;

  /// 消费待处理的导航路由（取出后清空）。
  String? consumePendingNavigation() {
    final nav = _pendingNavigation;
    _pendingNavigation = null;
    return nav;
  }

  /// Initialize plugins and notification channels WITHOUT requesting permissions.
  /// Safe to call at app startup.
  Future<void> initializePlugins() async {
    if (_pluginsInitialized) return;

    // Initialize timezone data
    tz.initializeTimeZones();

    // Initialize local notifications — do NOT request permissions on iOS here
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels (Android)
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
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

      // Clean up old channel IDs from previous versions
      await androidPlugin.deleteNotificationChannel(
        channelId: 'hachimi_focus_timer',
      );
      await androidPlugin.deleteNotificationChannel(
        channelId: 'hachimi_focus_timer_v2',
      );
    }

    _pluginsInitialized = true;
  }

  /// Set up FCM — registers token and listens for foreground messages.
  /// Call this AFTER permissions have been granted.
  Future<void> setupFCM() async {
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

  // ─── Permission Management ───

  /// Check if notification permission is currently granted.
  Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final granted = await androidPlugin.areNotificationsEnabled();
        return granted ?? false;
      }
      return false;
    } else if (Platform.isIOS) {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  /// Request notification permission. Returns true if granted.
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }
      return false;
    } else if (Platform.isIOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  // ─── Notification Handlers ───

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    _pendingNavigation = payload;
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification for FCM messages received in foreground
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          ),
        ),
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    final habitId = data['habitId'] as String?;
    final type = data['type'] as String?;
    if (habitId != null && habitId.isNotEmpty) {
      _pendingNavigation = '${type ?? 'habit'}:$habitId';
    }
  }

  // ─── Scheduling ───

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
      id: id,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: '$catName misses you!',
      body: 'Time for $habitName — your cat is waiting!',
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'habit:$habitId',
    );
  }

  /// Cancel a habit's daily reminder.
  Future<void> cancelDailyReminder(String habitId) async {
    final id = habitId.hashCode.abs() % 100000;
    await _localNotifications.cancel(id: id);
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
      id: id,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: '$catName is worried!',
      body: 'Your $streak-day streak is at risk. A quick session will save it!',
      payload: 'streak:$habitId',
    );
  }

  // ─── Timer Backup Alarm ───

  static const int _timerBackupId = 300001;

  /// Schedule a backup alarm for focus timer completion.
  /// If the foreground service is killed by the OS, this alarm ensures
  /// the user still gets a completion notification.
  Future<void> scheduleTimerBackup({
    required DateTime fireAt,
    required String title,
    required String body,
  }) async {
    final scheduledDate = tz.TZDateTime.from(fireAt, tz.local);
    await _localNotifications.zonedSchedule(
      id: _timerBackupId,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _focusChannelId,
          _focusChannelName,
          channelDescription: _focusChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: title,
      body: body,
    );
  }

  /// Cancel the backup timer alarm (called on normal completion, pause, etc.).
  Future<void> cancelTimerBackup() async {
    await _localNotifications.cancel(id: _timerBackupId);
  }

  /// Show a focus completion notification.
  /// Called from TimerScreen with localized strings (screen has BuildContext).
  Future<void> showFocusComplete({
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      id: 300000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _focusChannelId,
          _focusChannelName,
          channelDescription: _focusChannelDesc,
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Show a celebration notification after level-up.
  Future<void> showCelebration({
    required String catName,
    required String newStageName,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch % 100000 + 200000,
      title: '$catName evolved!',
      body: '$catName grew into a $newStageName! Keep up the great work!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
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
