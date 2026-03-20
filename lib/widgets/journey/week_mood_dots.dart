import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:intl/intl.dart';

/// 本周心情点阵 — 7 个圆点显示每天的心情。
class WeekMoodDotsRow extends ConsumerWidget {
  const WeekMoodDotsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    // 计算本周一
    final monday = now.subtract(Duration(days: now.weekday - 1));

    // 加载本月数据 — 覆盖本周所有天
    final monthStr = AppDateUtils.currentMonth();
    final lightsAsync = ref.watch(monthlyLightsProvider(monthStr));

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.weekMoodTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            lightsAsync.when(
              data: (lights) => _buildDots(context, monday, lights),
              loading: () => const SizedBox(
                height: 40,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) {
                debugPrint('[WeekMoodDots] Load error: $e');
                return Text(
                  context.l10n.weekMoodLoadError,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots(
    BuildContext context,
    DateTime monday,
    List<DailyLight> lights,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();

    // 按日期索引 lights
    final lightMap = <String, DailyLight>{};
    for (final light in lights) {
      lightMap[light.date] = light;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (i) {
        final day = monday.add(Duration(days: i));
        final dateStr = AppDateUtils.formatDay(day);
        final light = lightMap[dateStr];
        final isToday = dateStr == AppDateUtils.todayString();
        // 使用 locale-aware 的星期缩写首字母
        final dayLabel = DateFormat.E(locale).format(day).substring(0, 1);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayLabel,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: light != null
                    ? light.mood.themeColor(colorScheme).withValues(alpha: 0.2)
                    : isToday
                    ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : colorScheme.surfaceContainerHigh,
                border: isToday
                    ? Border.all(color: colorScheme.primary, width: 1.5)
                    : null,
              ),
              alignment: Alignment.center,
              child: light != null
                  ? Text(light.mood.emoji, style: const TextStyle(fontSize: 14))
                  : null,
            ),
          ],
        );
      }),
    );
  }
}
