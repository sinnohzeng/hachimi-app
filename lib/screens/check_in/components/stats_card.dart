import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';

/// 统计摘要卡片。
class StatsCard extends StatelessWidget {
  final MonthlyCheckIn monthly;
  final ThemeData theme;

  const StatsCard({super.key, required this.monthly, required this.theme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final colorScheme = theme.colorScheme;

    // 找出下一个未达成的里程碑
    String nextMilestoneText = context.l10n.checkInAllMilestones;
    final allThresholds = [...checkInMilestones.keys, daysInMonth];
    for (final threshold in allThresholds) {
      if (!monthly.milestonesClaimed.contains(threshold) &&
          monthly.checkedCount < threshold) {
        final bonus = threshold == daysInMonth
            ? checkInFullMonthBonus
            : checkInMilestones[threshold]!;
        final remaining = threshold - monthly.checkedCount;
        nextMilestoneText = context.l10n.checkInMilestoneProgress(
          remaining,
          bonus,
        );
        break;
      }
    }

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  value: '${monthly.checkedCount}/$daysInMonth',
                  label: context.l10n.checkInDays,
                  icon: Icons.calendar_today,
                  color: colorScheme.onPrimaryContainer,
                ),
                _StatItem(
                  value: '${monthly.totalCoins}',
                  label: context.l10n.checkInCoinsEarned,
                  icon: Icons.monetization_on,
                  color: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag, size: 16, color: colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    nextMilestoneText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
