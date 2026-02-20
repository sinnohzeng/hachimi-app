// ---
// 📘 文件说明：
// Cat Constants — 猫系统共享常量。
// v2: 移除品种/房间槽位体系，保留性格/心情/名字池。
// 成长阶段改为基于 pixel_cat_constants.dart 中的百分比阈值。
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:flutter/material.dart';

// ─── Personalities ───

class CatPersonality {
  final String id;
  final String emoji;

  const CatPersonality({
    required this.id,
    required this.emoji,
  });
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
const CatMood moodNeutral = CatMood(id: 'neutral', emoji: '😺', spriteKey: 'neutral');
const CatMood moodLonely = CatMood(id: 'lonely', emoji: '🥺', spriteKey: 'sad');
const CatMood moodMissing = CatMood(id: 'missing', emoji: '😿', spriteKey: 'sad');

/// 根据最近一次专注时间计算心情
String calculateMood(DateTime? lastSessionAt) {
  if (lastSessionAt == null) return moodMissing.id;
  final now = DateTime.now();
  final diff = now.difference(lastSessionAt);
  if (diff.inHours < 24) return moodHappy.id;
  if (diff.inDays < 3) return moodNeutral.id;
  if (diff.inDays < 7) return moodLonely.id;
  return moodMissing.id;
}

/// 根据 ID 查找心情对象
CatMood moodById(String id) {
  switch (id) {
    case 'happy':
      return moodHappy;
    case 'neutral':
      return moodNeutral;
    case 'lonely':
      return moodLonely;
    case 'missing':
      return moodMissing;
    default:
      return moodNeutral;
  }
}

// ─── Stage Colors ───

/// 阶段对应的主题色（用于 UI 进度条等）
Color stageColor(String stage) {
  switch (stage) {
    case 'kitten':
      return const Color(0xFFFFB74D); // 暖橙
    case 'adolescent':
      return const Color(0xFF81C784); // 浅绿
    case 'adult':
      return const Color(0xFF64B5F6); // 浅蓝
    case 'senior':
      return const Color(0xFFFFD700); // 金色
    default:
      return const Color(0xFFFFB74D);
  }
}

// ─── Random Cat Names ───

const List<String> randomCatNames = [
  'Mochi', 'Luna', 'Milo', 'Nori', 'Tofu',
  'Boba', 'Kiki', 'Suki', 'Taro', 'Yuki',
  'Coco', 'Mango', 'Peach', 'Daisy', 'Olive',
  'Pumpkin', 'Ginger', 'Pepper', 'Maple', 'Willow',
  'Clover', 'Hazel', 'Jasper', 'Felix', 'Oscar',
  'Simba', 'Nala', 'Bella', 'Chloe', 'Leo',
  'Loki', 'Thor', 'Miso', 'Ramen', 'Soba',
  'Pudding', 'Cookie', 'Waffle', 'Mocha', 'Latte',
  'Caramel', 'Biscuit', 'Sesame', 'Matcha', 'Azuki',
  'Hachi', 'Sakura', 'Hinata', 'Sora', 'Ren',
];

const List<String> randomCatNamesZh = [
  '年糕', '团子', '豆沙', '芋圆', '汤圆',
  '布丁', '麻薯', '糯米', '奶茶', '可可',
  '小橘', '花卷', '饺子', '包子', '馒头',
  '芒果', '桃子', '柿子', '栗子', '橙子',
  '小黑', '小白', '大橘', '狸花', '三花',
  '豆豆', '球球', '咪咪', '喵喵', '毛毛',
  '蛋挞', '曲奇', '芝士', '抹茶', '红豆',
  '小鱼', '虎斑', '雪球', '棉花', '云朵',
  '饭团', '薯条', '甜甜', '乖乖', '萌萌',
  '七七', '八八', '小樱', '小星', '月月',
];
