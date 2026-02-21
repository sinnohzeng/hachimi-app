import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 实时金币余额。
final coinBalanceProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(0);
  return ref.watch(coinServiceProvider).watchBalance(uid);
});

/// 今日是否已签到。
final hasCheckedInTodayProvider = FutureProvider<bool>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return false;
  return ref.watch(coinServiceProvider).hasCheckedInToday(uid);
});

/// 当月签到进度（实时流）。
final monthlyCheckInProvider = StreamProvider<MonthlyCheckIn?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(coinServiceProvider).watchMonthlyCheckIn(uid);
});
