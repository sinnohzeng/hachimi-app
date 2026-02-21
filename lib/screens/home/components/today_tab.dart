import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/check_in_banner.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';
import 'package:hachimi_app/widgets/offline_banner.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';

import 'featured_cat_card.dart';
import 'habit_row.dart';
import 'summary_item.dart';

/// Today tab -- shows coin balance, featured cat card and habit list.
class TodayTab extends ConsumerWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final todayMinutes = ref.watch(todayMinutesPerHabitProvider);
    final catsAsync = ref.watch(catsProvider);
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final l10n = context.l10n;

    return CustomScrollView(
      slivers: [
        SliverAppBar(floating: true, title: Text(l10n.appTitle)),

        // Daily check-in trigger
        const SliverToBoxAdapter(child: CheckInBanner()),

        // Offline banner
        const SliverToBoxAdapter(child: OfflineBanner()),

        // Today summary
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SummaryItem(
                      label: l10n.todaySummaryMinutes,
                      value:
                          '${todayMinutes.values.fold(0, (a, b) => a + b)}min',
                      icon: Icons.timer_outlined,
                    ),
                    SummaryItem(
                      label: l10n.todaySummaryTotal,
                      value: '${stats.totalHoursLogged}h',
                      icon: Icons.hourglass_bottom,
                    ),
                    SummaryItem(
                      label: l10n.todaySummaryCats,
                      value: '${catsAsync.value?.length ?? 0}',
                      icon: Icons.pets,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Featured cat card
        catsAsync.when(
          loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          data: (cats) {
            if (cats.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            final featured = _findFeaturedCat(cats);
            if (featured == null) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverToBoxAdapter(child: FeaturedCatCard(cat: featured));
          },
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.todayYourQuests,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Habit list
        habitsAsync.when(
          loading: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => const SkeletonCard(),
              childCount: 3,
            ),
          ),
          error: (error, _) => SliverFillRemaining(
            child: ErrorState(
              message: l10n.todayFailedToLoad,
              onRetry: () => ref.invalidate(habitsProvider),
            ),
          ),
          data: (habits) {
            if (habits.isEmpty) {
              return SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.add_task,
                  title: l10n.todayNoQuests,
                  subtitle: l10n.todayNoQuestsHint,
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final habit = habits[index];
                final cat = habit.catId != null
                    ? ref.watch(catByIdProvider(habit.catId!))
                    : null;
                final minutes = todayMinutes[habit.id] ?? 0;

                return HabitRow(
                  habit: habit,
                  cat: cat,
                  todayMinutes: minutes,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRouter.focusSetup, arguments: habit.id),
                  onDelete: () =>
                      _confirmDelete(context, ref, habit.id, habit.name),
                );
              }, childCount: habits.length),
            );
          },
        ),

        // Bottom breathing space for FAB + NavigationBar
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Cat? _findFeaturedCat(List<Cat> cats) {
    if (cats.isEmpty) return null;
    Cat? best;
    double bestProgress = -1;

    for (final cat in cats) {
      if (cat.computedStage != 'senior') {
        final progress = cat.stageProgress;
        if (progress > bestProgress) {
          bestProgress = progress;
          best = cat;
        }
      }
    }
    return best ?? cats.first;
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String habitId,
    String habitName,
  ) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.todayDeleteQuestTitle),
        content: Text(l10n.todayDeleteQuestMessage(habitName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              final uid = ref.read(currentUidProvider);
              if (uid != null) {
                HapticFeedback.mediumImpact();
                await ref
                    .read(firestoreServiceProvider)
                    .deleteHabit(uid: uid, habitId: habitId);
                await ref
                    .read(analyticsServiceProvider)
                    .logHabitDeleted(habitName: habitName);
              }
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(l10n.todayQuestCompleted(habitName)),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
  }
}
