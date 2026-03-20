import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 本月热爱与坚持卡片 — 最多 4 个习惯的 31 天打卡网格。
///
/// MVP 阶段显示占位提示，待与习惯模块集成后填充真实数据。
class HabitTrackersCard extends StatelessWidget {
  const HabitTrackersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.grid_view_rounded,
                  size: 20,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n.habitTrackerTitle,
                  style: textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // 功能开发中提示
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: 32,
                      color: colorScheme.primary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.habitTrackerComingSoon,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
