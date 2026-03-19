import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 心情追踪卡片 — 5 周 x 7 天网格 + 心情分布统计。
class MoodTrackerCard extends ConsumerWidget {
  const MoodTrackerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthStr = AppDateUtils.currentMonth();
    final lightsAsync = ref.watch(monthlyLightsProvider(monthStr));
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
                Icon(Icons.mood, size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('心情追踪', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            lightsAsync.when(
              data: (lights) => _buildContent(context, lights),
              loading: () => const Padding(
                padding: AppSpacing.paddingVBase,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) {
                debugPrint('[MoodTrackerCard] Load error: $e');
                return Text(
                  '加载失败',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<DailyLight> lights) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDay = DateTime(now.year, now.month, 1);
    final startOffset = firstDay.weekday - 1;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    // 按日索引
    final moodByDay = <int, Mood>{};
    for (final light in lights) {
      final day = int.tryParse(light.date.split('-').last);
      if (day != null) moodByDay[day] = light.mood;
    }

    // 统计分布
    final distribution = <Mood, int>{};
    for (final mood in moodByDay.values) {
      distribution[mood] = (distribution[mood] ?? 0) + 1;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // 网格
        ...List.generate(rows, (row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                final day = cellIndex - startOffset + 1;

                if (day < 1 || day > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 28));
                }

                final mood = moodByDay[day];
                return Expanded(
                  child: SizedBox(
                    height: 28,
                    child: Center(
                      child: mood != null
                          ? Text(
                              mood.emoji,
                              style: const TextStyle(fontSize: 16),
                            )
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surfaceContainerHigh,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.md),
        // 分布统计
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: Mood.values.map((mood) {
            final count = distribution[mood] ?? 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mood.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 2),
                Text(
                  '$count 次',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
