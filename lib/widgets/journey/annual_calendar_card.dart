import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 年历卡片 — 12 月 x 31 天点阵图，按心情着色。
class AnnualCalendarCard extends ConsumerWidget {
  const AnnualCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = DateTime.now().year;
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
                  Icons.calendar_today,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('我的年历', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // 12 个月
            ...List.generate(12, (monthIndex) {
              final month = monthIndex + 1;
              final monthStr = '$year-${month.toString().padLeft(2, '0')}';

              return _MonthRow(
                monthStr: monthStr,
                monthLabel: '$month 月',
                year: year,
                month: month,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MonthRow extends ConsumerWidget {
  final String monthStr;
  final String monthLabel;
  final int year;
  final int month;

  const _MonthRow({
    required this.monthStr,
    required this.monthLabel,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightsAsync = ref.watch(monthlyLightsProvider(monthStr));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              monthLabel,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: lightsAsync.when(
              data: (lights) => _buildDots(context, daysInMonth, lights),
              loading: () => SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  backgroundColor: colorScheme.surfaceContainerHigh,
                ),
              ),
              error: (_, _) => const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(
    BuildContext context,
    int daysInMonth,
    List<DailyLight> lights,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // 按日索引心情
    final moodByDay = <int, Mood>{};
    for (final light in lights) {
      final day = int.tryParse(light.date.split('-').last);
      if (day != null) moodByDay[day] = light.mood;
    }

    return Row(
      children: List.generate(31, (i) {
        final day = i + 1;
        if (day > daysInMonth) {
          return const SizedBox(width: 3);
        }

        final mood = moodByDay[day];
        return Padding(
          padding: const EdgeInsets.only(right: 1),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mood != null
                  ? mood.themeColor(colorScheme)
                  : colorScheme.surfaceContainerHigh,
            ),
          ),
        );
      }),
    );
  }
}
