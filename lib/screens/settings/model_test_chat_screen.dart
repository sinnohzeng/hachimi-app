import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/ai_provider.dart';

/// 内存消息模型 — 不持久化。
class _TestMessage {
  final String content;
  final bool isUser;

  const _TestMessage({required this.content, required this.isUser});
}

/// 测试聊天状态。
enum _TestChatStatus { validating, ready, generating, error }

/// AI 测试聊天页面 — 验证云端连接后可直接对话。
class ModelTestChatScreen extends ConsumerStatefulWidget {
  const ModelTestChatScreen({super.key});

  @override
  ConsumerState<ModelTestChatScreen> createState() =>
      _ModelTestChatScreenState();
}

class _ModelTestChatScreenState extends ConsumerState<ModelTestChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  final List<_TestMessage> _messages = [];
  String _partialResponse = '';
  _TestChatStatus _status = _TestChatStatus.validating;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _validateConnection();
  }

  Future<void> _validateConnection() async {
    setState(() => _status = _TestChatStatus.validating);
    final ok = await ref
        .read(aiAvailabilityProvider.notifier)
        .validateConnection();
    if (!mounted) return;
    setState(() {
      _status = ok ? _TestChatStatus.ready : _TestChatStatus.error;
      _errorMessage = ok ? null : context.l10n.settingsConnectionFailed;
    });
  }

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

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _status != _TestChatStatus.ready) return;

    _textController.clear();
    setState(() {
      _messages.add(_TestMessage(content: text, isUser: true));
      _partialResponse = '';
      _status = _TestChatStatus.generating;
    });
    _scrollToBottom();

    final aiService = ref.read(aiServiceProvider);
    final messages = TestPrompt.build(text);

    try {
      final stream = aiService.generateStream(messages, AiRequestConfig.chat);
      await for (final token in stream) {
        if (!mounted) return;
        setState(() => _partialResponse += token);
        _scrollToBottom();
      }
    } catch (_) {
      // 错误时保留已有的部分回复
    }

    _finishResponse();
  }

  void _finishResponse() {
    if (!mounted) return;
    final text = _partialResponse.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(_TestMessage(content: text, isUser: false));
      });
    }
    setState(() {
      _partialResponse = '';
      _status = _TestChatStatus.ready;
    });
    _scrollToBottom();
  }

  Future<void> _stopGeneration() async {
    final aiService = ref.read(aiServiceProvider);
    await aiService.cancel();
    _finishResponse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.testChatTitle)),
      body: Column(
        children: [
          _buildStatusBanner(colorScheme, textTheme),
          Expanded(child: _buildBody(colorScheme, textTheme)),
          if (_status != _TestChatStatus.validating &&
              _status != _TestChatStatus.error)
            _buildInputBar(colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(ColorScheme colorScheme, TextTheme textTheme) {
    final l10n = context.l10n;
    final IconData icon;
    final String text;
    final Color bgColor;
    final Color fgColor;

    switch (_status) {
      case _TestChatStatus.validating:
        icon = Icons.hourglass_top;
        text = l10n.settingsTestConnection;
        bgColor = colorScheme.secondaryContainer;
        fgColor = colorScheme.onSecondaryContainer;
      case _TestChatStatus.ready:
      case _TestChatStatus.generating:
        final brightness = Theme.of(context).brightness;
        icon = Icons.check_circle;
        text = l10n.settingsConnectionSuccess;
        bgColor = StatusColors.successContainer(brightness);
        fgColor = StatusColors.onSuccess(brightness);
      case _TestChatStatus.error:
        icon = Icons.error;
        text = _errorMessage ?? l10n.settingsConnectionFailed;
        bgColor = colorScheme.errorContainer;
        fgColor = colorScheme.onErrorContainer;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bgColor,
      child: Row(
        children: [
          Icon(icon, size: 18, color: fgColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(color: fgColor),
            ),
          ),
          if (_status == _TestChatStatus.validating)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: fgColor),
            ),
          if (_status == _TestChatStatus.error)
            TextButton(
              onPressed: _validateConnection,
              child: Text(l10n.commonRetry),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    if (_status == _TestChatStatus.validating) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_status == _TestChatStatus.error) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 48, color: colorScheme.error),
              const SizedBox(height: AppSpacing.base),
              Text(
                context.l10n.settingsConnectionFailed,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.aiRequiresNetwork,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.base),
              FilledButton.tonalIcon(
                onPressed: _validateConnection,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (_messages.isEmpty && _status != _TestChatStatus.generating) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.smart_toy_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                context.l10n.testChatModelReady,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.testChatSendToTest,
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

    final showPartial =
        _status == _TestChatStatus.generating && _partialResponse.isNotEmpty;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (showPartial ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildBubble(
            content: '$_partialResponse\u258A',
            isUser: false,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        }
        final msg = _messages[index];
        return _buildBubble(
          content: msg.content,
          isUser: msg.isUser,
          colorScheme: colorScheme,
          textTheme: textTheme,
        );
      },
    );
  }

  Widget _buildBubble({
    required String content,
    required bool isUser,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: AppSpacing.paddingVXs,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primaryContainer
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
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(ColorScheme colorScheme, TextTheme textTheme) {
    final isGenerating = _status == _TestChatStatus.generating;
    final canSend = _status == _TestChatStatus.ready;

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
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: isGenerating
                        ? context.l10n.testChatGenerating
                        : context.l10n.testChatTypeMessage,
                    border: OutlineInputBorder(
                      borderRadius: AppShape.borderExtraLarge,
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
                  onSubmitted: canSend ? (_) => _sendMessage() : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (isGenerating)
                IconButton(
                  onPressed: _stopGeneration,
                  icon: const Icon(Icons.stop),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                )
              else
                IconButton(
                  onPressed: canSend ? _sendMessage : null,
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
}
