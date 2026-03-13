import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风环形进度 — 替代 CircularProgressIndicator（确定进度模式）。
///
/// 将圆弧离散化为 N 段直线段，已完成段高亮、未完成段暗淡，
/// 形成类似 NES/SNES 游戏中的体力条视觉效果。
class PixelProgressRing extends StatelessWidget {
  const PixelProgressRing({
    super.key,
    required this.value,
    this.size = 64,
    this.segments = 12,
    this.strokeWidth = 3,
    this.activeColor,
    this.trackColor,
  });

  /// 进度值 0.0 ~ 1.0
  final double value;

  /// 环直径
  final double size;

  /// 分段数量
  final int segments;

  /// 线段宽度
  final double strokeWidth;

  /// 已填充段颜色 — 默认 xpBarFill
  final Color? activeColor;

  /// 未填充段颜色 — 默认 xpBarTrack
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: _SegmentedRingPainter(
          value: value.clamp(0.0, 1.0),
          segments: segments,
          strokeWidth: strokeWidth,
          activeColor: activeColor ?? pixel.xpBarFill,
          trackColor: trackColor ?? pixel.xpBarTrack,
          borderColor: pixel.pixelBorder,
        ),
      ),
    );
  }
}

class _SegmentedRingPainter extends CustomPainter {
  const _SegmentedRingPainter({
    required this.value,
    required this.segments,
    required this.strokeWidth,
    required this.activeColor,
    required this.trackColor,
    required this.borderColor,
  });

  final double value;
  final int segments;
  final double strokeWidth;
  final Color activeColor;
  final Color trackColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = (size.width - strokeWidth) / 2;
    final filledCount = (value * segments).ceil();

    // 每段之间留 2° 间隙
    const gapAngle = 2 * math.pi / 180;
    final segAngle = (2 * math.pi - gapAngle * segments) / segments;

    for (var i = 0; i < segments; i++) {
      // 从顶部（-π/2）开始顺时针
      final startAngle = -math.pi / 2 + i * (segAngle + gapAngle);
      final endAngle = startAngle + segAngle;
      final isFilled = i < filledCount;

      final paint = Paint()
        ..color = isFilled ? activeColor : trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = false;

      // 用直线段逼近弧线 — 每段分 2 小段，保持像素锯齿感
      const subSegs = 2;
      final subAngle = (endAngle - startAngle) / subSegs;
      for (var j = 0; j < subSegs; j++) {
        final a1 = startAngle + j * subAngle;
        final a2 = a1 + subAngle;
        canvas.drawLine(
          Offset(cx + r * math.cos(a1), cy + r * math.sin(a1)),
          Offset(cx + r * math.cos(a2), cy + r * math.sin(a2)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SegmentedRingPainter oldDelegate) {
    return value != oldDelegate.value ||
        segments != oldDelegate.segments ||
        activeColor != oldDelegate.activeColor ||
        trackColor != oldDelegate.trackColor;
  }
}
