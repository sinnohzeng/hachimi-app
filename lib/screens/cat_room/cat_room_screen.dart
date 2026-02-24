import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/coin_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/screens/cat_detail/cat_detail_screen.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';
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
    final outerScaffold = Scaffold.maybeOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: outerScaffold != null
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => outerScaffold.openDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              )
            : null,
        title: Text(context.l10n.catRoomTitle),
        actions: [
          // Coin balance
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.monetization_on,
                  size: 20,
                  color: theme.colorScheme.tertiary,
                  semanticLabel: 'Coins',
                ),
                const SizedBox(width: AppSpacing.xs),
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
            tooltip: context.l10n.catRoomInventory,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.inventory),
          ),
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: context.l10n.catRoomShop,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.accessoryShop),
          ),
        ],
      ),
      body: catsAsync.when(
        loading: () => const SkeletonGrid(),
        error: (e, _) => ErrorState(
          message: context.l10n.catRoomLoadError,
          onRetry: () => ref.invalidate(catsProvider),
        ),
        data: (cats) {
          if (cats.isEmpty) return _buildEmpty(context);
          return _buildGrid(context, ref, cats);
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyState(
      icon: Icons.home_outlined,
      title: context.l10n.catRoomEmptyTitle,
      subtitle: context.l10n.catRoomEmptySubtitle,
    );
  }

  void _showCatActions(
    BuildContext context,
    WidgetRef ref,
    Cat cat,
    Habit? habit,
  ) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: AppSpacing.paddingBase,
              child: Text(
                cat.name,
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (habit != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(context.l10n.catRoomEditQuest),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(
                    context,
                  ).pushNamed(AppRouter.habitDetail, arguments: habit.id);
                },
              ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: Text(context.l10n.catRoomRenameCat),
              onTap: () {
                Navigator.of(ctx).pop();
                _showRenameDialog(context, ref, cat);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.archive_outlined,
                color: Theme.of(ctx).colorScheme.error,
              ),
              title: Text(
                context.l10n.catRoomArchiveCat,
                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmArchive(context, ref, cat);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
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
        title: Text(context.l10n.catRoomRenameCat),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.catRoomNewName,
            prefixIcon: const Icon(Icons.pets),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              final uid = ref.read(currentUidProvider);
              if (uid == null) return;
              final renamedCat = cat.copyWith(name: newName);
              await ref
                  .read(localCatRepositoryProvider)
                  .update(uid, renamedCat);
              ref
                  .read(ledgerServiceProvider)
                  .notifyChange(const LedgerChange(type: 'cat_update'));
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: Text(context.l10n.catRoomRename),
          ),
        ],
      ),
    );
  }

  void _confirmArchive(BuildContext context, WidgetRef ref, Cat cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.catRoomArchiveTitle),
        content: Text(context.l10n.catRoomArchiveMessage(cat.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final uid = ref.read(currentUidProvider);
              if (uid == null) return;
              await ref.read(localCatRepositoryProvider).graduate(uid, cat.id);
              if (cat.boundHabitId.isNotEmpty) {
                await ref
                    .read(localHabitRepositoryProvider)
                    .delete(uid, cat.boundHabitId);
              }
            },
            child: Text(context.l10n.catRoomArchive),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, List<Cat> cats) {
    return GridView.builder(
      padding: AppSpacing.paddingMd,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cats.length,
      itemBuilder: (context, index) {
        final cat = cats[index];
        final habits = ref.watch(habitsProvider).value ?? [];
        final habit = habits.where((h) => h.id == cat.boundHabitId).firstOrNull;

        return StaggeredListItem(
          index: index,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: _CatHouseCard(
              cat: cat,
              habitName: habit?.name,
              habitId: habit?.id,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CatDetailScreen(catId: cat.id),
                  ),
                );
              },
              onLongPress: () => _showCatActions(context, ref, cat, habit),
            ),
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
  final String? habitId;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _CatHouseCard({
    required this.cat,
    this.habitName,
    this.habitId,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final stageClr = stageColor(cat.displayStage);

    return Semantics(
      label: habitName != null
          ? '${cat.name}, $habitName, ${context.l10n.stageName(cat.displayStage)}'
          : '${cat.name}, ${context.l10n.stageName(cat.displayStage)}',
      button: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            children: [
              // Pixel cat sprite — Hero flies to CatDetailScreen
              Hero(
                tag: 'cat-${cat.id}',
                child: TappableCatSprite(cat: cat, size: 80, enableTap: false),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Name + habit (flexible to prevent overflow)
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'cat-name-${cat.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          cat.name,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (habitName != null)
                      Flexible(
                        child: Text(
                          habitName!,
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
              const SizedBox(height: AppSpacing.xs),

              // Growth progress bar
              ClipRRect(
                borderRadius: AppShape.borderExtraSmall,
                child: LinearProgressIndicator(
                  value: cat.growthProgress,
                  minHeight: 6,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(stageClr),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Stage label
              Text(
                context.l10n.stageName(cat.displayStage),
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
