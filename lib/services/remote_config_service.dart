import 'package:firebase_remote_config/firebase_remote_config.dart';

/// RemoteConfigService — wraps Firebase Remote Config.
/// Remote Config is the SSOT for dynamic configuration (A/B tests).
/// See docs/firebase/remote-config.md for parameter definitions.
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Legacy keys
  static const String keyCheckInSuccessMessage = 'checkin_success_message';
  static const String defaultSuccessMessage =
      'Great job! Keep the momentum going.';

  // Cat system keys
  static const String keyXpMultiplier = 'xp_multiplier';
  static const String keyNotificationCopyVariant = 'notification_copy_variant';
  static const String keyMoodThresholdLonelyDays =
      'mood_threshold_lonely_days';
  static const String keyDefaultFocusDuration = 'default_focus_duration';

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults({
      keyCheckInSuccessMessage: defaultSuccessMessage,
      keyXpMultiplier: 1.0,
      keyNotificationCopyVariant: 'A',
      keyMoodThresholdLonelyDays: 3,
      keyDefaultFocusDuration: 25,
    });

    // Fetch and activate on init
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Use defaults if fetch fails
    }
  }

  String get checkInSuccessMessage =>
      _remoteConfig.getString(keyCheckInSuccessMessage);

  /// XP multiplier for events/promotions (default: 1.0, range: 0.1-10.0).
  double get xpMultiplier =>
      _remoteConfig.getDouble(keyXpMultiplier).clamp(0.1, 10.0);

  /// Notification copy variant for A/B testing (default: 'A').
  String get notificationCopyVariant =>
      _remoteConfig.getString(keyNotificationCopyVariant);

  /// Days without a session before mood becomes 'lonely' (default: 3, range: 1-30).
  int get moodThresholdLonelyDays =>
      _remoteConfig.getInt(keyMoodThresholdLonelyDays).clamp(1, 30);

  /// Default focus duration in minutes for new habits (default: 25, range: 5-180).
  int get defaultFocusDuration =>
      _remoteConfig.getInt(keyDefaultFocusDuration).clamp(5, 180);
}
