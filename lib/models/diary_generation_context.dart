import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';

/// 日记生成参数。
class DiaryGenerationContext {
  final Cat cat;
  final Habit habit;
  final int todayMinutes;
  final bool isZhLocale;

  const DiaryGenerationContext({
    required this.cat,
    required this.habit,
    required this.todayMinutes,
    required this.isZhLocale,
  });
}
