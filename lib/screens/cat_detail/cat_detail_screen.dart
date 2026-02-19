import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show accessoryDisplayName;
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/widgets/streak_heatmap.dart';

/// Cat detail page — pixel cat sprite, time-based growth progress,
/// habit info, rename, and streak heatmap.
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
    final personality = personalityMap[cat.personality];
    final moodData = moodById(cat.computedMood);
    final stageClr = stageColor(cat.computedStage);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient app bar with pixel cat
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
                      stageClr.withValues(alpha: 0.2),
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      PixelCatSprite.fromCat(cat: cat, size: 120),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat.name,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _showRenameDialog(context, ref, cat),
                            tooltip: 'Rename',
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (personality != null)
                        Text(
                          '${personality.emoji} ${personality.name}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
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

                // Growth progress (time-based)
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
                              cat.stageName,
                              style: textTheme.labelLarge?.copyWith(
                                color: stageClr,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: cat.growthProgress,
                            minHeight: 12,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(stageClr),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cat.totalMinutes ~/ 60}h ${cat.totalMinutes % 60}m',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Target: ${cat.targetMinutes ~/ 60}h',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        // Stage milestones
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StageMilestone(
                              name: 'Kitten',
                              isReached: true,
                              color: stageColor('kitten'),
                            ),
                            _StageMilestone(
                              name: 'Adolescent',
                              isReached: cat.growthProgress >= 0.20,
                              color: stageColor('adolescent'),
                            ),
                            _StageMilestone(
                              name: 'Adult',
                              isReached: cat.growthProgress >= 0.45,
                              color: stageColor('adult'),
                            ),
                            _StageMilestone(
                              name: 'Senior',
                              isReached: cat.growthProgress >= 0.75,
                              color: stageColor('senior'),
                            ),
                          ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                // Accessories card
                _AccessoriesCard(cat: cat),
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
                          label: 'Personality',
                          value:
                              '${personality?.emoji ?? ''} ${personality?.name ?? cat.personality}',
                        ),
                        _InfoRow(
                          label: 'State',
                          value: cat.state.toUpperCase(),
                        ),
                        _InfoRow(
                          label: 'Pelt',
                          value: cat.appearance.peltType,
                        ),
                        if (cat.appearance.isLonghair)
                          const _InfoRow(
                            label: 'Fur',
                            value: 'Longhair',
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

  void _showRenameDialog(BuildContext context, WidgetRef ref, cat) {
    final controller = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Cat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New name',
            prefixIcon: Icon(Icons.pets),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              final uid = ref.read(currentUidProvider);
              if (uid == null) return;
              await ref.read(catFirestoreServiceProvider).renameCat(
                    uid: uid,
                    catId: cat.id,
                    newName: newName,
                  );
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}

class _StageMilestone extends StatelessWidget {
  final String name;
  final bool isReached;
  final Color color;

  const _StageMilestone({
    required this.name,
    required this.isReached,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReached ? color : colorScheme.surfaceContainerHighest,
          ),
          child: isReached
              ? Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: textTheme.labelSmall?.copyWith(
            color: isReached ? color : colorScheme.onSurfaceVariant,
            fontWeight: isReached ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _HabitHeatmapCard extends ConsumerStatefulWidget {
  final String habitId;

  const _HabitHeatmapCard({required this.habitId});

  @override
  ConsumerState<_HabitHeatmapCard> createState() => _HabitHeatmapCardState();
}

class _HabitHeatmapCardState extends ConsumerState<_HabitHeatmapCard> {
  Map<String, int>? _dailyMinutes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final data =
          await ref.read(firestoreServiceProvider).getDailyMinutesForHabit(
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_off,
                          color: colorScheme.onSurfaceVariant, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load activity data',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
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

/// 饰品装备/卸下卡片 — 数据来源为 inventoryProvider。
class _AccessoriesCard extends ConsumerWidget {
  final Cat cat;
  const _AccessoriesCard({required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasEquipped = cat.equippedAccessory != null &&
        cat.equippedAccessory!.isNotEmpty;
    final inventory = ref.watch(inventoryProvider).value ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accessories',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 当前装备
            Row(
              children: [
                Text(
                  'Equipped: ',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (hasEquipped)
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          accessoryDisplayName(cat.equippedAccessory!),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => _unequip(ref),
                          icon: const Icon(Icons.remove_circle_outline, size: 16),
                          label: const Text('Unequip'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'None',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),

            // 道具箱中可装备的饰品
            if (inventory.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'From Inventory (${inventory.length})',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: inventory.map((id) {
                  return ActionChip(
                    label: Text(
                      accessoryDisplayName(id),
                      style: textTheme.labelSmall,
                    ),
                    onPressed: () => _equip(ref, id),
                  );
                }).toList(),
              ),
            ] else if (!hasEquipped)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'No accessories yet. Visit the shop!',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _equip(WidgetRef ref, String accessoryId) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    ref.read(inventoryServiceProvider).equipAccessory(
          uid: uid,
          catId: cat.id,
          accessoryId: accessoryId,
        );
  }

  void _unequip(WidgetRef ref) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    ref.read(inventoryServiceProvider).unequipAccessory(
          uid: uid,
          catId: cat.id,
        );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

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
            ),
          ),
        ],
      ),
    );
  }
}
