import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:intl/intl.dart';

/// 7 列日历网格。
class CalendarGrid extends StatelessWidget {
  final MonthlyCheckIn monthly;
  final ThemeData theme;

  const CalendarGrid({super.key, required this.monthly, required this.theme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final today = now.day;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon, 7=Sun
    final colorScheme = theme.colorScheme;

    final l10n = context.l10n;
    final weekdays = [
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
      l10n.weekdaySat,
      l10n.weekdaySun,
    ];

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMM(
                Localizations.localeOf(context).toString(),
              ).format(DateTime(year, month)),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // 星期标题行
            Row(
              children: List.generate(7, (i) {
                final isWeekend = i >= 5;
                return Expanded(
                  child: Center(
                    child: Text(
                      weekdays[i],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isWeekend
                            ? colorScheme.tertiary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.sm),
            // 日期网格
            ..._buildWeeks(
              daysInMonth: daysInMonth,
              firstWeekday: firstWeekday,
              today: today,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWeeks({
    required int daysInMonth,
    required int firstWeekday,
    required int today,
    required ColorScheme colorScheme,
  }) {
    final weeks = <Widget>[];
    // firstWeekday: 1=Mon → offset 0, 7=Sun → offset 6
    final offset = firstWeekday - 1;

    int day = 1;
    for (int week = 0; week < 6 && day <= daysInMonth; week++) {
      final cells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        final cellIndex = week * 7 + col;
        if (cellIndex < offset || day > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 40)));
          continue;
        }

        final currentDay = day;
        final isChecked = monthly.isCheckedOn(currentDay);
        final isToday = currentDay == today;
        final isPast = currentDay < today;
        final isWeekendCol = col >= 5;

        cells.add(
          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked
                    ? colorScheme.primary
                    : isWeekendCol
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                    : null,
                border: isToday && !isChecked
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: isChecked
                    ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary)
                    : Text(
                        '$currentDay',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isPast
                              ? colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                )
                              : isToday
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isToday ? FontWeight.bold : null,
                        ),
                      ),
              ),
            ),
          ),
        );
        day++;
      }
      weeks.add(Row(children: cells));
    }
    return weeks;
  }
}
