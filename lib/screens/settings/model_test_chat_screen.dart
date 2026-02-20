// ---
// 📘 文件说明：
// 模型测试聊天页 — 下载模型后快速验证 LLM 是否正常工作。
// 无猫猫角色、不持久化消息、纯验证用途。
//
// 📋 程序整体伪代码（中文）：
// 1. initState 检查模型可用性，必要时触发加载；
// 2. 用户发送消息 → TestPrompt 构建 prompt → LlmService.generateStream() 流式生成；
// 3. 流式 token 实时更新到 AI 气泡中，支持 Stop 中断；
// 4. dispose 时不卸载模型（保留给后续 Cat Chat 使用）；
//
// 🧩 文件结构：
// - ModelTestChatScreen：主页面 ConsumerStatefulWidget；
// - _TestMessage：内存消息模型；
//
// 🕒 创建时间：2026-02-19
// ---

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/llm_provider.dart';

/// 内存消息模型 — 不持久化。
class _TestMessage {
  final String content;
  final bool isUser;

  const _TestMessage({required this.content, required this.isUser});
}

/// 模型测试聊天状态。
enum _TestChatStatus { loading, ready, generating, error }

/// 模型测试聊天页面。
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
  _TestChatStatus _status = _TestChatStatus.loading;
  String? _errorMessage;
  StreamSubscription<String>? _streamSub;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    final availability = ref.read(llmAvailabilityProvider);
    if (availability == LlmAvailability.ready) {
      final llm = ref.read(llmServiceInstanceProvider);
      if (llm.isReady) {
        setState(() => _status = _TestChatStatus.ready);
        return;
      }
    }

    // 尝试加载模型
    setState(() => _status = _TestChatStatus.loading);
    try {
      await ref.read(llmAvailabilityProvider.notifier).loadModel();
      final newAvailability = ref.read(llmAvailabilityProvider);
      if (newAvailability == LlmAvailability.ready) {
        setState(() => _status = _TestChatStatus.ready);
      } else {
        setState(() {
          _status = _TestChatStatus.error;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _status = _TestChatStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _streamSub?.cancel();
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

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _status != _TestChatStatus.ready) return;

    // 取消旧 stream，防止快速连续发送导致泄漏
    await _streamSub?.cancel();
    _streamSub = null;

    _textController.clear();
    setState(() {
      _messages.add(_TestMessage(content: text, isUser: true));
      _partialResponse = '';
      _status = _TestChatStatus.generating;
    });
    _scrollToBottom();

    final llm = ref.read(llmServiceInstanceProvider);
    final prompt = TestPrompt.buildPrompt(text);

    try {
      final stream = llm.generateStream(prompt);
      _streamSub = stream.listen(
        (token) {
          if (!mounted) return;
          setState(() {
            _partialResponse += token;
          });
          _scrollToBottom();
        },
        onError: (e) {
          if (!mounted) return;
          _finishResponse();
        },
        onDone: () {
          if (!mounted) return;
          _finishResponse();
        },
      );
    } catch (e) {
      _finishResponse();
    }
  }

  void _finishResponse() {
    final cleaned = _cleanResponse(_partialResponse);
    if (cleaned.isNotEmpty) {
      setState(() {
        _messages.add(_TestMessage(content: cleaned, isUser: false));
      });
    }
    setState(() {
      _partialResponse = '';
      _status = _TestChatStatus.ready;
    });
    _streamSub = null;
    _scrollToBottom();
  }

  Future<void> _stopGeneration() async {
    await _streamSub?.cancel();
    _streamSub = null;
    final llm = ref.read(llmServiceInstanceProvider);
    await llm.stopGeneration();
    _finishResponse();
  }

  String _cleanResponse(String text) {
    return text
        .replaceAll('<|im_end|>', '')
        .replaceAll('<|im_start|>', '')
        .replaceAll('<|endoftext|>', '')
        .trim();
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
          // 状态 Banner
          _buildStatusBanner(colorScheme, textTheme),

          // 消息列表
          Expanded(child: _buildBody(colorScheme, textTheme)),

          // 输入栏
          if (_status != _TestChatStatus.loading &&
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
      case _TestChatStatus.loading:
        icon = Icons.hourglass_top;
        text = l10n.testChatLoadingModel;
        bgColor = colorScheme.secondaryContainer;
        fgColor = colorScheme.onSecondaryContainer;
      case _TestChatStatus.ready:
      case _TestChatStatus.generating:
        icon = Icons.check_circle;
        text = l10n.testChatModelLoaded;
        bgColor = Colors.green.withValues(alpha: 0.12);
        fgColor = Colors.green;
      case _TestChatStatus.error:
        icon = Icons.error;
        text = _errorMessage ?? l10n.testChatErrorLoading;
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
          if (_status == _TestChatStatus.loading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: fgColor,
              ),
            ),
          if (_status == _TestChatStatus.error)
            TextButton(
              onPressed: _initModel,
              child: Text(l10n.commonRetry),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    if (_status == _TestChatStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_status == _TestChatStatus.error) {
      final l10n = context.l10n;
      return Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                l10n.testChatCouldNotLoad,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _errorMessage ?? l10n.testChatUnknownError,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.base),
              FilledButton.tonalIcon(
                onPressed: _initModel,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (_messages.isEmpty && _status != _TestChatStatus.generating) {
      final l10n = context.l10n;
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
                l10n.testChatModelReady,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.testChatSendToTest,
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

    final isGenerating = _status == _TestChatStatus.generating;
    final showPartial = isGenerating && _partialResponse.isNotEmpty;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (showPartial ? 1 : 0),
      itemBuilder: (context, index) {
        // 流式部分回复
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
