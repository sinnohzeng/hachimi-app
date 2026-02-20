// ---
// 📘 文件说明：
// 像素猫参数枚举常量 — 与 pixel-cat-maker 项目严格对齐。
// 涵盖皮毛类型、颜色、眼色、白斑、饰品等全部参数空间。
//
// 📋 程序整体伪代码：
// 1. 定义皮毛图案类型列表；
// 2. 定义颜色/眼色/皮肤色枚举；
// 3. 定义白斑/玳瑁/饰品类别；
// 4. 定义 sprite 索引计算逻辑；
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:flutter/material.dart';

// ─── Pelt Types（皮毛图案类型） ───
// 对应 pixel-cat-maker inheritance.ts 中的分类

/// 虎斑类图案
const List<String> tabbies = [
  'Tabby', 'Ticked', 'Mackerel', 'Classic', 'Sokoke', 'Agouti',
];

/// 斑点类图案
const List<String> spotted = [
  'Speckled', 'Rosette',
];

/// 纯色类图案
const List<String> plain = [
  'SingleColour', 'TwoColour', 'Smoke', 'Singlestripe',
];

/// 特殊类图案
const List<String> exotic = [
  'Bengal', 'Marbled', 'Masked',
];

/// 所有皮毛图案类型
const List<String> allPeltTypes = [
  ...tabbies, ...spotted, ...plain, ...exotic,
];

/// 皮毛类型 → sprite 名称映射
const Map<String, String> peltTypeToSpriteName = {
  'Tabby': 'tabby',
  'Ticked': 'ticked',
  'Mackerel': 'mackerel',
  'Classic': 'classic',
  'Sokoke': 'sokoke',
  'Agouti': 'agouti',
  'Speckled': 'speckled',
  'Rosette': 'rosette',
  'SingleColour': 'single',
  'TwoColour': 'single',
  'Smoke': 'smoke',
  'Singlestripe': 'singlestripe',
  'Bengal': 'bengal',
  'Marbled': 'marbled',
  'Masked': 'masked',
  'Tortie': '',
  'Calico': '',
};

// ─── Pelt Colors（皮毛颜色）───

const List<String> peltColors = [
  'WHITE', 'PALEGREY', 'SILVER', 'GREY', 'DARKGREY',
  'GHOST', 'BLACK',
  'CREAM', 'PALEGINGER', 'GOLDEN', 'GINGER', 'DARKGINGER',
  'SIENNA',
  'LIGHTBROWN', 'LILAC', 'BROWN', 'GOLDEN-BROWN', 'DARKBROWN',
  'CHOCOLATE',
];

/// 颜色分组 — 用于玳瑁生成时的互补色选择
const List<String> gingerColors = [
  'CREAM', 'PALEGINGER', 'GOLDEN', 'GINGER', 'DARKGINGER', 'SIENNA',
];

const List<String> blackColors = [
  'GREY', 'DARKGREY', 'GHOST', 'BLACK',
];

const List<String> whiteColors = [
  'WHITE', 'PALEGREY', 'SILVER',
];

const List<String> brownColors = [
  'LIGHTBROWN', 'LILAC', 'BROWN', 'GOLDEN-BROWN', 'DARKBROWN', 'CHOCOLATE',
];

// ─── Eye Colors（眼色）───

const List<String> eyeColors = [
  'YELLOW', 'AMBER', 'HAZEL',
  'PALEGREEN', 'GREEN', 'BLUE', 'DARKBLUE', 'BLUEYELLOW', 'BLUEGREEN',
  'GREY', 'CYAN', 'EMERALD', 'HEATHERBLUE', 'SUNLITICE',
  'COPPER', 'SAGE', 'COBALT', 'PALEBLUE',
  'BRONZE', 'SILVER', 'PALEYELLOW',
];

const List<String> yellowEyes = ['YELLOW', 'AMBER', 'PALEYELLOW'];
const List<String> blueEyes = ['BLUE', 'DARKBLUE', 'CYAN', 'PALEBLUE', 'COBALT', 'HEATHERBLUE', 'SUNLITICE'];
const List<String> greenEyes = ['PALEGREEN', 'GREEN', 'EMERALD', 'SAGE'];

// ─── Skin Colors（皮肤色）───

const List<String> skinColors = [
  'BLACK', 'RED', 'PINK', 'DARKBROWN', 'BROWN', 'LIGHTBROWN',
  'DARK', 'DARKGREY', 'GREY', 'DARKSALMON', 'SALMON', 'PEACH',
  'DARKMARBLED', 'MARBLED', 'LIGHTMARBLED',
  'DARKBLUE', 'BLUE', 'LIGHTBLUE',
];

// ─── White Patches（白色斑块）───

const List<String> littleWhite = [
  'LITTLE', 'LIGHTTUXEDO', 'BUZZARDFANG', 'TIP', 'BLAZE', 'BIB',
  'VEE', 'PAWS', 'BELLY', 'TAILTIP', 'TOES', 'BROKENBLAZE',
  'LILTWO', 'SCOURGE', 'TOESTAIL', 'RAVENPAW', 'HONEY', 'LUNA',
  'EXTRA', 'MUSTACHE', 'REVERSEHEART', 'SPARKLE', 'RIGHTEAR',
  'LEFTEAR', 'ESTRELLA', 'REVERSEEYE', 'BACKSPOT',
  'EYEBAGS', 'LOCKET', 'BLAZEMASK', 'TEARS',
];

const List<String> midWhite = [
  'TUXEDO', 'FANCY', 'UNDERS', 'DAMIEN', 'SKUNK',
  'MITAINE', 'SQUEAKS', 'STAR',
  'WINGS', 'DIVA', 'SAVANNAH', 'FADESPOTS', 'BEARD',
  'DAPPLEPAW', 'TOPCOVER', 'WOODPECKER', 'MISS', 'BOWTIE',
  'PRINCESS', 'MISTER', 'BRINDLE', 'CURVED', 'HEART',
  'HALFWHITE', 'APPALOOSA', 'HALF', 'PETAL',
];

const List<String> highWhite = [
  'ANY', 'ANYTWO', 'BROKEN', 'FRECKLES', 'RINGTAIL',
  'HALFFACE', 'PANTSTWO', 'GOATEE', 'PRINCE', 'FAROFA',
  'MOUSTACHE', 'PANTS', 'REVERSEPANTS', 'SKUNK',
  'KARPATI', 'PIEBALD', 'CURVED', 'GLASS',
  'MASKMANTLE', 'MAO', 'PAINTED', 'SHIBAINU', 'OWL',
  'BUB', 'SPARROW', 'TRIXIE', 'SAMMY', 'FRONT',
  'BLOSSOMSTEP', 'BULLSEYE', 'FINN', 'SCAR', 'BUSTER',
];

const List<String> mostlyWhite = [
  'VAN', 'ONEEAR', 'LIGHTSONG', 'TAIL', 'HEART',
  'MOORISH', 'APRON', 'CAPSADDLE', 'CHESTSPECK',
  'BLACKSTAR', 'PETAL', 'HEARTTWO', 'WOODPECKER',
  'BOOTS', 'COW', 'COWTWO', 'BUB', 'BOWTIE',
  'EYEPATCH', 'PEBBLE', 'PEBBLETWO', 'PEBBBLETHREE',
];

const List<String> allWhitePatches = [
  'FULLWHITE', ...littleWhite, ...midWhite, ...highWhite, ...mostlyWhite,
];

// ─── Points（重点色）───

const List<String> pointMarkings = [
  'COLOURPOINT', 'RAGDOLL', 'SEPIAPOINT', 'MINKPOINT', 'SEALPOINT',
];

// ─── Vitiligo（白斑病）───

const List<String> vitiligoPatterns = [
  'VITILIGO', 'VITILIGOTWO', 'MOON', 'PHANTOM',
  'KOI', 'PAINTED', 'BLEACHED', 'SMOKEY',
];

// ─── Tortie Patterns（玳瑁遮罩）───

const List<String> tortiePatterns = [
  'ONE', 'TWO', 'THREE', 'FOUR', 'REDTAIL', 'DELILAH', 'MINIMALONE',
  'MINIMALTWO', 'MINIMALTHREE', 'MINIMALFOUR', 'HALF', 'OREO',
  'SWOOP', 'MOTTLED', 'SIDEMASK', 'EYEDOT', 'BANDANA', 'PACMAN',
  'STREAMSTRIKE', 'ROBIN', 'BRINDLE', 'EMBER', 'ORIOLE', 'CHIMERA',
  'DAUB', 'DAUBPAW', 'TOPBAR', 'STREAK', 'MASK', 'CHEST',
  'ARMTAIL', 'SMOKE', 'GRUMPYFACE', 'BRIE', 'BELOVED', 'BODY',
  'SHILOH', 'FRECKLED', 'HEARTBEAT',
  'SMUDGED', 'BULLSEYE', 'SPARROW', 'PHANTOM',
  'ROSETAIL',
];

/// 玳瑁底色图案 — tortieBase 用的 spriteName
const List<String> tortieBases = [
  'single', 'tabby', 'bengal', 'marbled', 'ticked', 'smoke',
  'rosette', 'speckled', 'mackerel', 'classic', 'sokoke',
  'agouti', 'singlestripe', 'masked',
];

// ─── White Patches Tint（白斑色调）───

const List<String> whitePatchesTints = [
  'none', 'offwhite', 'cream', 'darkcream',
  'gray', 'pink',
];

// ─── Accessories（饰品）───
// 分三大类，每类有 spritesIndex 对应的 sprite 前缀

/// 植物类饰品
const List<String> plantAccessories = [
  'MAPLE LEAF', 'HOLLY', 'BLUE BERRIES', 'FORGET ME NOTS',
  'RYE STALK', 'CATTAIL', 'POPPY', 'ORANGE POPPY', 'CYAN POPPY',
  'WHITE POPPY', 'PINK POPPY', 'BLUEBELLS', 'LILY OF THE VALLEY',
  'SNAPDRAGON', 'HERBS', 'PETALS', 'NETTLE', 'HEATHER', 'GORSE',
  'JUNIPER', 'RASPBERRY', 'LAVENDER', 'OAK LEAVES', 'CATMINT',
  'MAPLE SEED', 'LAUREL',
  'BULB WHITE', 'BULB YELLOW', 'BULB ORANGE', 'BULB PINK', 'BULB BLUE',
  'CLOVER', 'DAISY',
  'DRY HERBS', 'DRY CATMINT', 'DRY NETTLES', 'DRY LAURELS',
];

/// 野生类饰品
const List<String> wildAccessories = [
  'RED FEATHERS', 'BLUE FEATHERS', 'JAY FEATHERS', 'GULL FEATHERS',
  'SPARROW FEATHERS', 'MOTH WINGS', 'ROSY MOTH WINGS',
  'MORPHO BUTTERFLY', 'MONARCH BUTTERFLY', 'CICADA WINGS', 'BLACK CICADA',
];

/// 项圈类饰品 — 4 种样式 × 15 种颜色
const List<String> collarColors = [
  'CRIMSON', 'BLUE', 'YELLOW', 'CYAN', 'RED', 'LIME', 'GREEN',
  'RAINBOW', 'BLACK', 'SPIKES', 'WHITE', 'PINK', 'PURPLE', 'MULTI', 'INDIGO',
];

const List<String> collarStyles = ['', 'BELL', 'BOW', 'NYLON'];

/// 所有饰品（用于商店展示）
List<String> get allAccessories => [
  ...plantAccessories,
  ...wildAccessories,
  for (final style in collarStyles)
    for (final color in collarColors)
      '$color$style',
];

// ─── Streak Milestones ───

/// 连续签到里程碑天数 — 达到时给予一次性 XP 奖励。
const List<int> streakMilestones = [7, 14, 30];

/// 连续签到里程碑 XP 奖励。
const int streakMilestoneXpBonus = 30;

/// 签到金币：工作日（周一至周五）
const int checkInCoinsWeekday = 10;

/// 签到金币：周末（周六、周日）
const int checkInCoinsWeekend = 15;

/// 月度签到里程碑 — 累计天数 → 一次性奖励金币。
const Map<int, int> checkInMilestones = {
  7: 30,
  14: 50,
  21: 80,
};

/// 全月签到奖励（签满该月所有天数）。
const int checkInFullMonthBonus = 150;

/// 专注奖励：每分钟 +10 金币
const int focusRewardCoinsPerMinute = 10;

// ─── Accessory Pricing（饰品梯度定价）───
// 每日签到约 10-15 金币 + 里程碑奖励。Budget ≈ 几天，Legendary ≈ 数周。

/// Budget 级植物（50 金币）
const List<String> _budgetPlants = [
  'MAPLE LEAF', 'HOLLY', 'HERBS', 'PETALS', 'CLOVER', 'DAISY',
  'RYE STALK', 'CATTAIL', 'NETTLE', 'HEATHER', 'GORSE',
  'DRY HERBS', 'DRY CATMINT', 'DRY NETTLES', 'DRY LAURELS',
];

/// Standard 级植物（100 金币）
const List<String> _standardPlants = [
  'BLUE BERRIES', 'FORGET ME NOTS', 'POPPY', 'ORANGE POPPY', 'CYAN POPPY',
  'WHITE POPPY', 'PINK POPPY', 'BLUEBELLS', 'SNAPDRAGON', 'RASPBERRY', 'LAUREL',
];

/// Premium 级植物（150 金币）
const List<String> _premiumPlants = [
  'LAVENDER', 'CATMINT', 'JUNIPER',
  'BULB WHITE', 'BULB YELLOW', 'BULB ORANGE', 'BULB PINK', 'BULB BLUE',
];

/// Legendary 级植物（350 金币）
const List<String> _legendaryPlants = [
  'LILY OF THE VALLEY', 'OAK LEAVES', 'MAPLE SEED',
];

/// Legendary 级项圈颜色（所有样式均 350 金币）
const Set<String> _legendaryCollarColors = {'RAINBOW', 'SPIKES', 'MULTI'};

/// 饰品梯度价格表 — 根据稀有度分级定价。
/// Budget: 50, Standard: 100, Premium: 150, Rare: 250, Legendary: 350
Map<String, int> get accessoryPriceMap {
  final map = <String, int>{};

  for (final id in _budgetPlants) {
    map[id] = 50;
  }
  for (final id in _standardPlants) {
    map[id] = 100;
  }
  for (final id in _premiumPlants) {
    map[id] = 150;
  }
  for (final id in _legendaryPlants) {
    map[id] = 350;
  }
  for (final id in wildAccessories) {
    map[id] = 250;
  }

  // 项圈定价：Legendary 颜色 > NYLON > BELL/BOW > 普通
  for (final style in collarStyles) {
    for (final color in collarColors) {
      final id = '$color$style';
      if (_legendaryCollarColors.contains(color)) {
        map[id] = 350;
      } else if (style == 'NYLON') {
        map[id] = 250;
      } else if (style == 'BELL' || style == 'BOW') {
        map[id] = 150;
      } else {
        map[id] = 100;
      }
    }
  }

  return map;
}

/// 获取饰品价格，未在价格表中则返回 150（默认值）。
int accessoryPrice(String accessoryId) =>
    accessoryPriceMap[accessoryId] ?? 150;

/// 饰品 ID → 可读显示名称。
String accessoryDisplayName(String id) {
  // 植物和野生饰品：直接 title case
  if (plantAccessories.contains(id) || wildAccessories.contains(id)) {
    return id
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  // 项圈：解析 color + style
  for (final style in collarStyles.reversed) {
    if (style.isNotEmpty && id.endsWith(style)) {
      final color = id.substring(0, id.length - style.length);
      final colorName =
          color[0].toUpperCase() + color.substring(1).toLowerCase();
      final styleName =
          style[0].toUpperCase() + style.substring(1).toLowerCase();
      return '$colorName $styleName Collar';
    }
  }
  // 普通项圈（无样式后缀）
  if (collarColors.contains(id)) {
    final colorName = id[0].toUpperCase() + id.substring(1).toLowerCase();
    return '$colorName Collar';
  }

  return id;
}

/// 判断饰品类别：'plant' / 'wild' / 'collar'
String accessoryCategory(String id) {
  if (plantAccessories.contains(id)) return 'plant';
  if (wildAccessories.contains(id)) return 'wild';
  return 'collar';
}

// ─── Pelt Color → Material Color 映射 ───

/// 将 peltColor ID 映射到柔和的 Material 颜色，用于 CatDetailScreen 背景渐变。
Color peltColorToMaterial(String peltColor) {
  switch (peltColor) {
    // 白/灰系
    case 'WHITE':
      return const Color(0xFFE0E0E0);
    case 'PALEGREY':
      return const Color(0xFFB0BEC5);
    case 'SILVER':
      return const Color(0xFF90A4AE);
    case 'GREY':
      return const Color(0xFF78909C);
    case 'DARKGREY':
      return const Color(0xFF607D8B);
    case 'GHOST':
      return const Color(0xFF546E7A);
    // 黑色 — 提亮以保证渐变可视性
    case 'BLACK':
      return const Color(0xFF455A64);
    // 橘/奶油系
    case 'CREAM':
      return const Color(0xFFFFE0B2);
    case 'PALEGINGER':
      return const Color(0xFFFFCC80);
    case 'GOLDEN':
      return const Color(0xFFFFB74D);
    case 'GINGER':
      return const Color(0xFFFF9800);
    case 'DARKGINGER':
      return const Color(0xFFF57C00);
    case 'SIENNA':
      return const Color(0xFFE65100);
    // 棕色系
    case 'LIGHTBROWN':
      return const Color(0xFFBCAAA4);
    case 'LILAC':
      return const Color(0xFFB39DDB);
    case 'BROWN':
      return const Color(0xFF8D6E63);
    case 'GOLDEN-BROWN':
      return const Color(0xFFA1887F);
    case 'DARKBROWN':
      return const Color(0xFF6D4C41);
    case 'CHOCOLATE':
      return const Color(0xFF4E342E);
    default:
      return const Color(0xFFB0BEC5);
  }
}

// ─── Sprite Index 计算 ───

/// 根据成长阶段和外观参数计算 spriteIndex。
///
/// Sprite 编号布局（3 变体/阶段）：
/// - 0-2: kitten
/// - 3-5: adolescent
/// - 6-8: adult (shorthair)
/// - 9-11: adult (longhair)
/// - 12-14: senior
int computeSpriteIndex({
  required String stage,
  required int variant,
  required bool isLonghair,
}) {
  final v = variant.clamp(0, 2);
  switch (stage) {
    case 'kitten':
      return 0 + v;
    case 'adolescent':
      return 3 + v;
    case 'adult':
      return (isLonghair ? 9 : 6) + v;
    case 'senior':
      return 12 + v;
    default:
      return 0 + v;
  }
}

/// 成长阶段百分比阈值
const Map<String, double> stageThresholds = {
  'kitten': 0.0,
  'adolescent': 0.20,
  'adult': 0.45,
  'senior': 0.75,
};

/// 根据进度百分比计算成长阶段
String stageForProgress(double progress) {
  if (progress >= 0.75) return 'senior';
  if (progress >= 0.45) return 'adult';
  if (progress >= 0.20) return 'adolescent';
  return 'kitten';
}

/// 计算当前阶段内的进度（0.0-1.0）
double stageProgressInRange(double progress) {
  final stage = stageForProgress(progress);
  final currentThreshold = stageThresholds[stage]!;

  // 查找下一阶段阈值
  final stages = ['kitten', 'adolescent', 'adult', 'senior'];
  final currentIndex = stages.indexOf(stage);
  if (currentIndex >= stages.length - 1) {
    // senior: 从 0.75 到 1.0
    return ((progress - 0.75) / 0.25).clamp(0.0, 1.0);
  }
  final nextThreshold = stageThresholds[stages[currentIndex + 1]]!;
  final range = nextThreshold - currentThreshold;
  if (range <= 0) return 1.0;
  return ((progress - currentThreshold) / range).clamp(0.0, 1.0);
}
