// ---
// 📘 文件说明：
// 月度签到详情页 — 展示日历网格、里程碑进度、奖励说明。
//
// 📋 程序整体伪代码：
// 1. 从 monthlyCheckInProvider 获取当月签到数据；
// 2. 渲染统计卡片（X/N 天，Y 金币，下一里程碑）；
// 3. 渲染 7 列日历网格（已签到/未签到/今日/未来）；
// 4. 渲染里程碑进度卡片；
// 5. 渲染奖励说明卡片；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/coin_provider.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyCheckInProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Check-In')),
      body: monthlyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (monthly) {
          final data = monthly ?? MonthlyCheckIn.empty('');
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatsCard(monthly: data, theme: theme),
                const SizedBox(height: 16),
                _CalendarGrid(monthly: data, theme: theme),
                const SizedBox(height: 16),
                _MilestonesCard(monthly: data, theme: theme),
                const SizedBox(height: 16),
                _RewardScheduleCard(theme: theme),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 统计摘要卡片。
class _StatsCard extends StatelessWidget {
  final MonthlyCheckIn monthly;
  final ThemeData theme;

  const _StatsCard({required this.monthly, required this.theme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final colorScheme = theme.colorScheme;

    // 找出下一个未达成的里程碑
    String nextMilestoneText = 'All milestones claimed!';
    final allThresholds = [...checkInMilestones.keys, daysInMonth];
    for (final threshold in allThresholds) {
      if (!monthly.milestonesClaimed.contains(threshold) &&
          monthly.checkedCount < threshold) {
        final bonus = threshold == daysInMonth
            ? checkInFullMonthBonus
            : checkInMilestones[threshold]!;
        final remaining = threshold - monthly.checkedCount;
        nextMilestoneText = '$remaining more days → +$bonus coins';
        break;
      }
    }

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  value: '${monthly.checkedCount}/$daysInMonth',
                  label: 'Days',
                  icon: Icons.calendar_today,
                  color: colorScheme.onPrimaryContainer,
                ),
                _StatItem(
                  value: '${monthly.totalCoins}',
                  label: 'Coins earned',
                  icon: Icons.monetization_on,
                  color: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    nextMilestoneText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

/// 7 列日历网格。
class _CalendarGrid extends StatelessWidget {
  final MonthlyCheckIn monthly;
  final ThemeData theme;

  const _CalendarGrid({required this.monthly, required this.theme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final today = now.day;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon, 7=Sun
    final colorScheme = theme.colorScheme;

    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_monthName(month)} $year',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 8),
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

        cells.add(Expanded(
          child: Container(
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChecked
                  ? colorScheme.primary
                  : isWeekendCol
                      ? colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5)
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
                            ? colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : isToday
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                        fontWeight: isToday ? FontWeight.bold : null,
                      ),
                    ),
            ),
          ),
        ));
        day++;
      }
      weeks.add(Row(children: cells));
    }
    return weeks;
  }

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month];
  }
}

/// 里程碑进度卡片。
class _MilestonesCard extends StatelessWidget {
  final MonthlyCheckIn monthly;
  final ThemeData theme;

  const _MilestonesCard({required this.monthly, required this.theme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final colorScheme = theme.colorScheme;

    final milestones = <_MilestoneData>[
      for (final entry in checkInMilestones.entries)
        _MilestoneData(
          threshold: entry.key,
          bonus: entry.value,
          isClaimed: monthly.milestonesClaimed.contains(entry.key),
        ),
      _MilestoneData(
        threshold: daysInMonth,
        bonus: checkInFullMonthBonus,
        isClaimed: monthly.milestonesClaimed.contains(daysInMonth),
        label: 'Full month',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milestones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (final m in milestones) ...[
              _MilestoneRow(
                milestone: m,
                currentCount: monthly.checkedCount,
                colorScheme: colorScheme,
                theme: theme,
              ),
              if (m != milestones.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MilestoneData {
  final int threshold;
  final int bonus;
  final bool isClaimed;
  final String? label;

  const _MilestoneData({
    required this.threshold,
    required this.bonus,
    required this.isClaimed,
    this.label,
  });
}

class _MilestoneRow extends StatelessWidget {
  final _MilestoneData milestone;
  final int currentCount;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _MilestoneRow({
    required this.milestone,
    required this.currentCount,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        (currentCount / milestone.threshold).clamp(0.0, 1.0);
    final label =
        milestone.label ?? '${milestone.threshold} days';

    return Row(
      children: [
        Icon(
          milestone.isClaimed ? Icons.check_circle : Icons.circle_outlined,
          color: milestone.isClaimed
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: milestone.isClaimed
                          ? TextDecoration.lineThrough
                          : null,
                      color: milestone.isClaimed
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '+${milestone.bonus}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: milestone.isClaimed
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.primary,
                      decoration: milestone.isClaimed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
              if (!milestone.isClaimed) ...[
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor:
                        AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// 奖励说明卡片。
class _RewardScheduleCard extends StatelessWidget {
  final ThemeData theme;

  const _RewardScheduleCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reward Schedule',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _RewardRow(
              icon: Icons.work_outline,
              label: 'Weekday (Mon–Fri)',
              value: '$checkInCoinsWeekday coins/day',
              color: colorScheme.onSurfaceVariant,
              theme: theme,
            ),
            const SizedBox(height: 8),
            _RewardRow(
              icon: Icons.weekend_outlined,
              label: 'Weekend (Sat–Sun)',
              value: '$checkInCoinsWeekend coins/day',
              color: colorScheme.tertiary,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _RewardRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
