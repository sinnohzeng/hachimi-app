import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_icon_size.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/chat_message.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/chat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_badge.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_button.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_chat_bubble.dart';
import 'package:hachimi_app/widgets/pixel_ui/retro_tiled_background.dart';

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
          duration: AppMotion.durationMedium2,
          curve: AppMotion.standardDecelerate,
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
      return AppScaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.chatCatNotFound)),
      );
    }

    return AppScaffold(
      pattern: PatternType.crosshatch,
      appBar: AppBar(
        title: Text(
          context.l10n.chatTitle(cat.name),
          style: context.pixel.pixelTitle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: PixelBadge(
              text: context.l10n.chatDailyRemaining(
                chatState.remainingMessages,
              ),
            ),
          ),
          if (chatState.messages.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  _confirmClearHistory(context);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'clear',
                  child: Text(context.l10n.chatClearHistory),
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
                : _buildMessageList(chatState),
          ),

          // 输入区域
          _buildInputBar(context, chatState, cat, habit),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String catName, // catName 仍用于传参给 l10n 方法
  ) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💬', style: TextStyle(fontSize: AppIconSize.emoji)),
            const SizedBox(height: AppSpacing.base),
            Text(
              context.l10n.chatEmptyTitle(catName),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.chatEmptySubtitle,
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

  Widget _buildMessageList(ChatState chatState) {
    final messages = chatState.messages;
    final isGenerating = chatState.status == ChatStatus.generating;
    final isError = chatState.status == ChatStatus.error;
    final partial = chatState.partialResponse;
    final extraItems = (isGenerating && partial.isNotEmpty ? 1 : 0) +
        (isError ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length + extraItems,
      itemBuilder: (context, index) {
        // 流式部分回复
        if (isGenerating && partial.isNotEmpty && index == messages.length) {
          return Padding(
            padding: AppSpacing.paddingVXs,
            child: PixelChatBubble(
              text: partial,
              isUser: false,
              isStreaming: true,
            ),
          );
        }

        // 错误提示气泡
        if (isError && index == messages.length) {
          return _buildErrorBubble(chatState);
        }

        final msg = messages[index];
        return Padding(
          padding: AppSpacing.paddingVXs,
          child: PixelChatBubble(
            text: msg.content,
            isUser: msg.role == ChatRole.user,
          ),
        );
      },
    );
  }

  Widget _buildErrorBubble(ChatState chatState) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: AppSpacing.paddingVXs,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 18,
              color: colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.chatErrorMessage,
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(chatNotifierProvider(widget.catId).notifier)
                    .retryLastMessage();
              },
              child: Text(context.l10n.chatRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    ChatState chatState,
    Cat cat,
    Habit? habit,
  ) {
    final pixel = context.pixel;
    final colorScheme = Theme.of(context).colorScheme;
    final isGenerating = chatState.status == ChatStatus.generating;
    final atLimit = chatState.remainingMessages <= 0;
    final canSend = habit != null && !isGenerating && !atLimit;

    return Container(
      color: pixel.retroSurface,
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
                    hintText: atLimit
                        ? context.l10n.chatDailyLimitReached
                        : isGenerating
                        ? context.l10n.chatGenerating
                        : context.l10n.chatTypeMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: pixel.pixelBorder,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: pixel.pixelBorder,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  enabled: !isGenerating && !atLimit,
                  onSubmitted: canSend ? (_) => _send(cat, habit) : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // 发送/停止按钮
              if (isGenerating)
                PixelButton(
                  label: context.l10n.chatStop,
                  icon: Icons.stop,
                  backgroundColor: colorScheme.errorContainer,
                  foregroundColor: colorScheme.onErrorContainer,
                  onPressed: () {
                    ref
                        .read(chatNotifierProvider(widget.catId).notifier)
                        .stopGeneration();
                  },
                )
              else
                PixelButton(
                  label: context.l10n.chatSend,
                  icon: Icons.send,
                  onPressed: canSend ? () => _send(cat, habit) : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _send(Cat cat, Habit habit) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    // 获取当前 locale
    final locale = Localizations.localeOf(context);
    final isZh = locale.languageCode == 'zh';

    ref
        .read(chatNotifierProvider(widget.catId).notifier)
        .sendMessage(text: text, cat: cat, habit: habit, isZhLocale: isZh);

    // Analytics: log AI chat started
    ref.read(analyticsServiceProvider).logAiChatStarted(catId: widget.catId);
  }

  void _confirmClearHistory(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chatClearConfirmTitle),
        content: Text(l10n.chatClearConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(chatNotifierProvider(widget.catId).notifier)
                  .clearHistory();
            },
            child: Text(l10n.chatClearButton),
          ),
        ],
      ),
    );
  }
}
