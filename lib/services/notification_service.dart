import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:intl/intl.dart';
import 'package:hachimi_app/services/notification_scheduling.dart' as sched;
import 'package:shared_preferences/shared_preferences.dart';
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

  static const String _awarenessChannelId = 'hachimi_awareness';
  static const String _awarenessChannelName = 'Awareness Reminders';
  static const String _awarenessChannelDesc =
      'Daily light, weekly review, and monthly ritual reminders';

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
    tz.initializeTimeZones();
    await _initNotificationPlugin();
    await _createNotificationChannels();
    _pluginsInitialized = true;
  }

  /// 初始化本地通知插件（不请求权限）。
  Future<void> _initNotificationPlugin() async {
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
  }

  /// 创建 Android 通知通道 + 清理旧版本通道。
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

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
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _awarenessChannelId,
        _awarenessChannelName,
        description: _awarenessChannelDesc,
        importance: Importance.defaultImportance,
      ),
    );
    // 清理旧版本通道
    await androidPlugin.deleteNotificationChannel(
      channelId: 'hachimi_focus_timer',
    );
    await androidPlugin.deleteNotificationChannel(
      channelId: 'hachimi_focus_timer_v2',
    );
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

  /// 获取 Android 平台插件（非 Android 返回 null）。
  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  /// Check if notification permission is currently granted.
  Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid) {
      final granted = await _androidPlugin?.areNotificationsEnabled();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  /// Request notification permission. Returns true if granted.
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final granted = await _androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
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

  /// 为一个 habit 调度多条提醒。先取消旧通知，再按模式逐条调度。
  ///
  /// ID 方案: `base * 100 + reminderIdx * 10 + dayOffset`
  /// - base = habitId.hashCode.abs() % 100000（10 万空间，降低碰撞概率）
  /// - dayOffset: daily=0, weekdays=0~4, 具体星期=0
  ///
  /// [title] 和 [body] 为已本地化的通知文案，由调用方传入。
  Future<void> scheduleReminders({
    required String habitId,
    required String habitName,
    required String catName,
    required List<ReminderConfig> reminders,
    required String title,
    required String body,
  }) async {
    await cancelAllRemindersForHabit(habitId);

    for (int i = 0; i < reminders.length; i++) {
      try {
        await _scheduleByMode(
          reminders[i],
          index: i,
          habitId: habitId,
          title: title,
          body: body,
        );
      } catch (e, stack) {
        ErrorHandler.recordOperation(
          e,
          stackTrace: stack,
          feature: 'NotificationService',
          operation: 'scheduleReminders[$i]',
        );
      }
    }
  }

  /// 按提醒模式分发调度。
  Future<void> _scheduleByMode(
    ReminderConfig reminder, {
    required int index,
    required String habitId,
    required String title,
    required String body,
  }) async {
    switch (reminder.mode) {
      case ReminderMode.daily:
        await _scheduleDaily(reminder, index, habitId, title, body);
      case ReminderMode.weekdays:
        await _scheduleWeekdays(reminder, index, habitId, title, body);
      default:
        await _scheduleSpecificDay(reminder, index, habitId, title, body);
    }
  }

  Future<void> _scheduleDaily(
    ReminderConfig r,
    int i,
    String habitId,
    String title,
    String body,
  ) async {
    await _localNotifications.zonedSchedule(
      id: sched.computeReminderNotificationId(habitId, i, 0),
      scheduledDate: sched.nextInstanceOfTime(r.hour, r.minute),
      notificationDetails: _reminderDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'habit:$habitId',
    );
  }

  Future<void> _scheduleWeekdays(
    ReminderConfig r,
    int i,
    String habitId,
    String title,
    String body,
  ) async {
    for (int d = 0; d < 5; d++) {
      await _localNotifications.zonedSchedule(
        id: sched.computeReminderNotificationId(habitId, i, d),
        scheduledDate: sched.nextInstanceOfWeekdayTime(
          DateTime.monday + d,
          r.hour,
          r.minute,
        ),
        notificationDetails: _reminderDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'habit:$habitId',
      );
    }
  }

  Future<void> _scheduleSpecificDay(
    ReminderConfig r,
    int i,
    String habitId,
    String title,
    String body,
  ) async {
    final weekday = r.weekday;
    if (weekday == null) return;
    await _localNotifications.zonedSchedule(
      id: sched.computeReminderNotificationId(habitId, i, 0),
      scheduledDate: sched.nextInstanceOfWeekdayTime(weekday, r.hour, r.minute),
      notificationDetails: _reminderDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'habit:$habitId',
    );
  }

  /// 取消该 habit 的所有提醒通知（最多 5 reminders × 10 slots each）。
  Future<void> cancelAllRemindersForHabit(String habitId) async {
    for (int i = 0; i < 5; i++) {
      for (int d = 0; d < 10; d++) {
        final id = sched.computeReminderNotificationId(habitId, i, d);
        await _localNotifications.cancel(id: id);
      }
    }
  }

  /// 通知详情（提醒通道复用）。
  static const _reminderDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    ),
  );

  /// Schedule a streak-at-risk notification for 20:00 today.
  ///
  /// [title] and [body] are pre-localized strings from the caller.
  Future<void> scheduleStreakAtRisk({
    required String habitId,
    required String title,
    required String body,
  }) async {
    final id = sched.computeStreakNotificationId(habitId);

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
      title: title,
      body: body,
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
  ///
  /// [title] and [body] are pre-localized strings from the caller.
  Future<void> showCelebration({
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch % 100000 + 200000,
      title: title,
      body: body,
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

  // ─── Awareness Notifications ───

  /// 通知详情（觉知通道）。
  static const _awarenessDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _awarenessChannelId,
      _awarenessChannelName,
      channelDescription: _awarenessChannelDesc,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    ),
  );

  /// 调度每日睡前一点光提醒（ID: 200001）。
  /// 调用时机：App 启动 + 设置页修改提醒时间后。
  Future<void> scheduleAwarenessBedtimeReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      await _localNotifications.cancel(id: 200001);
      await _localNotifications.zonedSchedule(
        id: 200001,
        scheduledDate: sched.nextInstanceOfTime(hour, minute),
        notificationDetails: _awarenessDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'awareness:daily_light',
      );
    } catch (e) {
      debugPrint('[Notification] Schedule bedtime reminder failed: $e');
    }
  }

  /// 调度每周日 20:00 的周回顾提醒（ID: 200002）。
  Future<void> scheduleWeeklyReviewReminder({
    required String title,
    required String body,
  }) async {
    try {
      await _localNotifications.cancel(id: 200002);
      await _localNotifications.zonedSchedule(
        id: 200002,
        scheduledDate: sched.nextInstanceOfWeekdayTime(DateTime.sunday, 20, 0),
        notificationDetails: _awarenessDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'awareness:weekly_review',
      );
    } catch (e) {
      debugPrint('[Notification] Schedule weekly review reminder failed: $e');
    }
  }

  /// 月初仪式提醒（ID: 200003）— App 启动时检查。
  /// 不使用 zonedSchedule（不支持每月 N 日），改用即时显示。
  Future<void> checkMonthlyRitualReminder({
    required String title,
    required String body,
  }) async {
    try {
      final now = DateTime.now();
      if (now.day != 1) return;

      final prefs = await SharedPreferences.getInstance();
      final lastReminded =
          prefs.getString(AppPrefsKeys.monthlyRitualLastReminded) ?? '';
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      if (lastReminded == todayStr) return;

      await _localNotifications.show(
        id: 200003,
        title: title,
        body: body,
        notificationDetails: _awarenessDetails,
      );
      await prefs.setString(AppPrefsKeys.monthlyRitualLastReminded, todayStr);
    } catch (e) {
      debugPrint('[Notification] Check monthly ritual reminder failed: $e');
    }
  }

  /// 温柔召回通知调度（ID: 200004）。
  /// 调用时机：每次一点光保存后。最多每两周一次。
  Future<void> scheduleGentleReengagement({
    required String title,
    required String body,
  }) async {
    try {
      await _localNotifications.cancel(id: 200004);

      // 检查上次召回时间，如果 < 14 天前则跳过
      final prefs = await SharedPreferences.getInstance();
      final lastReengagement =
          prefs.getString(AppPrefsKeys.lastGentleReengagementAt) ?? '';
      if (lastReengagement.isNotEmpty) {
        final lastDate = DateTime.tryParse(lastReengagement);
        if (lastDate != null &&
            DateTime.now().difference(lastDate).inDays < 14) {
          return;
        }
      }

      // 调度 3 天后的通知
      final fireAt = tz.TZDateTime.now(tz.local).add(const Duration(days: 3));
      await _localNotifications.zonedSchedule(
        id: 200004,
        scheduledDate: fireAt,
        notificationDetails: _awarenessDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        payload: 'awareness:gentle_reengagement',
      );

      // 记录预期触发时间（用于 14 天间隔检查）
      await prefs.setString(
        AppPrefsKeys.lastGentleReengagementAt,
        DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      );
    } catch (e) {
      debugPrint('[Notification] Schedule gentle reengagement failed: $e');
    }
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
