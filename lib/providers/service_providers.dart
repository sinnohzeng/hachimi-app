import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/backend/analytics_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/backend/backend_registry.dart';
import 'package:hachimi_app/core/backend/crash_backend.dart';
import 'package:hachimi_app/core/backend/remote_config_backend.dart';
import 'package:hachimi_app/core/backend/sync_backend.dart';
import 'package:hachimi_app/core/backend/user_profile_backend.dart';
import 'package:hachimi_app/services/account_deletion_orchestrator.dart';
import 'package:hachimi_app/services/account_deletion_service.dart';
import 'package:hachimi_app/services/account_merge_service.dart';
import 'package:hachimi_app/services/account_snapshot_service.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/firebase/firebase_account_lifecycle_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_analytics_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_auth_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_crash_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_remote_config_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_sync_backend.dart';
import 'package:hachimi_app/services/firebase/firebase_user_profile_backend.dart';
import 'package:hachimi_app/services/guest_upgrade_coordinator.dart';
import 'package:hachimi_app/services/inventory_service.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/services/local_cat_repository.dart';
import 'package:hachimi_app/services/local_database_service.dart';
import 'package:hachimi_app/services/local_habit_repository.dart';
import 'package:hachimi_app/services/local_session_repository.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/services/sync_engine.dart';
import 'package:hachimi_app/services/user_profile_service.dart';
import 'package:hachimi_app/services/xp_service.dart';

/// SharedPreferences 在 main() 中预加载并通过 ProviderScope.overrides 注入。
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider 必须在 ProviderScope.overrides 中初始化',
  ),
);

// ─── 基础服务 ───

final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(),
);

final coinServiceProvider = Provider<CoinService>((ref) {
  return CoinService(ledger: ref.watch(ledgerServiceProvider));
});

final inventoryServiceProvider = Provider<InventoryService>((ref) {
  return InventoryService(ledger: ref.watch(ledgerServiceProvider));
});

final xpServiceProvider = Provider<XpService>((ref) => XpService());

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

// ─── 本地优先核心 ───

final localDatabaseServiceProvider = Provider<LocalDatabaseService>(
  (ref) => LocalDatabaseService(),
);

final ledgerServiceProvider = Provider<LedgerService>((ref) {
  return LedgerService(localDb: ref.watch(localDatabaseServiceProvider));
});

final localHabitRepositoryProvider = Provider<LocalHabitRepository>((ref) {
  return LocalHabitRepository(ledger: ref.watch(ledgerServiceProvider));
});

final localCatRepositoryProvider = Provider<LocalCatRepository>((ref) {
  return LocalCatRepository(ledger: ref.watch(ledgerServiceProvider));
});

final localSessionRepositoryProvider = Provider<LocalSessionRepository>((ref) {
  return LocalSessionRepository(ledger: ref.watch(ledgerServiceProvider));
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(ledger: ref.watch(ledgerServiceProvider));
});

// ─── 后端抽象 ───

final backendRegistryProvider = Provider<BackendRegistry>((ref) {
  return BackendRegistry(
    auth: FirebaseAuthBackend(),
    sync: FirebaseSyncBackend(),
    userProfile: FirebaseUserProfileBackend(),
    analytics: FirebaseAnalyticsBackend(),
    crash: FirebaseCrashBackend(),
    remoteConfig: FirebaseRemoteConfigBackend(),
  );
});

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

final accountLifecycleBackendProvider = Provider<AccountLifecycleBackend>(
  (ref) => FirebaseAccountLifecycleBackend(),
);

// ─── 账户生命周期编排 ───

final userProfileServiceProvider = Provider<UserProfileService>(
  (ref) => UserProfileService(backend: ref.watch(userProfileBackendProvider)),
);

final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  return AccountDeletionService(
    localDb: ref.watch(localDatabaseServiceProvider),
    notifications: ref.watch(notificationServiceProvider),
  );
});

final accountSnapshotServiceProvider = Provider<AccountSnapshotService>((ref) {
  return AccountSnapshotService(
    localDb: ref.watch(localDatabaseServiceProvider),
  );
});

final accountMergeServiceProvider = Provider<AccountMergeService>((ref) {
  return AccountMergeService(
    ledger: ref.watch(ledgerServiceProvider),
    syncEngine: ref.watch(syncEngineProvider),
    profileService: ref.watch(userProfileServiceProvider),
    lifecycleBackend: ref.watch(accountLifecycleBackendProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

final guestUpgradeCoordinatorProvider = Provider<GuestUpgradeCoordinator>((
  ref,
) {
  return GuestUpgradeCoordinator(
    snapshotService: ref.watch(accountSnapshotServiceProvider),
    mergeService: ref.watch(accountMergeServiceProvider),
  );
});

final accountDeletionOrchestratorProvider =
    Provider<AccountDeletionOrchestrator>((ref) {
      return AccountDeletionOrchestrator(
        deletionService: ref.watch(accountDeletionServiceProvider),
        lifecycleBackend: ref.watch(accountLifecycleBackendProvider),
        authBackend: ref.watch(authBackendProvider),
        prefs: ref.watch(sharedPreferencesProvider),
      );
    });
