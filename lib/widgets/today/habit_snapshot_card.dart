import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/habits_provider.dart';

/// 习惯速览卡 — 显示今日习惯列表，支持快速点击进入专注。
class HabitSnapshotCard extends ConsumerWidget {
  const HabitSnapshotCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final todayMinutes = ref.watch(todayMinutesPerHabitProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.habitSnapshotTitle,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            habitsAsync.when(
              data: (habits) {
                if (habits.isEmpty) {
                  return Padding(
                    padding: AppSpacing.paddingVBase,
                    child: Text(
                      context.l10n.habitSnapshotEmpty,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  children: habits.map((habit) {
                    final minutes = todayMinutes[habit.id] ?? 0;
                    final done = minutes >= habit.goalMinutes;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      leading: Icon(
                        done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: done ? colorScheme.primary : colorScheme.outline,
                      ),
                      title: Text(
                        habit.name,
                        style: textTheme.bodyMedium?.copyWith(
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: Text(
                        '$minutes/${habit.goalMinutes}m',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRouter.focusSetup, arguments: habit.id),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) {
                debugPrint('[HabitSnapshot] Load error: $e');
                return Padding(
                  padding: AppSpacing.paddingVBase,
                  child: Text(
                    context.l10n.habitSnapshotLoadError,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
