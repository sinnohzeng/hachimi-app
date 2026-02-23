import 'package:uuid/uuid.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/performance_traces.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/services/ai_service.dart';
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

/// 日记服务 — prompt 构建 + AI 生成 + SQLite 存储。
class DiaryService {
  final AiService _aiService;
  final LocalDatabaseService _dbService;
  static const _uuid = Uuid();

  DiaryService({
    required AiService aiService,
    required LocalDatabaseService dbService,
  }) : _aiService = aiService,
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
  /// 当天已有日记则直接返回，AI 未配置则返回 null。
  Future<DiaryEntry?> generateTodayDiary(DiaryGenerationContext ctx) async {
    final existing = await _dbService.getTodayDiary(ctx.cat.id);
    if (existing != null) return existing;
    if (!_aiService.isConfigured) return null;

    try {
      return await _generateAndSave(ctx);
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'DiaryService',
        operation: 'generateTodayDiary',
      );
      return null;
    }
  }

  // ─── Private Helpers ───

  Future<DiaryEntry?> _generateAndSave(DiaryGenerationContext ctx) async {
    final messages = _buildMessages(ctx);
    final response = await AppTraces.trace(
      'diary_generate',
      () => _aiService.generate(messages, AiRequestConfig.diary),
    );
    if (response.content.isEmpty) return null;
    return _saveDiaryEntry(ctx, response.content);
  }

  Future<DiaryEntry?> _saveDiaryEntry(
    DiaryGenerationContext ctx,
    String content,
  ) async {
    final entry = DiaryEntry(
      id: _uuid.v4(),
      catId: ctx.cat.id,
      habitId: ctx.habit.id,
      content: _formatContent(content, ctx.isZhLocale),
      date: AppDateUtils.todayString(),
      personality: ctx.cat.personality,
      mood: ctx.cat.computedMood,
      stage: ctx.cat.displayStage,
      totalMinutes: ctx.cat.totalMinutes,
      createdAt: DateTime.now(),
    );
    final saved = await _dbService.insertDiaryEntry(entry);
    return saved ? entry : null;
  }

  List<AiMessage> _buildMessages(DiaryGenerationContext ctx) {
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
      stageId: cat.displayStage,
      progressPercent: (cat.growthProgress * 100).round(),
      habitName: habit.name,
      todayMinutes: ctx.todayMinutes,
      goalMinutes: habit.goalMinutes,
      totalCheckInDays: habit.totalCheckInDays,
      totalHours: cat.totalMinutes ~/ 60,
      totalMins: cat.totalMinutes % 60,
      targetHours: habit.targetHours,
      isZhLocale: ctx.isZhLocale,
    );
  }

  /// 格式化日记内容 — 确保以日记开头。
  String _formatContent(String raw, bool isZhLocale) {
    final prefix = isZhLocale ? '亲爱的日记，\n\n' : 'Dear diary,\n\n';
    final text = raw.startsWith(prefix) ? raw : '$prefix$raw';
    return text.trimRight();
  }
}
