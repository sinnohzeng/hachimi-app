import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/lumi_constants.dart';

/// 每日灵感提示 — 基于日期轮转从灵感库中选取。
///
/// 使用当前日期的 dayOfYear 取模，确保同一天看到相同提示，
/// 第二天自动切换到下一条。
final dailyInspirationProvider = Provider<String>((ref) {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  const prompts = LumiConstants.dailyLightPrompts;
  return prompts[dayOfYear % prompts.length];
});
