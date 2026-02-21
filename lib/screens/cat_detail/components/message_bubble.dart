import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// 消息气泡组件。
class MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isUser,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
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
            color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
