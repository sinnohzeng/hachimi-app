import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风骨架屏 — 替代 shimmer 渐变加载器。
///
/// M3 的 shimmer 效果是平滑渐变扫过，不符合像素美学。
/// 此组件使用脉冲虚线矩形，以 2 帧切换透明度模拟 8-bit 加载感。
class PixelSkeletonLoader extends StatefulWidget {
  const PixelSkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderWidth = 1.5,
  });

  /// 宽度 — null 时自动填满父容器
  final double? width;

  /// 高度
  final double height;

  /// 虚线边框宽度
  final double borderWidth;

  @override
  State<PixelSkeletonLoader> createState() => _PixelSkeletonLoaderState();
}

class _PixelSkeletonLoaderState extends State<PixelSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 尊重系统「减少动画」无障碍设置 — 动态响应用户在设置中切换
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 2 帧切换：0.3 ↔ 0.6 透明度
        final opacity = _controller.value < 0.5 ? 0.3 : 0.6;
        return CustomPaint(
          size: Size(widget.width ?? double.infinity, widget.height),
          painter: _DashedRectPainter(
            color: pixel.pixelBorder.withValues(alpha: opacity),
            borderWidth: widget.borderWidth,
            fillColor: pixel.xpBarTrack.withValues(alpha: opacity * 0.5),
          ),
        );
      },
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  const _DashedRectPainter({
    required this.color,
    required this.borderWidth,
    required this.fillColor,
  });

  final Color color;
  final double borderWidth;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 填充
    canvas.drawRect(rect, Paint()..color = fillColor);

    // 虚线边框
    const dashLen = 4.0;
    const gapLen = 3.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = false;

    _drawDashedLine(
      canvas,
      rect.topLeft,
      rect.topRight,
      paint,
      dashLen,
      gapLen,
    );
    _drawDashedLine(
      canvas,
      rect.topRight,
      rect.bottomRight,
      paint,
      dashLen,
      gapLen,
    );
    _drawDashedLine(
      canvas,
      rect.bottomRight,
      rect.bottomLeft,
      paint,
      dashLen,
      gapLen,
    );
    _drawDashedLine(
      canvas,
      rect.bottomLeft,
      rect.topLeft,
      paint,
      dashLen,
      gapLen,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double dashLen,
    double gapLen,
  ) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final totalLen = (dx * dx + dy * dy);
    if (totalLen == 0) return;
    final len = totalLen > 0 ? totalLen : 1.0;
    final sqrtLen = math.sqrt(len);
    final unitDx = dx / sqrtLen;
    final unitDy = dy / sqrtLen;

    var drawn = 0.0;
    var drawing = true;
    while (drawn < sqrtLen) {
      final segLen = drawing ? dashLen : gapLen;
      final end2 = (drawn + segLen).clamp(0.0, sqrtLen);
      if (drawing) {
        canvas.drawLine(
          Offset(start.dx + unitDx * drawn, start.dy + unitDy * drawn),
          Offset(start.dx + unitDx * end2, start.dy + unitDy * end2),
          paint,
        );
      }
      drawn = end2;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_DashedRectPainter oldDelegate) {
    return color != oldDelegate.color || fillColor != oldDelegate.fillColor;
  }
}
