import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

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
                Text('本月热爱与坚持', style: textTheme.titleSmall),
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
                      Icons.construction_outlined,
                      size: 32,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '习惯追踪功能正在开发中',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '在小赢挑战中设定你的习惯',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
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
