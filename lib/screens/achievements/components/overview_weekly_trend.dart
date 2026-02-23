import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/session_stats_provider.dart';
import 'package:intl/intl.dart';

/// 周趋势柱状图 — 显示最近 7 天每日专注时长。
class OverviewWeeklyTrend extends ConsumerWidget {
  const OverviewWeeklyTrend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyTrendProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statsWeeklyTrend,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            weeklyAsync.when(
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, _) => const SizedBox(height: 150),
              data: (dailyMinutes) =>
                  _buildChart(dailyMinutes, colorScheme, textTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    Map<String, int> dailyMinutes,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final now = DateTime.now();
    final bars = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      final key = DateFormat('yyyy-MM-dd').format(date);
      final minutes = (dailyMinutes[key] ?? 0).toDouble();
      return _BarData(
        weekday: DateFormat.E().format(date),
        minutes: minutes,
        isToday: i == 6,
      );
    });

    final maxY = bars.fold(
      30.0,
      (prev, b) => b.minutes > prev ? b.minutes : prev,
    );

    return SizedBox(
      height: 150,
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.round()} min',
                  textTheme.labelSmall!.copyWith(
                    color: colorScheme.onInverseSurface,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= bars.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      bars[idx].weekday,
                      style: textTheme.labelSmall?.copyWith(
                        color: bars[idx].isToday
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: bars[idx].isToday ? FontWeight.bold : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(bars.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: bars[i].minutes,
                  color: bars[i].isToday
                      ? colorScheme.primary
                      : colorScheme.primary.withValues(alpha: 0.4),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _BarData {
  final String weekday;
  final double minutes;
  final bool isToday;

  const _BarData({
    required this.weekday,
    required this.minutes,
    required this.isToday,
  });
}
