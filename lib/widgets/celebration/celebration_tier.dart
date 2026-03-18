import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/models/achievement.dart';

/// 庆祝层级 — Standard / Notable / Epic。
enum CelebrationTier { standard, notable, epic }

/// 纸屑形状类型。
enum ConfettiShape { rectangle, circle, star, diamond, streamer }

/// 庆祝标题类型。
enum CelebrationHeadline {
  achievementUnlocked('achievementUnlocked'),
  achievementAwesome('achievementAwesome'),
  achievementIncredible('achievementIncredible');

  const CelebrationHeadline(this.value);
  final String value;
}

/// 庆祝动画配置 — 每个层级对应一组 const 预设。
class CelebrationConfig {
  final Duration bgFadeDuration;
  final Duration iconRevealDelay;
  final Duration textRevealDelay;
  final Duration rewardRevealDelay;
  final Duration exitDuration;
  final double iconScaleFrom;
  final int particleCount;
  final bool hasBurstOrigin;
  final List<ConfettiShape> shapes;
  final CelebrationHeadline celebrationHeadlineKey;

  const CelebrationConfig({
    required this.bgFadeDuration,
    required this.iconRevealDelay,
    required this.textRevealDelay,
    required this.rewardRevealDelay,
    required this.exitDuration,
    required this.iconScaleFrom,
    required this.particleCount,
    required this.hasBurstOrigin,
    required this.shapes,
    required this.celebrationHeadlineKey,
  });

  /// Standard: 快速、干净、无触觉反馈。
  static const standard = CelebrationConfig(
    bgFadeDuration: AppMotion.durationMedium2,
    iconRevealDelay: AppMotion.durationMedium2,
    textRevealDelay: Duration(milliseconds: 400),
    rewardRevealDelay: Duration(milliseconds: 600),
    exitDuration: AppMotion.durationMedium4,
    iconScaleFrom: 0.85,
    particleCount: 20,
    hasBurstOrigin: false,
    shapes: [ConfettiShape.rectangle, ConfettiShape.circle],
    celebrationHeadlineKey: CelebrationHeadline.achievementUnlocked,
  );

  /// Notable: 中等仪式感，单次 mediumImpact。
  static const notable = CelebrationConfig(
    bgFadeDuration: AppMotion.durationShort4,
    iconRevealDelay: Duration(milliseconds: 500),
    textRevealDelay: Duration(milliseconds: 800),
    rewardRevealDelay: Duration(milliseconds: 1100),
    exitDuration: AppMotion.durationMedium4,
    iconScaleFrom: 0.85,
    particleCount: 40,
    hasBurstOrigin: true,
    shapes: [ConfettiShape.rectangle, ConfettiShape.circle, ConfettiShape.star],
    celebrationHeadlineKey: CelebrationHeadline.achievementAwesome,
  );

  /// Epic: 三阶段仪式，全编排触觉 + 聚光灯。
  static const epic = CelebrationConfig(
    bgFadeDuration: AppMotion.durationMedium2,
    iconRevealDelay: Duration(milliseconds: 600),
    textRevealDelay: Duration(milliseconds: 1000),
    rewardRevealDelay: Duration(milliseconds: 1500),
    exitDuration: AppMotion.durationMedium4,
    iconScaleFrom: 0.7,
    particleCount: 60,
    hasBurstOrigin: true,
    shapes: ConfettiShape.values,
    celebrationHeadlineKey: CelebrationHeadline.achievementIncredible,
  );

  /// 根据成就定义自动选择层级。
  factory CelebrationConfig.fromDef(AchievementDef def) {
    final tier = tierFromDef(def);
    switch (tier) {
      case CelebrationTier.epic:
        return epic;
      case CelebrationTier.notable:
        return notable;
      case CelebrationTier.standard:
        return standard;
    }
  }

  /// 根据成就定义判断层级。
  static CelebrationTier tierFromDef(AchievementDef def) {
    if (def.titleReward != null || def.coinReward >= 300) {
      return CelebrationTier.epic;
    }
    if (def.coinReward >= 100) {
      return CelebrationTier.notable;
    }
    return CelebrationTier.standard;
  }
}
