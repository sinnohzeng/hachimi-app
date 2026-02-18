import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/cat_sprite.dart';
import 'package:hachimi_app/widgets/streak_heatmap.dart';

/// Cat detail page — shows large cat sprite, XP progress, habit info,
/// and streak heatmap.
class CatDetailScreen extends ConsumerWidget {
  final String catId;

  const CatDetailScreen({super.key, required this.catId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final cat = ref.watch(catByIdProvider(catId));
    if (cat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Cat not found')),
      );
    }

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit =
        habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final breedData = breedMap[cat.breed];
    final personalityData = personalityMap[cat.personality];
    final bgColor = breedData?.colors.base ?? colorScheme.primary;
    final moodData = moodById(cat.computedMood);

    // Stage progress
    final nextStageThreshold = cat.computedStage < 4
        ? catStages[cat.computedStage].xpThreshold
        : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient app bar with cat
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      bgColor.withValues(alpha: 0.2),
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      CatSprite.fromCat(
                        breed: cat.breed,
                        stage: cat.computedStage,
                        mood: cat.computedMood,
                        size: 120,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cat.name,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${breedData?.name ?? cat.breed} ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${personalityData?.emoji ?? ''} ${personalityData?.name ?? cat.personality}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Mood badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${moodData.emoji} ${moodData.name}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // XP Progress
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Growth Progress',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${cat.stageName} ${catStages[cat.computedStage - 1].emoji}',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // XP bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: cat.stageProgress,
                            minHeight: 12,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cat.xp} XP',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (nextStageThreshold != null)
                              Text(
                                'Next: $nextStageThreshold XP',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              )
                            else
                              Text(
                                'MAX LEVEL',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        // Stage milestones
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: catStages.map((stage) {
                            final isReached = cat.xp >= stage.xpThreshold;
                            return Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isReached
                                        ? colorScheme.primary
                                        : colorScheme
                                            .surfaceContainerHighest,
                                  ),
                                  child: Center(
                                    child: Text(
                                      stage.emoji,
                                      style:
                                          const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  stage.name,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: isReached
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: isReached
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Habit info
                if (habit != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bound Habit',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(habit.icon,
                                  style: const TextStyle(fontSize: 28)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit.name,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Goal: ${habit.goalMinutes}min/day  •  Total: ${habit.totalMinutes ~/ 60}h ${habit.totalMinutes % 60}m',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (habit.currentStreak > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                          Icons.local_fire_department,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${habit.currentStreak}',
                                        style:
                                            textTheme.labelMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRouter.focusSetup,
                                  arguments: habit.id,
                                );
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Focus'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Streak heatmap
                if (habit != null)
                  _HabitHeatmapCard(habitId: habit.id),
                const SizedBox(height: 16),

                // Cat info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cat Info',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          label: 'Breed',
                          value: breedData?.name ?? cat.breed,
                        ),
                        _InfoRow(
                          label: 'Rarity',
                          value: cat.rarity.toUpperCase(),
                          valueColor: _rarityColor(cat.rarity),
                        ),
                        _InfoRow(
                          label: 'Personality',
                          value:
                              '${personalityData?.emoji ?? ''} ${personalityData?.name ?? cat.personality}',
                        ),
                        _InfoRow(
                          label: 'State',
                          value: cat.state.toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'rare':
        return const Color(0xFFE040FB);
      case 'uncommon':
        return const Color(0xFF448AFF);
      default:
        return const Color(0xFF66BB6A);
    }
  }
}

/// Loads and displays a streak heatmap for a specific habit.
class _HabitHeatmapCard extends ConsumerStatefulWidget {
  final String habitId;

  const _HabitHeatmapCard({required this.habitId});

  @override
  ConsumerState<_HabitHeatmapCard> createState() => _HabitHeatmapCardState();
}

class _HabitHeatmapCardState extends ConsumerState<_HabitHeatmapCard> {
  Map<String, int>? _dailyMinutes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final data = await ref.read(firestoreServiceProvider).getDailyMinutesForHabit(
          uid: uid,
          habitId: widget.habitId,
          lastNDays: 91,
        );

    if (mounted) {
      setState(() {
        _dailyMinutes = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              StreakHeatmap(dailyMinutes: _dailyMinutes ?? {}),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
