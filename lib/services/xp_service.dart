import 'package:hachimi_app/core/constants/cat_constants.dart';

/// XP calculation result returned after a focus session.
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

/// Level-up check result.
class LevelUpResult {
  final bool didLevelUp;
  final int oldStage;
  final int newStage;
  final String newStageName;

  const LevelUpResult({
    required this.didLevelUp,
    required this.oldStage,
    required this.newStage,
    required this.newStageName,
  });
}

/// XpService — pure Dart calculation for XP earning and level-up detection.
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

    // Milestone bonus: +30 one-time for 7/14/30-day streaks
    // Note: caller is responsible for checking if milestone was already awarded
    int milestoneBonus = 0;
    if (streakDays == 7 || streakDays == 14 || streakDays == 30) {
      milestoneBonus = 30;
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

  /// Check if XP change results in a level-up (stage change).
  LevelUpResult checkLevelUp(int oldXp, int newXp) {
    final oldStage = stageForXp(oldXp);
    final newStage = stageForXp(newXp);
    return LevelUpResult(
      didLevelUp: newStage > oldStage,
      oldStage: oldStage,
      newStage: newStage,
      newStageName: stageNameForLevel(newStage),
    );
  }
}
