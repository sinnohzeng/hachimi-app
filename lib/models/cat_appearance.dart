/// 像素猫外观参数 — 与 pixel-cat-maker 的 Pelt 类型严格对齐。
/// 所有字段在创建时随机生成，之后不可变（饰品除外）。
class CatAppearance {
  /// 皮毛图案类型：Tabby, SingleColour, Marbled, Rosette 等
  final String peltType;

  /// 皮毛颜色：WHITE, PALEGREY, SILVER, DARKGREY 等 19 种
  final String peltColor;

  /// 色调叠加名称，"none" 表示无色调
  final String tint;

  /// 主眼色：YELLOW, AMBER, HAZEL 等 21 种
  final String eyeColor;

  /// 异色瞳第二眼色，null 表示无异色瞳
  final String? eyeColor2;

  /// 白色斑块图案名称，null 表示无白斑
  final String? whitePatches;

  /// 白色斑块色调
  final String whitePatchesTint;

  /// 皮肤颜色：BLACK, PINK, DARKBROWN 等 18 种
  final String skinColor;

  /// 重点色（暹罗猫等），null 表示无
  final String? points;

  /// 白斑病图案，null 表示无
  final String? vitiligo;

  /// 是否为玳瑁/三花猫
  final bool isTortie;

  /// 玳瑁遮罩图案（仅 isTortie 时有效）
  final String? tortiePattern;

  /// 玳瑁底色图案
  final String? tortieBase;

  /// 玳瑁叠加颜色
  final String? tortieColor;

  /// 是否长毛（影响成年期 sprite 选择）
  final bool isLonghair;

  /// 水平翻转
  final bool reverse;

  /// sprite 变体 (0, 1, 2)，每阶段 3 个姿势变体
  final int spriteVariant;

  const CatAppearance({
    required this.peltType,
    required this.peltColor,
    required this.tint,
    required this.eyeColor,
    this.eyeColor2,
    this.whitePatches,
    required this.whitePatchesTint,
    required this.skinColor,
    this.points,
    this.vitiligo,
    required this.isTortie,
    this.tortiePattern,
    this.tortieBase,
    this.tortieColor,
    required this.isLonghair,
    required this.reverse,
    required this.spriteVariant,
  });

  /// 从 Firestore Map 反序列化
  factory CatAppearance.fromMap(Map<String, dynamic> map) {
    return CatAppearance(
      peltType: map['peltType'] as String? ?? 'SingleColour',
      peltColor: map['peltColor'] as String? ?? 'WHITE',
      tint: map['tint'] as String? ?? 'none',
      eyeColor: map['eyeColor'] as String? ?? 'YELLOW',
      eyeColor2: map['eyeColor2'] as String?,
      whitePatches: map['whitePatches'] as String?,
      whitePatchesTint: map['whitePatchesTint'] as String? ?? 'none',
      skinColor: map['skinColor'] as String? ?? 'PINK',
      points: map['points'] as String?,
      vitiligo: map['vitiligo'] as String?,
      isTortie: map['isTortie'] as bool? ?? false,
      tortiePattern: map['tortiePattern'] as String?,
      tortieBase: map['tortieBase'] as String?,
      tortieColor: map['tortieColor'] as String?,
      isLonghair: map['isLonghair'] as bool? ?? false,
      reverse: map['reverse'] as bool? ?? false,
      spriteVariant: map['spriteVariant'] as int? ?? 0,
    );
  }

  /// 序列化为 Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'peltType': peltType,
      'peltColor': peltColor,
      'tint': tint,
      'eyeColor': eyeColor,
      'eyeColor2': eyeColor2,
      'whitePatches': whitePatches,
      'whitePatchesTint': whitePatchesTint,
      'skinColor': skinColor,
      'points': points,
      'vitiligo': vitiligo,
      'isTortie': isTortie,
      'tortiePattern': tortiePattern,
      'tortieBase': tortieBase,
      'tortieColor': tortieColor,
      'isLonghair': isLonghair,
      'reverse': reverse,
      'spriteVariant': spriteVariant,
    };
  }

  /// 渲染缓存键 — 所有外观字段的组合哈希
  String get cacheKey {
    return '$peltType:$peltColor:$tint:$eyeColor:$eyeColor2:'
        '$whitePatches:$whitePatchesTint:$skinColor:$points:'
        '$vitiligo:$isTortie:$tortiePattern:$tortieBase:'
        '$tortieColor:$isLonghair:$reverse:$spriteVariant';
  }

  CatAppearance copyWith({
    String? peltType,
    String? peltColor,
    String? tint,
    String? eyeColor,
    String? eyeColor2,
    String? whitePatches,
    String? whitePatchesTint,
    String? skinColor,
    String? points,
    String? vitiligo,
    bool? isTortie,
    String? tortiePattern,
    String? tortieBase,
    String? tortieColor,
    bool? isLonghair,
    bool? reverse,
    int? spriteVariant,
  }) {
    return CatAppearance(
      peltType: peltType ?? this.peltType,
      peltColor: peltColor ?? this.peltColor,
      tint: tint ?? this.tint,
      eyeColor: eyeColor ?? this.eyeColor,
      eyeColor2: eyeColor2 ?? this.eyeColor2,
      whitePatches: whitePatches ?? this.whitePatches,
      whitePatchesTint: whitePatchesTint ?? this.whitePatchesTint,
      skinColor: skinColor ?? this.skinColor,
      points: points ?? this.points,
      vitiligo: vitiligo ?? this.vitiligo,
      isTortie: isTortie ?? this.isTortie,
      tortiePattern: tortiePattern ?? this.tortiePattern,
      tortieBase: tortieBase ?? this.tortieBase,
      tortieColor: tortieColor ?? this.tortieColor,
      isLonghair: isLonghair ?? this.isLonghair,
      reverse: reverse ?? this.reverse,
      spriteVariant: spriteVariant ?? this.spriteVariant,
    );
  }
}
