import 'package:hachimi_app/core/backend/analytics_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/backend/crash_backend.dart';
import 'package:hachimi_app/core/backend/remote_config_backend.dart';
import 'package:hachimi_app/core/backend/sync_backend.dart';
import 'package:hachimi_app/core/backend/user_profile_backend.dart';

/// 后端注册中心。
///
/// 当前仅保留 Firebase 一条后端路径，不再维护多区域兼容分支。
class BackendRegistry {
  final AuthBackend auth;
  final SyncBackend sync;
  final UserProfileBackend userProfile;
  final AnalyticsBackend analytics;
  final CrashBackend crash;
  final RemoteConfigBackend remoteConfig;

  const BackendRegistry({
    required this.auth,
    required this.sync,
    required this.userProfile,
    required this.analytics,
    required this.crash,
    required this.remoteConfig,
  });
}
