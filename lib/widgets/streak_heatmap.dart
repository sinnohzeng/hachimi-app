import 'package:flutter/material.dart';

/// GitHub-style streak heatmap — shows 90 days of focus activity.
/// Each cell represents a day, colored by intensity of focus minutes.
class StreakHeatmap extends StatelessWidget {
  /// Map of date (yyyy-MM-dd) → minutes focused on that day.
  final Map<String, int> dailyMinutes;

  /// Number of days to display (default 91 = 13 weeks).
  final int days;

  const StreakHeatmap({
    super.key,
    required this.dailyMinutes,
    this.days = 91,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: days - 1));

    // Find the max minutes for color scaling
    int maxMinutes = 1;
    for (final v in dailyMinutes.values) {
      if (v > maxMinutes) maxMinutes = v;
    }

    // Build the grid: 7 rows (days of week) × N columns (weeks)
    final totalWeeks = ((days + startDate.weekday % 7) / 7).ceil();

    // Compute stats
    int totalDays = 0;
    int totalMin = 0;
    for (final entry in dailyMinutes.entries) {
      if (entry.value > 0) {
        totalDays++;
        totalMin += entry.value;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heatmap grid
        SizedBox(
          height: 7 * (14.0 + 2.0), // 7 cells × (14 height + 2 margin)
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(totalWeeks, (weekIndex) {
              return Column(
                children: List.generate(7, (dayIndex) {
                  final dayOffset = weekIndex * 7 + dayIndex -
                      (startDate.weekday % 7);
                  final date = startDate.add(Duration(days: dayOffset));

                  // Skip cells outside our range
                  if (dayOffset < 0 || date.isAfter(today)) {
                    return Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.all(1),
                    );
                  }

                  final key =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final minutes = dailyMinutes[key] ?? 0;
                  final intensity =
                      minutes > 0 ? (minutes / maxMinutes).clamp(0.2, 1.0) : 0.0;

                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: intensity > 0
                          ? colorScheme.primary
                              .withValues(alpha: intensity)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),

        // Stats row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HeatmapStat(
              label: 'Active days',
              value: '$totalDays',
            ),
            _HeatmapStat(
              label: 'Total',
              value: '${totalMin ~/ 60}h ${totalMin % 60}m',
            ),
            _HeatmapStat(
              label: 'Rate',
              value: days > 0
                  ? '${(totalDays / days * 100).round()}%'
                  : '0%',
            ),
          ],
        ),

        // Legend
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Less',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            ...List.generate(4, (i) {
              final alpha = [0.0, 0.3, 0.6, 1.0][i];
              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: alpha > 0
                      ? colorScheme.primary.withValues(alpha: alpha)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
            const SizedBox(width: 4),
            Text(
              'More',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeatmapStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeatmapStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
