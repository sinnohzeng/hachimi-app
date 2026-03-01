// ---
// AuthProvider 单元测试 — 验证 AuthUser/AuthResult 值语义、
// currentUidProvider 三态回退、isGuestProvider 场景覆盖。
// ---

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
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
  container.listen(authStateProvider, (_, __) {});

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

    test('data state with null user: falls back to local_guest_uid', () async {
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

    test('data state with null user: falls back to cached_uid', () async {
      SharedPreferences.setMockInitialValues({'cached_uid': 'cached-only'});
      final prefs = await SharedPreferences.getInstance();

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield null;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(currentUidProvider), equals('cached-only'));
    });

    test('loading state: falls back to cached_uid', () async {
      SharedPreferences.setMockInitialValues({'cached_uid': 'cached-123'});
      final prefs = await SharedPreferences.getInstance();

      // 永不 yield 的 stream → 持续 loading
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) async* {
            await Completer<void>().future;
          }),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(currentUidProvider), equals('cached-123'));
    });

    test(
      'loading with both guest and cached uid: prefers cached_uid',
      () async {
        SharedPreferences.setMockInitialValues({
          'local_guest_uid': 'guest_xxx',
          'cached_uid': 'cached-xxx',
        });
        final prefs = await SharedPreferences.getInstance();

        // loading 状态 — currentUidProvider 返回 cached_uid
        final container = ProviderContainer(
          overrides: [
            authStateProvider.overrideWith((ref) async* {
              await Completer<void>().future;
            }),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(currentUidProvider), equals('cached-xxx'));
      },
    );
  });

  // --- isGuestProvider ---

  group('isGuestProvider', () {
    test('anonymous Firebase user → true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const user = AuthUser(uid: 'anon-uid', isAnonymous: true);

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield user;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(isGuestProvider), isTrue);
    });

    test('registered Firebase user → false', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const user = AuthUser(
        uid: 'reg-uid',
        email: 'user@test.com',
        isAnonymous: false,
      );

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

    test('no Firebase user without local_guest_uid → false', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = await _createAndPump(
        streamBuilder: (ref) async* {
          yield null;
        },
        prefs: prefs,
      );
      addTearDown(container.dispose);

      expect(container.read(isGuestProvider), isFalse);
    });
  });
}
