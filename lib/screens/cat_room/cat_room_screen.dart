import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/coin_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';

/// CatHouse — 2-column grid layout showing all active cats.
class CatRoomScreen extends ConsumerWidget {
  const CatRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catsAsync = ref.watch(catsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CatHouse'),
        actions: [
          // Coin balance
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on,
                    size: 20, color: theme.colorScheme.tertiary),
                const SizedBox(width: 4),
                Text(
                  '${ref.watch(coinBalanceProvider).value ?? 0}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.inventory_2),
            tooltip: 'Inventory',
            onPressed: () => Navigator.of(context).pushNamed(
              AppRouter.inventory,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: 'Accessory Shop',
            onPressed: () => Navigator.of(context).pushNamed(
              AppRouter.accessoryShop,
            ),
          ),
        ],
      ),
      body: catsAsync.when(
        loading: () => const SkeletonGrid(),
        error: (e, _) => ErrorState(
          message: 'Failed to load cats',
          onRetry: () => ref.invalidate(catsProvider),
        ),
        data: (cats) {
          if (cats.isEmpty) return _buildEmpty(theme);
          return _buildGrid(context, ref, cats);
        },
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return const EmptyState(
      icon: Icons.home_outlined,
      title: 'Your CatHouse is empty',
      subtitle: 'Start a quest to adopt your first cat!',
    );
  }

  void _showCatActions(BuildContext context, WidgetRef ref, Cat cat, dynamic habit) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                cat.name,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (habit != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Quest'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushNamed(
                    AppRouter.habitDetail,
                    arguments: habit.id as String,
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: const Text('Rename Cat'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showRenameDialog(context, ref, cat);
              },
            ),
            ListTile(
              leading: Icon(Icons.archive_outlined,
                  color: Theme.of(ctx).colorScheme.error),
              title: Text(
                'Archive Cat',
                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmArchive(context, ref, cat);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, Cat cat) {
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

  void _confirmArchive(BuildContext context, WidgetRef ref, Cat cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archive cat?'),
        content: Text(
          'This will archive "${cat.name}" and delete its bound quest. '
          'The cat will still appear in your album.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final uid = ref.read(currentUidProvider);
              if (uid == null) return;
              await ref.read(catFirestoreServiceProvider).archiveCat(
                    uid: uid,
                    catId: cat.id,
                  );
              if (cat.boundHabitId.isNotEmpty) {
                await ref.read(firestoreServiceProvider).deleteHabit(
                      uid: uid,
                      habitId: cat.boundHabitId,
                    );
              }
            },
            child: const Text('Archive'),
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
        childAspectRatio: 0.78,
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
          habitId: habit?.id,
          onTap: () => Navigator.of(context).pushNamed(
            AppRouter.catDetail,
            arguments: cat.id,
          ),
          onLongPress: () => _showCatActions(context, ref, cat, habit),
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
  final String? habitId;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _CatHouseCard({
    required this.cat,
    this.habitName,
    this.habitIcon,
    this.habitId,
    required this.onTap,
    this.onLongPress,
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
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Pixel cat sprite
              Hero(
                tag: 'cat-${cat.id}',
                child: TappableCatSprite(cat: cat, size: 80),
              ),
              const SizedBox(height: 4),

              // Name + habit (flexible to prevent overflow)
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (habitName != null)
                      Flexible(
                        child: Text(
                          '${habitIcon ?? ""} $habitName',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

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
