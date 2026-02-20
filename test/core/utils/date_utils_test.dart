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
}
