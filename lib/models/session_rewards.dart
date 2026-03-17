import 'package:hachimi_app/models/xp_result.dart';

/// 会话奖励计算结果 — 在会话保存子方法间传递。
class SessionRewards {
  final int coins;
  final XpResult xp;
  final StageUpResult? stageUp;

  const SessionRewards({required this.coins, required this.xp, this.stageUp});
}
