import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ai_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/core/utils/background_color_utils.dart';
import 'package:hachimi_app/widgets/animated_mesh_background.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
    final stageClr = stageColor(cat.displayStage);

    // Mesh gradient colors derived from cat appearance
    final meshColors = catMeshColors(
      cat.displayStage,
      cat.appearance.peltColor,
      colorScheme,
    );

    return Scaffold(
      body: ContentWidthConstraint(
        child: CustomScrollView(
          slivers: [
            // [B2] SliverAppBar with FlexibleSpaceBar.title for smooth scroll-to-title
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              systemOverlayStyle:
                  Theme.of(context).brightness == Brightness.light
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
              actions: [
                // [B3] 编辑入口移到 AppBar actions
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showRenameDialog(context, cat),
                  tooltip: context.l10n.catDetailRenameTooltip,
                ),
                // 聊天入口 — 仅当 AI 功能就绪时显示
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
              ],
              flexibleSpace: FlexibleSpaceBar(
                // [B2] 猫名作为 FlexibleSpaceBar.title，随滚动平滑过渡
                title: Text(
                  cat.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                centerTitle: true,
                expandedTitleScale: 1.3,
                // [B1] 粒子效果移入 FlexibleSpaceBar.background，随 AppBar 折叠消失
                background: Stack(
                  children: [
                    AnimatedMeshBackground(
                      colors: meshColors,
                      speed: 1.0,
                      fadeIn: true,
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: AppSpacing.xxl),
                            // Tappable cat sprite with bounce animation + Hero
                            Hero(
                              tag: 'cat-${cat.id}',
                              child: TappableCatSprite(cat: cat, size: 120),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // 性格标签（猫名已移到 FlexibleSpaceBar.title）
                            if (personality != null)
                              Text(
                                '${personality.emoji} ${context.l10n.personalityName(personality.id)}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            // 为 FlexibleSpaceBar.title 留出底部空间
                            const SizedBox(height: AppSpacing.xxl),
                          ],
                        ),
                      ),
                    ),
                    // [B1] 粒子覆盖层
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: ParticleOverlay(
                          mode: ParticleMode.firefly,
                          child: SizedBox.expand(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: AppSpacing.paddingBase,
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
                        borderRadius: AppShape.borderLarge,
                      ),
                      child: Text(
                        '${moodData.emoji} ${context.l10n.moodName(moodData.id)}',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Growth progress (time-based)
                  _buildGrowthCard(context, cat, stageClr),
                  const SizedBox(height: AppSpacing.base),

                  // Focus statistics card (replaces old "Bound Habit" card)
                  if (habit != null) ...[
                    FocusStatsCard(habit: habit, cat: cat),
                    const SizedBox(height: AppSpacing.base),
                  ],

                  // Hachimi Diary card — AI 日记预览
                  if (ref.watch(aiAvailabilityProvider) ==
                      AiAvailability.ready) ...[
                    DiaryPreviewCard(catId: cat.id),
                    const SizedBox(height: AppSpacing.base),

                    // 聊天入口卡片 — 提升可发现性
                    ChatEntryCard(catId: cat.id, catName: cat.name),
                    const SizedBox(height: AppSpacing.base),
                  ],

                  // Reminder card
                  if (habit != null) ...[
                    ReminderCard(habit: habit, cat: cat),
                    const SizedBox(height: AppSpacing.base),
                  ],

                  // Streak heatmap
                  if (habit != null) HabitHeatmapCard(habitId: habit.id),
                  const SizedBox(height: AppSpacing.base),

                  // Accessories card
                  AccessoriesCard(cat: cat),
                  const SizedBox(height: AppSpacing.base),

                  // Enhanced cat info card
                  EnhancedCatInfoCard(cat: cat),
                  const SizedBox(height: AppSpacing.xl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, Cat cat, Color stageClr) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  context.l10n.catDetailGrowthTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  context.l10n.stageName(cat.displayStage),
                  style: textTheme.labelLarge?.copyWith(
                    color: stageClr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: AppShape.borderSmall,
              child: LinearProgressIndicator(
                value: cat.growthProgress,
                minHeight: 12,
                backgroundColor: colorScheme.outlineVariant.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.8
                      : 0.5,
                ),
                valueColor: AlwaysStoppedAnimation(stageClr),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
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
                  '200h',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            // Stage milestones
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StageMilestone(
                  name: context.l10n.stageKitten,
                  isReached: true,
                  color: stageColor('kitten'),
                ),
                StageMilestone(
                  name: context.l10n.stageAdolescent,
                  isReached: stageOrder(cat.displayStage) >= 1,
                  color: stageColor('adolescent'),
                ),
                StageMilestone(
                  name: context.l10n.stageAdult,
                  isReached: stageOrder(cat.displayStage) >= 2,
                  color: stageColor('adult'),
                ),
                StageMilestone(
                  name: context.l10n.stageSenior,
                  isReached: stageOrder(cat.displayStage) >= 3,
                  color: stageColor('senior'),
                ),
              ],
            ),
          ],
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
              await ref
                  .read(catFirestoreServiceProvider)
                  .renameCat(uid: uid, catId: cat.id, newName: newName);
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
