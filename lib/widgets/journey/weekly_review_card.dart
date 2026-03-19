import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 周回顾摘要卡 — 显示 3 个幸福时刻完成度，点击进入周回顾页。
class WeeklyReviewCard extends ConsumerWidget {
  const WeeklyReviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(currentWeekReviewProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: AppShape.borderMedium,
        onTap: () => Navigator.of(context).pushNamed(AppRouter.weeklyReview),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: reviewAsync.when(
            data: (review) {
              if (review == null) {
                return Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      size: 20,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '记录本周的幸福时刻', // TODO: l10n
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Icon(
                    review.isComplete ? Icons.favorite : Icons.favorite_outline,
                    size: 20,
                    color: review.isComplete
                        ? colorScheme.tertiary
                        : colorScheme.outline,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '幸福时刻', // TODO: l10n
                      style: textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    '${review.filledMomentCount}/3',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: AppSpacing.paddingVSm,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) {
              debugPrint('[WeeklyReviewCard] Load error: $e');
              return Text(
                '加载失败', // TODO: l10n
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              );
            },
          ),
        ),
      ),
    );
  }
}
