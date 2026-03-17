import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/error_state.dart';

/// 每日详情页 — 只读展示单日的心情、光文本、标签、时间轴。
class DailyDetailScreen extends ConsumerWidget {
  /// 日期字符串（'YYYY-MM-DD'）。
  final String date;

  const DailyDetailScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightAsync = ref.watch(dailyLightByDateProvider(date));
    final l10n = context.l10n;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.dailyDetailTitle)),
      body: ContentWidthConstraint(
        child: lightAsync.when(
          data: (light) => light != null
              ? _DetailContent(light: light, date: date)
              : _EmptyState(date: date),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(dailyLightByDateProvider(date)),
          ),
        ),
      ),
    );
  }
}

// ─── 详情内容 ───

class _DetailContent extends StatelessWidget {
  final DailyLight light;
  final String date;

  const _DetailContent({required this.light, required this.date});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: AppSpacing.paddingScreenBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 日期标题
          Text(_formatDate(date, context), style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          // 2. 心情展示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(light.mood.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 12),
              Text(_moodLabel(light.mood, l10n), style: textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // 3. 一点光文本
          if (light.hasText) ...[
            Card(
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyDetailLight,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(light.lightText!, style: textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
          ],
          // 4. 标签
          if (light.hasTags) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: light.tags
                  .map((tag) => Chip(label: Text('#$tag')))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.base),
          ],
          // 5. 时间轴事件
          if (light.timelineEvents?.isNotEmpty == true) ...[
            Card(
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyDetailTimeline,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...light.timelineEvents!.asMap().entries.map(
                      (e) => _TimelineRow(
                        index: e.key,
                        text: e.value,
                        isLast: e.key == light.timelineEvents!.length - 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
          ],
          // 6. 编辑按钮
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: FilledButton.tonal(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRouter.dailyLight,
                arguments: <String, dynamic>{'quickMode': false},
              ),
              child: Text(l10n.dailyDetailEdit),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  /// 格式化日期显示。
  String _formatDate(String date, BuildContext context) {
    if (date.length < 10) return date;
    final year = date.substring(0, 4);
    final month = int.tryParse(date.substring(5, 7)) ?? 1;
    final day = int.tryParse(date.substring(8, 10)) ?? 1;
    final dt = DateTime(int.tryParse(year) ?? 2026, month, day);
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'zh') {
      final weekdays = ['一', '二', '三', '四', '五', '六', '日'];
      return '$year\u5E74$month\u6708$day\u65E5 '
          '\u661F\u671F${weekdays[dt.weekday - 1]}';
    }
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[dt.weekday - 1]}, '
        '${months[month - 1]} $day, $year';
  }

  /// 心情标签。
  String _moodLabel(Mood mood, S l10n) {
    return switch (mood) {
      Mood.veryHappy => l10n.moodVeryHappy,
      Mood.happy => l10n.moodHappy,
      Mood.calm => l10n.moodCalm,
      Mood.down => l10n.moodDown,
      Mood.veryDown => l10n.moodVeryDown,
    };
  }
}

// ─── 时间轴行 ───

class _TimelineRow extends StatelessWidget {
  final int index;
  final String text;
  final bool isLast;

  const _TimelineRow({
    required this.index,
    required this.text,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(text, style: textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 空状态 ───

class _EmptyState extends StatelessWidget {
  final String date;

  const _EmptyState({required this.date});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.dailyDetailNoRecord,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pushNamed(
              AppRouter.dailyLight,
              arguments: <String, dynamic>{'quickMode': false},
            ),
            child: Text(l10n.dailyDetailGoRecord),
          ),
        ],
      ),
    );
  }
}
