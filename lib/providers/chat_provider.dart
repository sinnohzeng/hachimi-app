import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/chat_message.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/llm_provider.dart';
import 'package:hachimi_app/services/chat_service.dart';

/// 聊天状态。
enum ChatStatus {
  idle,
  loading, // 加载历史消息
  generating, // LLM 正在生成回复
  error,
}

/// 聊天状态数据。
class ChatState {
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String partialResponse; // 流式生成中的部分回复
  final String? error;

  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.idle,
    this.partialResponse = '',
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? partialResponse,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      partialResponse: partialResponse ?? this.partialResponse,
      error: error,
    );
  }
}

/// 聊天状态管理器。
class ChatNotifier extends Notifier<ChatState> {
  final String _catId;
  late final ChatService _chatService;
  StreamSubscription<String>? _tokenSub;

  ChatNotifier(this._catId);

  @override
  ChatState build() {
    _chatService = ref.watch(chatServiceProvider);

    ref.onDispose(() {
      _tokenSub?.cancel();
    });

    _loadHistory();
    return const ChatState(status: ChatStatus.loading);
  }

  Future<void> _loadHistory() async {
    try {
      final messages = await _chatService.getRecentMessages(_catId);
      state = state.copyWith(messages: messages, status: ChatStatus.idle);
    } catch (e) {
      state = state.copyWith(status: ChatStatus.error, error: e.toString());
    }
  }

  /// 发送用户消息。
  Future<void> sendMessage({
    required String text,
    required Cat cat,
    required Habit habit,
    required bool isZhLocale,
  }) async {
    if (state.status == ChatStatus.generating) return;
    if (text.trim().isEmpty) return;

    // 乐观更新：先把用户消息加到列表
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      catId: _catId,
      role: ChatRole.user,
      content: text.trim(),
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      status: ChatStatus.generating,
      partialResponse: '',
    );

    // 监听 token 流
    _tokenSub?.cancel();
    _tokenSub = _chatService.tokenStream.listen(
      (token) {
        state = state.copyWith(partialResponse: state.partialResponse + token);
      },
      onError: (e) {
        state = state.copyWith(status: ChatStatus.error, error: e.toString());
      },
    );

    try {
      final chatCtx = ChatContext(
        cat: cat,
        habit: habit,
        isZhLocale: isZhLocale,
      );

      await _chatService.sendMessage(
        userMessage: text.trim(),
        chatCtx: chatCtx,
      );

      // 生成完毕，从数据库重新加载消息（确保与 SQLite 一致）
      final messages = await _chatService.getRecentMessages(_catId);
      state = state.copyWith(
        messages: messages,
        status: ChatStatus.idle,
        partialResponse: '',
      );
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        partialResponse: '',
        error: e.toString(),
      );
    } finally {
      _tokenSub?.cancel();
      _tokenSub = null;
    }
  }

  /// 停止当前生成。
  Future<void> stopGeneration() async {
    await _chatService.stopGeneration();
    _tokenSub?.cancel();
    _tokenSub = null;

    // 重新加载消息
    final messages = await _chatService.getRecentMessages(_catId);
    state = state.copyWith(
      messages: messages,
      status: ChatStatus.idle,
      partialResponse: '',
    );
  }

  /// 清除聊天历史。
  Future<void> clearHistory() async {
    await _chatService.clearHistory(_catId);
    state = const ChatState(status: ChatStatus.idle);
  }
}

/// 聊天状态 Provider — 按 catId 分家族。
final chatNotifierProvider =
    NotifierProvider.family<ChatNotifier, ChatState, String>(ChatNotifier.new);
