// ---
// 📘 文件说明：
// CoinService 断言测试 — 验证 spendCoins / purchaseAccessory 的参数断言。
// 使用 firebase_core_platform_interface/test.dart 的 setupFirebaseCoreMocks
// 以允许构造 CoinService（内部 eagerly 初始化 FirebaseFirestore.instance）。
//
// 🧩 文件结构：
// - Firebase Core mock 初始化；
// - spendCoins amount <= 0 触发断言；
// - purchaseAccessory 空 accessoryId 触发断言；
// - purchaseAccessory price <= 0 触发断言；
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

  group('CoinService.spendCoins assertions', () {
    test('amount <= 0 throws assertion error', () {
      expect(
        () => coinService.spendCoins(uid: 'test-uid', amount: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('negative amount throws assertion error', () {
      expect(
        () => coinService.spendCoins(uid: 'test-uid', amount: -5),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('CoinService.earnCoins assertions', () {
    test('amount <= 0 throws assertion error', () {
      expect(
        () => coinService.earnCoins(uid: 'test-uid', amount: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('negative amount throws assertion error', () {
      expect(
        () => coinService.earnCoins(uid: 'test-uid', amount: -5),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('CoinService.purchaseAccessory assertions', () {
    test('empty accessoryId throws assertion error', () {
      expect(
        () => coinService.purchaseAccessory(
          uid: 'test-uid',
          accessoryId: '',
          price: 100,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('price <= 0 throws assertion error', () {
      expect(
        () => coinService.purchaseAccessory(
          uid: 'test-uid',
          accessoryId: 'MAPLE LEAF',
          price: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('negative price throws assertion error', () {
      expect(
        () => coinService.purchaseAccessory(
          uid: 'test-uid',
          accessoryId: 'MAPLE LEAF',
          price: -10,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
