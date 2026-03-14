// ---
// AuthProvider 单元测试 — 验证 AppAuthState sealed class 派生语义、
// currentUidProvider 回退逻辑、isGuestProvider 场景覆盖。
//
// v2.33.0 重写：移除 cachedUid 测试，新增 appAuthStateProvider 测试。
// ---

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/models/app_auth_state.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 辅助函数：创建 ProviderContainer，订阅 authStateProvider 并等待事件循环处理。
/// 解决 Riverpod 3.x StreamProvider.overrideWith + ProviderContainer 的异步订阅问题。
Future<ProviderContainer> _createAndPump({
  required Stream<AuthUser?> Function(Ref) streamBuilder,
  required SharedPreferences prefs,
}) async {
  final container = ProviderContainer(
    overrides: [
      authStateProvider.overrideWith(streamBuilder),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  // 用 listen 触发 StreamProvider 订阅（不阻塞等待 future）
  container.listen(authStateProvider, (_, _) {});

  // 给 async* generator 足够的事件循环来 yield 值
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);

  return container;
}

void main() {
  // --- AuthUser 值语义 ---

  group('AuthUser — value semantics', () {
    test('equal instances with same fields', () {
      const a = AuthUser(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Test',
        isAnonymous: false,
      );
      const b = AuthUser(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Test',
        isAnonymous: false,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different uid → not equal', () {
      const a = AuthUser(uid: 'u1');
      const b = AuthUser(uid: 'u2');
      expect(a, isNot(equals(b)));
    });

    test('different email → not equal', () {
      const a = AuthUser(uid: 'u1', email: 'a@b.com');
      const b = AuthUser(uid: 'u1', email: 'c@d.com');
      expect(a, isNot(equals(b)));
    });

    test('different isAnonymous → not equal', () {
      const a = AuthUser(uid: 'u1', isAnonymous: true);
      const b = AuthUser(uid: 'u1', isAnonymous: false);
      expect(a, isNot(equals(b)));
    });

    test('toString format', () {
      const user = AuthUser(uid: 'abc', isAnonymous: true);
      expect(user.toString(), equals('AuthUser(abc, anonymous=true)'));
    });
  });

  // --- AuthResult 值语义 ---

  group('AuthResult — value semantics', () {
    test('equal instances with same fields', () {
      const a = AuthResult(uid: 'u1', email: 'a@b.com', isNewUser: true);
      const b = AuthResult(uid: 'u1', email: 'a@b.com', isNewUser: true);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different isNewUser → not equal', () {
      const a = AuthResult(uid: 'u1', isNewUser: true);
      const b = AuthResult(uid: 'u1', isNewUser: false);
      expect(a, isNot(equals(b)));
    });

    test('toString format', () {
      const result = AuthResult(uid: 'xyz', isNewUser: true);
      expect(result.toString(), equals('AuthResult(xyz, new=true)'));
    });
  });

  // --- appAuthStateProvider ---

  group('appAuthStateProvider', () {
    test('Firebase user → AuthenticatedState', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const user = AuthUser(uid: 'fb-uid', email: 'u@t.com');

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield user;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      final state = container.read(appAuthStateProvider);
      expect(state, isA<AuthenticatedState>());
      expect(state.uid, equals('fb-uid'));
      expect(state.isGuest, isFalse);
    });

    test('null user with local_guest_uid → GuestState', () async {
      SharedPreferences.setMockInitialValues({'local_guest_uid': 'guest_abc'});
      final prefs = await SharedPreferences.getInstance();

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield null;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      final state = container.read(appAuthStateProvider);
      expect(state, isA<GuestState>());
      expect(state.uid, equals('guest_abc'));
      expect(state.isGuest, isTrue);
    });

    test(
      'null user without local_guest_uid → GuestState with empty uid',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final container = await _createAndPump(
          streamBuilder: (ref) async* {
            yield null;
          },
          prefs: prefs,
        );
        addTearDown(container.dispose);

        final state = container.read(appAuthStateProvider);
        expect(state, isA<GuestState>());
        expect(state.uid, isEmpty);
        expect(state.isGuest, isTrue);
      },
    );

    test('loading state with local_guest_uid → GuestState', () async {
      SharedPreferences.setMockInitialValues({'local_guest_uid': 'guest_load'});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) async* {
            await Completer<void>().future; // 永不 yield → 持续 loading
          }),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(appAuthStateProvider);
      expect(state, isA<GuestState>());
      expect(state.uid, equals('guest_load'));
    });
  });

  // --- currentUidProvider ---

  group('currentUidProvider', () {
    test('data state: returns AuthUser.uid', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const user = AuthUser(uid: 'firebase-uid');

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield user;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(currentUidProvider), equals('firebase-uid'));
    });

    test('null user: falls back to local_guest_uid', () async {
      SharedPreferences.setMockInitialValues({'local_guest_uid': 'guest_abc'});
      final prefs = await SharedPreferences.getInstance();

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield null;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(currentUidProvider), equals('guest_abc'));
    });

    test('null user without any uid: returns null', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield null;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(currentUidProvider), isNull);
    });

    test('loading state: falls back to local_guest_uid', () async {
      SharedPreferences.setMockInitialValues({'local_guest_uid': 'guest_123'});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) async* {
            await Completer<void>().future;
          }),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(currentUidProvider), equals('guest_123'));
    });
  });

  // --- isGuestProvider ---

  group('isGuestProvider', () {
    test('Firebase user (any) → false', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const user = AuthUser(uid: 'fb-uid', isAnonymous: false);

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield user;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(isGuestProvider), isFalse);
    });

    test('no Firebase user with local_guest_uid → true', () async {
      SharedPreferences.setMockInitialValues({'local_guest_uid': 'guest_xyz'});
      final prefs = await SharedPreferences.getInstance();

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield null;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(isGuestProvider), isTrue);
    });

    test(
      'no Firebase user without local_guest_uid → true (empty guest)',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final container = await _createAndPump(
          streamBuilder: (ref) async* {
            yield null;
          },
          prefs: prefs,
        );
        addTearDown(container.dispose);

        // GuestState(uid: '') 仍然是访客，isGuest = true
        expect(container.read(isGuestProvider), isTrue);
      },
    );
  });
}
