import 'package:flutter/material.dart';

// ─── Cat State（生命周期状态）───

/// 猫的生命周期状态 — Firestore / SQLite 中 state 字段的合法值。
enum CatState {
  active('active'),
  graduated('graduated'),
  dormant('dormant');

  const CatState(this.value);
  final String value;

  static CatState fromValue(String value) {
    return CatState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown CatState: $value'),
    );
  }
}

// ─── Personalities ───

class CatPersonality {
  final String id;
  final String emoji;

  const CatPersonality({required this.id, required this.emoji});
}

const List<CatPersonality> catPersonalities = [
  CatPersonality(id: 'lazy', emoji: '😴'),
  CatPersonality(id: 'curious', emoji: '🔍'),
  CatPersonality(id: 'playful', emoji: '🎯'),
  CatPersonality(id: 'shy', emoji: '🙈'),
  CatPersonality(id: 'brave', emoji: '🦁'),
  CatPersonality(id: 'clingy', emoji: '🥺'),
];

/// 快速查找 personalityId → CatPersonality
final Map<String, CatPersonality> personalityMap = {
  for (final p in catPersonalities) p.id: p,
};

// ─── Moods ───

class CatMood {
  final String id;
  final String emoji;
  final String spriteKey;

  const CatMood({
    required this.id,
    required this.emoji,
    required this.spriteKey,
  });
}

const CatMood moodHappy = CatMood(id: 'happy', emoji: '😸', spriteKey: 'happy');
const CatMood moodNeutral = CatMood(
  id: 'neutral',
  emoji: '😺',
  spriteKey: 'neutral',
);
const CatMood moodLonely = CatMood(id: 'lonely', emoji: '🥺', spriteKey: 'sad');
const CatMood moodMissing = CatMood(
  id: 'missing',
  emoji: '😿',
  spriteKey: 'sad',
);

/// 根据最近一次专注时间计算心情。
/// [createdAt] 用于区分新领养猫（24h 内为 happy）和长期未互动猫（missing）。
String calculateMood(DateTime? lastSessionAt, {DateTime? createdAt}) {
  final now = DateTime.now();
  if (lastSessionAt != null) {
    final diff = now.difference(lastSessionAt);
    return diff.inHours < 24
        ? moodHappy.id
        : diff.inDays < 3
        ? moodNeutral.id
        : diff.inDays < 7
        ? moodLonely.id
        : moodMissing.id;
  }
  final adoptedRecently =
      createdAt != null && now.difference(createdAt).inHours < 24;
  return adoptedRecently ? moodHappy.id : moodMissing.id;
}

/// 根据 ID 查找心情对象
CatMood moodById(String id) {
  const moodMap = {
    'happy': moodHappy,
    'neutral': moodNeutral,
    'lonely': moodLonely,
    'missing': moodMissing,
  };
  return moodMap[id] ?? moodNeutral;
}

// ─── Stage Colors ───

/// 阶段对应的主题色（用于 UI 进度条等）
Color stageColor(String stage) {
  const colors = {
    'kitten': Color(0xFFFFB74D),
    'adolescent': Color(0xFF81C784),
    'adult': Color(0xFF64B5F6),
    'senior': Color(0xFFE57373),
  };
  return colors[stage] ?? const Color(0xFFFFB74D);
}

// ─── Random Cat Names ───

const List<String> randomCatNames = [
  'Mochi',
  'Luna',
  'Milo',
  'Nori',
  'Tofu',
  'Boba',
  'Kiki',
  'Suki',
  'Taro',
  'Yuki',
  'Coco',
  'Mango',
  'Peach',
  'Daisy',
  'Olive',
  'Pumpkin',
  'Ginger',
  'Pepper',
  'Maple',
  'Willow',
  'Clover',
  'Hazel',
  'Jasper',
  'Felix',
  'Oscar',
  'Simba',
  'Nala',
  'Bella',
  'Chloe',
  'Leo',
  'Loki',
  'Thor',
  'Miso',
  'Ramen',
  'Soba',
  'Pudding',
  'Cookie',
  'Waffle',
  'Mocha',
  'Latte',
  'Caramel',
  'Biscuit',
  'Sesame',
  'Matcha',
  'Azuki',
  'Hachi',
  'Sakura',
  'Hinata',
  'Sora',
  'Ren',
];

const List<String> randomCatNamesZh = [
  '年糕',
  '团子',
  '豆沙',
  '芋圆',
  '汤圆',
  '布丁',
  '麻薯',
  '糯米',
  '奶茶',
  '可可',
  '小橘',
  '花卷',
  '饺子',
  '包子',
  '馒头',
  '芒果',
  '桃子',
  '柿子',
  '栗子',
  '橙子',
  '小黑',
  '小白',
  '大橘',
  '狸花',
  '三花',
  '豆豆',
  '球球',
  '咪咪',
  '喵喵',
  '毛毛',
  '蛋挞',
  '曲奇',
  '芝士',
  '抹茶',
  '红豆',
  '小鱼',
  '虎斑',
  '雪球',
  '棉花',
  '云朵',
  '饭团',
  '薯条',
  '甜甜',
  '乖乖',
  '萌萌',
  '七七',
  '八八',
  '小樱',
  '小星',
  '月月',
];
