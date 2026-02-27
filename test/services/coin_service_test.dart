// ---
// 📘 文件说明：
// CoinService 参数校验测试 — 验证 spendCoins / earnCoins / purchaseAccessory 的运行时参数校验。
// 使用 firebase_core_platform_interface/test.dart 的 setupFirebaseCoreMocks
// 以允许构造 CoinService（内部 eagerly 初始化 FirebaseFirestore.instance）。
//
// 🧩 文件结构：
// - Firebase Core mock 初始化；
// - spendCoins amount <= 0 触发 ArgumentError；
// - purchaseAccessory 空 accessoryId 触发 ArgumentError；
// - purchaseAccessory price <= 0 触发 ArgumentError；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';

void main() {
  late CoinService coinService;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    final localDb = LocalDatabaseService();
    final ledger = LedgerService(localDb: localDb);
    coinService = CoinService(ledger: ledger);
  });

  group('CoinService.spendCoins validation', () {
    test('amount <= 0 throws ArgumentError', () {
      expect(
        () => coinService.spendCoins(uid: 'test-uid', amount: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('negative amount throws ArgumentError', () {
      expect(
        () => coinService.spendCoins(uid: 'test-uid', amount: -5),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('CoinService.earnCoins validation', () {
    test('amount <= 0 throws ArgumentError', () {
      expect(
        () => coinService.earnCoins(uid: 'test-uid', amount: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('negative amount throws ArgumentError', () {
      expect(
        () => coinService.earnCoins(uid: 'test-uid', amount: -5),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('CoinService.purchaseAccessory validation', () {
    test('empty accessoryId throws ArgumentError', () {
      expect(
        () => coinService.purchaseAccessory(
          uid: 'test-uid',
          accessoryId: '',
          price: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('price <= 0 throws ArgumentError', () {
      expect(
        () => coinService.purchaseAccessory(
          uid: 'test-uid',
          accessoryId: 'MAPLE LEAF',
          price: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('negative price throws ArgumentError', () {
      expect(
        () => coinService.purchaseAccessory(
          uid: 'test-uid',
          accessoryId: 'MAPLE LEAF',
          price: -10,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
