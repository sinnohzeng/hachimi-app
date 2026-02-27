import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hachimi_app/core/backend/remote_config_backend.dart';

/// Firebase Remote Config 后端实现。
class FirebaseRemoteConfigBackend implements RemoteConfigBackend {
  final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;

  @override
  String get id => 'firebase';

  @override
  Future<void> initialize(Map<String, dynamic> defaults) async {
    await _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _config.setDefaults(defaults);

    try {
      await _config.fetchAndActivate();
    } catch (_) {
      // 使用默认值
    }
  }

  @override
  String getString(String key) => _config.getString(key);

  @override
  int getInt(String key) => _config.getInt(key);

  @override
  double getDouble(String key) => _config.getDouble(key);

  @override
  bool getBool(String key) => _config.getBool(key);

  @override
  Future<void> fetchAndActivate() async {
    await _config.fetchAndActivate();
  }
}
