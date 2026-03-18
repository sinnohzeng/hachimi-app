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
    final pelt = _randomPeltType();
    final eyes = _randomEyeColors();
    final white = _randomWhitePatches();
    final tint = _randomTint();
    final skinColor = _choice(skinColors);

    // Points ~10%（仅无白斑时）
    String? points;
    if (white.patches == null && _random.nextDouble() < 0.10) {
      points = _choice(pointMarkings);
    }

    // Vitiligo ~5%
    String? vitiligo;
    if (_random.nextDouble() < 0.05) {
      vitiligo = _choice(vitiligoPatterns);
    }

    final tortie = _randomTortieParams(pelt.isTortie, pelt.peltColor);

    return CatAppearance(
      peltType: pelt.isTortie
          ? (pelt.peltType == 'Calico' ? 'Calico' : 'Tortie')
          : pelt.peltType,
      peltColor: pelt.peltColor,
      tint: tint,
      eyeColor: eyes.primary,
      eyeColor2: eyes.secondary,
      whitePatches: white.patches,
      whitePatchesTint: white.tint,
      skinColor: skinColor,
      points: points,
      vitiligo: vitiligo,
      isTortie: pelt.isTortie,
      tortiePattern: tortie.pattern,
      tortieBase: tortie.base,
      tortieColor: tortie.color,
      isLonghair: _random.nextDouble() < 0.20,
      reverse: _random.nextBool(),
      spriteVariant: _random.nextInt(3),
    );
  }

  /// 皮毛类型 + 玳瑁判定。
  ({String peltType, String peltColor, bool isTortie}) _randomPeltType() {
    final categoryWeights = [0.35, 0.15, 0.35, 0.15];
    final categories = [tabbies, spotted, plain, exotic];
    final category = _weightedChoice(categories, categoryWeights);
    var peltType = _choice(category);
    final isTortie = _random.nextDouble() < 0.15;
    if (isTortie) {
      peltType = _random.nextBool() ? 'Tortie' : 'Calico';
    }
    final peltColor = _choice(peltColors);
    return (peltType: peltType, peltColor: peltColor, isTortie: isTortie);
  }

  /// 眼色 + 异色瞳（~10%）。
  ({String primary, String? secondary}) _randomEyeColors() {
    final primary = _choice(eyeColors);
    String? secondary;
    if (_random.nextDouble() < 0.10) {
      secondary = _choice(eyeColors.where((e) => e != primary).toList());
    }
    return (primary: primary, secondary: secondary);
  }

  /// 白色斑块（~60%）+ 白斑色调。
  ({String? patches, String tint}) _randomWhitePatches() {
    String? patches;
    if (_random.nextDouble() < 0.60) {
      final wpGroups = [littleWhite, midWhite, highWhite, mostlyWhite];
      final wpWeights = [0.35, 0.30, 0.25, 0.10];
      final group = _weightedChoice(wpGroups, wpWeights);
      patches = _choice(group);
    }
    return (patches: patches, tint: _choice(whitePatchesTints));
  }

  /// 色调（~30%）。
  String _randomTint() {
    if (_random.nextDouble() < 0.30) {
      return _choice([
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
    return 'none';
  }

  /// 玳瑁参数（仅 isTortie 时生成）。
  ({String? pattern, String? base, String? color}) _randomTortieParams(
    bool isTortie,
    String peltColor,
  ) {
    if (!isTortie) return (pattern: null, base: null, color: null);
    final pattern = _choice(tortiePatterns);
    final base = _choice(tortieBases);
    String color;
    if (gingerColors.contains(peltColor)) {
      color = _choice(blackColors);
    } else if (blackColors.contains(peltColor)) {
      color = _choice(gingerColors);
    } else {
      color = _choice([...gingerColors, ...blackColors]);
    }
    return (pattern: pattern, base: base, color: color);
  }

  /// 生成完整的 Cat 对象
  Cat generateCat({required String boundHabitId}) {
    final appearance = generateRandomAppearance();
    final personality = _choice(catPersonalities);
    final name = _choice(randomCatNames);

    return Cat(
      id: '', // Firestore 分配
      name: name,
      personality: personality.id,
      appearance: appearance,
      totalMinutes: 0,
      boundHabitId: boundHabitId,
      state: CatState.active.value,
      createdAt: DateTime.now(),
    );
  }
}
