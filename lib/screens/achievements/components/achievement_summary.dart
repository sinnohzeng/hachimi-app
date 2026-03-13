import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

/// 成就摘要头部 — 带入场动画的进度环、统计数据、完成百分比。
class AchievementSummary extends ConsumerStatefulWidget {
  const AchievementSummary({super.key});

  @override
  ConsumerState<AchievementSummary> createState() => _AchievementSummaryState();
}

class _AchievementSummaryState extends ConsumerState<AchievementSummary>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium2,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unlockedIds = ref.watch(unlockedIdsProvider);
    final total = AchievementDefinitions.totalCount;
    final unlocked = unlockedIds.length;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    int totalCoins = 0;
    for (final id in unlockedIds) {
      final def = AchievementDefinitions.byId(id);
      if (def != null) totalCoins += def.coinReward;
    }

    final progress = total > 0 ? unlocked / total : 0.0;
    final percent = (progress * 100).round();

    return Padding(
      padding: AppSpacing.paddingBase,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppShape.borderMedium,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.08),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: AppSpacing.paddingBase,
            child: Row(
              children: [
                // 带动画的进度环
                AnimatedBuilder(
                  animation: CurvedAnimation(
                    parent: _progressController,
                    curve: AppMotion.emphasizedDecelerate,
                  ),
                  builder: (context, _) => ProgressRing(
                    progress: progress * _progressController.value,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.pie_chart,
                            size: 16,
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$percent%',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }
}
