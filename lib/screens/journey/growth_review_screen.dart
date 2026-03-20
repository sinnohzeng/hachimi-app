import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/providers/list_highlight_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';

/// 成长回望 — 年度回顾：高光时刻、总结、小赢颁奖、温暖收官。
class GrowthReviewScreen extends ConsumerWidget {
  const GrowthReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final happyAsync = ref.watch(happyMomentsProvider);
    final highlightAsync = ref.watch(highlightMomentsProvider);
    final statsAsync = ref.watch(awarenessStatsProvider);

    final allMoments = <HighlightEntry>[
      ...happyAsync.value ?? [],
      ...highlightAsync.value ?? [],
    ];
    // 按评分排序，取 top 5
    allMoments.sort((a, b) => b.rating.compareTo(a.rating));
    final topMoments = allMoments.take(5).toList();

    final totalDays = statsAsync.value?['totalLightDays'] ?? 0;
    final totalReviews = statsAsync.value?['totalWeeklyReviews'] ?? 0;

    return AppScaffold(
      appBar: AppBar(title: Text(context.l10n.growthReviewScreenTitle)),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: 属于我的时刻
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.auto_awesome,
              context.l10n.growthReviewMyMoments,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (topMoments.isEmpty)
              _emptyHint(
                textTheme,
                colorScheme,
                context.l10n.growthReviewEmptyMoments,
              )
            else
              ...topMoments.map((m) => _momentTile(m, textTheme, colorScheme)),

            const SizedBox(height: AppSpacing.lg),

            // Section 2: 我的总结
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.edit_note,
              context.l10n.growthReviewMySummary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingBase,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: AppShape.borderMedium,
              ),
              child: Text(
                context.l10n.growthReviewSummaryPrompt,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 3: 小赢颁奖
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.emoji_events_outlined,
              context.l10n.growthReviewSmallWins,
            ),
            const SizedBox(height: AppSpacing.sm),
            _achievementCard(
              textTheme,
              colorScheme,
              context.l10n.growthReviewConsistentRecord,
              context.l10n.growthReviewRecordedDays(totalDays),
              Icons.calendar_today_outlined,
            ),
            _achievementCard(
              textTheme,
              colorScheme,
              context.l10n.growthReviewWeeklyChamp,
              context.l10n.growthReviewCompletedReviews(totalReviews),
              Icons.rate_review_outlined,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 4: 温暖收官
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.favorite_outline,
              context.l10n.growthReviewWarmClose,
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.5),
                    colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: AppShape.borderLarge,
              ),
              child: Column(
                children: [
                  // 星星数量可视化
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalDays.clamp(0, 10),
                      (_) => Icon(
                        Icons.star,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.l10n.growthReviewEveryStar,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.growthReviewKeepShining(totalDays),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: textTheme.titleSmall),
      ],
    );
  }

  Widget _emptyHint(TextTheme textTheme, ColorScheme colorScheme, String text) {
    return Padding(
      padding: AppSpacing.paddingVBase,
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _momentTile(
    HighlightEntry entry,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            entry.type == HighlightType.happy
                ? Icons.favorite
                : Icons.auto_awesome,
            size: 16,
            color: colorScheme.tertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.description, style: textTheme.bodyMedium),
                Text(
                  entry.date,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          // 星级
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(entry.rating.clamp(1, 5), (_) {
              return Icon(Icons.star, size: 12, color: colorScheme.primary);
            }),
          ),
        ],
      ),
    );
  }

  Widget _achievementCard(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(icon, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(title, style: textTheme.bodyLarge),
        subtitle: Text(subtitle),
      ),
    );
  }
}
