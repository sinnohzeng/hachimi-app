// ---
// 📘 文件说明：
// 猫猫聊天页 — 与猫猫进行简单文字对话。
// 支持 token-by-token 流式显示，猫猫回复基于性格特征。
//
// 🧩 文件结构：
// - CatChatScreen：主页面 ConsumerStatefulWidget；
// - _MessageBubble：消息气泡组件；
// - _TypingIndicator：打字指示器；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/chat_message.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/chat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';

/// 猫猫聊天页。
class CatChatScreen extends ConsumerStatefulWidget {
  final String catId;

  const CatChatScreen({super.key, required this.catId});

  @override
  ConsumerState<CatChatScreen> createState() => _CatChatScreenState();
}

class _CatChatScreenState extends ConsumerState<CatChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final cat = ref.watch(catByIdProvider(widget.catId));
    final chatState = ref.watch(chatNotifierProvider(widget.catId));
    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = cat != null
        ? habits.where((h) => h.id == cat.boundHabitId).firstOrNull
        : null;

    // 自动滚动到底部
    ref.listen(chatNotifierProvider(widget.catId), (prev, next) {
      if (prev?.messages.length != next.messages.length ||
          prev?.partialResponse != next.partialResponse) {
        _scrollToBottom();
      }
    });

    if (cat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Cat not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${cat.name}'),
        actions: [
          if (chatState.messages.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  _confirmClearHistory(context);
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('Clear history'),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: chatState.status == ChatStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : chatState.messages.isEmpty &&
                        chatState.status != ChatStatus.generating
                    ? _buildEmptyState(textTheme, colorScheme, cat.name)
                    : _buildMessageList(chatState, colorScheme, textTheme),
          ),

          // 输入区域
          _buildInputBar(
            context,
            chatState,
            colorScheme,
            textTheme,
            cat,
            habit,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String catName,
  ) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💬', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Say hi to $catName!',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start a conversation with your cat. They will reply based on their personality!',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(
    ChatState chatState,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final messages = chatState.messages;
    final isGenerating = chatState.status == ChatStatus.generating;
    final partial = chatState.partialResponse;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length + (isGenerating && partial.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        // 流式部分回复
        if (index == messages.length) {
          return _MessageBubble(
            content: partial,
            isUser: false,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        }

        final msg = messages[index];
        return _MessageBubble(
          content: msg.content,
          isUser: msg.role == ChatRole.user,
          colorScheme: colorScheme,
          textTheme: textTheme,
        );
      },
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    ChatState chatState,
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic cat,
    dynamic habit,
  ) {
    final isGenerating = chatState.status == ChatStatus.generating;
    final canSend = habit != null && !isGenerating;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // 输入框
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: isGenerating
                        ? 'Generating...'
                        : 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  enabled: !isGenerating,
                  onSubmitted: canSend ? (_) => _send(cat, habit) : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // 发送/停止按钮
              if (isGenerating)
                IconButton(
                  onPressed: () {
                    ref
                        .read(chatNotifierProvider(widget.catId).notifier)
                        .stopGeneration();
                  },
                  icon: const Icon(Icons.stop),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                )
              else
                IconButton(
                  onPressed: canSend ? () => _send(cat, habit) : null,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    disabledBackgroundColor:
                        colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _send(dynamic cat, dynamic habit) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    // 获取当前 locale
    final locale = Localizations.localeOf(context);
    final isZh = locale.languageCode == 'zh';

    ref.read(chatNotifierProvider(widget.catId).notifier).sendMessage(
          text: text,
          cat: cat,
          habit: habit,
          isZhLocale: isZh,
        );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear chat history?'),
        content: const Text('This will delete all messages. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(chatNotifierProvider(widget.catId).notifier)
                  .clearHistory();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

/// 消息气泡组件。
class _MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _MessageBubble({
    required this.content,
    required this.isUser,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: AppSpacing.paddingVXs,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          content,
          style: textTheme.bodyMedium?.copyWith(
            color: isUser
                ? colorScheme.onPrimary
                : colorScheme.onSurface,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
