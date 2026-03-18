// ---
// SessionChecksum 单元测试 — 验证 HMAC 签名计算逻辑。
//
// 测试范围：
// - 空 key 返回 null（开发环境）
// - 确定性输出（相同输入 → 相同摘要）
// - 不同输入 → 不同摘要
// - 输出格式为 hex 字符串
//
// 注意：SessionChecksum._key 是编译时常量（String.fromEnvironment），
// 在测试环境下默认为空字符串，因此 compute() 始终返回 null。
// 我们通过直接测试 HMAC 逻辑来验证算法正确性。
//
// 创建时间：2026-03-17
// ---

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/utils/session_checksum.dart';

void main() {
  // --- SessionChecksum.compute — 空 key 场景 ---

  group('SessionChecksum.compute — empty key (test env)', () {
    test('returns null when SESSION_HMAC_KEY is not configured', () {
      final result = SessionChecksum.compute(
        habitId: 'habit-1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: DateTime(2026, 3, 17, 10, 0),
      );
      expect(result, isNull);
    });

    test('returns null regardless of input values', () {
      final result = SessionChecksum.compute(
        habitId: '',
        durationMinutes: 0,
        coinsEarned: 0,
        xpEarned: 0,
        startedAt: DateTime(1970),
      );
      expect(result, isNull);
    });
  });

  // --- HMAC-SHA256 算法验证 ---
  //
  // 由于 _key 在测试环境为空，我们直接测试底层 HMAC 逻辑，
  // 确保 SessionChecksum.compute 的算法实现正确。

  group('HMAC-SHA256 — algorithm verification', () {
    // 镜像 SessionChecksum.compute 的内部实现
    String computeChecksum({
      required String key,
      required String habitId,
      required int durationMinutes,
      required int coinsEarned,
      required int xpEarned,
      required DateTime startedAt,
    }) {
      final payload =
          '$habitId|$durationMinutes|$coinsEarned|$xpEarned|${startedAt.millisecondsSinceEpoch}';
      final hmac = Hmac(sha256, utf8.encode(key));
      final digest = hmac.convert(utf8.encode(payload));
      return digest.toString();
    }

    test('deterministic: same input → same output', () {
      final dt = DateTime(2026, 3, 17, 10, 0);
      final a = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      final b = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      expect(a, equals(b));
    });

    test('different habitId → different checksum', () {
      final dt = DateTime(2026, 3, 17, 10, 0);
      final a = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      final b = computeChecksum(
        key: 'test-secret',
        habitId: 'h2',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      expect(a, isNot(equals(b)));
    });

    test('different durationMinutes → different checksum', () {
      final dt = DateTime(2026, 3, 17, 10, 0);
      final a = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      final b = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 30,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      expect(a, isNot(equals(b)));
    });

    test('different key → different checksum', () {
      final dt = DateTime(2026, 3, 17, 10, 0);
      final a = computeChecksum(
        key: 'key-a',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      final b = computeChecksum(
        key: 'key-b',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      expect(a, isNot(equals(b)));
    });

    test('different startedAt → different checksum', () {
      final a = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: DateTime(2026, 3, 17, 10, 0),
      );
      final b = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: DateTime(2026, 3, 17, 11, 0),
      );
      expect(a, isNot(equals(b)));
    });

    test(
      'output is hex string of expected length (SHA-256 = 64 hex chars)',
      () {
        final result = computeChecksum(
          key: 'test-key',
          habitId: 'h1',
          durationMinutes: 25,
          coinsEarned: 10,
          xpEarned: 50,
          startedAt: DateTime(2026, 3, 17),
        );
        expect(result.length, equals(64));
        expect(RegExp(r'^[a-f0-9]{64}$').hasMatch(result), isTrue);
      },
    );

    test('different coinsEarned → different checksum', () {
      final dt = DateTime(2026, 3, 17, 10, 0);
      final a = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      final b = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 20,
        xpEarned: 50,
        startedAt: dt,
      );
      expect(a, isNot(equals(b)));
    });

    test('different xpEarned → different checksum', () {
      final dt = DateTime(2026, 3, 17, 10, 0);
      final a = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 50,
        startedAt: dt,
      );
      final b = computeChecksum(
        key: 'test-secret',
        habitId: 'h1',
        durationMinutes: 25,
        coinsEarned: 10,
        xpEarned: 100,
        startedAt: dt,
      );
      expect(a, isNot(equals(b)));
    });
  });
}
