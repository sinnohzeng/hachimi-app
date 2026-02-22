import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';

/// XP calculation result returned after a focus session.
/// Still used for timer completion page display.
class XpResult {
  final int baseXp;
  final int fullHouseBonus;
  final int totalXp;

  const XpResult({
    required this.baseXp,
    required this.fullHouseBonus,
    required this.totalXp,
  });
}

/// Stage-up check result (fixed hour ladder: 0/20/100/200h).
class StageUpResult {
  final bool didStageUp;
  final String oldStage;
  final String newStage;

  const StageUpResult({
    required this.didStageUp,
    required this.oldStage,
    required this.newStage,
  });
}

/// XpService — pure Dart calculation for focus session rewards
/// and stage transition detection.
/// No Firebase dependency — can be tested in isolation.
class XpService {
  /// Calculate XP earned from a focus session.
  ///
  /// - [minutes]: actual focused time
  /// - [allHabitsDone]: whether all habits were completed today
  /// - [xpMultiplier]: from Remote Config (default: 1)
  XpResult calculateXp({
    required int minutes,
    required bool allHabitsDone,
    double xpMultiplier = 1.0,
  }) {
    // Base: 1 XP per minute
    final baseXp = minutes;

    // Full house: +10 if all habits done today
    final fullHouseBonus = allHabitsDone ? 10 : 0;

    final rawTotal = baseXp + fullHouseBonus;
    final totalXp = (rawTotal * xpMultiplier).round();

    return XpResult(
      baseXp: baseXp,
      fullHouseBonus: fullHouseBonus,
      totalXp: totalXp,
    );
  }

  /// Check if adding minutes results in a stage transition.
  /// Uses fixed hour ladder: kitten(0h) / adolescent(20h) / adult(100h) / senior(200h).
  StageUpResult checkStageUp({
    required int oldTotalMinutes,
    required int newTotalMinutes,
  }) {
    // 固定阶梯：200h (12000min) = 1.0
    final oldProgress = (oldTotalMinutes / 12000.0).clamp(0.0, 1.0);
    final newProgress = (newTotalMinutes / 12000.0).clamp(0.0, 1.0);
    final oldStage = stageForProgress(oldProgress);
    final newStage = stageForProgress(newProgress);

    return StageUpResult(
      didStageUp: oldStage != newStage,
      oldStage: oldStage,
      newStage: newStage,
    );
  }
}
