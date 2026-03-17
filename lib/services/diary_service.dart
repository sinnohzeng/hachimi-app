import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/performance_traces.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/models/diary_generation_context.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/services/ai_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';

// Re-export so existing `import diary_service.dart` still compiles.
export 'package:hachimi_app/models/diary_generation_context.dart';

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
  /// 失败时保存重试条目到 SharedPreferences 队列。
  Future<DiaryEntry?> generateTodayDiary(DiaryGenerationContext ctx) async {
    debugPrint('[DiaryService] generateTodayDiary start (catId=${ctx.cat.id})');
    final existing = await _dbService.getTodayDiary(ctx.cat.id);
    if (existing != null) {
      debugPrint('[DiaryService] cache hit — today diary exists');
      return existing;
    }
    if (!_aiService.isConfigured) return null;

    try {
      final result = await _generateAndSave(ctx);
      debugPrint(
        '[DiaryService] success (length=${result?.content.length ?? 0})',
      );
      return result;
    } catch (e, stack) {
      debugPrint('[DiaryService] failed — saving retry (error=$e)');
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'DiaryService',
        operation: 'generateTodayDiary',
      );
      await savePendingRetry(ctx);
      return null;
    }
  }

  // ─── Retry Queue ───

  static const _maxRetryAttempts = 3;

  /// 保存待重试条目。
  Future<void> savePendingRetry(DiaryGenerationContext ctx) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries);
    final list = raw != null
        ? (jsonDecode(raw) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    // 移除同一 catId 已有的条目（覆盖）
    list.removeWhere((e) => e['catId'] == ctx.cat.id);
    list.add({
      'catId': ctx.cat.id,
      'habitId': ctx.habit.id,
      'todayMinutes': ctx.todayMinutes,
      'isZhLocale': ctx.isZhLocale,
      'date': AppDateUtils.todayString(),
      'attempts': 0,
    });
    await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));
  }

  /// 处理待重试队列中指定 catId 的条目。
  /// 由 CatDetailScreen 打开时调用。
  Future<DiaryEntry?> processPendingRetries(
    String catId,
    Cat cat,
    Habit habit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries);
    if (raw == null) return null;

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final idx = list.indexWhere((e) => e['catId'] == catId);
    if (idx == -1) return null;

    final entry = list[idx];
    final today = AppDateUtils.todayString();

    // 过期（非今天）或超过最大重试次数 → 移除
    if (entry['date'] != today ||
        (entry['attempts'] as int) >= _maxRetryAttempts) {
      list.removeAt(idx);
      await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));
      return null;
    }

    // 今天的日记已存在 → 移除重试条目
    final existing = await _dbService.getTodayDiary(catId);
    if (existing != null) {
      list.removeAt(idx);
      await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));
      return existing;
    }

    // 尝试重试
    entry['attempts'] = (entry['attempts'] as int) + 1;
    list[idx] = entry;
    await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));

    debugPrint(
      '[DiaryService] retry attempt=${entry['attempts']} '
      '(catId=$catId)',
    );

    final ctx = DiaryGenerationContext(
      cat: cat,
      habit: habit,
      todayMinutes: entry['todayMinutes'] as int,
      isZhLocale: entry['isZhLocale'] as bool,
    );

    try {
      final result = await _generateAndSave(ctx);
      if (result != null) await clearPendingRetry(catId);
      return result;
    } catch (e) {
      debugPrint('[DiaryService] retry failed (error=$e)');
      return null;
    }
  }

  /// 清除指定 catId 的待重试条目。
  Future<void> clearPendingRetry(String catId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries);
    if (raw == null) return;

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    list.removeWhere((e) => e['catId'] == catId);
    await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));
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
