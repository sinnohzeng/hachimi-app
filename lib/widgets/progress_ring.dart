import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';

/// ProgressRing — 带弧线过渡动画的环形进度指示器。
///
/// 当 [progress] 变化时，弧线平滑过渡到新进度值。
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final Widget child;
  final double strokeWidth;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 56,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: '${(progress * 100).round()}% progress',
      value: '${(progress * 100).round()}%',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RepaintBoundary(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: progress),
                duration: AppMotion.durationMedium2,
                curve: AppMotion.emphasized,
                builder: (context, animatedProgress, _) => CustomPaint(
                  size: Size(size, size),
                  painter: _RingPainter(
                    progress: animatedProgress,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.primary,
                    strokeWidth: strokeWidth,
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = backgroundColor;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final fgPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = foregroundColor
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from top
        2 * pi * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.foregroundColor != foregroundColor;
}
