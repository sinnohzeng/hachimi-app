import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/firestore_service.dart';
import 'package:hachimi_app/services/cat_firestore_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
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
import 'package:hachimi_app/services/achievement_service.dart';
import 'package:hachimi_app/services/xp_service.dart';

/// SharedPreferences — 在 main() 中预加载并通过 ProviderScope.overrides 注入。
/// 所有消费方通过此 provider 同步读取，消除异步等待和主题闪烁。
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider 必须在 ProviderScope.overrides 中初始化',
  ),
);

/// Service providers — singletons
final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(),
);
final catFirestoreServiceProvider = Provider<CatFirestoreService>(
  (ref) => CatFirestoreService(),
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
final achievementServiceProvider = Provider<AchievementService>(
  (ref) => AchievementService(),
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
