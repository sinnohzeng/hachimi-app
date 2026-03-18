import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

/// sprite 位置信息（对应 spritesIndex.json 的每个条目）
class _SpriteInfo {
  final String spritesheet;
  final double xOffset;
  final double yOffset;
  const _SpriteInfo(this.spritesheet, this.xOffset, this.yOffset);
}

/// sprite 在 spritesheet 网格中的坐标（对应 spritesOffsetMap.json）
class _GridPos {
  final int x;
  final int y;
  const _GridPos(this.x, this.y);
}

/// 像素猫渲染器 — 无状态服务，通过 Provider 暴露为单例。
class PixelCatRenderer {
  /// spritesheet Image 缓存（长期缓存）
  final Map<String, ui.Image> _spritesheetCache = {};

  /// config 数据
  Map<String, _SpriteInfo>? _spritesIndex;
  List<_GridPos>? _offsetMap;
  Map<String, List<int>?>? _tintColors;
  Map<String, List<int>?>? _diluteTintColors;
  Map<String, List<int>?>? _whitePatchesTintColors;
  Map<String, List<String>>? _peltInfo;

  /// 合成结果 LRU 缓存
  final Map<String, ui.Image> _renderCache = {};
  final List<String> _renderCacheKeys = [];
  static const int _maxCacheSize = 50;

  /// sprite 尺寸
  static const int spriteSize = 50;

  // ─── Config 加载 ───

  /// 加载 config JSON（懒加载）。
  /// 成功后 _spritesIndex != null，不再重试。
  /// 失败时保持 null，下次调用自动重试；_drawSprite 等方法有 null guard 安全降级。
  Future<void> _ensureConfigLoaded() async {
    if (_spritesIndex != null) return;

    try {
      final configs = await _loadConfigFiles();
      _parseSpritesIndex(configs.$1);
      _parseOffsetMap(configs.$2);
      _parseTintConfigs(configs.$3, configs.$4);
      _parsePeltInfo(configs.$5);
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'PixelCatRenderer',
        operation: '_ensureConfigLoaded',
      );
      // 不设置默认值 → 下次调用会重试
    }
  }

  Future<(String, String, String, String, String)> _loadConfigFiles() async {
    const base = 'assets/pixel_cat/config';
    return (
      await rootBundle.loadString('$base/spritesIndex.json'),
      await rootBundle.loadString('$base/spritesOffsetMap.json'),
      await rootBundle.loadString('$base/tints/tint.json'),
      await rootBundle.loadString('$base/tints/white_patches_tint.json'),
      await rootBundle.loadString('$base/peltInfo.json'),
    );
  }

  void _parseSpritesIndex(String jsonStr) {
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    _spritesIndex = {
      for (final e in map.entries)
        e.key: _SpriteInfo(
          (e.value as Map<String, dynamic>)['spritesheet'] as String,
          ((e.value as Map<String, dynamic>)['xOffset'] as num).toDouble(),
          ((e.value as Map<String, dynamic>)['yOffset'] as num).toDouble(),
        ),
    };
  }

  void _parseOffsetMap(String jsonStr) {
    final list = json.decode(jsonStr) as List<dynamic>;
    _offsetMap = list
        .cast<Map<String, dynamic>>()
        .map((e) => _GridPos((e['x'] as num).toInt(), (e['y'] as num).toInt()))
        .toList();
  }

  void _parseTintConfigs(String tintJson, String wpTintJson) {
    final tintData = json.decode(tintJson) as Map<String, dynamic>;
    _tintColors = _parseTintMap(
      tintData['tint_colours'] as Map<String, dynamic>?,
    );
    _diluteTintColors = _parseTintMap(
      tintData['dilute_tint_colours'] as Map<String, dynamic>?,
    );

    final wpData = json.decode(wpTintJson) as Map<String, dynamic>;
    _whitePatchesTintColors = _parseTintMap(
      wpData['tint_colours'] as Map<String, dynamic>?,
    );
  }

  void _parsePeltInfo(String jsonStr) {
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    _peltInfo = {
      for (final e in data.entries)
        e.key: (e.value as List<dynamic>).map((v) => v as String).toList(),
    };
  }

  Map<String, List<int>?> _parseTintMap(Map<String, dynamic>? map) {
    if (map == null) return {};
    return {
      for (final e in map.entries)
        e.key: e.value == null
            ? null
            : (e.value as List<dynamic>)
                  .map((v) => (v as num).toInt())
                  .toList(),
    };
  }

  // ─── Spritesheet 加载与绘制 ───

  /// 加载 spritesheet 图片（带缓存）
  Future<ui.Image> _loadSpritesheet(String name) async {
    if (_spritesheetCache.containsKey(name)) {
      return _spritesheetCache[name]!;
    }
    try {
      final data = await rootBundle.load(
        'assets/pixel_cat/spritesheets/$name.png',
      );
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      _spritesheetCache[name] = frame.image;
      return frame.image;
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'PixelCatRenderer',
        operation: '_loadSpritesheet',
        extras: {'spritesheet': name},
      );
      rethrow;
    }
  }

  /// 从 spritesheet 裁切并绘制单个 50×50 sprite 到 canvas
  Future<void> _drawSprite(
    String spriteName,
    int spriteNumber,
    ui.Canvas canvas,
  ) async {
    final index = _spritesIndex;
    final offsets = _offsetMap;
    if (index == null || offsets == null) return;

    final info = index[spriteName];
    if (info == null) return;
    if (spriteNumber < 0 || spriteNumber >= offsets.length) return;

    final grid = offsets[spriteNumber];
    final sheet = await _loadSpritesheet(info.spritesheet);
    final size = spriteSize.toDouble();

    canvas.drawImageRect(
      sheet,
      ui.Rect.fromLTWH(
        info.xOffset + spriteSize * grid.x,
        info.yOffset + spriteSize * grid.y,
        size,
        size,
      ),
      ui.Rect.fromLTWH(0, 0, size, size),
      ui.Paint(),
    );
  }

  /// 在独立层上绘制 sprite 并返回 Image
  Future<ui.Image> _renderSpriteToImage(String spriteName, int spriteNumber) {
    return _renderLayer(
      (canvas) => _drawSprite(spriteName, spriteNumber, canvas),
    );
  }

  // ─── 图像合成基础工具 ───

  /// 在独立画布上执行绘制操作并返回合成图像。
  /// 消除 PictureRecorder + Canvas 模板代码的重复。
  Future<ui.Image> _renderLayer(
    Future<void> Function(ui.Canvas canvas) draw,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    await draw(canvas);
    return recorder.endRecording().toImage(spriteSize, spriteSize);
  }

  // ─── 图像处理工具 ───

  /// 色调叠加（对应 drawTint）
  Future<ui.Image> _applyTint(
    ui.Image source,
    List<int> tintRgb,
    ui.BlendMode blendMode,
  ) async {
    final tintColor = ui.Color.fromARGB(
      255,
      tintRgb[0],
      tintRgb[1],
      tintRgb[2],
    );

    // 生成色调遮罩 → 混合到源图 → 用源图 alpha 裁切
    final tintOverlay = await _renderTintOverlay(source, tintColor);
    final blended = await _blendImages(source, tintOverlay, blendMode);
    return _clipToAlpha(blended, source);
  }

  Future<ui.Image> _renderTintOverlay(ui.Image source, ui.Color color) {
    return _renderLayer((canvas) async {
      canvas.drawImage(source, ui.Offset.zero, ui.Paint());
      canvas.drawRect(
        ui.Rect.fromLTWH(0, 0, spriteSize.toDouble(), spriteSize.toDouble()),
        ui.Paint()
          ..color = color
          ..blendMode = ui.BlendMode.srcIn,
      );
    });
  }

  Future<ui.Image> _blendImages(
    ui.Image base,
    ui.Image overlay,
    ui.BlendMode mode,
  ) {
    return _renderLayer((canvas) async {
      canvas.drawImage(base, ui.Offset.zero, ui.Paint());
      canvas.drawImage(overlay, ui.Offset.zero, ui.Paint()..blendMode = mode);
    });
  }

  Future<ui.Image> _clipToAlpha(ui.Image image, ui.Image alphaSource) {
    return _renderLayer((canvas) async {
      canvas.drawImage(image, ui.Offset.zero, ui.Paint());
      canvas.drawImage(
        alphaSource,
        ui.Offset.zero,
        ui.Paint()..blendMode = ui.BlendMode.dstIn,
      );
    });
  }

  /// 遮罩合成（对应 drawMaskedSprite）
  Future<ui.Image> _renderMaskedSprite(
    String spriteName,
    String maskSpriteName,
    int spriteNumber,
  ) {
    return _renderLayer((canvas) async {
      await _drawSprite(maskSpriteName, spriteNumber, canvas);
      final spriteImage = await _renderSpriteToImage(spriteName, spriteNumber);
      canvas.drawImage(
        spriteImage,
        ui.Offset.zero,
        ui.Paint()..blendMode = ui.BlendMode.srcIn,
      );
    });
  }

  // ─── 渲染管线 ───

  /// 渲染完整的猫猫图像。
  /// 每步完成后 dispose 前一步的中间 Image，释放 native 纹理内存。
  Future<ui.Image> renderCat(
    CatAppearance appearance,
    int spriteIndex, {
    String? accessoryId,
  }) async {
    await _ensureConfigLoaded();

    final cacheKey = '${appearance.cacheKey}:$spriteIndex:$accessoryId';
    if (_renderCache.containsKey(cacheKey)) {
      return _renderCache[cacheKey]!;
    }

    // Layer 1-2：底层皮毛 + 玳瑁叠加
    var image = await _renderBasePelt(appearance, spriteIndex);

    // Layer 3：色调叠加
    var next = await _applyPeltTint(image, appearance);
    if (!identical(next, image)) image.dispose();
    image = next;

    // Layer 4-7：白色斑块 + 重点色 + 白斑病
    next = await _renderOverlays(image, appearance, spriteIndex);
    image.dispose();
    image = next;

    // Layer 8-12：眼睛 + 线稿 + 皮肤
    next = await _renderFaceAndSkin(image, appearance, spriteIndex);
    image.dispose();
    image = next;

    // Layer 13：饰品
    next = await _renderAccessories(
      image,
      appearance,
      spriteIndex,
      accessoryId,
    );
    if (!identical(next, image)) image.dispose();
    image = next;

    // 翻转 + 缓存（_finalizeImage 创建新 image，原 image 可 dispose）
    final result = await _finalizeImage(image, appearance, cacheKey);
    image.dispose();
    return result;
  }

  /// Layer 1-2：底层皮毛 + 玳瑁叠加
  Future<ui.Image> _renderBasePelt(CatAppearance appearance, int spriteIndex) {
    return _renderLayer((canvas) async {
      final spriteName = peltTypeToSpriteName[appearance.peltType] ?? 'single';

      // Layer 1：底色
      final baseSprite = appearance.isTortie
          ? '${appearance.tortieBase ?? "single"}${appearance.peltColor}'
          : '$spriteName${appearance.peltColor}';
      await _drawSprite(baseSprite, spriteIndex, canvas);

      // Layer 2：玳瑁遮罩叠加
      if (appearance.isTortie &&
          appearance.tortiePattern != null &&
          appearance.tortieColor != null) {
        await _drawTortieOverlay(canvas, appearance, spriteIndex);
      }
    });
  }

  Future<void> _drawTortieOverlay(
    ui.Canvas canvas,
    CatAppearance appearance,
    int spriteIndex,
  ) async {
    final index = _spritesIndex;
    if (index == null) return;

    final patternSprite =
        peltTypeToSpriteName[appearance.tortiePattern!] ??
        appearance.tortiePattern!.toLowerCase();
    final tortieSprite = patternSprite.isEmpty
        ? 'single${appearance.tortieColor}'
        : '$patternSprite${appearance.tortieColor}';
    final maskName = 'tortiemask${appearance.tortiePattern}';

    if (!index.containsKey(tortieSprite) || !index.containsKey(maskName)) {
      return;
    }

    final masked = await _renderMaskedSprite(
      tortieSprite,
      maskName,
      spriteIndex,
    );
    canvas.drawImage(masked, ui.Offset.zero, ui.Paint());
  }

  /// Layer 3：色调叠加（tint + dilute）
  Future<ui.Image> _applyPeltTint(
    ui.Image image,
    CatAppearance appearance,
  ) async {
    if (appearance.tint == 'none') return image;

    final tint = _tintColors?[appearance.tint];
    if (tint != null) {
      image = await _applyTint(image, tint, ui.BlendMode.multiply);
    }

    final dilute = _diluteTintColors?[appearance.tint];
    if (dilute != null) {
      image = await _applyTint(image, dilute, ui.BlendMode.plus);
    }

    return image;
  }

  /// Layer 4-7：白色斑块 + 重点色 + 白斑病
  Future<ui.Image> _renderOverlays(
    ui.Image base,
    CatAppearance appearance,
    int spriteIndex,
  ) {
    return _renderLayer((canvas) async {
      canvas.drawImage(base, ui.Offset.zero, ui.Paint());

      // Layer 4-5：白色斑块（含色调）
      if (appearance.whitePatches != null) {
        final wpImage = await _renderTintedWhiteLayer(
          'white${appearance.whitePatches}',
          appearance,
          spriteIndex,
        );
        canvas.drawImage(wpImage, ui.Offset.zero, ui.Paint());
      }

      // Layer 6：重点色（含色调）
      if (appearance.points != null) {
        final pointsImage = await _renderTintedWhiteLayer(
          'white${appearance.points}',
          appearance,
          spriteIndex,
        );
        canvas.drawImage(pointsImage, ui.Offset.zero, ui.Paint());
      }

      // Layer 7：白斑病
      if (appearance.vitiligo != null) {
        await _drawSprite('white${appearance.vitiligo}', spriteIndex, canvas);
      }
    });
  }

  /// 渲染一个白色叠加层并应用白色斑块色调
  Future<ui.Image> _renderTintedWhiteLayer(
    String spriteName,
    CatAppearance appearance,
    int spriteIndex,
  ) async {
    var image = await _renderSpriteToImage(spriteName, spriteIndex);

    if (appearance.whitePatchesTint == 'none') return image;
    final tint = _whitePatchesTintColors?[appearance.whitePatchesTint];
    if (tint != null) {
      image = await _applyTint(image, tint, ui.BlendMode.multiply);
    }
    return image;
  }

  /// Layer 8-12：眼睛 + 线稿 + 皮肤
  Future<ui.Image> _renderFaceAndSkin(
    ui.Image base,
    CatAppearance appearance,
    int spriteIndex,
  ) async {
    // Layer 8：眼睛
    final withEyes = await _renderLayer((canvas) async {
      canvas.drawImage(base, ui.Offset.zero, ui.Paint());
      await _drawSprite('eyes${appearance.eyeColor}', spriteIndex, canvas);
      if (appearance.eyeColor2 != null) {
        await _drawSprite('eyes2${appearance.eyeColor2}', spriteIndex, canvas);
      }
    });

    // Layer 10-12：线稿 + 皮肤（跳过 shading 以优化移动端性能）
    return _renderLayer((canvas) async {
      canvas.drawImage(withEyes, ui.Offset.zero, ui.Paint());
      await _drawSprite('lines', spriteIndex, canvas);
      await _drawSprite('skin${appearance.skinColor}', spriteIndex, canvas);
    });
  }

  /// Layer 13：饰品
  Future<ui.Image> _renderAccessories(
    ui.Image base,
    CatAppearance appearance,
    int spriteIndex,
    String? accessoryId,
  ) async {
    if (accessoryId == null || _peltInfo == null) return base;

    final prefix = _resolveAccessoryPrefix(accessoryId);
    if (prefix == null) return base;

    return _renderLayer((canvas) async {
      canvas.drawImage(base, ui.Offset.zero, ui.Paint());
      await _drawSprite('$prefix$accessoryId', spriteIndex, canvas);
    });
  }

  String? _resolveAccessoryPrefix(String accessoryId) {
    final info = _peltInfo;
    if (info == null) return null;

    if (info['plant_accessories']?.contains(accessoryId) == true) {
      return 'acc_herbs';
    }
    if (info['wild_accessories']?.contains(accessoryId) == true) {
      return 'acc_wild';
    }
    if (info['collars']?.contains(accessoryId) == true) return 'collars';
    return null;
  }

  /// 翻转（如需）+ LRU 缓存
  Future<ui.Image> _finalizeImage(
    ui.Image image,
    CatAppearance appearance,
    String cacheKey,
  ) async {
    final result = await _renderLayer((canvas) async {
      if (appearance.reverse) {
        canvas.scale(-1, 1);
        canvas.drawImage(
          image,
          ui.Offset(-spriteSize.toDouble(), 0),
          ui.Paint(),
        );
      } else {
        canvas.drawImage(image, ui.Offset.zero, ui.Paint());
      }
    });
    _addToCache(cacheKey, result);
    return result;
  }

  void _addToCache(String key, ui.Image image) {
    _renderCache[key] = image;
    _renderCacheKeys.add(key);
    while (_renderCacheKeys.length > _maxCacheSize) {
      _renderCache.remove(_renderCacheKeys.removeAt(0))?.dispose();
    }
  }
}
