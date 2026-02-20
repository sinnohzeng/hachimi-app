import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';

/// XP calculation result returned after a focus session.
/// Still used for timer completion page display.
class XpResult {
  final int baseXp;
  final int streakBonus;
  final int milestoneBonus;
  final int fullHouseBonus;
  final int totalXp;

  const XpResult({
    required this.baseXp,
    required this.streakBonus,
    required this.milestoneBonus,
    required this.fullHouseBonus,
    required this.totalXp,
  });
}

/// Stage-up check result (percentage-based growth system).
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
  /// - [streakDays]: current streak count for this habit
  /// - [allHabitsDone]: whether all habits were completed today
  /// - [xpMultiplier]: from Remote Config (default: 1)
  XpResult calculateXp({
    required int minutes,
    required int streakDays,
    required bool allHabitsDone,
    double xpMultiplier = 1.0,
  }) {
    // Base: 1 XP per minute
    final baseXp = minutes;

    // Streak bonus: +5 per session if streak >= 3
    final streakBonus = streakDays >= 3 ? 5 : 0;

    // Milestone bonus: one-time for streak milestones (7/14/30 days)
    int milestoneBonus = 0;
    if (streakMilestones.contains(streakDays)) {
      milestoneBonus = streakMilestoneXpBonus;
    }

    // Full house: +10 if all habits done today
    final fullHouseBonus = allHabitsDone ? 10 : 0;

    final rawTotal = baseXp + streakBonus + milestoneBonus + fullHouseBonus;
    final totalXp = (rawTotal * xpMultiplier).round();

    return XpResult(
      baseXp: baseXp,
      streakBonus: streakBonus,
      milestoneBonus: milestoneBonus,
      fullHouseBonus: fullHouseBonus,
      totalXp: totalXp,
    );
  }

  /// Check if adding minutes results in a stage transition.
  /// Uses percentage-based thresholds: kitten / adolescent / adult / senior.
  StageUpResult checkStageUp({
    required int oldTotalMinutes,
    required int newTotalMinutes,
    required int targetMinutes,
  }) {
    if (targetMinutes <= 0) {
      return const StageUpResult(
        didStageUp: false,
        oldStage: 'kitten',
        newStage: 'kitten',
      );
    }

    final oldProgress = (oldTotalMinutes / targetMinutes).clamp(0.0, 1.0);
    final newProgress = (newTotalMinutes / targetMinutes).clamp(0.0, 1.0);
    final oldStage = stageForProgress(oldProgress);
    final newStage = stageForProgress(newProgress);

    return StageUpResult(
      didStageUp: oldStage != newStage,
      oldStage: oldStage,
      newStage: newStage,
    );
  }
}
