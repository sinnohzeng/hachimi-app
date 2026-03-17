import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/providers/cat_sprite_provider.dart';

/// PixelCatSprite — 显示像素猫 sprite 的核心组件。
///
/// 用法：
/// ```dart
/// PixelCatSprite(cat: myCat, size: 120)
/// PixelCatSprite.fromAppearance(appearance: app, spriteIndex: 3, size: 100)
/// ```
class PixelCatSprite extends ConsumerWidget {
  final CatAppearance appearance;
  final int spriteIndex;
  final String? accessoryId;
  final double size;

  const PixelCatSprite({
    super.key,
    required this.appearance,
    required this.spriteIndex,
    this.accessoryId,
    this.size = 100,
  });

  /// 从 Cat 对象快捷构造 — 自动读取 equippedAccessory。
  factory PixelCatSprite.fromCat({
    Key? key,
    required Cat cat,
    double size = 100,
  }) {
    return PixelCatSprite(
      key: key,
      appearance: cat.appearance,
      spriteIndex: cat.spriteIndex,
      accessoryId: cat.equippedAccessory,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (
      appearance: appearance,
      spriteIndex: spriteIndex,
      accessoryId: accessoryId,
    );
    final imageAsync = ref.watch(catSpriteImageProvider(params));

    return Semantics(
      label: '${appearance.peltColor} ${appearance.peltType} cat',
      image: true,
      child: RepaintBoundary(
        child: SizedBox(
          width: size,
          height: size,
          child: imageAsync.when(
            data: (image) => CustomPaint(
              size: Size(size, size),
              painter: _PixelCatPainter(image),
            ),
            loading: () => const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Center(
              child: ExcludeSemantics(
                child: Text('🐱', style: TextStyle(fontSize: size * 0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 像素完美绘制 — 使用 FilterQuality.none 避免模糊。
class _PixelCatPainter extends CustomPainter {
  final ui.Image image;

  _PixelCatPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(_PixelCatPainter old) => old.image != image;
}
