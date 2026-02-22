import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

/// 成就摘要头部 — 显示进度环、统计数据。
class AchievementSummary extends ConsumerWidget {
  const AchievementSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedIdsProvider);
    final total = AchievementDefinitions.totalCount;
    final unlocked = unlockedIds.length;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    // 计算已获金币总额
    int totalCoins = 0;
    for (final id in unlockedIds) {
      final def = AchievementDefinitions.byId(id);
      if (def != null) totalCoins += def.coinReward;
    }

    return Padding(
      padding: AppSpacing.paddingBase,
      child: Card(
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Row(
            children: [
              // 进度环
              ProgressRing(
                progress: total > 0 ? unlocked / total : 0,
                size: 72,
                strokeWidth: 6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$unlocked',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      '/$total',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),

              // 统计数据
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.achievementSummaryTitle,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.achievementUnlockedCount(unlocked),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 16,
                          color: colorScheme.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.achievementTotalCoins(totalCoins),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
