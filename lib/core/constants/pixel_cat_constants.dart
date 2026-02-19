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

/// 默认饰品价格（金币）
const int defaultAccessoryPrice = 150;

/// 每日签到金币奖励
const int dailyCheckInCoins = 50;

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
