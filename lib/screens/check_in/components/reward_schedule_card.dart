import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 奖励说明卡片。
class RewardScheduleCard extends StatelessWidget {
  final ThemeData theme;

  const RewardScheduleCard({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.checkInRewardSchedule,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _RewardRow(
              icon: Icons.work_outline,
              label: context.l10n.checkInWeekday,
              value: context.l10n.checkInWeekdayReward(checkInCoinsWeekday),
              color: colorScheme.onSurfaceVariant,
              theme: theme,
            ),
            const SizedBox(height: AppSpacing.sm),
            _RewardRow(
              icon: Icons.weekend_outlined,
              label: context.l10n.checkInWeekend,
              value: context.l10n.checkInWeekdayReward(checkInCoinsWeekend),
              color: colorScheme.tertiary,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _RewardRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
