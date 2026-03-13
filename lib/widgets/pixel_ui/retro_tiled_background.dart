import 'package:flutter/material.dart';

/// 复古平铺背景图案类型。
enum PatternType { dots, diagonal, crosshatch, grid }

/// 复古平铺背景 — 在 Scaffold 上叠加微妙的图案纹理。
///
/// 极低透明度（0.03~0.06），增添质感但不喧宾夺主。
/// 可选滚动偏移实现 1-2px 视差效果。
class RetroTiledBackground extends StatelessWidget {
  const RetroTiledBackground({
    super.key,
    required this.child,
    this.pattern = PatternType.dots,
    this.scrollOffset = 0,
    this.color,
    this.opacity,
  });

  final Widget child;
  final PatternType pattern;

  /// 滚动偏移量（像素）— 产生微妙视差
  final double scrollOffset;

  /// 图案颜色 — 默认 onSurface
  final Color? color;

  /// 覆盖透明度 — 默认根据亮暗模式自动选择
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor = color ?? Theme.of(context).colorScheme.onSurface;
    final patternOpacity = opacity ?? (isDark ? 0.03 : 0.05);

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _TiledPatternPainter(
                pattern: pattern,
                color: patternColor.withValues(alpha: patternOpacity),
                offset: scrollOffset % 16,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _TiledPatternPainter extends CustomPainter {
  _TiledPatternPainter({
    required this.pattern,
    required this.color,
    required this.offset,
  });

  final PatternType pattern;
  final Color color;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;

    switch (pattern) {
      case PatternType.dots:
        _paintDots(canvas, size, paint);
      case PatternType.diagonal:
        _paintDiagonal(canvas, size, paint);
      case PatternType.crosshatch:
        _paintCrosshatch(canvas, size, paint);
      case PatternType.grid:
        _paintGrid(canvas, size, paint);
    }
  }

  void _paintDots(Canvas canvas, Size size, Paint paint) {
    const spacing = 16.0;
    const dotSize = 1.5;
    for (var y = -spacing + offset; y < size.height + spacing; y += spacing) {
      for (var x = 0.0; x < size.width + spacing; x += spacing) {
        canvas.drawRect(Rect.fromLTWH(x, y, dotSize, dotSize), paint);
      }
    }
  }

  void _paintDiagonal(Canvas canvas, Size size, Paint paint) {
    const spacing = 12.0;
    paint.strokeWidth = 1;
    final maxDim = size.width + size.height;
    for (var i = -maxDim; i < maxDim; i += spacing) {
      canvas.drawLine(
        Offset(i + offset, 0),
        Offset(i + size.height + offset, size.height),
        paint,
      );
    }
  }

  void _paintCrosshatch(Canvas canvas, Size size, Paint paint) {
    const spacing = 14.0;
    paint.strokeWidth = 0.5;
    final maxDim = size.width + size.height;

    // 斜线 /
    for (var i = -maxDim; i < maxDim; i += spacing) {
      canvas.drawLine(
        Offset(i + offset, 0),
        Offset(i + size.height + offset, size.height),
        paint,
      );
    }
    // 反斜线 \
    for (var i = -maxDim; i < maxDim; i += spacing) {
      canvas.drawLine(
        Offset(i - offset + size.width, 0),
        Offset(i - size.height - offset + size.width, size.height),
        paint,
      );
    }
  }

  void _paintGrid(Canvas canvas, Size size, Paint paint) {
    const spacing = 16.0;
    paint.strokeWidth = 0.5;

    // 水平线
    for (var y = offset; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // 垂直线
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_TiledPatternPainter oldDelegate) {
    return pattern != oldDelegate.pattern ||
        color != oldDelegate.color ||
        offset != oldDelegate.offset;
  }
}
