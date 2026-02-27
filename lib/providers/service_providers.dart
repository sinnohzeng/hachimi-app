import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/backend/analytics_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/backend/backend_registry.dart';
import 'package:hachimi_app/core/backend/crash_backend.dart';
import 'package:hachimi_app/core/backend/remote_config_backend.dart';
import 'package:hachimi_app/core/backend/sync_backend.dart';
import 'package:hachimi_app/core/backend/user_profile_backend.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/firebase/firebase_analytics_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_auth_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_crash_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_remote_config_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_sync_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_user_profile_backend.dart';
import 'package:hachimi_app/services/inventory_service.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/services/local_cat_repository.dart';
import 'package:hachimi_app/services/local_database_service.dart';
import 'package:hachimi_app/services/local_habit_repository.dart';
import 'package:hachimi_app/services/local_session_repository.dart';
import 'package:hachimi_app/services/sync_engine.dart';
import 'package:hachimi_app/services/migration_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/services/account_deletion_service.dart';
import 'package:hachimi_app/services/xp_service.dart';

/// SharedPreferences — 在 main() 中预加载并通过 ProviderScope.overrides 注入。
/// 所有消费方通过此 provider 同步读取，消除异步等待和主题闪烁。
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider 必须在 ProviderScope.overrides 中初始化',
  ),
);

/// Service providers — singletons
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(),
);
final coinServiceProvider = Provider<CoinService>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return CoinService(ledger: ledger);
});
final inventoryServiceProvider = Provider<InventoryService>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return InventoryService(ledger: ledger);
});
final migrationServiceProvider = Provider<MigrationService>(
  (ref) => MigrationService(),
);
final xpServiceProvider = Provider<XpService>((ref) => XpService());
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
final accountDeletionServiceProvider = Provider<AccountDeletionService>(
  (ref) => AccountDeletionService(),
);

// ─── 本地优先架构 Providers ───

final localDatabaseServiceProvider = Provider<LocalDatabaseService>(
  (ref) => LocalDatabaseService(),
);
final ledgerServiceProvider = Provider<LedgerService>((ref) {
  final localDb = ref.watch(localDatabaseServiceProvider);
  return LedgerService(localDb: localDb);
});
final localHabitRepositoryProvider = Provider<LocalHabitRepository>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return LocalHabitRepository(ledger: ledger);
});
final localCatRepositoryProvider = Provider<LocalCatRepository>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return LocalCatRepository(ledger: ledger);
});
final localSessionRepositoryProvider = Provider<LocalSessionRepository>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return LocalSessionRepository(ledger: ledger);
});
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return SyncEngine(ledger: ledger);
});

// ─── 多后端抽象层 Providers ───

/// 当前后端区域 — 默认全球版（Firebase）。
/// 未来区域切换 UI 修改此值即可切换全部后端。
final backendRegionProvider = Provider<BackendRegion>(
  (_) => BackendRegion.global,
);

/// 后端注册中心 — 根据区域创建对应的全部后端实例。
final backendRegistryProvider = Provider<BackendRegistry>((ref) {
  final region = ref.watch(backendRegionProvider);
  return switch (region) {
    BackendRegion.global => BackendRegistry(
      region: region,
      auth: FirebaseAuthBackend(),
      sync: FirebaseSyncBackend(),
      userProfile: FirebaseUserProfileBackend(),
      analytics: FirebaseAnalyticsBackend(),
      crash: FirebaseCrashBackend(),
      remoteConfig: FirebaseRemoteConfigBackend(),
    ),
    BackendRegion.china => throw UnimplementedError('CloudBase 后端尚未实现'),
  };
});

/// 便捷 backend providers — 屏蔽 Registry 细节。
final authBackendProvider = Provider<AuthBackend>(
  (ref) => ref.watch(backendRegistryProvider).auth,
);
final syncBackendProvider = Provider<SyncBackend>(
  (ref) => ref.watch(backendRegistryProvider).sync,
);
final userProfileBackendProvider = Provider<UserProfileBackend>(
  (ref) => ref.watch(backendRegistryProvider).userProfile,
);
final analyticsBackendProvider = Provider<AnalyticsBackend>(
  (ref) => ref.watch(backendRegistryProvider).analytics,
);
final crashBackendProvider = Provider<CrashBackend>(
  (ref) => ref.watch(backendRegistryProvider).crash,
);
final remoteConfigBackendProvider = Provider<RemoteConfigBackend>(
  (ref) => ref.watch(backendRegistryProvider).remoteConfig,
);
