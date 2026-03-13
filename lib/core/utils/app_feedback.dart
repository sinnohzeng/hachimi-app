import 'package:flutter/material.dart';

/// AppFeedback — 统一 SnackBar 反馈工具。
///
/// 替代分散的 `ScaffoldMessenger.of(context).showSnackBar()` 调用，
/// 确保全局一致的视觉风格和行为。
///
/// Usage:
/// ```dart
/// AppFeedback.success(context, '操作成功');
/// AppFeedback.error(context, '操作失败');
/// AppFeedback.info(context, '提示信息');
/// ```
class AppFeedback {
  AppFeedback._();

  /// 成功反馈 — 带 check 图标的绿色 SnackBar。
  static void success(BuildContext context, String message) {
    _show(context, message, icon: Icons.check_circle_outline);
  }

  /// 错误反馈 — 带 error 图标的红色 SnackBar。
  static void error(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    _show(
      context,
      message,
      icon: Icons.error_outline,
      backgroundColor: colorScheme.errorContainer,
      textColor: colorScheme.onErrorContainer,
    );
  }

  /// 信息反馈 — 默认主题色 SnackBar。
  static void info(BuildContext context, String message) {
    _show(context, message);
  }

  static void _show(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: icon != null
            ? Row(
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(message)),
                ],
              )
            : Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
