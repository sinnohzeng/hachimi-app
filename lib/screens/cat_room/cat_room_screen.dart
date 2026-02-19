import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// CatHouse — 2-column grid layout showing all active cats.
class CatRoomScreen extends ConsumerWidget {
  const CatRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catsAsync = ref.watch(catsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CatHouse')),
      body: catsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (cats) {
          if (cats.isEmpty) return _buildEmpty(theme);
          return _buildGrid(context, ref, cats);
        },
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏠', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Your CatHouse is empty',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a habit to adopt your first cat!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, List<Cat> cats) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cats.length,
      itemBuilder: (context, index) {
        final cat = cats[index];
        final habits = ref.watch(habitsProvider).value ?? [];
        final habit =
            habits.where((h) => h.id == cat.boundHabitId).firstOrNull;

        return _CatHouseCard(
          cat: cat,
          habitName: habit?.name,
          habitIcon: habit?.icon,
          onTap: () => Navigator.of(context).pushNamed(
            AppRouter.catDetail,
            arguments: cat.id,
          ),
        );
      },
    );
  }
}

/// Grid card for a single cat in the CatHouse.
class _CatHouseCard extends StatelessWidget {
  final Cat cat;
  final String? habitName;
  final String? habitIcon;
  final VoidCallback onTap;

  const _CatHouseCard({
    required this.cat,
    this.habitName,
    this.habitIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final stageClr = stageColor(cat.computedStage);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pixel cat sprite
              PixelCatSprite.fromCat(cat: cat, size: 80),
              const SizedBox(height: 8),

              // Name
              Text(
                cat.name,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),

              // Habit name
              if (habitName != null)
                Text(
                  '${habitIcon ?? ""} $habitName',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),

              // Growth progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: cat.growthProgress,
                  minHeight: 6,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(stageClr),
                ),
              ),
              const SizedBox(height: 4),

              // Stage label
              Text(
                cat.stageName,
                style: textTheme.labelSmall?.copyWith(
                  color: stageClr,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
