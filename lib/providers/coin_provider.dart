// ---
// 📘 文件说明：
// 金币系统 Provider — 余额监听 + 签到状态。
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
