import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/session_stats_provider.dart';
import 'package:hachimi_app/widgets/streak_heatmap.dart';

/// 30 天热力图卡片 — 显示每日专注活跃度。
class OverviewHeatmapCard extends ConsumerWidget {
  const OverviewHeatmapCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyMinutesProvider);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statsLast30Days,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            dailyAsync.when(
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, _) => const SizedBox(height: 120),
              data: (dailyMinutes) =>
                  StreakHeatmap(dailyMinutes: dailyMinutes, days: 30),
            ),
          ],
        ),
      ),
    );
  }
}
