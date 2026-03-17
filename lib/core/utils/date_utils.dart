import 'package:intl/intl.dart';

/// 日期格式化工具 — 全局统一的日期字符串方法。
abstract final class AppDateUtils {
  static final _dayFormat = DateFormat('yyyy-MM-dd');
  static final _monthFormat = DateFormat('yyyy-MM');

  /// 今日日期字符串，格式 "yyyy-MM-dd"。
  static String todayString() => _dayFormat.format(DateTime.now());

  /// 格式化任意 DateTime 为 "yyyy-MM-dd"。
  static String formatDay(DateTime date) => _dayFormat.format(date);

  /// 当月字符串，格式 "yyyy-MM"。
  static String currentMonth() => _monthFormat.format(DateTime.now());

  /// 计算 ISO 8601 周 ID（'YYYY-WNN'）。
  ///
  /// ISO 8601 算法：
  /// 1. 找到本周四 → 确定 ISO 年
  /// 2. 找到该 ISO 年第 1 周的周一（包含 1 月 4 日的那一周）
  /// 3. 周数 = (本周四 - 第 1 周周一) / 7 + 1
  static String isoWeekId(DateTime date) {
    final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));
    final isoYear = thursday.year;
    final jan4 = DateTime(isoYear, 1, 4);
    final week1Monday = jan4.subtract(Duration(days: jan4.weekday - 1));
    final weekNumber = (thursday.difference(week1Monday).inDays ~/ 7) + 1;
    return '$isoYear-W${weekNumber.toString().padLeft(2, '0')}';
  }

  /// 当前 ISO 周 ID。
  static String currentWeekId() => isoWeekId(DateTime.now());
}
