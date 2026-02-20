import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/widgets/offline_banner.dart';
import 'package:hachimi_app/widgets/streak_indicator.dart';
import 'package:hachimi_app/widgets/check_in_banner.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';
import 'package:hachimi_app/screens/cat_room/cat_room_screen.dart';
import 'package:hachimi_app/screens/stats/stats_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    _TodayTab(),
    CatRoomScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRouter.adoption),
              tooltip: 'New quest',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'CatHouse',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Today tab — shows coin balance, featured cat card and habit list.
class _TodayTab extends ConsumerWidget {
  const _TodayTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final todayMinutes = ref.watch(todayMinutesPerHabitProvider);
    final catsAsync = ref.watch(catsProvider);
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Hachimi'),
        ),

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
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      label: 'Today',
                      value:
                          '${todayMinutes.values.fold(0, (a, b) => a + b)}min',
                      icon: Icons.timer_outlined,
                    ),
                    _SummaryItem(
                      label: 'Total',
                      value: '${stats.totalHoursLogged}h',
                      icon: Icons.hourglass_bottom,
                    ),
                    _SummaryItem(
                      label: 'Cats',
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
            return SliverToBoxAdapter(
              child: _FeaturedCatCard(cat: featured),
            );
          },
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Your Quests',
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
              message: 'Failed to load quests',
              onRetry: () => ref.invalidate(habitsProvider),
            ),
          ),
          data: (habits) {
            if (habits.isEmpty) {
              return const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.add_task,
                  title: 'No quests yet',
                  subtitle: 'Tap + to start a quest and adopt a cat!',
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habit = habits[index];
                  final cat = habit.catId != null
                      ? ref.watch(catByIdProvider(habit.catId!))
                      : null;
                  final minutes = todayMinutes[habit.id] ?? 0;

                  return _HabitRow(
                    habit: habit,
                    cat: cat,
                    todayMinutes: minutes,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRouter.focusSetup,
                      arguments: habit.id,
                    ),
                    onDelete: () =>
                        _confirmDelete(context, ref, habit.id, habit.name),
                  );
                },
                childCount: habits.length,
              ),
            );
          },
        ),

        // Bottom breathing space for FAB + NavigationBar
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
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
      BuildContext context, WidgetRef ref, String habitId, String habitName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete quest?'),
        content: Text(
          'Are you sure you want to delete "$habitName"? '
          'The cat will be graduated to your album.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
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
                    content: Text('$habitName completed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Featured cat card — shows the cat closest to stage-up.
class _FeaturedCatCard extends ConsumerWidget {
  final Cat cat;

  const _FeaturedCatCard({required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit =
        habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final stageClr = stageColor(cat.computedStage);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: habit != null
              ? () => Navigator.of(context)
                  .pushNamed(AppRouter.focusSetup, arguments: habit.id)
              : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  stageClr.withValues(alpha: 0.08),
                  stageClr.withValues(alpha: 0.03),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'cat-${cat.id}',
                  child: TappableCatSprite(cat: cat, size: 72),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (habit != null)
                        Text(
                          '${habit.icon} ${habit.name}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: cat.growthProgress,
                          minHeight: 6,
                          backgroundColor:
                              colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(stageClr),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${cat.totalMinutes ~/ 60}h ${cat.totalMinutes % 60}m  •  ${cat.stageName}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: habit != null
                      ? () => Navigator.of(context).pushNamed(
                          AppRouter.focusSetup,
                          arguments: habit.id)
                      : null,
                  child: const Text('Focus'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  final dynamic habit;
  final Cat? cat;
  final int todayMinutes;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HabitRow({
    required this.habit,
    required this.cat,
    required this.todayMinutes,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Cat avatar or habit emoji
              if (cat != null)
                PixelCatSprite.fromCat(cat: cat!, size: 48)
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      habit.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              const SizedBox(width: 12),

              // Habit info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (todayMinutes > 0) ...[
                          Text(
                            '${todayMinutes}min today',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' / ${habit.goalMinutes}min',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ] else
                          Text(
                            'Goal: ${habit.goalMinutes}min/day',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Streak badge
              if (habit.currentStreak > 0) ...[
                StreakIndicator(streak: habit.currentStreak),
                const SizedBox(width: 8),
              ],

              // Start button
              IconButton(
                icon: Icon(Icons.play_circle_filled,
                    color: colorScheme.primary, size: 32),
                onPressed: onTap,
                tooltip: 'Start focus',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, color: colorScheme.onPrimaryContainer, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
