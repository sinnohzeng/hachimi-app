import 'package:hachimi_app/core/backend/analytics_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/backend/crash_backend.dart';
import 'package:hachimi_app/core/backend/remote_config_backend.dart';
import 'package:hachimi_app/core/backend/sync_backend.dart';
import 'package:hachimi_app/core/backend/user_profile_backend.dart';

/// 后端区域枚举。
enum BackendRegion {
  /// 全球版（Firebase）。
  global,

  /// 中国版（Tencent CloudBase）。
  china,
}

/// 后端注册中心 — 持有当前区域所有后端实例。
///
/// 通过 [backendRegistryProvider] 注入，
/// 运行时根据 [BackendRegion] 切换具体实现。
class BackendRegistry {
  final BackendRegion region;
  final AuthBackend auth;
  final SyncBackend sync;
  final UserProfileBackend userProfile;
  final AnalyticsBackend analytics;
  final CrashBackend crash;
  final RemoteConfigBackend remoteConfig;

  const BackendRegistry({
    required this.region,
    required this.auth,
    required this.sync,
    required this.userProfile,
    required this.analytics,
    required this.crash,
    required this.remoteConfig,
  });
}
