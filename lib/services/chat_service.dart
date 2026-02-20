// ---
// 📘 文件说明：
// 猫猫聊天服务 — 负责聊天 prompt 构建、历史管理、LLM 流式生成、SQLite 读写。
// 上下文窗口管理：最近 10 轮对话 + system prompt。
//
// 📋 程序整体伪代码（中文）：
// 1. 加载最近 10 轮聊天历史；
// 2. 构建完整 prompt（system + history + user message）；
// 3. 调用 LlmService 流式生成回复；
// 4. 保存用户消息和助手回复到 SQLite；
//
// 🕒 创建时间：2026-02-19
// ---

import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/chat_message.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/services/llm_service.dart';
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
  final LlmService _llmService;
  final LocalDatabaseService _dbService;
  static const _uuid = Uuid();

  /// 滑动窗口：保留最近 10 轮对话（20 条消息）在 prompt 中。
  static const int maxHistoryMessages = 20;

  /// 内部 token 转发控制器（broadcast 支持多个监听者）。
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  ChatService({
    required LlmService llmService,
    required LocalDatabaseService dbService,
  })  : _llmService = llmService,
        _dbService = dbService;

  /// 释放资源。
  void dispose() {
    _tokenController.close();
  }

  /// 获取最近的聊天消息。
  Future<List<ChatMessage>> getRecentMessages(String catId) {
    return _dbService.getRecentMessages(catId, limit: 50);
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
  /// 返回完整的助手回复文本。
  /// 同时通过 tokenStream 流式输出 token。
  Future<String> sendMessage({
    required String userMessage,
    required ChatContext chatCtx,
  }) async {
    if (!_llmService.isReady) {
      throw StateError('LLM engine not ready');
    }

    // 1. 保存用户消息到 SQLite
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      catId: chatCtx.cat.id,
      role: ChatRole.user,
      content: userMessage,
      createdAt: DateTime.now(),
    );
    await _dbService.insertChatMessage(userMsg);

    // 2. 加载最近历史（用于 prompt 上下文）
    final history = await _dbService.getRecentMessages(
      chatCtx.cat.id,
      limit: maxHistoryMessages,
    );

    // 3. 构建完整 prompt
    final prompt = _buildPrompt(
      chatCtx: chatCtx,
      history: history,
    );

    // 4. 流式生成回复 — 收集 token 并转发到 tokenController
    try {
      final buffer = StringBuffer();
      final stream = _llmService.generateStream(prompt);

      await for (final token in stream) {
        buffer.write(token);
        _tokenController.add(token);
      }

      final response = _llmService.cleanResponse(buffer.toString());
      final cleanedResponse =
          response.isEmpty ? _fallbackResponse(chatCtx.isZhLocale) : response;

      // 5. 保存助手回复到 SQLite
      await _saveAssistantMessage(chatCtx.cat.id, cleanedResponse);
      return cleanedResponse;
    } catch (e) {
      // 生成失败时返回 fallback 并保存
      final fallback = _fallbackResponse(chatCtx.isZhLocale);
      await _saveAssistantMessage(chatCtx.cat.id, fallback);
      return fallback;
    }
  }

  /// 保存助手回复消息到 SQLite。
  Future<void> _saveAssistantMessage(String catId, String content) async {
    final msg = ChatMessage(
      id: _uuid.v4(),
      catId: catId,
      role: ChatRole.assistant,
      content: content,
      createdAt: DateTime.now(),
    );
    await _dbService.insertChatMessage(msg);
  }

  /// 停止当前生成。
  Future<void> stopGeneration() => _llmService.stopGeneration();

  String _buildPrompt({
    required ChatContext chatCtx,
    required List<ChatMessage> history,
  }) {
    final cat = chatCtx.cat;
    final habit = chatCtx.habit;
    final personality = cat.personalityData;
    final moodData = cat.moodData;

    // System prompt
    final systemPrompt = ChatPrompt.buildSystem(
      catName: cat.name,
      personalityId: personality?.id ?? 'playful',
      moodId: moodData.id,
      stageId: cat.computedStage,
      habitName: habit.name,
      isZhLocale: chatCtx.isZhLocale,
    );

    // 拼接历史消息
    final buffer = StringBuffer(systemPrompt);
    for (final msg in history) {
      switch (msg.role) {
        case ChatRole.user:
          buffer.write(ChatPrompt.formatUserMessage(msg.content));
        case ChatRole.assistant:
          buffer.write(ChatPrompt.formatAssistantMessage(msg.content));
      }
    }

    // 添加助手回复的起始标记
    buffer.write(ChatPrompt.assistantPrefix);

    return buffer.toString();
  }

  String _fallbackResponse(bool isZhLocale) {
    return isZhLocale ? '喵~（揉揉眼睛）抱歉，我刚刚走神了...' : 'Meow~ *rubs eyes* Sorry, I spaced out for a moment...';
  }
}
