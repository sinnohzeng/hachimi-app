import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/providers/ai_provider.dart';

/// 指定猫猫的所有日记条目（按日期倒序）。
final diaryEntriesProvider = FutureProvider.family<List<DiaryEntry>, String>((
  ref,
  catId,
) async {
  final diaryService = ref.watch(diaryServiceProvider);
  return diaryService.getDiaryEntries(catId);
});

/// 指定猫猫当天的日记。
final todayDiaryProvider = FutureProvider.family<DiaryEntry?, String>((
  ref,
  catId,
) async {
  final diaryService = ref.watch(diaryServiceProvider);
  return diaryService.getTodayDiary(catId);
});
