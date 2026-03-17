import 'package:flutter/material.dart';

import '../../core/theme/app_shape.dart';
import '../../core/theme/pixel_border_shape.dart';
import '../../core/theme/pixel_theme_extension.dart';

/// 自适应徽章 — 用于阶段标签、心情标签、性格标签等。
///
/// 自动感知 UI 风格：当 [PixelThemeExtension.isRetro] 为 true 时使用
/// 阶梯角 CustomPaint + Silkscreen 字体；否则使用 Material 3 圆角容器。
class PixelBadge extends StatelessWidget {
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

  /// 是否播放入场动画（复古模式：弹跳缩放；MD3 模式：AnimatedScale）
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;

    if (pixel.isRetro) {
      return _RetroPixelBadge(
        text: text,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        animate: animate,
      );
    }

    return _Md3Badge(
      text: text,
      icon: icon,
      backgroundColor: backgroundColor,
      textColor: textColor,
      animate: animate,
    );
  }
}

// ---------------------------------------------------------------------------
// MD3 模式 — 圆角容器 + AnimatedScale 入场动画
// ---------------------------------------------------------------------------

class _Md3Badge extends StatelessWidget {
  const _Md3Badge({
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
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = backgroundColor ?? scheme.surfaceContainerHigh;
    final fg = textColor ?? scheme.onSurfaceVariant;

    Widget badge = Container(
      decoration: BoxDecoration(
        borderRadius: AppShape.borderFull,
        color: bg,
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 4)],
          Text(text, style: theme.textTheme.labelMedium?.copyWith(color: fg)),
        ],
      ),
    );

    if (!animate) return badge;

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: badge,
    );
  }
}

// ---------------------------------------------------------------------------
// 复古像素模式 — 阶梯角 CustomPaint + Silkscreen 字体 + 弹跳动画
// ---------------------------------------------------------------------------

class _RetroPixelBadge extends StatefulWidget {
  const _RetroPixelBadge({
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
  final bool animate;

  @override
  State<_RetroPixelBadge> createState() => _RetroPixelBadgeState();
}

class _RetroPixelBadgeState extends State<_RetroPixelBadge>
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
    final fg =
        widget.textColor ?? pixel.pixelLabel.color ?? scheme.onSurfaceVariant;
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
