import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风加载指示器 — 替代 CircularProgressIndicator。
///
/// 使用 4 帧阶梯旋转（0°、90°、180°、270°）代替平滑旋转，
/// 模拟 8-bit 游戏中的加载动画效果。
///
/// CustomPaint 作为 AnimatedBuilder.child 提取，仅构建一次；
/// builder 回调只包装 Transform.rotate（GPU 加速矩阵变换）。
/// RepaintBoundary 隔离旋转重绘区域。
@Deprecated('零屏幕引用，维护期不再维护。')
class PixelLoadingIndicator extends StatefulWidget {
  const PixelLoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  State<PixelLoadingIndicator> createState() => _PixelLoadingIndicatorState();
}

class _PixelLoadingIndicatorState extends State<PixelLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final color = widget.color ?? pixel.pixelBorder;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // 4 帧阶梯旋转：将连续动画离散化为 4 步
          final frame = (_controller.value * 4).floor() % 4;
          final angle = frame * math.pi / 2;
          return Transform.rotate(angle: angle, child: child);
        },
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _PixelSpinnerPainter(
            color: color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _PixelSpinnerPainter extends CustomPainter {
  _PixelSpinnerPainter({required this.color, required this.strokeWidth})
    : _brightPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..isAntiAlias = false,
      _fadePaint = Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..isAntiAlias = false;

  final Color color;
  final double strokeWidth;
  final Paint _brightPaint;
  final Paint _fadePaint;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = (size.width - strokeWidth) / 2;

    // 上边（亮）
    canvas.drawLine(
      Offset(cx - r, cy - r),
      Offset(cx + r, cy - r),
      _brightPaint,
    );
    // 右边（亮）
    canvas.drawLine(
      Offset(cx + r, cy - r),
      Offset(cx + r, cy + r),
      _brightPaint,
    );
    // 下边（暗）
    canvas.drawLine(Offset(cx + r, cy + r), Offset(cx - r, cy + r), _fadePaint);
    // 左边（暗）
    canvas.drawLine(Offset(cx - r, cy + r), Offset(cx - r, cy - r), _fadePaint);
  }

  @override
  bool shouldRepaint(_PixelSpinnerPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
