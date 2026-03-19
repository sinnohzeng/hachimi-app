import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 月历卡片 — 日历网格，每天显示心情 emoji。
class MonthlyCalendarCard extends ConsumerWidget {
  const MonthlyCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
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
                Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${now.year} 年 ${now.month} 月',
                  style: textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // 星期标题行
            _buildWeekdayHeader(context),
            const SizedBox(height: AppSpacing.xs),
            // 日历网格
            lightsAsync.when(
              data: (lights) => _buildCalendarGrid(context, now, lights),
              loading: () => const Padding(
                padding: AppSpacing.paddingVBase,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) {
                debugPrint('[MonthlyCalendarCard] Load error: $e');
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

  Widget _buildWeekdayHeader(BuildContext context) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: weekdays
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    DateTime now,
    List<DailyLight> lights,
  ) {
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    // 周一=1, 周日=7, 偏移量 = weekday - 1
    final startOffset = firstDay.weekday - 1;

    // 按日期索引心情
    final moodByDay = <int, DailyLight>{};
    for (final light in lights) {
      final day = int.tryParse(light.date.split('-').last);
      if (day != null) moodByDay[day] = light;
    }

    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final day = cellIndex - startOffset + 1;

            if (day < 1 || day > daysInMonth) {
              return const Expanded(child: SizedBox(height: 40));
            }

            final light = moodByDay[day];
            final isToday = day == now.day;

            return Expanded(
              child: _DayCell(
                day: day,
                emoji: light?.mood.emoji,
                isToday: isToday,
                onTap: () {
                  final dateStr = AppDateUtils.formatDay(
                    DateTime(now.year, now.month, day),
                  );
                  Navigator.of(
                    context,
                  ).pushNamed(AppRouter.dailyDetail, arguments: dateStr);
                },
              ),
            );
          }),
        );
      }),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final String? emoji;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    this.emoji,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        height: 40,
        decoration: isToday
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
              )
            : null,
        child: Center(
          child: emoji != null
              ? Text(emoji!, style: const TextStyle(fontSize: 16))
              : Text(
                  '$day',
                  style: textTheme.bodySmall?.copyWith(
                    color: isToday
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isToday ? FontWeight.bold : null,
                  ),
                ),
        ),
      ),
    );
  }
}
