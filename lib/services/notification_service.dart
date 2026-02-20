// ---
// 📘 文件说明：
// NotificationService — 封装 FCM 和 flutter_local_notifications，
// 支持每日提醒、连续打卡风险提醒、庆祝通知和权限管理。
//
// 📋 程序整体伪代码（中文）：
// 1. initializePlugins() 初始化插件和通知渠道（不请求权限）；
// 2. setupFCM() 注册 FCM token 和监听前台消息（需权限）；
// 3. requestPermission() 请求 Android POST_NOTIFICATIONS / iOS 通知权限；
// 4. isPermissionGranted() 检查当前权限状态；
// 5. scheduleDailyReminder() / cancelDailyReminder() 调度/取消提醒；
//
// 🧩 文件结构：
// - NotificationService：单例服务；
// - 权限管理方法；
// - 调度方法；
// ---

import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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

  static const String _focusChannelId = 'hachimi_focus';
  static const String _focusChannelName = 'Focus Timer';
  static const String _focusChannelDesc = 'Focus session notifications';

  bool _pluginsInitialized = false;

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
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
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
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
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
    // Handle local notification taps — navigate based on payload
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
    // Navigate to relevant screen based on message data
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
      body: "Time for $habitName — your cat is waiting!",
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
      body: "Your $streak-day streak is at risk. A quick session will save it!",
      payload: 'streak:$habitId',
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
