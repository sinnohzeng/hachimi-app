import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/chat_message.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/services/ai_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';

/// 聊天上下文参数。
class ChatContext {
  final Cat cat;
  final Habit habit;
  final bool isZhLocale;

  const ChatContext({
    required this.cat,
    required this.habit,
    required this.isZhLocale,
  });
}

/// 聊天服务 — prompt 构建 + 流式生成 + 历史管理。
class ChatService {
  final AiService _aiService;
  final LocalDatabaseService _dbService;
  static const _uuid = Uuid();

  /// 滑动窗口：保留最近 10 轮对话（20 条消息）在 prompt 中。
  static const int maxHistoryMessages = 20;

  /// 获取最近消息时的数据库拉取上限。
  static const int recentMessagesFetchLimit = 50;

  /// 内部 token 转发控制器（broadcast 支持多个监听者）。
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  ChatService({
    required AiService aiService,
    required LocalDatabaseService dbService,
  }) : _aiService = aiService,
       _dbService = dbService;

  /// 释放资源。
  void dispose() {
    _tokenController.close();
  }

  /// 获取最近的聊天消息。
  Future<List<ChatMessage>> getRecentMessages(String catId) {
    return _dbService.getRecentMessages(catId, limit: recentMessagesFetchLimit);
  }

  /// 获取聊天消息数量。
  Future<int> getMessageCount(String catId) {
    return _dbService.getChatMessageCount(catId);
  }

  /// 清除聊天历史。
  Future<void> clearHistory(String catId) {
    return _dbService.clearChatHistory(catId);
  }

  /// Token 流（流式输出，broadcast 以支持多个监听者）。
  Stream<String> get tokenStream => _tokenController.stream;

  /// 发送用户消息并获取猫猫回复。
  Future<String> sendMessage({
    required String userMessage,
    required ChatContext chatCtx,
  }) async {
    // 1. 保存用户消息到 SQLite
    await _saveMessage(chatCtx.cat.id, ChatRole.user, userMessage);

    // 2. 加载最近历史 + 构建消息列表
    final history = await _dbService.getRecentMessages(
      chatCtx.cat.id,
      limit: maxHistoryMessages,
    );
    final messages = _buildMessages(chatCtx: chatCtx, history: history);

    // 3. 流式生成回复
    try {
      final response = await _streamGenerate(messages);
      final cleaned = response.isEmpty
          ? _fallbackResponse(chatCtx.isZhLocale)
          : response;
      await _saveMessage(chatCtx.cat.id, ChatRole.assistant, cleaned);
      return cleaned;
    } catch (e) {
      final fallback = _fallbackResponse(chatCtx.isZhLocale);
      await _saveMessage(chatCtx.cat.id, ChatRole.assistant, fallback);
      return fallback;
    }
  }

  /// 停止当前生成。
  Future<void> stopGeneration() => _aiService.cancel();

  // ─── Private Helpers ───

  Future<String> _streamGenerate(List<AiMessage> messages) async {
    final buffer = StringBuffer();
    final stream = _aiService.generateStream(messages, AiRequestConfig.chat);
    await for (final token in stream) {
      buffer.write(token);
      _tokenController.add(token);
    }
    return buffer.toString();
  }

  Future<void> _saveMessage(String catId, ChatRole role, String content) async {
    final msg = ChatMessage(
      id: _uuid.v4(),
      catId: catId,
      role: role,
      content: content,
      createdAt: DateTime.now(),
    );
    await _dbService.insertChatMessage(msg);
  }

  List<AiMessage> _buildMessages({
    required ChatContext chatCtx,
    required List<ChatMessage> history,
  }) {
    final cat = chatCtx.cat;
    final habit = chatCtx.habit;
    final personality = cat.personalityData;
    final moodData = cat.moodData;

    final systemMsg = ChatPrompt.buildSystem(
      catName: cat.name,
      personalityId: personality?.id ?? 'playful',
      moodId: moodData.id,
      stageId: cat.displayStage,
      habitName: habit.name,
      isZhLocale: chatCtx.isZhLocale,
    );

    return [systemMsg, ...history.map(_toAiMessage)];
  }

  AiMessage _toAiMessage(ChatMessage msg) {
    final role = msg.role == ChatRole.user ? AiRole.user : AiRole.assistant;
    return AiMessage(role: role, content: msg.content);
  }

  String _fallbackResponse(bool isZhLocale) {
    return isZhLocale
        ? '喵~（揉揉眼睛）抱歉，我刚刚走神了...'
        : 'Meow~ *rubs eyes* Sorry, I spaced out for a moment...';
  }
}
