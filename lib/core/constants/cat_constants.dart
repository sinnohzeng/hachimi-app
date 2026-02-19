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
  final String name;
  final String emoji;
  final String flavorText;

  const CatPersonality({
    required this.id,
    required this.name,
    required this.emoji,
    required this.flavorText,
  });
}

const List<CatPersonality> catPersonalities = [
  CatPersonality(
    id: 'lazy',
    name: 'Lazy',
    emoji: '😴',
    flavorText: 'Will nap 23 hours a day. The other hour? Also napping.',
  ),
  CatPersonality(
    id: 'curious',
    name: 'Curious',
    emoji: '🔍',
    flavorText: 'Already sniffing everything in sight!',
  ),
  CatPersonality(
    id: 'playful',
    name: 'Playful',
    emoji: '🎯',
    flavorText: "Can't stop chasing butterflies!",
  ),
  CatPersonality(
    id: 'shy',
    name: 'Shy',
    emoji: '🙈',
    flavorText: 'Took 3 minutes to peek out of the box...',
  ),
  CatPersonality(
    id: 'brave',
    name: 'Brave',
    emoji: '🦁',
    flavorText: 'Jumped out of the box before it was even opened!',
  ),
  CatPersonality(
    id: 'clingy',
    name: 'Clingy',
    emoji: '🥺',
    flavorText: "Immediately started purring and won't let go.",
  ),
];

/// 快速查找 personalityId → CatPersonality
final Map<String, CatPersonality> personalityMap = {
  for (final p in catPersonalities) p.id: p,
};

// ─── Moods ───

class CatMood {
  final String id;
  final String name;
  final String emoji;
  final String spriteKey;

  const CatMood({
    required this.id,
    required this.name,
    required this.emoji,
    required this.spriteKey,
  });
}

const CatMood moodHappy = CatMood(id: 'happy', name: 'Happy', emoji: '😸', spriteKey: 'happy');
const CatMood moodNeutral = CatMood(id: 'neutral', name: 'Neutral', emoji: '😺', spriteKey: 'neutral');
const CatMood moodLonely = CatMood(id: 'lonely', name: 'Lonely', emoji: '🥺', spriteKey: 'sad');
const CatMood moodMissing = CatMood(id: 'missing', name: 'Missing You', emoji: '😿', spriteKey: 'sad');

/// 心情消息 — personality:mood 组合矩阵
const Map<String, String> moodMessages = {
  // Happy
  'lazy:happy': 'Nya~! Time for a well-deserved nap...',
  'curious:happy': 'What are we exploring today?',
  'playful:happy': 'Nya~! Ready to work!',
  'shy:happy': '...I-I\'m glad you\'re here.',
  'brave:happy': 'Let\'s conquer today together!',
  'clingy:happy': 'Yay! You\'re back! Don\'t leave again!',
  // Neutral
  'lazy:neutral': '*yawn* Oh, hey...',
  'curious:neutral': 'Hmm, what\'s that over there?',
  'playful:neutral': 'Wanna play? Maybe later...',
  'shy:neutral': '*peeks out slowly*',
  'brave:neutral': 'Standing guard, as always.',
  'clingy:neutral': 'I\'ve been waiting for you...',
  // Lonely
  'lazy:lonely': 'Even napping feels lonely...',
  'curious:lonely': 'I wonder when you\'ll come back...',
  'playful:lonely': 'The toys aren\'t fun without you...',
  'shy:lonely': '*curls up quietly*',
  'brave:lonely': 'I\'ll keep waiting. I\'m brave.',
  'clingy:lonely': 'Where did you go... 🥺',
  // Missing
  'lazy:missing': '*opens one eye hopefully*',
  'curious:missing': 'Did something happen...?',
  'playful:missing': 'I saved your favorite toy...',
  'shy:missing': '*hiding, but watching the door*',
  'brave:missing': 'I know you\'ll come back. I believe.',
  'clingy:missing': 'I miss you so much... please come back.',
};

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
