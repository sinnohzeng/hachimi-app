// ---
// 📘 文件说明：
// Service Provider 定义 — 所有非认证 Service 的 Riverpod Provider 单例注册。
// 从 auth_provider.dart 迁出，职责分离。
//
// 🧩 文件结构：
// - firestoreServiceProvider / analyticsServiceProvider / ...：Service 单例；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/firestore_service.dart';
import 'package:hachimi_app/services/cat_firestore_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/inventory_service.dart';
import 'package:hachimi_app/services/migration_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/services/xp_service.dart';

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
