// ---
// 📘 文件说明：
// AppDateUtils 单元测试 — 验证日期格式化工具的输出格式正确性。
//
// 🧩 文件结构：
// - todayString() 格式验证；
// - currentMonth() 格式验证；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('todayString() returns yyyy-MM-dd format', () {
      final result = AppDateUtils.todayString();

      // 格式必须为 yyyy-MM-dd（如 2026-02-19）
      expect(
        RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(result),
        isTrue,
        reason: 'todayString() should match yyyy-MM-dd, got: $result',
      );
    });

    test('currentMonth() returns yyyy-MM format', () {
      final result = AppDateUtils.currentMonth();

      // 格式必须为 yyyy-MM（如 2026-02）
      expect(
        RegExp(r'^\d{4}-\d{2}$').hasMatch(result),
        isTrue,
        reason: 'currentMonth() should match yyyy-MM, got: $result',
      );
    });

    test('todayString() is consistent with DateTime.now()', () {
      final result = AppDateUtils.todayString();
      final now = DateTime.now();

      // 年份应匹配当前年
      expect(result.substring(0, 4), equals(now.year.toString()));
    });

    test('currentMonth() is a prefix of todayString()', () {
      final today = AppDateUtils.todayString();
      final month = AppDateUtils.currentMonth();

      // yyyy-MM 应该是 yyyy-MM-dd 的前 7 个字符
      expect(today.substring(0, 7), equals(month));
    });
  });

  group('AppDateUtils.isoWeekId', () {
    test('normal date returns correct ISO week', () {
      // 2026-03-17 是周二，ISO 第 12 周
      expect(AppDateUtils.isoWeekId(DateTime(2026, 3, 17)), equals('2026-W12'));
    });

    test('week number is zero-padded', () {
      // 2026-01-05 是周一，ISO 第 2 周
      expect(AppDateUtils.isoWeekId(DateTime(2026, 1, 5)), equals('2026-W02'));
    });

    test('first day of year may belong to previous year week', () {
      // 2026-01-01 是周四，属于 2026-W01
      expect(AppDateUtils.isoWeekId(DateTime(2026, 1, 1)), equals('2026-W01'));
    });

    test('year boundary: 2025-12-29 belongs to ISO 2026-W01', () {
      // 2025-12-29 是周一，ISO 8601 中它属于 2026 年第 1 周
      // （因为该周的周四 2026-01-01 在 2026 年）
      expect(
        AppDateUtils.isoWeekId(DateTime(2025, 12, 29)),
        equals('2026-W01'),
      );
    });

    test('year boundary: 2024-12-30 belongs to ISO 2025-W01', () {
      // 2024-12-30 是周一，该周四是 2025-01-02 → 2025-W01
      expect(
        AppDateUtils.isoWeekId(DateTime(2024, 12, 30)),
        equals('2025-W01'),
      );
    });

    test('last week of year: 2025-12-28 is 2025-W52', () {
      // 2025-12-28 是周日，该周四是 2025-12-25 → 2025-W52
      expect(
        AppDateUtils.isoWeekId(DateTime(2025, 12, 28)),
        equals('2025-W52'),
      );
    });

    test('matches yyyy-Wnn format', () {
      final result = AppDateUtils.isoWeekId(DateTime(2026, 6, 15));
      expect(
        RegExp(r'^\d{4}-W\d{2}$').hasMatch(result),
        isTrue,
        reason: 'isoWeekId should match yyyy-Wnn, got: $result',
      );
    });
  });
}
