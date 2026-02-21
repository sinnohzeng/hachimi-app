import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/diary_provider.dart';

/// 日记预览卡片 — 展示今日日记摘要，点击进入日记列表。
class DiaryPreviewCard extends ConsumerWidget {
  final String catId;

  const DiaryPreviewCard({super.key, required this.catId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final todayDiary = ref.watch(todayDiaryProvider(catId));

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRouter.catDiary, arguments: catId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('\u{1F4D6}', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    context.l10n.catDetailDiaryTitle,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              todayDiary.when(
                loading: () => Text(
                  context.l10n.catDetailDiaryLoading,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                error: (_, __) => Text(
                  context.l10n.catDetailDiaryError,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                data: (entry) {
                  if (entry == null) {
                    return Text(
                      context.l10n.catDetailDiaryEmpty,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  }
                  return Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(height: 1.4),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
