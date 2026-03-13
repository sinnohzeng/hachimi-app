import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';

/// AnimatedLoadingButton — 异步操作按钮，自动切换 label 与 loading 指示器。
///
/// 当 [isLoading] 为 true 时，按钮文本平滑切换为旋转指示器，
/// 同时禁用按钮防止重复点击。
///
/// Usage:
/// ```dart
/// AnimatedLoadingButton(
///   onPressed: _submit,
///   isLoading: _isSubmitting,
///   icon: Icon(Icons.check),
///   label: Text('提交'),
/// )
/// ```
class AnimatedLoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget label;
  final Widget? icon;

  /// 使用 FilledButton 样式（默认）还是 FilledButton.tonal 样式。
  final bool tonal;

  const AnimatedLoadingButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
    this.icon,
    this.tonal = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = AnimatedSwitcher(
      duration: AppMotion.durationShort4,
      switchInCurve: AppMotion.standardDecelerate,
      switchOutCurve: AppMotion.standardAccelerate,
      child: isLoading
          ? const SizedBox(
              key: ValueKey('loading'),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : KeyedSubtree(key: const ValueKey('label'), child: label),
    );

    final effectiveOnPressed = isLoading ? null : onPressed;

    if (icon != null && !isLoading) {
      return tonal
          ? FilledButton.tonalIcon(
              onPressed: effectiveOnPressed,
              icon: icon!,
              label: child,
            )
          : FilledButton.icon(
              onPressed: effectiveOnPressed,
              icon: icon!,
              label: child,
            );
    }

    return tonal
        ? FilledButton.tonal(
            onPressed: effectiveOnPressed,
            child: child,
          )
        : FilledButton(
            onPressed: effectiveOnPressed,
            child: child,
          );
  }
}
