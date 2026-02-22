import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

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
    final stageClr = stageColor(cat.computedStage);

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
            child: Row(
              children: [
                Hero(
                  tag: 'cat-${cat.id}',
                  child: TappableCatSprite(
                    cat: cat,
                    size: 72,
                    enableTap: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.base),
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
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        context.l10n.moodMessage(
                          cat.personality,
                          cat.computedMood,
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (habit != null)
                        Text(
                          habit.name,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: cat.growthProgress,
                          minHeight: 6,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(stageClr),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${context.l10n.durationHoursMinutes(cat.totalMinutes ~/ 60, cat.totalMinutes % 60)}  •  ${context.l10n.stageName(cat.computedStage)}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: habit != null
                      ? () => Navigator.of(
                          context,
                        ).pushNamed(AppRouter.focusSetup, arguments: habit.id)
                      : null,
                  child: Text(context.l10n.todayFocus),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
