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
