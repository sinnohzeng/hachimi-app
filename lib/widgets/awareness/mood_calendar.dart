import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:intl/intl.dart';

/// MoodCalendar — 月历心情日历，显示每日心情 emoji。
class MoodCalendar extends ConsumerWidget {
  /// 当前显示的年份。
  final int year;

  /// 当前显示的月份（1-12）。
  final int month;

  /// 用户点击某一天时触发。
  final ValueChanged<DateTime> onDayTapped;

  /// 用户切换月份时触发。
  final ValueChanged<(int, int)> onMonthChanged;

  const MoodCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.onDayTapped,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthStr = '$year-${month.toString().padLeft(2, '0')}';
    final lightsAsync = ref.watch(monthlyLightsProvider(monthStr));
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MonthNavHeader(
              year: year,
              month: month,
              onMonthChanged: onMonthChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            _WeekdayHeader(),
            const SizedBox(height: AppSpacing.xs),
            lightsAsync.when(
              data: (lights) => _DateGrid(
                year: year,
                month: month,
                moodMap: _buildMoodMap(lights),
                onDayTapped: onDayTapped,
              ),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) {
                debugPrint('[MoodCalendar] Load error for $monthStr: $e');
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      context.l10n.awarenessLoadFailed,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 从 DailyLight 列表构建 {day: mood} 查找表。
  Map<int, Mood> _buildMoodMap(List<DailyLight> lights) {
    final map = <int, Mood>{};
    for (final l in lights) {
      final day = int.tryParse(l.date.length >= 10 ? l.date.substring(8) : '');
      if (day != null) map[day] = l.mood;
    }
    return map;
  }
}

// ─── 月份导航 ───

class _MonthNavHeader extends StatelessWidget {
  final int year;
  final int month;
  final ValueChanged<(int, int)> onMonthChanged;

  const _MonthNavHeader({
    required this.year,
    required this.month,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _navigate(-1),
        ),
        Text(_formatMonthTitle(context), style: textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: isCurrentMonth ? null : () => _navigate(1),
        ),
      ],
    );
  }

  void _navigate(int delta) {
    var newMonth = month + delta;
    var newYear = year;
    if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    } else if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    }
    onMonthChanged((newYear, newMonth));
  }

  String _formatMonthTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMM(locale).format(DateTime(year, month));
  }
}

// ─── 星期表头 ───

class _WeekdayHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final days = [
      l10n.calendarMon,
      l10n.calendarTue,
      l10n.calendarWed,
      l10n.calendarThu,
      l10n.calendarFri,
      l10n.calendarSat,
      l10n.calendarSun,
    ];

    return Row(
      children: days
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
}

// ─── 日期网格 ───

class _DateGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<int, Mood> moodMap;
  final ValueChanged<DateTime> onDayTapped;

  const _DateGrid({
    required this.year,
    required this.month,
    required this.moodMap,
    required this.onDayTapped,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // ISO 8601: 周一 = 1，偏移量 = weekday - 1
    final startOffset = firstDay.weekday - 1;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final index = row * 7 + col;
            final day = index - startOffset + 1;
            if (day < 1 || day > daysInMonth) {
              return const Expanded(child: SizedBox(height: 48));
            }
            return Expanded(
              child: _DayCell(
                year: year,
                month: month,
                day: day,
                mood: moodMap[day],
                onTap: () => onDayTapped(DateTime(year, month, day)),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ─── 单日格子 ───

class _DayCell extends StatelessWidget {
  final int year;
  final int month;
  final int day;
  final Mood? mood;
  final VoidCallback onTap;

  const _DayCell({
    required this.year,
    required this.month,
    required this.day,
    this.mood,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = year == now.year && month == now.month && day == now.day;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (mood != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: isToday
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : null,
                alignment: Alignment.center,
                child: Text(mood!.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ] else ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHigh,
                  border: isToday
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
