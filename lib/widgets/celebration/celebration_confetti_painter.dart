import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hachimi_app/widgets/celebration/celebration_tier.dart';

/// 高性能纸屑粒子画笔 — 支持 5 种形状、交错出生、主题色。
///
/// 粒子在构造期预生成，paint() 内仅做插值，无分配。
class CelebrationConfettiPainter extends CustomPainter {
  CelebrationConfettiPainter({
    required this.progress,
    required this.config,
    required this.seed,
    required this.screenSize,
    required this.colors,
  }) : _particles = _generateParticles(seed, config, screenSize);

  final double progress;
  final CelebrationConfig config;
  final int seed;
  final Size screenSize;
  final List<Color> colors;
  final List<_Particle> _particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      if (progress < p.birthTime) continue;

      final localProgress = ((progress - p.birthTime) / (1.0 - p.birthTime))
          .clamp(0.0, 1.0);
      final y = p.startY + localProgress * size.height * p.speed;
      if (y > size.height) continue;

      final opacity = (1.0 - (y / size.height)).clamp(0.0, 0.8);
      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = colors[p.colorIndex % colors.length].withValues(
          alpha: opacity,
        );
      final angle = localProgress * pi * 2 * p.rotationDir;

      canvas.save();
      canvas.translate(p.x, y);
      canvas.rotate(angle);
      _drawShape(canvas, p, paint);
      canvas.restore();
    }
  }

  void _drawShape(Canvas canvas, _Particle p, Paint paint) {
    switch (p.shape) {
      case ConfettiShape.rectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.w, height: p.h),
            const Radius.circular(2),
          ),
          paint,
        );
      case ConfettiShape.circle:
        canvas.drawCircle(Offset.zero, p.w * 0.4, paint);
      case ConfettiShape.star:
        _drawStar(canvas, p.w * 0.5, paint);
      case ConfettiShape.diamond:
        _drawDiamond(canvas, p.w * 0.5, paint);
      case ConfettiShape.streamer:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.w * 0.4,
              height: p.h * 1.6,
            ),
            const Radius.circular(1),
          ),
          paint,
        );
    }
  }

  void _drawStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * pi / 180;
      final outerX = cos(outerAngle) * radius;
      final outerY = sin(outerAngle) * radius;
      final innerX = cos(innerAngle) * radius * 0.4;
      final innerY = sin(innerAngle) * radius * 0.4;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, double radius, Paint paint) {
    final path = Path()
      ..moveTo(0, -radius)
      ..lineTo(radius * 0.6, 0)
      ..lineTo(0, radius)
      ..lineTo(-radius * 0.6, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CelebrationConfettiPainter old) =>
      old.progress != progress;

  static List<_Particle> _generateParticles(
    int seed,
    CelebrationConfig config,
    Size size,
  ) {
    final random = Random(seed);
    final particles = <_Particle>[];
    final shapes = config.shapes;

    for (var i = 0; i < config.particleCount; i++) {
      final x = config.hasBurstOrigin
          ? size.width * 0.5 + (random.nextDouble() - 0.5) * size.width * 0.6
          : random.nextDouble() * size.width;

      particles.add(
        _Particle(
          x: x,
          startY: config.hasBurstOrigin
              ? size.height * 0.2 + random.nextDouble() * size.height * 0.1
              : random.nextDouble() * size.height * 0.3,
          speed: 0.5 + random.nextDouble() * 1.5,
          w: 4.0 + random.nextDouble() * 6,
          h: 3.0 + random.nextDouble() * 4,
          colorIndex: i,
          rotationDir: random.nextBool() ? 1.0 : -1.0,
          shape: shapes[i % shapes.length],
          birthTime: random.nextDouble() * 0.3,
        ),
      );
    }
    return particles;
  }
}

class _Particle {
  final double x;
  final double startY;
  final double speed;
  final double w;
  final double h;
  final int colorIndex;
  final double rotationDir;
  final ConfettiShape shape;
  final double birthTime;

  const _Particle({
    required this.x,
    required this.startY,
    required this.speed,
    required this.w,
    required this.h,
    required this.colorIndex,
    required this.rotationDir,
    required this.shape,
    required this.birthTime,
  });
}
