import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/core/theme/app_elevation.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
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
import 'package:hachimi_app/screens/cat_room/components/archived_cats_section.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_badge.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_coin_display.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_progress_bar.dart';
import 'package:hachimi_app/widgets/pixel_ui/retro_tiled_background.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:hachimi_app/widgets/error_state.dart';

/// CatHouse — 活跃猫 Grid + 可折叠归档相册。
class CatRoomScreen extends ConsumerStatefulWidget {
  const CatRoomScreen({super.key});

  @override
  ConsumerState<CatRoomScreen> createState() => _CatRoomScreenState();
}

class _CatRoomScreenState extends ConsumerState<CatRoomScreen> {
  bool _isAlbumExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCatsAsync = ref.watch(catsProvider);
    final allCatsAsync = ref.watch(allCatsProvider);
    final outerScaffold = Scaffold.maybeOf(context);

    return AppScaffold(
      pattern: PatternType.dots,
      appBar: _buildAppBar(context, theme, outerScaffold),
      body: activeCatsAsync.when(
        loading: () => const SkeletonGrid(),
        error: (e, _) => ErrorState(
          message: context.l10n.catRoomLoadError,
          onRetry: () => ref.invalidate(catsProvider),
        ),
        data: (activeCats) {
          final archivedCats = _extractArchivedCats(allCatsAsync);
          return _buildBody(context, activeCats, archivedCats);
        },
      ),
    );
  }

  List<Cat> _extractArchivedCats(AsyncValue<List<Cat>> allCatsAsync) {
    final allCats = allCatsAsync.value ?? [];
    return allCats.where((c) => c.state == 'graduated').toList();
  }

  Widget _buildBody(
    BuildContext context,
    List<Cat> activeCats,
    List<Cat> archivedCats,
  ) {
    if (activeCats.isEmpty && archivedCats.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => ref.invalidate(catsProvider),
        child: ListView(children: [_buildEmpty(context)]),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(catsProvider),
      child: CustomScrollView(
        slivers: [
          if (activeCats.isNotEmpty) _buildActiveCatsGrid(activeCats),
          if (activeCats.isEmpty && archivedCats.isNotEmpty)
            SliverToBoxAdapter(child: _buildEmpty(context)),
          if (archivedCats.isNotEmpty)
            ArchivedCatsSection(
              cats: archivedCats,
              expanded: _isAlbumExpanded,
              onToggle: _toggleAlbum,
              onTap: (cat) => _navigateToCatDetail(context, cat),
              onLongPress: (cat) => _showArchivedCatActions(context, cat),
            ),
        ],
      ),
    );
  }

  void _toggleAlbum() {
    setState(() => _isAlbumExpanded = !_isAlbumExpanded);
  }

  AppBar _buildAppBar(
    BuildContext context,
    ThemeData theme,
    ScaffoldState? outerScaffold,
  ) {
    final pixel = context.pixel;

    return AppBar(
      leading: outerScaffold != null
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: outerScaffold.openDrawer,
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            )
          : null,
      title: Text(context.l10n.catRoomTitle, style: pixel.pixelTitle),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: PixelCoinDisplay(
            amount: ref.watch(coinBalanceProvider).value ?? 0,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.inventory_2),
          tooltip: context.l10n.catRoomInventory,
          onPressed: () => Navigator.of(context).pushNamed(AppRouter.inventory),
        ),
        IconButton(
          icon: const Icon(Icons.storefront),
          tooltip: context.l10n.catRoomShop,
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRouter.accessoryShop),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyState(
      icon: Icons.home_outlined,
      title: context.l10n.catRoomEmptyTitle,
      subtitle: context.l10n.catRoomEmptySubtitle,
    );
  }

  SliverPadding _buildActiveCatsGrid(List<Cat> cats) {
    return SliverPadding(
      padding: AppSpacing.paddingMd,
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildActiveCatItem(context, cats[index], index),
          childCount: cats.length,
        ),
      ),
    );
  }

  Widget _buildActiveCatItem(BuildContext context, Cat cat, int index) {
    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StaggeredListItem(
      index: index,
      child: OpenContainer<void>(
        transitionDuration: AppMotion.durationMedium4,
        closedShape: AppShape.shapeMedium,
        closedElevation: theme.cardTheme.elevation ?? AppElevation.level1,
        closedColor: theme.cardTheme.color ?? colorScheme.surfaceContainerLow,
        openColor: colorScheme.surface,
        tappable: false,
        openBuilder: (context, _) => CatDetailScreen(catId: cat.id),
        closedBuilder: (context, openContainer) => _CatHouseCard(
          cat: cat,
          habitName: habit?.name,
          habitId: habit?.id,
          onTap: openContainer,
          onLongPress: () => _showActiveCatActions(context, cat, habit),
        ),
      ),
    );
  }

  void _navigateToCatDetail(BuildContext context, Cat cat) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CatDetailScreen(catId: cat.id)),
    );
  }

  // ─── 活跃猫操作菜单 ───

  void _showActiveCatActions(BuildContext context, Cat cat, Habit? habit) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSheetTitle(ctx, cat.name),
            if (habit != null) _buildEditQuestTile(ctx, habit),
            _buildRenameTile(ctx, cat),
            _buildArchiveTile(ctx, cat),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetTitle(BuildContext ctx, String name) {
    return Padding(
      padding: AppSpacing.paddingBase,
      child: Text(
        name,
        style: Theme.of(
          ctx,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEditQuestTile(BuildContext ctx, Habit habit) {
    return ListTile(
      leading: const Icon(Icons.edit_outlined),
      title: Text(context.l10n.catRoomEditQuest),
      onTap: () {
        Navigator.of(ctx).pop();
        Navigator.of(
          context,
        ).pushNamed(AppRouter.habitDetail, arguments: habit.id);
      },
    );
  }

  Widget _buildRenameTile(BuildContext ctx, Cat cat) {
    return ListTile(
      leading: const Icon(Icons.drive_file_rename_outline),
      title: Text(context.l10n.catRoomRenameCat),
      onTap: () {
        Navigator.of(ctx).pop();
        _showRenameDialog(context, cat);
      },
    );
  }

  Widget _buildArchiveTile(BuildContext ctx, Cat cat) {
    return ListTile(
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
        _confirmArchive(context, cat);
      },
    );
  }

  // ─── 归档猫操作菜单 ───

  void _showArchivedCatActions(BuildContext context, Cat cat) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSheetTitle(ctx, cat.name),
            ListTile(
              leading: const Icon(Icons.replay),
              title: Text(context.l10n.catRoomReactivateCat),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmReactivate(context, cat);
              },
            ),
            _buildRenameTile(ctx, cat),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  // ─── 对话框 ───

  void _showRenameDialog(BuildContext context, Cat cat) {
    final controller = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.catRoomRenameCat),
        content: TextField(
          controller: controller,
          maxLength: Cat.maxNameLength,
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

  void _confirmArchive(BuildContext context, Cat cat) {
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
              await _executeArchive(cat);
            },
            child: Text(context.l10n.catRoomArchive),
          ),
        ],
      ),
    );
  }

  Future<void> _executeArchive(Cat cat) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref
        .read(localCatRepositoryProvider)
        .archive(uid, cat.id, cat.boundHabitId);
    if (!mounted) return;
    AppFeedback.success(context, context.l10n.catRoomArchiveSuccess(cat.name));
  }

  void _confirmReactivate(BuildContext context, Cat cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.catRoomReactivateTitle),
        content: Text(context.l10n.catRoomReactivateMessage(cat.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _executeReactivate(cat);
            },
            child: Text(context.l10n.catRoomReactivate),
          ),
        ],
      ),
    );
  }

  Future<void> _executeReactivate(Cat cat) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref
        .read(localCatRepositoryProvider)
        .reactivate(uid, cat.id, cat.boundHabitId);
    if (!mounted) return;
    AppFeedback.success(
      context,
      context.l10n.catRoomReactivateSuccess(cat.name),
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
    final pixel = context.pixel;
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
              TappableCatSprite(cat: cat, size: 80, enableTap: false),
              const SizedBox(height: AppSpacing.xs),

              // Name + habit
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat.name,
                      style: pixel.pixelHeading.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (habitName != null)
                      Flexible(
                        child: Text(
                          habitName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Pixel progress bar
              PixelProgressBar(
                value: cat.growthProgress,
                segments: 10,
                filledColor: stageClr,
                height: 10,
              ),
              const SizedBox(height: AppSpacing.xs),

              // Stage badge
              PixelBadge(
                text: context.l10n.stageName(cat.displayStage),
                backgroundColor: stageClr.withValues(alpha: 0.15),
                textColor: stageClr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
