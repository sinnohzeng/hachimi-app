import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/session_stats_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';

import 'overview_stat_card.dart';
import 'overview_weekly_trend.dart';
import 'overview_heatmap_card.dart';
import 'overview_recent_sessions.dart';

/// 概览 Tab — 统计概览内容。
/// 响应式布局：compact 纵向堆叠，expanded 并排 + 多列。
class OverviewTab extends ConsumerStatefulWidget {
  const OverviewTab({super.key});

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= AppBreakpoints.expanded;
        final edgePadding = isExpanded ? AppSpacing.lg : AppSpacing.base;

        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            _buildSummaryCards(
              stats,
              activeDays,
              colorScheme,
              l10n,
              isExpanded,
              edgePadding,
            ),
            _buildCharts(isExpanded, edgePadding),
            _buildOverallProgress(
              stats,
              textTheme,
              colorScheme,
              l10n,
              isExpanded,
              edgePadding,
            ),
            _buildHabitHeader(textTheme, l10n, edgePadding),
            _buildHabitProgress(
              habitsAsync,
              textTheme,
              colorScheme,
              l10n,
              isExpanded,
              edgePadding,
            ),
            _buildSessionsHeader(textTheme, l10n, edgePadding),
            _buildRecentSessions(isExpanded),
          ],
        );
      },
    );
  }

  // ─── Summary cards ───

  Widget _buildSummaryCards(
    HabitStats stats,
    int activeDays,
    ColorScheme colorScheme,
    S l10n,
    bool isExpanded,
    double edgePadding,
  ) {
    final cards = [
      OverviewStatCard(
        label: l10n.statsTotalHours,
        value: l10n.statsTimeValue(
          stats.totalHoursLogged,
          stats.remainingMinutes,
        ),
        icon: Icons.hourglass_bottom,
        color: colorScheme.primaryContainer,
        onColor: colorScheme.onPrimaryContainer,
      ),
      OverviewStatCard(
        label: l10n.statsBestStreak,
        value: '${stats.totalHabits}',
        icon: Icons.flag,
        color: colorScheme.tertiaryContainer,
        onColor: colorScheme.onTertiaryContainer,
      ),
      OverviewStatCard(
        label: l10n.statsTotalHabits,
        value: '${stats.totalHabits}',
        icon: Icons.category_outlined,
        color: colorScheme.secondaryContainer,
        onColor: colorScheme.onSecondaryContainer,
      ),
      OverviewStatCard(
        label: l10n.statsActiveDays,
        value: '$activeDays',
        icon: Icons.calendar_today,
        color: colorScheme.surfaceContainerHighest,
        onColor: colorScheme.onSurface,
      ),
    ];

    if (isExpanded) {
      // Expanded: 单行 4 个卡片
      return Padding(
        padding: EdgeInsets.all(edgePadding),
        child: Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              Expanded(child: cards[i]),
            ],
          ],
        ),
      );
    }

    // Compact: 2×2 网格
    return Padding(
      padding: EdgeInsets.all(edgePadding),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Charts (weekly trend + heatmap) ───

  Widget _buildCharts(bool isExpanded, double edgePadding) {
    if (isExpanded) {
      // Expanded: 并排显示
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: edgePadding),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: OverviewWeeklyTrend()),
            SizedBox(width: AppSpacing.base),
            Expanded(child: OverviewHeatmapCard()),
          ],
        ),
      );
    }

    // Compact: 纵向堆叠
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: edgePadding),
          child: const OverviewWeeklyTrend(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(edgePadding, 12, edgePadding, 4),
          child: const OverviewHeatmapCard(),
        ),
      ],
    );
  }

  // ─── Overall progress ───

  Widget _buildOverallProgress(
    HabitStats stats,
    TextTheme textTheme,
    ColorScheme colorScheme,
    S l10n,
    bool isExpanded,
    double edgePadding,
  ) {
    final card = Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statsOverallProgress, style: textTheme.titleMedium),
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
    );

    if (isExpanded) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: edgePadding),
        child: ContentWidthConstraint(child: card),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edgePadding),
      child: card,
    );
  }

  // ─── Section headers ───

  Widget _buildHabitHeader(TextTheme textTheme, S l10n, double edgePadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(edgePadding, 24, edgePadding, 8),
      child: Text(l10n.statsPerQuestProgress, style: textTheme.titleMedium),
    );
  }

  Widget _buildSessionsHeader(TextTheme textTheme, S l10n, double edgePadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(edgePadding, 24, edgePadding, 8),
      child: Text(l10n.statsRecentSessions, style: textTheme.titleMedium),
    );
  }

  // ─── Per-habit progress ───

  Widget _buildHabitProgress(
    AsyncValue<List<Habit>> habitsAsync,
    TextTheme textTheme,
    ColorScheme colorScheme,
    S l10n,
    bool isExpanded,
    double edgePadding,
  ) {
    return habitsAsync.when(
      loading: () =>
          Column(children: List.generate(3, (_) => const SkeletonCard())),
      error: (e, _) => ErrorState(
        message: l10n.statsQuestLoadError,
        onRetry: () => ref.invalidate(habitsProvider),
      ),
      data: (habits) {
        if (habits.isEmpty) {
          return EmptyState(
            icon: Icons.bar_chart_outlined,
            title: l10n.statsNoQuestData,
            subtitle: l10n.statsNoQuestHint,
          );
        }

        final cards = habits
            .map((h) => _habitCard(h, textTheme, colorScheme, edgePadding))
            .toList();

        if (!isExpanded) return Column(children: cards);

        // Expanded: 2 列布局
        return _twoColumnLayout(cards, edgePadding);
      },
    );
  }

  Widget _habitCard(
    Habit habit,
    TextTheme textTheme,
    ColorScheme colorScheme,
    double edgePadding,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: edgePadding, vertical: 4),
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
  }

  /// 将卡片列表排成 2 列，奇数时最后一行只放一个。
  Widget _twoColumnLayout(List<Widget> cards, double edgePadding) {
    final rows = <Widget>[];
    for (int i = 0; i < cards.length; i += 2) {
      if (i + 1 < cards.length) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[i]),
              Expanded(child: cards[i + 1]),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            children: [
              Expanded(child: cards[i]),
              const Spacer(),
            ],
          ),
        );
      }
    }
    return Column(children: rows);
  }

  // ─── Recent sessions ───

  Widget _buildRecentSessions(bool isExpanded) {
    if (isExpanded) {
      return const ContentWidthConstraint(child: OverviewRecentSessions());
    }
    return const OverviewRecentSessions();
  }
}
