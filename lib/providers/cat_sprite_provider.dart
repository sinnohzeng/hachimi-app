// ---
// 📘 文件说明：
// 像素猫 Sprite 渲染 Provider — 单例渲染器 + 缓存图片 FutureProvider。
//
// 🕒 创建时间：2026-02-18
// ---

import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/services/pixel_cat_renderer.dart';

/// 渲染器单例 — 全局共享 spritesheet 缓存。
final pixelCatRendererProvider = Provider<PixelCatRenderer>(
  (ref) => PixelCatRenderer(),
);

/// Sprite 渲染参数。
typedef CatSpriteParams = ({
  CatAppearance appearance,
  int spriteIndex,
  String? accessoryId,
});

/// 渲染结果缓存 — 按 appearance + spriteIndex + accessoryId 组合 family。
final catSpriteImageProvider = FutureProvider.family<ui.Image, CatSpriteParams>(
  (ref, params) {
    final renderer = ref.watch(pixelCatRendererProvider);
    return renderer.renderCat(
      params.appearance,
      params.spriteIndex,
      accessoryId: params.accessoryId,
    );
  },
);
