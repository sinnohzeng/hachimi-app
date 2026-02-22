import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/firestore_service.dart';
import 'package:hachimi_app/services/cat_firestore_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/inventory_service.dart';
import 'package:hachimi_app/services/migration_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
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
final coinServiceProvider = Provider<CoinService>((ref) => CoinService());
final inventoryServiceProvider = Provider<InventoryService>(
  (ref) => InventoryService(),
);
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
