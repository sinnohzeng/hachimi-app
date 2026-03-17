import 'package:flutter/material.dart';

import '../../core/theme/app_shape.dart';
import '../../core/theme/pixel_theme_extension.dart';

/// 自适应边框容器 — Retro 模式使用阶梯角 CustomPaint，MD3 模式使用圆角 Container。
///
/// 用法：
/// ```dart
/// PixelBorder(
///   child: Text('Hello'),
/// )
/// ```
class PixelBorder extends StatelessWidget {
  const PixelBorder({
    super.key,
    required this.child,
    this.borderColor,
    this.fillColor,
    this.borderWidth = 2,
    this.padding,
  });

  final Widget child;

  /// 边框颜色 — Retro 默认 pixelBorder，MD3 默认 outlineVariant
  final Color? borderColor;

  /// 填充色 — Retro 默认 retroSurface，MD3 默认 surfaceContainerLow
  final Color? fillColor;

  /// 边框宽度（像素）
  final double borderWidth;

  /// 内边距 — 默认 12px
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    if (!pixel.isRetro) return _buildMaterial(context);
    return _buildRetro(context, pixel);
  }

  Widget _buildMaterial(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: AppShape.borderMedium,
        color: fillColor ?? scheme.surfaceContainerLow,
        border: Border.all(color: borderColor ?? scheme.outlineVariant),
      ),
      child: child,
    );
  }

  Widget _buildRetro(BuildContext context, PixelThemeExtension pixel) {
    return CustomPaint(
      painter: _PixelBorderPainter(
        borderColor: borderColor ?? pixel.pixelBorder,
        fillColor: fillColor ?? pixel.retroSurface,
        borderWidth: borderWidth,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}

/// 绘制阶梯角矩形 — 四角各裁掉一个 step×step 的小方块。
class _PixelBorderPainter extends CustomPainter {
  _PixelBorderPainter({
    required this.borderColor,
    required this.fillColor,
    required this.borderWidth,
  }) : _fillPaint = Paint()..color = fillColor,
       _strokePaint = Paint()
         ..color = borderColor
         ..style = PaintingStyle.stroke
         ..strokeWidth = borderWidth
         ..isAntiAlias = false;

  final Color borderColor;
  final Color fillColor;
  final double borderWidth;
  final Paint _fillPaint;
  final Paint _strokePaint;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _steppedPath(size, borderWidth * 2);
    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _strokePaint);
  }

  Path _steppedPath(Size size, double step) {
    final w = size.width;
    final h = size.height;

    return Path()
      ..moveTo(step, 0)
      ..lineTo(w - step, 0)
      ..lineTo(w - step, step)
      ..lineTo(w, step)
      ..lineTo(w, h - step)
      ..lineTo(w - step, h - step)
      ..lineTo(w - step, h)
      ..lineTo(step, h)
      ..lineTo(step, h - step)
      ..lineTo(0, h - step)
      ..lineTo(0, step)
      ..lineTo(step, step)
      ..close();
  }

  @override
  bool shouldRepaint(_PixelBorderPainter oldDelegate) {
    return borderColor != oldDelegate.borderColor ||
        fillColor != oldDelegate.fillColor ||
        borderWidth != oldDelegate.borderWidth;
  }
}
