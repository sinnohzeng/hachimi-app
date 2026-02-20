// ---
// 📘 文件说明：
// ErrorState — 统一错误状态组件，替代散落各处的 Text('Error: $error')。
// 包含错误图标、消息文本和重试按钮。
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';

/// ErrorState — Material 3 style error state with icon, message, and retry button.
///
/// Usage:
/// ```dart
/// ErrorState(
///   message: 'Failed to load data',
///   onRetry: () => ref.invalidate(someProvider),
/// )
/// ```
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
