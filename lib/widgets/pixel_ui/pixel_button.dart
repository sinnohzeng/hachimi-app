import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/pixel_theme_extension.dart';
import 'pixel_border.dart';

/// 自适应主操作按钮 — MD3 / Retro Pixel 双模式。
///
/// - MD3：FilledButton.tonal + 触觉反馈
/// - Retro：阶梯角边框 + Silkscreen 字体 + 按压缩放动画
class PixelButton extends StatelessWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    if (!context.pixel.isRetro) return _buildMaterial(context);
    return _RetroPixelButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon!, size: 16),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Retro Pixel 渲染 — 阶梯角边框 + Silkscreen 字体 + 按压缩放动画
// ---------------------------------------------------------------------------

class _RetroPixelButton extends StatefulWidget {
  const _RetroPixelButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<_RetroPixelButton> createState() => _RetroPixelButtonState();
}

class _RetroPixelButtonState extends State<_RetroPixelButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _scaleCurve;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleCurve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween(begin: 1.0, end: 0.95).animate(_scaleCurve);
  }

  @override
  void dispose() {
    _scaleCurve.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pixel = context.pixel;
    final bg = widget.backgroundColor ?? scheme.primary;
    final fg = widget.foregroundColor ?? scheme.onPrimary;
    final enabled = widget.onPressed != null;

    // 用颜色 alpha 替代 Opacity widget — 避免不必要的 GPU 合成层
    final effectiveBg = enabled ? bg : bg.withValues(alpha: 0.5);
    final effectiveFg = enabled ? fg : fg.withValues(alpha: 0.5);
    final effectiveBorder = enabled
        ? pixel.pixelBorder
        : pixel.pixelBorder.withValues(alpha: 0.5);

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.label,
        child: GestureDetector(
          onTap: _handleTap,
          child: ExcludeSemantics(
            child: PixelBorder(
              fillColor: effectiveBg,
              borderColor: effectiveBorder,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 16, color: effectiveFg),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.label,
                    style: pixel.pixelLabel.copyWith(color: effectiveFg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
