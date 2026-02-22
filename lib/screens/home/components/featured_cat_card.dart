import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// 首页精选猫卡片 — 两行布局：
/// 上行: Cat(56px) + Column(name, mood · quest name)
/// 下行: progress bar + label + Focus 按钮
class FeaturedCatCard extends ConsumerWidget {
  final Cat cat;

  const FeaturedCatCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final stageClr = stageColor(cat.displayStage);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: habit != null
              ? () => Navigator.of(
                  context,
                ).pushNamed(AppRouter.focusSetup, arguments: habit.id)
              : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  stageClr.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.18 : 0.08,
                  ),
                  stageClr.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.08 : 0.03,
                  ),
                ],
              ),
            ),
            padding: AppSpacing.paddingBase,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 上行: Cat + Info
                Row(
                  children: [
                    Hero(
                      tag: 'cat-${cat.id}',
                      child: TappableCatSprite(
                        cat: cat,
                        size: 56,
                        enableTap: false,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
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
                          const SizedBox(height: 2),
                          Text(
                            _buildSubtitle(context, habit),
                            style: textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // 下行: Progress bar + label + Focus 按钮
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${context.l10n.durationHoursMinutes(cat.totalMinutes ~/ 60, cat.totalMinutes % 60)}  ·  ${context.l10n.stageName(cat.displayStage)}',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    FilledButton.tonal(
                      onPressed: habit != null
                          ? () => Navigator.of(context).pushNamed(
                              AppRouter.focusSetup,
                              arguments: habit.id,
                            )
                          : null,
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(context.l10n.todayFocus),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建副标题：mood · quest name
  String _buildSubtitle(BuildContext context, Habit? habit) {
    final mood = context.l10n.moodMessage(cat.personality, cat.computedMood);
    if (habit != null) {
      return '$mood  ·  ${habit.name}';
    }
    return mood;
  }
}
