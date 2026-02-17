import 'package:firebase_remote_config/firebase_remote_config.dart';

/// RemoteConfigService — wraps Firebase Remote Config.
/// Remote Config is the SSOT for dynamic configuration (A/B tests).
/// See docs/firebase/remote-config.md for parameter definitions.
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const String keyCheckInSuccessMessage = 'checkin_success_message';
  static const String defaultSuccessMessage =
      'Great job! Keep the momentum going.';

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults({
      keyCheckInSuccessMessage: defaultSuccessMessage,
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
}
