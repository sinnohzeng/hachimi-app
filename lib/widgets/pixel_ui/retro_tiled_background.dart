import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 复古平铺背景图案类型。
enum PatternType { dots, diagonal, crosshatch, grid }

/// 复古平铺背景 — 在 Scaffold 上叠加微妙的图案纹理。
///
/// 极低透明度（0.03~0.06），增添质感但不喧宾夺主。
/// 可选滚动偏移实现 1-2px 视差效果。
///
/// 内部使用 [PictureRecorder] 将图案缓存为 [ui.Image]，
/// 避免每帧绘制数千个基础图元。仅在尺寸或图案参数变化时重新生成缓存。
/// 缓存与 State 生命周期绑定，widget 销毁时自动释放 GPU 纹理。
class RetroTiledBackground extends StatefulWidget {
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
  State<RetroTiledBackground> createState() => _RetroTiledBackgroundState();
}

class _RetroTiledBackgroundState extends State<RetroTiledBackground> {
  ui.Image? _cachedImage;
  PatternType? _cachedPattern;
  Color? _cachedColor;
  double? _cachedOffset;
  Size? _cachedSize;

  @override
  void dispose() {
    _cachedImage?.dispose();
    _cachedImage = null;
    super.dispose();
  }

  /// 检查缓存是否需要重新生成，返回当前位图。
  ui.Image? _ensureCache(
    Size size,
    PatternType pattern,
    Color color,
    double offset,
  ) {
    if (size.isEmpty) return null;

    final needsRegen =
        _cachedImage == null ||
        _cachedSize != size ||
        _cachedPattern != pattern ||
        _cachedColor != color ||
        _cachedOffset != offset;

    if (needsRegen) {
      _cachedImage?.dispose();
      _cachedImage = _renderToImage(size, pattern, color, offset);
      _cachedPattern = pattern;
      _cachedColor = color;
      _cachedOffset = offset;
      _cachedSize = size;
    }

    return _cachedImage;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor =
        widget.color ?? Theme.of(context).colorScheme.onSurface;
    final patternOpacity = widget.opacity ?? (isDark ? 0.03 : 0.05);
    final effectiveColor = patternColor.withValues(alpha: patternOpacity);
    final effectiveOffset = widget.scrollOffset % 16;

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _CachedPatternPainter(
                pattern: widget.pattern,
                color: effectiveColor,
                offset: effectiveOffset,
                ensureCache: _ensureCache,
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

/// 将图案绘制到离屏画布，返回位图。
///
/// 对 GPU 纹理分配做防御性保护：尺寸超限或分配失败时返回 null，
/// 画笔层退化为无背景（而非红屏崩溃）。
ui.Image? _renderToImage(
  Size size,
  PatternType pattern,
  Color color,
  double offset,
) {
  // 防御超大画布导致 GPU OOM
  if (size.width > 4096 || size.height > 4096) return null;

  try {
    final recorder = ui.PictureRecorder();
    final offscreen = Canvas(recorder);

    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;

    switch (pattern) {
      case PatternType.dots:
        _paintDots(offscreen, size, paint, offset);
      case PatternType.diagonal:
        _paintDiagonal(offscreen, size, paint, offset);
      case PatternType.crosshatch:
        _paintCrosshatch(offscreen, size, paint, offset);
      case PatternType.grid:
        _paintGrid(offscreen, size, paint, offset);
    }

    final picture = recorder.endRecording();
    final image = picture.toImageSync(size.width.ceil(), size.height.ceil());
    picture.dispose();
    return image;
  } catch (e) {
    debugPrint('[RetroTiledBackground] toImageSync failed: $e');
    return null;
  }
}

void _paintDots(Canvas canvas, Size size, Paint paint, double offset) {
  const spacing = 16.0;
  const dotSize = 1.5;
  for (var y = -spacing + offset; y < size.height + spacing; y += spacing) {
    for (var x = 0.0; x < size.width + spacing; x += spacing) {
      canvas.drawRect(Rect.fromLTWH(x, y, dotSize, dotSize), paint);
    }
  }
}

void _paintDiagonal(Canvas canvas, Size size, Paint paint, double offset) {
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

void _paintCrosshatch(Canvas canvas, Size size, Paint paint, double offset) {
  const spacing = 14.0;
  paint.strokeWidth = 0.5;
  final maxDim = size.width + size.height;

  for (var i = -maxDim; i < maxDim; i += spacing) {
    canvas.drawLine(
      Offset(i + offset, 0),
      Offset(i + size.height + offset, size.height),
      paint,
    );
  }
  for (var i = -maxDim; i < maxDim; i += spacing) {
    canvas.drawLine(
      Offset(i - offset + size.width, 0),
      Offset(i - size.height - offset + size.width, size.height),
      paint,
    );
  }
}

void _paintGrid(Canvas canvas, Size size, Paint paint, double offset) {
  const spacing = 16.0;
  paint.strokeWidth = 0.5;

  for (var y = offset; y < size.height; y += spacing) {
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  for (var x = 0.0; x < size.width; x += spacing) {
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }
}

/// 缓存图案到 [ui.Image] 的画笔。
///
/// 缓存管理委托给 [_RetroTiledBackgroundState]，
/// 确保 GPU 纹理与 widget 生命周期绑定。
class _CachedPatternPainter extends CustomPainter {
  _CachedPatternPainter({
    required this.pattern,
    required this.color,
    required this.offset,
    required this.ensureCache,
  });

  final PatternType pattern;
  final Color color;
  final double offset;
  final ui.Image? Function(Size, PatternType, Color, double) ensureCache;

  @override
  void paint(Canvas canvas, Size size) {
    final image = ensureCache(size, pattern, color, offset);
    if (image != null) {
      canvas.drawImage(image, Offset.zero, Paint());
    }
  }

  @override
  bool shouldRepaint(_CachedPatternPainter oldDelegate) {
    return pattern != oldDelegate.pattern ||
        color != oldDelegate.color ||
        offset != oldDelegate.offset;
  }
}
