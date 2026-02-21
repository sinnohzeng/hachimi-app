import 'package:uuid/uuid.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/core/utils/performance_traces.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/services/llm_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';

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

/// 日记服务 — prompt 构建 + LLM 生成 + SQLite 存储。
class DiaryService {
  final LlmService _llmService;
  final LocalDatabaseService _dbService;
  static const _uuid = Uuid();

  DiaryService({
    required LlmService llmService,
    required LocalDatabaseService dbService,
  }) : _llmService = llmService,
       _dbService = dbService;

  /// 获取指定猫猫的所有日记条目。
  Future<List<DiaryEntry>> getDiaryEntries(String catId) {
    return _dbService.getDiaryEntries(catId);
  }

  /// 获取指定猫猫当天的日记。
  Future<DiaryEntry?> getTodayDiary(String catId) {
    return _dbService.getTodayDiary(catId);
  }

  /// 生成今日日记。
  /// 如果当天已有日记，直接返回已存在的条目。
  /// 如果 LLM 引擎未就绪，返回 null。
  Future<DiaryEntry?> generateTodayDiary(DiaryGenerationContext ctx) async {
    // 检查是否已有当天日记
    final existing = await _dbService.getTodayDiary(ctx.cat.id);
    if (existing != null) return existing;

    // 检查 LLM 引擎状态
    if (!_llmService.isReady) return null;

    // 构建 prompt
    final prompt = _buildPrompt(ctx);

    try {
      // 生成日记文本
      final content = await AppTraces.trace('diary_generate', () => _llmService.generate(prompt));
      if (content.isEmpty) return null;

      // 构建日记条目
      final now = DateTime.now();
      final entry = DiaryEntry(
        id: _uuid.v4(),
        catId: ctx.cat.id,
        habitId: ctx.habit.id,
        content: _formatDiaryContent(content, ctx.isZhLocale),
        date: AppDateUtils.todayString(),
        personality: ctx.cat.personality,
        mood: ctx.cat.computedMood,
        stage: ctx.cat.computedStage,
        totalMinutes: ctx.cat.totalMinutes,
        createdAt: now,
      );

      // 保存到 SQLite
      final saved = await _dbService.insertDiaryEntry(entry);
      return saved ? entry : null;
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'DiaryService', operation: 'generateTodayDiary');
      return null;
    }
  }

  String _buildPrompt(DiaryGenerationContext ctx) {
    final cat = ctx.cat;
    final habit = ctx.habit;
    final personality = cat.personalityData;
    final moodData = cat.moodData;

    final hoursSince = cat.lastSessionAt != null
        ? DateTime.now().difference(cat.lastSessionAt!).inHours
        : 999;

    return DiaryPrompt.build(
      catName: cat.name,
      personalityId: personality?.id ?? 'playful',
      moodId: moodData.id,
      hoursSinceLastSession: hoursSince,
      stageId: cat.computedStage,
      progressPercent: (cat.growthProgress * 100).round(),
      habitName: habit.name,
      todayMinutes: ctx.todayMinutes,
      goalMinutes: habit.goalMinutes,
      currentStreak: habit.currentStreak,
      totalHours: cat.totalMinutes ~/ 60,
      totalMins: cat.totalMinutes % 60,
      targetHours: habit.targetHours,
      isZhLocale: ctx.isZhLocale,
    );
  }

  /// 格式化日记内容 — 添加日记开头并清理多余换行。
  String _formatDiaryContent(String raw, bool isZhLocale) {
    final prefix = isZhLocale ? '亲爱的日记，\n\n' : 'Dear diary,\n\n';
    // 如果 LLM 生成的文本已经包含前缀，不重复添加
    final text = raw.startsWith(prefix) ? raw : '$prefix$raw';
    // 清理尾部空白和多余换行
    return text.trimRight();
  }
}
