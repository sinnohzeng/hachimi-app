import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ai_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/core/utils/background_color_utils.dart';
import 'package:hachimi_app/widgets/animated_mesh_background.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';
import 'package:hachimi_app/widgets/guest_upgrade_prompt.dart';

import 'components/focus_stats_card.dart';
import 'components/reminder_card.dart';
import 'components/diary_preview_card.dart';
import 'components/chat_entry_card.dart';
import 'components/habit_heatmap_card.dart';
import 'components/accessories_card.dart';
import 'components/cat_info_card.dart';

/// Cat detail page — the central hub for a cat and its bound quest.
class CatDetailScreen extends ConsumerStatefulWidget {
  final String catId;

  const CatDetailScreen({super.key, required this.catId});

  @override
  ConsumerState<CatDetailScreen> createState() => _CatDetailScreenState();
}

class _CatDetailScreenState extends ConsumerState<CatDetailScreen> {
  late final ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.hasClients && _scrollController.offset > 200;
    if (show != _showAppBarTitle) setState(() => _showAppBarTitle = show);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = ref.watch(catByIdProvider(widget.catId));
    if (cat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.catDetailNotFound)),
      );
    }

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final personality = personalityMap[cat.personality];
    final moodData = moodById(cat.computedMood);
    final colorScheme = Theme.of(context).colorScheme;
    final meshColors = catMeshColors(
      cat.displayStage,
      cat.appearance.peltColor,
      colorScheme,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= AppBreakpoints.expanded;
          if (isWide) {
            return _buildWideLayout(
              context,
              cat: cat,
              habit: habit,
              personality: personality,
              moodData: moodData,
              meshColors: meshColors,
            );
          }
          return _buildNarrowLayout(
            context,
            cat: cat,
            habit: habit,
            personality: personality,
            moodData: moodData,
            meshColors: meshColors,
          );
        },
      ),
    );
  }

  // ─── Narrow layout (phone) ─────────────────────────────────────

  Widget _buildNarrowLayout(
    BuildContext context, {
    required Cat cat,
    required Habit? habit,
    required CatPersonality? personality,
    required CatMood moodData,
    required List<Color> meshColors,
  }) {
    return ContentWidthConstraint(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(context, cat, personality, meshColors),
          SliverPadding(
            padding: AppSpacing.paddingBase,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildAllCards(context, cat, habit, moodData),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Wide layout (tablet >= 840dp) ─────────────────────────────

  Widget _buildWideLayout(
    BuildContext context, {
    required Cat cat,
    required Habit? habit,
    required CatPersonality? personality,
    required CatMood moodData,
    required List<Color> meshColors,
  }) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(context, cat, personality, meshColors),
        SliverPadding(
          padding: AppSpacing.paddingBase,
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左栏：心情 + 成长卡
                Expanded(
                  flex: 2,
                  child: _buildLeftColumn(context, cat, moodData),
                ),
                const SizedBox(width: AppSpacing.base),
                // 右栏：功能卡片
                Expanded(
                  flex: 3,
                  child: _buildRightColumn(context, cat, habit),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 左栏 — 心情徽章
  Widget _buildLeftColumn(BuildContext context, Cat cat, CatMood moodData) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        StaggeredListItem(
          waitForRoute: true,
          index: 0,
          child: _buildMoodBadge(context, moodData, colorScheme, textTheme),
        ),
      ],
    );
  }

  /// 右栏 — FocusStats, Diary, Chat, Reminder, Heatmap, Accessories, CatInfo
  Widget _buildRightColumn(BuildContext context, Cat cat, Habit? habit) {
    final aiReady = ref.watch(aiAvailabilityProvider) == AiAvailability.ready;
    final isGuest = ref.watch(isGuestProvider);
    var idx = 1; // 左栏占 0

    return Column(
      children: [
        if (habit != null) ...[
          StaggeredListItem(
            waitForRoute: true,
            index: idx++,
            child: FocusStatsCard(habit: habit, cat: cat),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
        if (aiReady) ...[
          StaggeredListItem(
            waitForRoute: true,
            index: idx++,
            child: DiaryPreviewCard(catId: cat.id),
          ),
          const SizedBox(height: AppSpacing.base),
          StaggeredListItem(
            waitForRoute: true,
            index: idx++,
            child: ChatEntryCard(catId: cat.id, catName: cat.name),
          ),
          const SizedBox(height: AppSpacing.base),
        ] else if (isGuest) ...[
          StaggeredListItem(
            waitForRoute: true,
            index: idx++,
            child: _AiTeaserCard(catName: cat.name, context: context),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
        if (habit != null) ...[
          StaggeredListItem(
            waitForRoute: true,
            index: idx++,
            child: ReminderCard(habit: habit, cat: cat),
          ),
          const SizedBox(height: AppSpacing.base),
          StaggeredListItem(
            waitForRoute: true,
            index: idx++,
            child: HabitHeatmapCard(habitId: habit.id),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
        StaggeredListItem(
          waitForRoute: true,
          index: idx++,
          child: AccessoriesCard(cat: cat),
        ),
        const SizedBox(height: AppSpacing.base),
        StaggeredListItem(
          waitForRoute: true,
          index: idx++,
          child: EnhancedCatInfoCard(cat: cat),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  // ─── Shared SliverAppBar ───────────────────────────────────────

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    Cat cat,
    CatPersonality? personality,
    List<Color> meshColors,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      systemOverlayStyle: Theme.of(context).brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      title: AnimatedOpacity(
        opacity: _showAppBarTitle ? 1.0 : 0.0,
        duration: AppMotion.durationShort2,
        child: Text(
          cat.name,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      actions: _buildAppBarActions(context, cat),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: _buildHeroBackground(
          context,
          cat,
          personality,
          meshColors,
          colorScheme,
          textTheme,
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, Cat cat) {
    return [
      IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () => _showRenameDialog(context, cat),
        tooltip: context.l10n.catDetailRenameTooltip,
      ),
      if (ref.watch(aiAvailabilityProvider) == AiAvailability.ready)
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamed(AppRouter.catChat, arguments: widget.catId);
          },
          tooltip: context.l10n.catDetailChatTooltip,
        ),
    ];
  }

  Widget _buildHeroBackground(
    BuildContext context,
    Cat cat,
    CatPersonality? personality,
    List<Color> meshColors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Stack(
      children: [
        AnimatedMeshBackground(
          colors: meshColors,
          speed: 1.0,
          fadeIn: true,
          child: SafeArea(
            child: _buildHeroContent(
              context,
              cat,
              personality,
              colorScheme,
              textTheme,
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: ParticleOverlay(
              mode: ParticleMode.firefly,
              fadeIn: true,
              child: SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroContent(
    BuildContext context,
    Cat cat,
    CatPersonality? personality,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Hero(
          tag: 'cat-${cat.id}',
          child: TappableCatSprite(cat: cat, size: 120),
        ),
        const SizedBox(height: AppSpacing.sm),
        Hero(
          tag: 'cat-name-${cat.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              cat.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (personality != null)
          Text(
            '${personality.emoji} ${context.l10n.personalityName(personality.id)}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  // ─── Narrow layout card list ───────────────────────────────────

  /// 构建窄屏卡片列表（含 StaggeredListItem 动画）
  List<Widget> _buildAllCards(
    BuildContext context,
    Cat cat,
    Habit? habit,
    CatMood moodData,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final aiReady = ref.watch(aiAvailabilityProvider) == AiAvailability.ready;
    final isGuest = ref.watch(isGuestProvider);

    return [
      StaggeredListItem(
        waitForRoute: true,
        index: 0,
        child: _buildMoodBadge(context, moodData, colorScheme, textTheme),
      ),
      const SizedBox(height: AppSpacing.lg),
      if (habit != null) ...[
        StaggeredListItem(
          waitForRoute: true,
          index: 1,
          child: FocusStatsCard(habit: habit, cat: cat),
        ),
        const SizedBox(height: AppSpacing.base),
      ],
      if (aiReady) ...[
        StaggeredListItem(
          waitForRoute: true,
          index: 2,
          child: DiaryPreviewCard(catId: cat.id),
        ),
        const SizedBox(height: AppSpacing.base),
        StaggeredListItem(
          waitForRoute: true,
          index: 3,
          child: ChatEntryCard(catId: cat.id, catName: cat.name),
        ),
        const SizedBox(height: AppSpacing.base),
      ] else if (isGuest) ...[
        StaggeredListItem(
          waitForRoute: true,
          index: 2,
          child: _AiTeaserCard(catName: cat.name, context: context),
        ),
        const SizedBox(height: AppSpacing.base),
      ],
      if (habit != null) ...[
        StaggeredListItem(
          waitForRoute: true,
          index: 4,
          child: ReminderCard(habit: habit, cat: cat),
        ),
        const SizedBox(height: AppSpacing.base),
      ],
      if (habit != null)
        StaggeredListItem(
          waitForRoute: true,
          index: 5,
          child: HabitHeatmapCard(habitId: habit.id),
        ),
      const SizedBox(height: AppSpacing.base),
      StaggeredListItem(
        waitForRoute: true,
        index: 6,
        child: AccessoriesCard(cat: cat),
      ),
      const SizedBox(height: AppSpacing.base),
      StaggeredListItem(
        waitForRoute: true,
        index: 7,
        child: EnhancedCatInfoCard(cat: cat),
      ),
      const SizedBox(height: AppSpacing.xl),
    ];
  }

  // ─── Mood badge widget ─────────────────────────────────────────

  Widget _buildMoodBadge(
    BuildContext context,
    CatMood moodData,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: AppShape.borderLarge,
        ),
        child: Text(
          '${moodData.emoji} ${context.l10n.moodName(moodData.id)}',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onTertiaryContainer,
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, Cat cat) {
    final controller = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.catDetailRenameTitle),
        content: TextField(
          controller: controller,
          maxLength: Cat.maxNameLength,
          decoration: InputDecoration(
            labelText: context.l10n.catDetailNewName,
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
              HapticFeedback.mediumImpact();
              final renamedCat = cat.copyWith(name: newName);
              await ref
                  .read(localCatRepositoryProvider)
                  .update(uid, renamedCat);
              ref
                  .read(ledgerServiceProvider)
                  .notifyChange(const LedgerChange(type: 'cat_update'));
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.catDetailRenamed),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(context.l10n.catDetailRename),
          ),
        ],
      ),
    );
  }
}

/// AI 功能 Teaser 卡 — 访客用户看到的虚化预览引导。
class _AiTeaserCard extends ConsumerWidget {
  final String catName;
  final BuildContext context;

  const _AiTeaserCard({required this.catName, required this.context});

  @override
  Widget build(BuildContext innerContext, WidgetRef ref) {
    final colorScheme = Theme.of(innerContext).colorScheme;
    final textTheme = Theme.of(innerContext).textTheme;
    final l10n = innerContext.l10n;

    return Card.outlined(
      child: InkWell(
        borderRadius: AppShape.borderMedium,
        onTap: () => showGuestUpgradePrompt(innerContext, ref),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_stories,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.aiTeaserTitle,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // 虚化预览区
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white.withValues(alpha: 0)],
                  stops: const [0.3, 1.0],
                ).createShader(bounds),
                child: Text(
                  l10n.aiTeaserPreview(catName),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.aiTeaserCta(catName),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
