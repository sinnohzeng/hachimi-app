// ---
// Featured Cat 智能选择算法单元测试 — 验证加权评分逻辑和心情修复。
//
// 🧩 测试场景：
// - 刚专注完 → recency 主导
// - 一周未开 app → mood 主导
// - 全 adult 猫 → recency + mood 仍有效
// - 单猫 → 短路返回
// - 新用户 → calculateMood 的 createdAt 修复
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

const _defaultAppearance = CatAppearance(
  peltType: 'Tabby',
  peltColor: 'GINGER',
  tint: 'none',
  eyeColor: 'GREEN',
  whitePatchesTint: 'none',
  skinColor: 'PINK',
  isTortie: false,
  isLonghair: false,
  reverse: false,
  spriteVariant: 0,
);

Cat _makeCat({
  required String id,
  String personality = 'playful',
  int totalMinutes = 100,
  DateTime? createdAt,
  DateTime? lastSessionAt,
  String boundHabitId = 'habit-1',
}) {
  return Cat(
    id: id,
    name: 'Cat-$id',
    personality: personality,
    appearance: _defaultAppearance,
    totalMinutes: totalMinutes,
    boundHabitId: boundHabitId,
    createdAt: createdAt ?? DateTime(2026, 1, 1),
    lastSessionAt: lastSessionAt,
  );
}

/// 与 TodayTab._findFeaturedCat 完全一致的纯函数副本（用于单元测试）。
Cat? findFeaturedCat(List<Cat> cats, Map<String, int> todayMinutes) {
  if (cats.isEmpty) return null;
  if (cats.length == 1) return cats.first;

  Cat? best;
  double bestScore = -1;

  for (final cat in cats) {
    final recency = _recencyScore(cat.lastSessionAt);
    final mood = _moodScore(cat.computedMood);
    final growth = _growthScore(cat.stageProgress);
    final today = (todayMinutes[cat.boundHabitId] ?? 0) > 0 ? 0.0 : 1.0;

    final score = recency * 0.45 + mood * 0.30 + growth * 0.20 + today * 0.05;
    if (score > bestScore) {
      bestScore = score;
      best = cat;
    }
  }
  return best;
}

double _recencyScore(DateTime? lastSessionAt) {
  if (lastSessionAt == null) return 0.05;
  final hours = DateTime.now().difference(lastSessionAt).inHours;
  if (hours < 1) return 1.0;
  if (hours < 6) return 0.8;
  if (hours < 24) return 0.6;
  final days = hours ~/ 24;
  if (days < 3) return 0.3;
  if (days < 7) return 0.15;
  return 0.05;
}

double _moodScore(String mood) {
  switch (mood) {
    case 'missing':
      return 1.0;
    case 'lonely':
      return 0.8;
    case 'neutral':
      return 0.3;
    case 'happy':
      return 0.1;
    default:
      return 0.3;
  }
}

double _growthScore(double stageProgress) {
  if (stageProgress >= 0.85) return 1.0;
  if (stageProgress >= 0.70) return 0.7;
  return stageProgress * 0.5;
}

void main() {
  group('Featured Cat 智能选择算法', () {
    test('刚专注完 → recency 主导，选择最近互动的猫', () {
      final now = DateTime.now();
      final recentCat = _makeCat(
        id: 'recent',
        lastSessionAt: now.subtract(const Duration(minutes: 30)),
        boundHabitId: 'h1',
      );
      final oldCat = _makeCat(
        id: 'old',
        lastSessionAt: now.subtract(const Duration(days: 2)),
        boundHabitId: 'h2',
      );

      final result = findFeaturedCat([recentCat, oldCat], {});
      expect(result?.id, equals('recent'));
    });

    test('一周未开 app → mood(missing) 主导，选择最想念用户的猫', () {
      final now = DateTime.now();
      final missingCat = _makeCat(
        id: 'missing',
        lastSessionAt: now.subtract(const Duration(days: 10)),
        boundHabitId: 'h1',
      );
      final lonelyCat = _makeCat(
        id: 'lonely',
        lastSessionAt: now.subtract(const Duration(days: 5)),
        boundHabitId: 'h2',
      );

      final result = findFeaturedCat([missingCat, lonelyCat], {});
      expect(result?.id, equals('missing'));
    });

    test('全 adult 猫 → recency + mood 仍有效', () {
      final now = DateTime.now();
      // 6000 min = 100h → adult stage
      final recentAdult = _makeCat(
        id: 'recent-adult',
        totalMinutes: 6000,
        lastSessionAt: now.subtract(const Duration(hours: 2)),
        boundHabitId: 'h1',
      );
      final oldAdult = _makeCat(
        id: 'old-adult',
        totalMinutes: 6000,
        lastSessionAt: now.subtract(const Duration(days: 4)),
        boundHabitId: 'h2',
      );

      expect(recentAdult.computedStage, equals('adult'));
      expect(oldAdult.computedStage, equals('adult'));

      final result = findFeaturedCat([recentAdult, oldAdult], {});
      expect(result?.id, equals('recent-adult'));
    });

    test('单猫 → 短路返回', () {
      final cat = _makeCat(id: 'only');
      final result = findFeaturedCat([cat], {});
      expect(result?.id, equals('only'));
    });

    test('空列表 → 返回 null', () {
      final result = findFeaturedCat([], {});
      expect(result, isNull);
    });

    test('todayScore 影响：今日已做 vs 未做', () {
      final now = DateTime.now();
      final doneCat = _makeCat(
        id: 'done',
        lastSessionAt: now.subtract(const Duration(hours: 12)),
        boundHabitId: 'h-done',
      );
      final notDoneCat = _makeCat(
        id: 'not-done',
        lastSessionAt: now.subtract(const Duration(hours: 12)),
        boundHabitId: 'h-not-done',
      );

      final result = findFeaturedCat([doneCat, notDoneCat], {'h-done': 25});
      expect(result?.id, equals('not-done'));
    });
  });

  group('calculateMood 新用户修复', () {
    test('lastSessionAt == null 且 createdAt 在 24h 内 → happy', () {
      final recentCreate = DateTime.now().subtract(const Duration(hours: 2));
      final mood = calculateMood(null, createdAt: recentCreate);
      expect(mood, equals('happy'));
    });

    test('lastSessionAt == null 且 createdAt 超过 24h → missing', () {
      final oldCreate = DateTime.now().subtract(const Duration(days: 3));
      final mood = calculateMood(null, createdAt: oldCreate);
      expect(mood, equals('missing'));
    });

    test('lastSessionAt == null 且 createdAt == null → missing', () {
      final mood = calculateMood(null);
      expect(mood, equals('missing'));
    });

    test('lastSessionAt 存在时 createdAt 不影响结果', () {
      final recent = DateTime.now().subtract(const Duration(hours: 2));
      final mood = calculateMood(recent, createdAt: DateTime(2020));
      expect(mood, equals('happy'));
    });

    test('Cat 模型的 computedMood 使用 createdAt', () {
      final newCat = _makeCat(
        id: 'new',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        lastSessionAt: null,
      );
      expect(newCat.computedMood, equals('happy'));
    });

    test('旧猫无 lastSessionAt 仍为 missing', () {
      final oldCat = _makeCat(
        id: 'old',
        createdAt: DateTime(2025, 1, 1),
        lastSessionAt: null,
      );
      expect(oldCat.computedMood, equals('missing'));
    });
  });
}
