import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风阶梯边框 — 用 2px 阶梯角替代圆角，营造复古游戏 UI 感。
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

  /// 边框颜色 — 默认取 PixelThemeExtension.pixelBorder
  final Color? borderColor;

  /// 填充色 — 默认取 PixelThemeExtension.retroSurface
  final Color? fillColor;

  /// 边框宽度（像素）
  final double borderWidth;

  /// 内边距 — 默认 12px
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final effectiveBorder = borderColor ?? pixel.pixelBorder;
    final effectiveFill = fillColor ?? pixel.retroSurface;

    return CustomPaint(
      painter: _PixelBorderPainter(
        borderColor: effectiveBorder,
        fillColor: effectiveFill,
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
///
/// Paint 对象在构造时缓存，避免 paint() 中分配，降低 GC 压力。
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

  /// 生成阶梯角路径 — 每个角切掉 step×step 像素。
  Path _steppedPath(Size size, double step) {
    final w = size.width;
    final h = size.height;

    return Path()
      // 左上角 — 从 (step, 0) 开始
      ..moveTo(step, 0)
      ..lineTo(w - step, 0) // 顶边
      ..lineTo(w - step, step) // 右上阶梯 ↓
      ..lineTo(w, step) // 右上阶梯 →
      ..lineTo(w, h - step) // 右边
      ..lineTo(w - step, h - step) // 右下阶梯 ←
      ..lineTo(w - step, h) // 右下阶梯 ↓
      ..lineTo(step, h) // 底边
      ..lineTo(step, h - step) // 左下阶梯 ↑
      ..lineTo(0, h - step) // 左下阶梯 ←
      ..lineTo(0, step) // 左边
      ..lineTo(step, step) // 左上阶梯 →
      ..close();
  }

  @override
  bool shouldRepaint(_PixelBorderPainter oldDelegate) {
    return borderColor != oldDelegate.borderColor ||
        fillColor != oldDelegate.fillColor ||
        borderWidth != oldDelegate.borderWidth;
  }
}
