import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 觉知统计卡片 — 嵌入 ProfileScreen 展示心情分布和关键指标。
class AwarenessStatsCard extends ConsumerWidget {
  const AwarenessStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(awarenessStatsProvider);
    final moodAsync = ref.watch(moodDistributionProvider);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              l10n.awarenessStatsTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            // 心情分布
            _buildMoodDistribution(context, moodAsync, l10n),
            const SizedBox(height: AppSpacing.base),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            // 关键指标
            _buildKeyMetrics(context, statsAsync, l10n),
            const SizedBox(height: AppSpacing.md),
            // 标签频率（条件显示）
            _buildTagSection(context, ref, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodDistribution(
    BuildContext context,
    AsyncValue<Map<Mood, int>> moodAsync,
    S l10n,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return moodAsync.when(
      data: (distribution) {
        if (distribution.isEmpty) {
          return _buildEmptyGuide(context, l10n);
        }
        final total = distribution.values.fold(0, (a, b) => a + b);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.awarenessStatsMoodDistribution,
              style: textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...Mood.values.map(
              (mood) => _MoodBar(
                mood: mood,
                count: distribution[mood] ?? 0,
                total: total,
              ),
            ),
          ],
        );
      },
      loading: () => const _ShimmerBlock(height: 120),
      error: (e, _) {
        debugPrint('[AwarenessStats] Load error: $e');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            context.l10n.awarenessLoadFailed,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyMetrics(
    BuildContext context,
    AsyncValue<Map<String, int>> statsAsync,
    S l10n,
  ) {
    return statsAsync.when(
      data: (stats) {
        final lightDays = stats['totalLightDays'] ?? 0;
        final reviews = stats['totalWeeklyReviews'] ?? 0;
        final resolved = stats['totalWorriesResolved'] ?? 0;
        // 解忧率暂时无 totalWorriesAll，用 resolved 展示
        final rateStr = '${resolved > 0 ? resolved : 0}';

        return Row(
          children: [
            _MetricTile(
              value: '$lightDays',
              label: l10n.awarenessStatsLightDays,
            ),
            _MetricTile(
              value: '$reviews',
              label: l10n.awarenessStatsWeeklyReviews,
            ),
            _MetricTile(
              value: rateStr,
              label: l10n.awarenessStatsResolutionRate,
            ),
          ],
        );
      },
      loading: () => const _ShimmerBlock(height: 60),
      error: (e, _) {
        debugPrint('[AwarenessStats] Load error: $e');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            context.l10n.awarenessLoadFailed,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagSection(BuildContext context, WidgetRef ref, S l10n) {
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();

    final tagAsync = ref.watch(_tagFrequencyProvider);

    return tagAsync.when(
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();
        final textTheme = Theme.of(context).textTheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.awarenessStatsTopTags, style: textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tags.entries
                  .take(3)
                  .map((e) => Chip(label: Text('#${e.key} (${e.value})')))
                  .toList(),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) {
        debugPrint('[AwarenessStats] Load error: $e');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            context.l10n.awarenessLoadFailed,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyGuide(BuildContext context, S l10n) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Text(
            l10n.awarenessStatsStartRecording,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonal(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.awareness),
            child: Text(l10n.awarenessEmptyLightAction),
          ),
        ],
      ),
    );
  }
}

/// 标签频率 provider — 封装 getTagFrequency 调用。
final _tagFrequencyProvider = FutureProvider<Map<String, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};
  final repo = ref.watch(awarenessRepositoryProvider);
  return repo.getTagFrequency(uid);
});

// ─── 心情柱状条 ───

class _MoodBar extends StatelessWidget {
  final Mood mood;
  final int count;
  final int total;

  const _MoodBar({
    required this.mood,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final percent = total > 0 ? (count / total * 100).round() : 0;
    final barFraction = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(mood.emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 16,
                    width: constraints.maxWidth * barFraction,
                    decoration: BoxDecoration(
                      color: mood.themeColor(colorScheme),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 64,
            child: Text(
              '$percent% ($count)',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 指标格子 ───

class _MetricTile extends StatelessWidget {
  final String value;
  final String label;

  const _MetricTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 骨架屏占位 ───

class _ShimmerBlock extends StatelessWidget {
  final double height;

  const _ShimmerBlock({required this.height});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
