import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// RPG 风格分段经验条 — 取代 LinearProgressIndicator。
///
/// 每个段落是一个小矩形，填充时从左到右逐段动画。
class PixelProgressBar extends StatelessWidget {
  const PixelProgressBar({
    super.key,
    required this.value,
    this.segments = 20,
    this.filledColor,
    this.emptyColor,
    this.height = 12,
  });

  /// 进度值 0.0 ~ 1.0
  final double value;

  /// 分段数量
  final int segments;

  /// 已填充段颜色 — 默认 xpBarFill（金色）
  final Color? filledColor;

  /// 空段颜色 — 默认 xpBarTrack
  final Color? emptyColor;

  /// 条高度
  final double height;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final filled = filledColor ?? pixel.xpBarFill;
    final empty = emptyColor ?? pixel.xpBarTrack;
    final border = pixel.pixelBorder;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: _SegmentedBarPainter(
          value: value.clamp(0.0, 1.0),
          segments: segments,
          filledColor: filled,
          emptyColor: empty,
          borderColor: border,
        ),
      ),
    );
  }
}

class _SegmentedBarPainter extends CustomPainter {
  _SegmentedBarPainter({
    required this.value,
    required this.segments,
    required this.filledColor,
    required this.emptyColor,
    required this.borderColor,
  });

  final double value;
  final int segments;
  final Color filledColor;
  final Color emptyColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final filledCount = (value * segments).ceil();
    const gap = 1.5;
    final segWidth = (size.width - gap * (segments - 1)) / segments;

    // 外框
    canvas.drawRect(
      Rect.fromLTWH(-1, -1, size.width + 2, size.height + 2),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..isAntiAlias = false,
    );

    for (var i = 0; i < segments; i++) {
      final x = i * (segWidth + gap);
      final isFilled = i < filledCount;
      canvas.drawRect(
        Rect.fromLTWH(x, 0, segWidth, size.height),
        Paint()
          ..color = isFilled ? filledColor : emptyColor
          ..isAntiAlias = false,
      );
    }
  }

  @override
  bool shouldRepaint(_SegmentedBarPainter oldDelegate) {
    return value != oldDelegate.value ||
        segments != oldDelegate.segments ||
        filledColor != oldDelegate.filledColor ||
        emptyColor != oldDelegate.emptyColor;
  }
}
