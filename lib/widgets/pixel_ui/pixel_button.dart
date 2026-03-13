import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/pixel_theme_extension.dart';
import 'pixel_border.dart';

/// 像素风主操作按钮 — 阶梯角边框 + Silkscreen 字体。
///
/// 取代猫咪屏幕中的 FilledButton / FilledButton.tonal。
class PixelButton extends StatefulWidget {
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
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
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

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTap: _handleTap,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: PixelBorder(
            fillColor: bg,
            borderColor: pixel.pixelBorder,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 16, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(widget.label, style: pixel.pixelLabel.copyWith(color: fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
