import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';

/// 金币奖励徽章。
class CoinRewardBadge extends StatelessWidget {
  final int coinReward;
  final S l10n;

  const CoinRewardBadge({
    super.key,
    required this.coinReward,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: BrandColors.rewardGold.withValues(alpha: 0.15),
        borderRadius: AppShape.borderLarge,
      ),
      child: Text(
        l10n.achievementCelebrationCoins(coinReward),
        style: textTheme.titleMedium?.copyWith(
          color: BrandColors.achievementStar,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 称号奖励徽章。
class TitleRewardBadge extends StatelessWidget {
  final String titleName;
  final S l10n;

  const TitleRewardBadge({
    super.key,
    required this.titleName,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: AppShape.borderMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, size: 18, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            l10n.achievementCelebrationTitle(titleName),
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
