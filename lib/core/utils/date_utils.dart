import 'package:intl/intl.dart';

/// 日期格式化工具 — 全局统一的日期字符串方法。
abstract final class AppDateUtils {
  static final _dayFormat = DateFormat('yyyy-MM-dd');
  static final _monthFormat = DateFormat('yyyy-MM');

  /// 今日日期字符串，格式 "yyyy-MM-dd"。
  static String todayString() => _dayFormat.format(DateTime.now());

  /// 当月字符串，格式 "yyyy-MM"。
  static String currentMonth() => _monthFormat.format(DateTime.now());
}
