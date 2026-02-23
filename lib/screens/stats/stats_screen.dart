import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/session_stats_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';
import 'package:hachimi_app/widgets/streak_heatmap.dart';
import 'package:intl/intl.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logStatsViewed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsProvider);
    final habitsAsync = ref.watch(habitsProvider);
    final dailyMinutes = ref.watch(dailyMinutesProvider).value ?? {};
    final activeDays = dailyMinutes.values.where((m) => m > 0).length;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(l10n.statsTitle),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRouter.sessionHistory),
              tooltip: l10n.historyTitle,
            ),
          ],
        ),

        // Summary cards (2×2)
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingBase,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: l10n.statsTotalHours,
                        value: l10n.statsTimeValue(
                          stats.totalHoursLogged,
                          stats.remainingMinutes,
                        ),
                        icon: Icons.hourglass_bottom,
                        color: colorScheme.primaryContainer,
                        onColor: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        label: l10n.statsBestStreak,
                        value: '${stats.totalHabits}',
                        icon: Icons.flag,
                        color: colorScheme.tertiaryContainer,
                        onColor: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: l10n.statsTotalHabits,
                        value: '${stats.totalHabits}',
                        icon: Icons.category_outlined,
                        color: colorScheme.secondaryContainer,
                        onColor: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        label: l10n.statsActiveDays,
                        value: '$activeDays',
                        icon: Icons.calendar_today,
                        color: colorScheme.surfaceContainerHighest,
                        onColor: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Weekly trend chart
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingHBase,
            child: _WeeklyTrendCard(),
          ),
        ),

        // 30-day heatmap
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: _HeatmapCard(),
          ),
        ),

        // Overall progress
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingHBase,
            child: Card(
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsOverallProgress,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value: stats.overallProgress,
                      minHeight: 8,
                      borderRadius: AppShape.borderExtraSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.statsPercentOfGoals(
                        (stats.overallProgress * 100).toStringAsFixed(1),
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Per-habit progress
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              l10n.statsPerQuestProgress,
              style: textTheme.titleMedium,
            ),
          ),
        ),

        habitsAsync.when(
          loading: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, _) => const SkeletonCard(),
              childCount: 3,
            ),
          ),
          error: (e, _) => SliverFillRemaining(
            child: ErrorState(
              message: l10n.statsQuestLoadError,
              onRetry: () => ref.invalidate(habitsProvider),
            ),
          ),
          data: (habits) {
            if (habits.isEmpty) {
              return SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.bar_chart_outlined,
                  title: l10n.statsNoQuestData,
                  subtitle: l10n.statsNoQuestHint,
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final habit = habits[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Padding(
                    padding: AppSpacing.paddingBase,
                    child: Row(
                      children: [
                        ProgressRing(
                          progress: habit.progressPercent,
                          size: 48,
                          child: Text(
                            '${(habit.progressPercent * 100).round()}%',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.base),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(habit.name, style: textTheme.titleSmall),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                habit.progressText,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (habit.totalCheckInDays > 0)
                          Chip(
                            avatar: Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: colorScheme.onTertiaryContainer,
                            ),
                            label: Text('${habit.totalCheckInDays}d'),
                            backgroundColor: colorScheme.tertiaryContainer,
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: habits.length),
            );
          },
        ),

        // Recent sessions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(l10n.statsRecentSessions, style: textTheme.titleMedium),
          ),
        ),
        SliverToBoxAdapter(child: _RecentSessionsCard()),

        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }
}

// ─── Summary stat card ───

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color onColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: color,
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: onColor),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: onColor,
              ),
            ),
            Text(label, style: textTheme.bodySmall?.copyWith(color: onColor)),
          ],
        ),
      ),
    );
  }
}

// ─── Weekly trend bar chart ───

class _WeeklyTrendCard extends ConsumerWidget {
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
              data: (dailyMinutes) {
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
                                    fontWeight: bars[idx].isToday
                                        ? FontWeight.bold
                                        : null,
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
              },
            ),
          ],
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

// ─── 30-day heatmap ───

class _HeatmapCard extends ConsumerWidget {
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

// ─── Recent sessions card ───

class _RecentSessionsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(recentSessionsProvider);
    final habits = ref.watch(habitsProvider).value ?? [];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: AppSpacing.paddingHBase,
      child: Card(
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: sessionsAsync.when(
            loading: () => const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => const SizedBox(height: 80),
            data: (sessions) {
              if (sessions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      l10n.historyNoSessions,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...sessions.map((session) {
                    final habit = habits
                        .where((h) => h.id == session.habitId)
                        .firstOrNull;
                    return _SessionTile(
                      session: session,
                      habitName: habit?.name ?? '',
                    );
                  }),
                  const Divider(height: 1),
                  TextButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRouter.sessionHistory),
                    child: Text(l10n.statsViewAllHistory),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final FocusSession session;
  final String habitName;

  const _SessionTile({required this.session, required this.habitName});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final modeLabel = session.mode == 'countdown'
        ? l10n.sessionCountdown
        : l10n.sessionStopwatch;
    final statusIcon = session.isCompleted
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;
    final statusColor = session.isCompleted
        ? colorScheme.primary
        : colorScheme.error;
    final timeStr = DateFormat.Hm().format(session.endedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(statusIcon, size: 20, color: statusColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${session.durationMinutes} min · $modeLabel · $timeStr',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (session.coinsEarned > 0)
            Text(
              '+${session.coinsEarned}',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
