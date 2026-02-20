import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final habitsAsync = ref.watch(habitsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('Statistics'),
          automaticallyImplyLeading: false,
        ),

        // Summary cards
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingBase,
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Hours',
                    value:
                        '${stats.totalHoursLogged}h ${stats.remainingMinutes}m',
                    icon: Icons.hourglass_bottom,
                    color: colorScheme.primaryContainer,
                    onColor: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatCard(
                    label: 'Best Streak',
                    value: '${stats.longestStreak} days',
                    icon: Icons.local_fire_department,
                    color: colorScheme.tertiaryContainer,
                    onColor: colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
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
                    Text('Overall Progress', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value: stats.overallProgress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${(stats.overallProgress * 100).toStringAsFixed(1)}% of all goals',
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
            child: Text('Per-Quest Progress', style: textTheme.titleMedium),
          ),
        ),

        habitsAsync.when(
          loading: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => const SkeletonCard(),
              childCount: 3,
            ),
          ),
          error: (e, _) => SliverFillRemaining(
            child: ErrorState(
              message: 'Failed to load quest stats',
              onRetry: () => ref.invalidate(habitsProvider),
            ),
          ),
          data: (habits) {
            if (habits.isEmpty) {
              return const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.bar_chart_outlined,
                  title: 'No quest data yet',
                  subtitle: 'Start a quest to see your progress here!',
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
                        if (habit.currentStreak > 0)
                          Chip(
                            avatar: Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: colorScheme.onTertiaryContainer,
                            ),
                            label: Text('${habit.currentStreak}d'),
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

        // Calendar heatmap placeholder
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text('Last 30 Days', style: textTheme.titleMedium),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingBase,
            child: Card(
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: _CalendarHeatmap(),
              ),
            ),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }
}

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

class _CalendarHeatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(30, (index) {
        final day = now.subtract(Duration(days: 29 - index));
        // Placeholder: show a simple grid (real data would come from Firestore)
        return Tooltip(
          message: '${day.month}/${day.day}',
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
