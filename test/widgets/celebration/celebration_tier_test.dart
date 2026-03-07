import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/widgets/celebration/celebration_tier.dart';

void main() {
  AchievementDef makeDef({int coinReward = 10, String? titleReward}) {
    return AchievementDef(
      id: 'test_${coinReward}_$titleReward',
      category: 'quest',
      nameKey: 'test',
      descKey: 'test',
      icon: Icons.star,
      coinReward: coinReward,
      titleReward: titleReward,
    );
  }

  group('CelebrationConfig.tierFromDef', () {
    test('coinReward < 100 -> standard', () {
      final def = makeDef(coinReward: 10);
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.standard);
    });

    test('coinReward 50 -> standard', () {
      final def = makeDef(coinReward: 50);
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.standard);
    });

    test('coinReward exactly 100 -> notable', () {
      final def = makeDef(coinReward: 100);
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.notable);
    });

    test('coinReward 200 -> notable', () {
      final def = makeDef(coinReward: 200);
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.notable);
    });

    test('coinReward exactly 300 -> epic', () {
      final def = makeDef(coinReward: 300);
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.epic);
    });

    test('coinReward 500 -> epic', () {
      final def = makeDef(coinReward: 500);
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.epic);
    });

    test('titleReward overrides coin threshold to epic', () {
      final def = makeDef(coinReward: 50, titleReward: 'title_master');
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.epic);
    });

    test('titleReward with high coins stays epic', () {
      final def = makeDef(coinReward: 1000, titleReward: 'title_legend');
      expect(CelebrationConfig.tierFromDef(def), CelebrationTier.epic);
    });
  });

  group('CelebrationConfig.fromDef', () {
    test('standard config for low-coin achievement', () {
      final config = CelebrationConfig.fromDef(makeDef(coinReward: 10));
      expect(config.particleCount, 20);
      expect(config.hasBurstOrigin, false);
      expect(config.celebrationHeadlineKey, 'achievementUnlocked');
    });

    test('notable config for mid-coin achievement', () {
      final config = CelebrationConfig.fromDef(makeDef(coinReward: 150));
      expect(config.particleCount, 40);
      expect(config.hasBurstOrigin, true);
      expect(config.celebrationHeadlineKey, 'achievementAwesome');
    });

    test('epic config for high-coin achievement', () {
      final config = CelebrationConfig.fromDef(makeDef(coinReward: 500));
      expect(config.particleCount, 60);
      expect(config.hasBurstOrigin, true);
      expect(config.celebrationHeadlineKey, 'achievementIncredible');
    });
  });
}
