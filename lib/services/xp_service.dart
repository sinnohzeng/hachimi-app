import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/xp_result.dart';

// Re-export types so existing `import xp_service.dart` still compiles.
export 'package:hachimi_app/models/xp_result.dart';

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
