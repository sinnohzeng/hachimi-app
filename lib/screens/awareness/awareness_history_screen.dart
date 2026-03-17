import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/widgets/awareness/awareness_empty_state.dart';
import 'package:hachimi_app/widgets/awareness/mood_calendar.dart';

/// 觉知历史视图 — 月历 + 周回顾折叠列表。
///
/// 同时作为 AwarenessScreen「回顾」子 Tab 的渲染内容。
class AwarenessHistoryScreen extends ConsumerStatefulWidget {
  const AwarenessHistoryScreen({super.key});

  @override
  ConsumerState<AwarenessHistoryScreen> createState() =>
      _AwarenessHistoryScreenState();
}

class _AwarenessHistoryScreenState
    extends ConsumerState<AwarenessHistoryScreen> {
  late int _displayYear;
  late int _displayMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayYear = now.year;
    _displayMonth = now.month;
  }

  void _handleMonthChange((int, int) ym) {
    setState(() {
      _displayYear = ym.$1;
      _displayMonth = ym.$2;
    });
  }

  void _handleDayTap(DateTime date) {
    final dateStr = AppDateUtils.formatDay(date);
    Navigator.of(context).pushNamed(AppRouter.dailyDetail, arguments: dateStr);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final reviewsAsync = ref.watch(
      weeklyReviewsForMonthProvider((_displayYear, _displayMonth)),
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: MoodCalendar(
            year: _displayYear,
            month: _displayMonth,
            onDayTapped: _handleDayTap,
            onMonthChanged: _handleMonthChange,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.base,
              top: AppSpacing.base,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              l10n.historyWeeklyReviews,
              style: textTheme.titleMedium,
            ),
          ),
        ),
        reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: AwarenessEmptyState(type: AwarenessEmptyType.history),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _WeeklyReviewFoldCard(review: reviews[index]),
                childCount: reviews.length,
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (e, _) {
            debugPrint('[AwarenessHistory] Weekly reviews load error: $e');
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    context.l10n.awarenessLoadFailed,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }
}

// ─── 周回顾折叠卡片 ───

class _WeeklyReviewFoldCard extends StatelessWidget {
  final WeeklyReview review;

  const _WeeklyReviewFoldCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final momentCount = review.filledMomentCount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.xs,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          title: Text(_formatWeekRange(review), style: textTheme.bodyMedium),
          trailing: Chip(
            label: Text(
              l10n.historyHappyMoments(momentCount),
              style: textTheme.labelSmall,
            ),
            side: BorderSide.none,
            backgroundColor: colorScheme.primaryContainer,
          ),
          children: [_buildExpandedContent(context, review)],
        ),
      ),
    );
  }

  String _formatWeekRange(WeeklyReview review) {
    return '${_formatShortDate(review.weekStartDate)}'
        ' - ${_formatShortDate(review.weekEndDate)}';
  }

  /// 将 'YYYY-MM-DD' 格式化为 'M/D' 短日期。
  String _formatShortDate(String date) {
    if (date.length < 10) return date;
    final month = int.tryParse(date.substring(5, 7)) ?? 0;
    final day = int.tryParse(date.substring(8, 10)) ?? 0;
    return '$month/$day';
  }

  Widget _buildExpandedContent(BuildContext context, WeeklyReview review) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: AppSpacing.paddingBase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 幸福时刻
          if (review.filledMomentCount > 0) ...[
            Text(
              l10n.weeklyReviewHappyMoment(0).replaceAll('#0', ''),
              style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xs),
            ..._buildMomentsList(review, textTheme),
            const SizedBox(height: AppSpacing.md),
          ],
          // 感恩
          if (review.gratitude?.isNotEmpty == true) ...[
            Text(
              l10n.weeklyReviewGratitude,
              style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(review.gratitude!, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
          ],
          // 学到了什么
          if (review.learning?.isNotEmpty == true) ...[
            Text(
              l10n.weeklyReviewLearning,
              style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(review.learning!, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
          ],
          // 猫咪周总结
          if (review.catWeeklySummary?.isNotEmpty == true) ...[
            Row(
              children: [
                const Text('\uD83D\uDC31 ', style: TextStyle(fontSize: 16)),
                Text(
                  l10n.weeklyReviewTitle,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: AppSpacing.paddingSm,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                review.catWeeklySummary!,
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMomentsList(WeeklyReview review, TextTheme textTheme) {
    final moments = <String>[];
    if (review.happyMoment1?.isNotEmpty == true) {
      moments.add(review.happyMoment1!);
    }
    if (review.happyMoment2?.isNotEmpty == true) {
      moments.add(review.happyMoment2!);
    }
    if (review.happyMoment3?.isNotEmpty == true) {
      moments.add(review.happyMoment3!);
    }
    return moments
        .asMap()
        .entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${e.key + 1}. ${e.value}',
              style: textTheme.bodyMedium,
            ),
          ),
        )
        .toList();
  }
}
