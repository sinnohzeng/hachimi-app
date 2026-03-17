import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 复古平铺背景图案类型。
enum PatternType { dots, diagonal, crosshatch, grid }

/// 复古平铺背景 — 在 Scaffold 上叠加微妙的图案纹理。
///
/// 极低透明度（0.03~0.06），增添质感但不喧宾夺主。
/// 可选滚动偏移实现 1-2px 视差效果。
///
/// 内部使用 [PictureRecorder] 将图案异步缓存为 [ui.Image]，
/// 避免每帧绘制数千个基础图元，且不阻塞页面转场动画。
/// 仅在尺寸或图案参数变化时重新生成缓存。
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
  bool _isGenerating = false;
  bool _cacheScheduled = false;

  // 缓存 theme 依赖值，避免在 build() 中产生副作用
  Color? _effectiveColor;
  double _effectiveOffset = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateThemeValues();
    _scheduleCache();
  }

  @override
  void didUpdateWidget(RetroTiledBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pattern != widget.pattern ||
        oldWidget.scrollOffset != widget.scrollOffset ||
        oldWidget.color != widget.color ||
        oldWidget.opacity != widget.opacity) {
      _updateThemeValues();
      _scheduleCache();
    }
  }

  @override
  void dispose() {
    _cachedImage?.dispose();
    _cachedImage = null;
    super.dispose();
  }

  /// 根据 Theme 和 widget 参数计算有效颜色与偏移。
  void _updateThemeValues() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor =
        widget.color ?? Theme.of(context).colorScheme.onSurface;
    final patternOpacity = widget.opacity ?? (isDark ? 0.03 : 0.05);
    _effectiveColor = patternColor.withValues(alpha: patternOpacity);
    _effectiveOffset = widget.scrollOffset % 16;
  }

  /// 在下一帧回调中触发缓存生成 — 去重防止同帧多次排队。
  void _scheduleCache() {
    if (_cacheScheduled) return;
    _cacheScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cacheScheduled = false;
      if (!mounted) return;
      final color = _effectiveColor;
      if (color == null) return;
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        _ensureCacheAsync(
          renderBox.size,
          widget.pattern,
          color,
          _effectiveOffset,
        );
      }
    });
  }

  /// 异步检查并更新缓存 — 将 GPU 纹理分配移出关键帧路径。
  ///
  /// 首帧：背景透明（图案仅 3-5% 透明度，不可感知）。
  /// 异步完成后 setState 触发重绘，图案无缝出现。
  void _ensureCacheAsync(
    Size size,
    PatternType pattern,
    Color color,
    double offset,
  ) {
    if (size.isEmpty) return;

    final needsRegen =
        _cachedImage == null ||
        _cachedSize != size ||
        _cachedPattern != pattern ||
        _cachedColor != color ||
        _cachedOffset != offset;

    if (!needsRegen || _isGenerating) return;

    _isGenerating = true;
    _renderToImageAsync(size, pattern, color, offset).then((image) {
      if (!mounted) {
        image?.dispose();
        return;
      }
      setState(() {
        _cachedImage?.dispose();
        _cachedImage = image;
        _cachedPattern = pattern;
        _cachedColor = color;
        _cachedOffset = offset;
        _cachedSize = size;
        _isGenerating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 纯渲染，不再注册回调 — 副作用已移至生命周期方法
    return Stack(
      children: [
        if (_cachedImage != null)
          Positioned.fill(
            child: CustomPaint(
              painter: _CachedPatternPainter(image: _cachedImage!),
            ),
          ),
        widget.child,
      ],
    );
  }
}

/// 异步将图案绘制到离屏画布，返回位图。
///
/// 使用 [Picture.toImage]（异步版本）代替 toImageSync，
/// 避免在页面转场首帧同步阻塞 GPU 线程。
Future<ui.Image?> _renderToImageAsync(
  Size size,
  PatternType pattern,
  Color color,
  double offset,
) async {
  // 防御超大画布导致 GPU OOM
  if (size.width > 4096 || size.height > 4096) return null;

  try {
    final recorder = ui.PictureRecorder();
    final offscreen = Canvas(recorder);

    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;

    // 各图案所需 strokeWidth 不同，在调用前显式设置，
    // 避免 paint 函数内部隐式修改传入参数。
    switch (pattern) {
      case PatternType.dots:
        _paintDots(offscreen, size, paint, offset);
      case PatternType.diagonal:
        paint.strokeWidth = 1;
        _paintDiagonal(offscreen, size, paint, offset);
      case PatternType.crosshatch:
        paint.strokeWidth = 0.5;
        _paintCrosshatch(offscreen, size, paint, offset);
      case PatternType.grid:
        paint.strokeWidth = 0.5;
        _paintGrid(offscreen, size, paint, offset);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.ceil(), size.height.ceil());
    picture.dispose();
    return image;
  } catch (e) {
    debugPrint('[RetroTiledBackground] toImage failed: $e');
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

  for (var y = offset; y < size.height; y += spacing) {
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  for (var x = 0.0; x < size.width; x += spacing) {
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }
}

/// 仅负责绘制已缓存的 [ui.Image] — 零逻辑、零分配。
class _CachedPatternPainter extends CustomPainter {
  const _CachedPatternPainter({required this.image});

  final ui.Image image;

  static final Paint _drawPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, _drawPaint);
  }

  @override
  bool shouldRepaint(_CachedPatternPainter oldDelegate) {
    return !identical(image, oldDelegate.image);
  }
}
