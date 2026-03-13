import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/timer/components/stat_row.dart';
import 'package:hachimi_app/services/xp_service.dart';

/// 专注完成页的会话统计卡片：时间、金币、XP 明细。
class FocusSessionStatsCard extends StatelessWidget {
  final int minutes;
  final int coinsEarned;
  final XpResult xpResult;

  const FocusSessionStatsCard({
    super.key,
    required this.minutes,
    required this.coinsEarned,
    required this.xpResult,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatRow(
              label: l10n.focusCompleteFocusTime,
              value: '+$minutes min',
              icon: Icons.timer_outlined,
            ),
            if (coinsEarned > 0) ...[
              const Divider(height: 16),
              StatRow(
                label: l10n.focusCompleteCoinsEarned,
                value: '+$coinsEarned',
                icon: Icons.monetization_on,
              ),
            ],
            const Divider(height: 16),
            StatRow(
              label: l10n.focusCompleteBaseXp,
              value: '+${xpResult.baseXp} XP',
              icon: Icons.star_outline,
            ),
            if (xpResult.fullHouseBonus > 0) ...[
              const Divider(height: 16),
              StatRow(
                label: l10n.focusCompleteFullHouseBonus,
                value: '+${xpResult.fullHouseBonus} XP',
                icon: Icons.home,
              ),
            ],
            const Divider(height: 16),
            StatRow(
              label: l10n.focusCompleteTotal,
              value: '+${xpResult.totalXp} XP',
              icon: Icons.star,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
