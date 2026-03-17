import 'package:flutter/material.dart';

import '../../core/theme/pixel_border_shape.dart';
import '../../core/theme/pixel_theme_extension.dart';

/// 像素风徽章 — 用于阶段标签、心情标签、性格标签等。
///
/// 带阶梯角的小容器，可选入场弹跳动画。
class PixelBadge extends StatefulWidget {
  const PixelBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.animate = false,
  });

  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;

  /// 是否播放入场弹跳动画
  final bool animate;

  @override
  State<PixelBadge> createState() => _PixelBadgeState();
}

class _PixelBadgeState extends State<PixelBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.1), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animate) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final scheme = Theme.of(context).colorScheme;
    final bg = widget.backgroundColor ?? pixel.retroSurface;
    final fg = widget.textColor ?? pixel.pixelLabel.color ?? scheme.onSurfaceVariant;
    final border = pixel.pixelBorder;

    Widget badge = CustomPaint(
      painter: _BadgePainter(fillColor: bg, borderColor: border),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 4),
            ],
            Text(widget.text, style: pixel.pixelLabel.copyWith(color: fg)),
          ],
        ),
      ),
    );

    if (!widget.animate) return badge;

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: badge,
    );
  }
}

class _BadgePainter extends CustomPainter {
  _BadgePainter({required this.fillColor, required this.borderColor});

  final Color fillColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = PixelBorderShape.steppedPath(Offset.zero & size, 3.0);

    canvas.drawPath(path, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(_BadgePainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        borderColor != oldDelegate.borderColor;
  }
}
