// ---
// 📘 文件说明：
// 日记 Provider — 管理猫猫日记的读取和生成触发。
//
// 📋 Provider Graph:
// - diaryEntriesProvider(catId)：指定猫猫的全部日记列表
// - todayDiaryProvider(catId)：指定猫猫当天的日记
// - diaryGenerationTrigger：手动触发日记生成
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/providers/llm_provider.dart';

/// 指定猫猫的所有日记条目（按日期倒序）。
final diaryEntriesProvider =
    FutureProvider.family<List<DiaryEntry>, String>((ref, catId) async {
  final diaryService = ref.watch(diaryServiceProvider);
  return diaryService.getDiaryEntries(catId);
});

/// 指定猫猫当天的日记。
final todayDiaryProvider =
    FutureProvider.family<DiaryEntry?, String>((ref, catId) async {
  final diaryService = ref.watch(diaryServiceProvider);
  return diaryService.getTodayDiary(catId);
});
