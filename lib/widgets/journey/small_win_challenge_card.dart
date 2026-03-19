import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/providers/journey_providers.dart';

/// 小赢挑战卡片 — 30 天习惯挑战 + 四法则提示。
class SmallWinChallengeCard extends ConsumerWidget {
  const SmallWinChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(currentMonthPlanProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 20,
                  color: colorScheme.tertiary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('小赢挑战', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            planAsync.when(
              data: (plan) {
                final habitName = plan?.challengeHabitName;
                if (habitName == null || habitName.isEmpty) {
                  return Padding(
                    padding: AppSpacing.paddingVSm,
                    child: Text(
                      '设定一个 $daysInMonth 天小挑战，每天坚持一点点',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habitName, style: textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.sm),
                    _buildDayGrid(context, daysInMonth, now.day),
                    if (plan?.challengeReward != null &&
                        plan!.challengeReward!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 16,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              '奖励: ${plan.challengeReward}',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: AppSpacing.paddingVSm,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) {
                debugPrint('[SmallWinChallengeCard] Load error: $e');
                return Text(
                  '加载失败',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // 四法则提示
            Container(
              padding: AppSpacing.paddingSm,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: AppShape.borderSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['看得见', '想去做', '易上手', '有奖励'].map((label) {
                  return Text(
                    label,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayGrid(BuildContext context, int daysInMonth, int today) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(daysInMonth, (i) {
        final day = i + 1;
        final isPast = day < today;
        final isToday = day == today;

        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPast
                ? colorScheme.tertiary.withValues(alpha: 0.3)
                : isToday
                ? colorScheme.tertiary
                : colorScheme.surfaceContainerHigh,
            border: isToday
                ? Border.all(color: colorScheme.tertiary, width: 2)
                : null,
          ),
        );
      }),
    );
  }
}
