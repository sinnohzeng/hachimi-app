import 'dart:math';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

class PixelCatGenerationService {
  final _random = Random();

  T _choice<T>(List<T> list) => list[_random.nextInt(list.length)];

  /// 加权随机选择
  T _weightedChoice<T>(List<T> items, List<double> weights) {
    final total = weights.fold(0.0, (a, b) => a + b);
    var roll = _random.nextDouble() * total;
    for (int i = 0; i < items.length; i++) {
      roll -= weights[i];
      if (roll <= 0) return items[i];
    }
    return items.last;
  }

  /// 生成随机外观
  CatAppearance generateRandomAppearance() {
    // 选择皮毛类型（按类别加权）
    final categoryWeights = [
      0.35,
      0.15,
      0.35,
      0.15,
    ]; // tabby, spotted, plain, exotic
    final categories = [tabbies, spotted, plain, exotic];
    final category = _weightedChoice(categories, categoryWeights);
    var peltType = _choice(category);

    // 玳瑁 ~15%
    final isTortie = _random.nextDouble() < 0.15;
    if (isTortie) {
      peltType = _random.nextBool() ? 'Tortie' : 'Calico';
    }

    // 皮毛颜色
    final peltColor = _choice(peltColors);

    // 眼色
    final eyeColor = _choice(eyeColors);

    // 异色瞳 ~10%
    String? eyeColor2;
    if (_random.nextDouble() < 0.10) {
      eyeColor2 = _choice(eyeColors.where((e) => e != eyeColor).toList());
    }

    // 白色斑块 ~60%
    String? whitePatches;
    if (_random.nextDouble() < 0.60) {
      final wpGroups = [littleWhite, midWhite, highWhite, mostlyWhite];
      final wpWeights = [0.35, 0.30, 0.25, 0.10];
      final group = _weightedChoice(wpGroups, wpWeights);
      whitePatches = _choice(group);
    }

    // 白斑色调
    final whitePatchesTint = _choice(whitePatchesTints);

    // 色调 ~30%
    String tint = 'none';
    if (_random.nextDouble() < 0.30) {
      tint = _choice([
        'pink',
        'gray',
        'red',
        'orange',
        'yellow',
        'purple',
        'blue',
        'black',
        'dilute',
        'warmdilute',
        'cooldilute',
      ]);
    }

    // 皮肤色
    final skinColor = _choice(skinColors);

    // Points ~10%
    String? points;
    if (whitePatches == null && _random.nextDouble() < 0.10) {
      points = _choice(pointMarkings);
    }

    // Vitiligo ~5%
    String? vitiligo;
    if (_random.nextDouble() < 0.05) {
      vitiligo = _choice(vitiligoPatterns);
    }

    // 玳瑁参数
    String? tortiePattern;
    String? tortieBase;
    String? tortieColor;
    if (isTortie) {
      tortiePattern = _choice(tortiePatterns);
      tortieBase = _choice(tortieBases);
      // 互补色选择
      if (gingerColors.contains(peltColor)) {
        tortieColor = _choice(blackColors);
      } else if (blackColors.contains(peltColor)) {
        tortieColor = _choice(gingerColors);
      } else {
        tortieColor = _choice([...gingerColors, ...blackColors]);
      }
    }

    // 长毛 ~20%
    final isLonghair = _random.nextDouble() < 0.20;

    // 朝向翻转 50%
    final reverse = _random.nextBool();

    // sprite 变体 (0, 1, 2)
    final spriteVariant = _random.nextInt(3);

    return CatAppearance(
      peltType: isTortie
          ? (peltType == 'Calico' ? 'Calico' : 'Tortie')
          : peltType,
      peltColor: peltColor,
      tint: tint,
      eyeColor: eyeColor,
      eyeColor2: eyeColor2,
      whitePatches: whitePatches,
      whitePatchesTint: whitePatchesTint,
      skinColor: skinColor,
      points: points,
      vitiligo: vitiligo,
      isTortie: isTortie,
      tortiePattern: tortiePattern,
      tortieBase: tortieBase,
      tortieColor: tortieColor,
      isLonghair: isLonghair,
      reverse: reverse,
      spriteVariant: spriteVariant,
    );
  }

  /// 生成完整的 Cat 对象
  Cat generateCat({required String boundHabitId, required int targetMinutes}) {
    final appearance = generateRandomAppearance();
    final personality = _choice(catPersonalities);
    final name = _choice(randomCatNames);

    return Cat(
      id: '', // Firestore 分配
      name: name,
      personality: personality.id,
      appearance: appearance,
      totalMinutes: 0,
      targetMinutes: targetMinutes,
      boundHabitId: boundHabitId,
      state: 'active',
      createdAt: DateTime.now(),
    );
  }
}
