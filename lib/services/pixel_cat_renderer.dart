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

  /// 加载 config JSON（懒加载，只执行一次）
  Future<void> _ensureConfigLoaded() async {
    if (_spritesIndex != null) return;

    try {
      final indexJson = await rootBundle.loadString(
        'assets/pixel_cat/config/spritesIndex.json',
      );
      final offsetJson = await rootBundle.loadString(
        'assets/pixel_cat/config/spritesOffsetMap.json',
      );
      final tintJson = await rootBundle.loadString(
        'assets/pixel_cat/config/tints/tint.json',
      );
      final wpTintJson = await rootBundle.loadString(
        'assets/pixel_cat/config/tints/white_patches_tint.json',
      );
      final peltInfoJson = await rootBundle.loadString(
        'assets/pixel_cat/config/peltInfo.json',
      );

      final indexMap = json.decode(indexJson) as Map<String, dynamic>;
      _spritesIndex = {};
      for (final entry in indexMap.entries) {
        final info = entry.value as Map<String, dynamic>;
        _spritesIndex![entry.key] = _SpriteInfo(
          info['spritesheet'] as String,
          (info['xOffset'] as num).toDouble(),
          (info['yOffset'] as num).toDouble(),
        );
      }

      final offsetList = json.decode(offsetJson) as List<dynamic>;
      _offsetMap = offsetList
          .cast<Map<String, dynamic>>()
          .map(
            (e) => _GridPos((e['x'] as num).toInt(), (e['y'] as num).toInt()),
          )
          .toList();

      final tintData = json.decode(tintJson) as Map<String, dynamic>;
      _tintColors = _parseTintMap(
        tintData['tint_colours'] as Map<String, dynamic>?,
      );
      _diluteTintColors = _parseTintMap(
        tintData['dilute_tint_colours'] as Map<String, dynamic>?,
      );

      final wpTintData = json.decode(wpTintJson) as Map<String, dynamic>;
      _whitePatchesTintColors = _parseTintMap(
        wpTintData['tint_colours'] as Map<String, dynamic>?,
      );

      final peltData = json.decode(peltInfoJson) as Map<String, dynamic>;
      _peltInfo = {};
      for (final entry in peltData.entries) {
        _peltInfo![entry.key] = (entry.value as List<dynamic>)
            .map((e) => e as String)
            .toList();
      }
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'PixelCatRenderer',
        operation: '_ensureConfigLoaded',
      );
      // 初始化空默认值防止重复尝试
      _spritesIndex ??= {};
      _offsetMap ??= [];
      _tintColors ??= {};
      _diluteTintColors ??= {};
      _whitePatchesTintColors ??= {};
      _peltInfo ??= {};
    }
  }

  Map<String, List<int>?> _parseTintMap(Map<String, dynamic>? map) {
    if (map == null) return {};
    final result = <String, List<int>?>{};
    for (final entry in map.entries) {
      if (entry.value == null) {
        result[entry.key] = null;
      } else {
        result[entry.key] = (entry.value as List<dynamic>)
            .map((e) => (e as num).toInt())
            .toList();
      }
    }
    return result;
  }

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
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'PixelCatRenderer',
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
    final info = _spritesIndex![spriteName];
    if (info == null) return;

    final grid = _offsetMap![spriteNumber];
    final sheet = await _loadSpritesheet(info.spritesheet);

    final srcRect = ui.Rect.fromLTWH(
      info.xOffset + spriteSize * grid.x,
      info.yOffset + spriteSize * grid.y,
      spriteSize.toDouble(),
      spriteSize.toDouble(),
    );
    final dstRect = ui.Rect.fromLTWH(
      0,
      0,
      spriteSize.toDouble(),
      spriteSize.toDouble(),
    );

    canvas.drawImageRect(sheet, srcRect, dstRect, ui.Paint());
  }

  /// 在独立层上绘制 sprite 并返回 Image
  Future<ui.Image> _renderSpriteToImage(
    String spriteName,
    int spriteNumber,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    await _drawSprite(spriteName, spriteNumber, canvas);
    final picture = recorder.endRecording();
    return picture.toImage(spriteSize, spriteSize);
  }

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

    final tintRecorder = ui.PictureRecorder();
    final tintCanvas = ui.Canvas(tintRecorder);
    tintCanvas.drawImage(source, ui.Offset.zero, ui.Paint());
    tintCanvas.drawRect(
      ui.Rect.fromLTWH(0, 0, spriteSize.toDouble(), spriteSize.toDouble()),
      ui.Paint()
        ..color = tintColor
        ..blendMode = ui.BlendMode.srcIn,
    );
    final tintOverlay = await tintRecorder.endRecording().toImage(
      spriteSize,
      spriteSize,
    );

    final resultRecorder = ui.PictureRecorder();
    final resultCanvas = ui.Canvas(resultRecorder);
    resultCanvas.drawImage(source, ui.Offset.zero, ui.Paint());
    resultCanvas.drawImage(
      tintOverlay,
      ui.Offset.zero,
      ui.Paint()..blendMode = blendMode,
    );

    // 用原图的 alpha 通道裁切结果（保持透明区域）
    final clipRecorder = ui.PictureRecorder();
    final clipCanvas = ui.Canvas(clipRecorder);
    final tintedImage = await resultRecorder.endRecording().toImage(
      spriteSize,
      spriteSize,
    );
    clipCanvas.drawImage(tintedImage, ui.Offset.zero, ui.Paint());
    clipCanvas.drawImage(
      source,
      ui.Offset.zero,
      ui.Paint()..blendMode = ui.BlendMode.dstIn,
    );

    return clipRecorder.endRecording().toImage(spriteSize, spriteSize);
  }

  /// 遮罩合成（对应 drawMaskedSprite）
  Future<ui.Image> _renderMaskedSprite(
    String spriteName,
    String maskSpriteName,
    int spriteNumber,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    await _drawSprite(maskSpriteName, spriteNumber, canvas);
    // srcIn: sprite 只在 mask 不透明区域显示
    final spriteImage = await _renderSpriteToImage(spriteName, spriteNumber);
    canvas.drawImage(
      spriteImage,
      ui.Offset.zero,
      ui.Paint()..blendMode = ui.BlendMode.srcIn,
    );

    return recorder.endRecording().toImage(spriteSize, spriteSize);
  }

  /// 渲染完整的猫猫图像
  ///
  /// [appearance] 猫的外观参数
  /// [spriteIndex] sprite 编号（基于阶段+变体计算）
  /// [accessoryId] 可选的饰品 ID
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

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final spriteName = peltTypeToSpriteName[appearance.peltType] ?? 'single';

    // ── Layer 1: 底层皮毛（base pelt）──
    if (!appearance.isTortie) {
      await _drawSprite(
        '$spriteName${appearance.peltColor}',
        spriteIndex,
        canvas,
      );
    } else {
      final base = appearance.tortieBase ?? 'single';
      await _drawSprite('$base${appearance.peltColor}', spriteIndex, canvas);
    }

    // ── Layer 2: 玳瑁叠加 ──
    if (appearance.isTortie &&
        appearance.tortiePattern != null &&
        appearance.tortieColor != null) {
      var tPattern = appearance.tortiePattern!;
      // Single → SingleColour 映射
      final patternSprite =
          peltTypeToSpriteName[tPattern] ?? tPattern.toLowerCase();
      final tortieSpriteName = patternSprite.isEmpty
          ? 'single${appearance.tortieColor}'
          : '$patternSprite${appearance.tortieColor}';
      final maskName = 'tortiemask${appearance.tortiePattern}';

      if (_spritesIndex!.containsKey(tortieSpriteName) &&
          _spritesIndex!.containsKey(maskName)) {
        final masked = await _renderMaskedSprite(
          tortieSpriteName,
          maskName,
          spriteIndex,
        );
        canvas.drawImage(masked, ui.Offset.zero, ui.Paint());
      }
    }

    var currentImage = await recorder.endRecording().toImage(
      spriteSize,
      spriteSize,
    );

    // ── Layer 3: 色调叠加（tint）──
    if (appearance.tint != 'none') {
      if (_tintColors != null && _tintColors!.containsKey(appearance.tint)) {
        final tint = _tintColors![appearance.tint];
        if (tint != null) {
          currentImage = await _applyTint(
            currentImage,
            tint,
            ui.BlendMode.multiply,
          );
        }
      }
      if (_diluteTintColors != null &&
          _diluteTintColors!.containsKey(appearance.tint)) {
        final tint = _diluteTintColors![appearance.tint];
        if (tint != null) {
          currentImage = await _applyTint(
            currentImage,
            tint,
            ui.BlendMode.plus,
          );
        }
      }
    }

    final mainRecorder = ui.PictureRecorder();
    final mainCanvas = ui.Canvas(mainRecorder);
    mainCanvas.drawImage(currentImage, ui.Offset.zero, ui.Paint());

    // ── Layer 4: 白色斑块 ──
    if (appearance.whitePatches != null) {
      final wpRecorder = ui.PictureRecorder();
      final wpCanvas = ui.Canvas(wpRecorder);
      await _drawSprite(
        'white${appearance.whitePatches}',
        spriteIndex,
        wpCanvas,
      );
      var wpImage = await wpRecorder.endRecording().toImage(
        spriteSize,
        spriteSize,
      );

      // ── Layer 5: 白色斑块色调 ──
      if (appearance.whitePatchesTint != 'none' &&
          _whitePatchesTintColors != null &&
          _whitePatchesTintColors!.containsKey(appearance.whitePatchesTint)) {
        final tint = _whitePatchesTintColors![appearance.whitePatchesTint];
        if (tint != null) {
          wpImage = await _applyTint(wpImage, tint, ui.BlendMode.multiply);
        }
      }

      mainCanvas.drawImage(wpImage, ui.Offset.zero, ui.Paint());
    }

    // ── Layer 6: 重点色（points）──
    if (appearance.points != null) {
      final ptRecorder = ui.PictureRecorder();
      final ptCanvas = ui.Canvas(ptRecorder);
      await _drawSprite('white${appearance.points}', spriteIndex, ptCanvas);
      var ptImage = await ptRecorder.endRecording().toImage(
        spriteSize,
        spriteSize,
      );

      if (appearance.whitePatchesTint != 'none' &&
          _whitePatchesTintColors != null &&
          _whitePatchesTintColors!.containsKey(appearance.whitePatchesTint)) {
        final tint = _whitePatchesTintColors![appearance.whitePatchesTint];
        if (tint != null) {
          ptImage = await _applyTint(ptImage, tint, ui.BlendMode.multiply);
        }
      }

      mainCanvas.drawImage(ptImage, ui.Offset.zero, ui.Paint());
    }

    // ── Layer 7: 白斑病（vitiligo）──
    if (appearance.vitiligo != null) {
      await _drawSprite('white${appearance.vitiligo}', spriteIndex, mainCanvas);
    }

    // ── Layer 8: 眼睛 ──
    await _drawSprite('eyes${appearance.eyeColor}', spriteIndex, mainCanvas);
    if (appearance.eyeColor2 != null) {
      await _drawSprite(
        'eyes2${appearance.eyeColor2}',
        spriteIndex,
        mainCanvas,
      );
    }

    // ── Layer 9: 伤疤（跳过 — Hachimi 不使用伤疤系统）──

    // ── Layer 10-11: 明暗 + 线稿 ──
    final preShadingImage = await mainRecorder.endRecording().toImage(
      spriteSize,
      spriteSize,
    );

    final finalRecorder = ui.PictureRecorder();
    final finalCanvas = ui.Canvas(finalRecorder);
    finalCanvas.drawImage(preShadingImage, ui.Offset.zero, ui.Paint());

    // 简化：跳过 shading 以优化移动端性能，直接绘制线稿
    await _drawSprite('lines', spriteIndex, finalCanvas);

    // ── Layer 12: 皮肤 ──
    await _drawSprite('skin${appearance.skinColor}', spriteIndex, finalCanvas);

    // ── Layer 13: 饰品 ──
    if (accessoryId != null && _peltInfo != null) {
      if (_peltInfo!['plant_accessories']?.contains(accessoryId) == true) {
        await _drawSprite('acc_herbs$accessoryId', spriteIndex, finalCanvas);
      } else if (_peltInfo!['wild_accessories']?.contains(accessoryId) ==
          true) {
        await _drawSprite('acc_wild$accessoryId', spriteIndex, finalCanvas);
      } else if (_peltInfo!['collars']?.contains(accessoryId) == true) {
        await _drawSprite('collars$accessoryId', spriteIndex, finalCanvas);
      }
    }

    final outRecorder = ui.PictureRecorder();
    final outCanvas = ui.Canvas(outRecorder);
    final layeredImage = await finalRecorder.endRecording().toImage(
      spriteSize,
      spriteSize,
    );

    if (appearance.reverse) {
      outCanvas.scale(-1, 1);
      outCanvas.drawImage(
        layeredImage,
        ui.Offset(-spriteSize.toDouble(), 0),
        ui.Paint(),
      );
    } else {
      outCanvas.drawImage(layeredImage, ui.Offset.zero, ui.Paint());
    }

    final result = await outRecorder.endRecording().toImage(
      spriteSize,
      spriteSize,
    );

    _renderCache[cacheKey] = result;
    _renderCacheKeys.add(cacheKey);
    while (_renderCacheKeys.length > _maxCacheSize) {
      final evicted = _renderCacheKeys.removeAt(0);
      _renderCache.remove(evicted);
    }

    return result;
  }
}
