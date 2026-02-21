import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';

/// 里程碑进度卡片。
class MilestonesCard extends StatelessWidget {
  final MonthlyCheckIn monthly;
  final ThemeData theme;

  const MilestonesCard({super.key, required this.monthly, required this.theme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final colorScheme = theme.colorScheme;

    final milestones = <_MilestoneData>[
      for (final entry in checkInMilestones.entries)
        _MilestoneData(
          threshold: entry.key,
          bonus: entry.value,
          isClaimed: monthly.milestonesClaimed.contains(entry.key),
        ),
      _MilestoneData(
        threshold: daysInMonth,
        bonus: checkInFullMonthBonus,
        isClaimed: monthly.milestonesClaimed.contains(daysInMonth),
        label: context.l10n.checkInFullMonth,
      ),
    ];

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.checkInMilestones,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final m in milestones) ...[
              _MilestoneRow(
                milestone: m,
                currentCount: monthly.checkedCount,
                colorScheme: colorScheme,
                theme: theme,
              ),
              if (m != milestones.last) const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _MilestoneData {
  final int threshold;
  final int bonus;
  final bool isClaimed;
  final String? label;

  const _MilestoneData({
    required this.threshold,
    required this.bonus,
    required this.isClaimed,
    this.label,
  });
}

class _MilestoneRow extends StatelessWidget {
  final _MilestoneData milestone;
  final int currentCount;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _MilestoneRow({
    required this.milestone,
    required this.currentCount,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentCount / milestone.threshold).clamp(0.0, 1.0);
    final label =
        milestone.label ?? context.l10n.checkInNDays(milestone.threshold);

    return Row(
      children: [
        Icon(
          milestone.isClaimed ? Icons.check_circle : Icons.circle_outlined,
          color: milestone.isClaimed
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: milestone.isClaimed
                          ? TextDecoration.lineThrough
                          : null,
                      color: milestone.isClaimed
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '+${milestone.bonus}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: milestone.isClaimed
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.primary,
                      decoration: milestone.isClaimed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
              if (!milestone.isClaimed) ...[
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
