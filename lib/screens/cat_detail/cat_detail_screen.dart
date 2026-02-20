// ---
// 📘 文件说明：
// Cat Detail 页面 — 猫猫和关联任务的核心信息中枢。
// 展示猫猫形象、成长进度、专注统计、每日提醒、活动热力图、饰品和详细外观信息。
//
// 📋 程序整体伪代码（中文）：
// 1. 从 Provider 加载猫猫和关联 Habit 数据；
// 2. SliverAppBar：TappableCatSprite + 猫名 + 性格标签；
// 3. 心情标签；
// 4. 成长进度卡片（时间制进度条 + 阶段里程碑）；
// 5. 专注统计卡片（替代旧 "Bound Habit" 卡片）；
// 6. 每日提醒卡片（设置/修改/移除提醒）；
// 7. 活动热力图卡片；
// 8. 饰品装备卡片；
// 9. 增强版猫猫信息卡片（性格 + 外观详情 + 状态）；
//
// 🧩 文件结构：
// - CatDetailScreen：主页面 ConsumerStatefulWidget；
// - 各子组件已拆分至 components/ 目录；
//
// 🕒 创建时间：2026-02-18
// 🕒 重构时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/llm_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/core/utils/background_color_utils.dart';
import 'package:hachimi_app/widgets/animated_mesh_background.dart';
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
    final habit =
        habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final personality = personalityMap[cat.personality];
    final moodData = moodById(cat.computedMood);
    final stageClr = stageColor(cat.computedStage);

    // Mesh gradient colors derived from cat appearance
    final meshColors = catMeshColors(
      cat.computedStage,
      cat.appearance.peltColor,
      colorScheme,
    );

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Gradient app bar with pixel cat
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                actions: [
                  // 聊天入口 — 仅当 AI 功能就绪时显示
                  if (ref.watch(llmAvailabilityProvider) ==
                      LlmAvailability.ready)
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.catChat,
                          arguments: widget.catId,
                        );
                      },
                      tooltip: context.l10n.catDetailChatTooltip,
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: AnimatedMeshBackground(
                    colors: meshColors,
                    speed: 1.0,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cat.name,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () => _showRenameDialog(context, cat),
                                tooltip: context.l10n.catDetailRenameTooltip,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
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
                if (ref.watch(llmAvailabilityProvider) ==
                    LlmAvailability.ready) ...[
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
        // Particle overlay — covers header area only
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 280,
          child: IgnorePointer(
            child: ParticleOverlay(
              mode: ParticleMode.firefly,
              child: SizedBox.expand(),
            ),
          ),
        ),
        ],
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
                  cat.stageName,
                  style: textTheme.labelLarge?.copyWith(
                    color: stageClr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: cat.growthProgress,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceContainerHighest,
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
                  context.l10n.catDetailTarget(cat.targetMinutes ~/ 60),
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
                  isReached: cat.growthProgress >= 0.20,
                  color: stageColor('adolescent'),
                ),
                StageMilestone(
                  name: context.l10n.stageAdult,
                  isReached: cat.growthProgress >= 0.45,
                  color: stageColor('adult'),
                ),
                StageMilestone(
                  name: context.l10n.stageSenior,
                  isReached: cat.growthProgress >= 0.75,
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
              await ref.read(catFirestoreServiceProvider).renameCat(
                    uid: uid,
                    catId: cat.id,
                    newName: newName,
                  );
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
