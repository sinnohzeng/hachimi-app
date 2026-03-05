import 'package:package_info_plus/package_info_plus.dart';

import 'package:hachimi_app/core/observability/uid_hasher.dart';

class ObservabilityRuntime {
  ObservabilityRuntime._();

  static String _uidHash = 'anonymous';
  static String _appVersion = 'unknown';
  static String _buildNumber = '0';

  static String get uidHash => _uidHash;
  static String get appVersion => _appVersion;
  static String get buildNumber => _buildNumber;

  static Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  static void setUidHashFromUid(String uid) {
    _uidHash = UidHasher.hash(uid);
  }

  static void setUidHash(String uidHash) {
    _uidHash = uidHash;
  }

  static void clearUidHash() {
    _uidHash = 'anonymous';
  }
}
