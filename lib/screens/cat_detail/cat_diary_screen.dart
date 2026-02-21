// ---
// 📘 文件说明：
// 猫猫日记列表页 — 按日期倒序展示所有 AI 生成的日记条目。
// 每条日记包含日期、心情 emoji、性格快照和完整日记文本。
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/diary_provider.dart';
import 'package:intl/intl.dart';

/// 猫猫日记列表页。
class CatDiaryScreen extends ConsumerWidget {
  final String catId;

  const CatDiaryScreen({super.key, required this.catId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final cat = ref.watch(catByIdProvider(catId));
    final diaryAsync = ref.watch(diaryEntriesProvider(catId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.diaryTitle(cat?.name ?? context.l10n.fallbackCatName),
        ),
      ),
      body: diaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(context.l10n.diaryLoadFailed, style: textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () => ref.invalidate(diaryEntriesProvider(catId)),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: AppSpacing.paddingXl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📖', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      context.l10n.diaryEmptyTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.diaryEmptyHint,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: AppSpacing.paddingBase,
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final moodData = moodById(entry.mood);
              final personality = personalityMap[entry.personality];

              return Card(
                child: Padding(
                  padding: AppSpacing.paddingBase,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 日期 + 心情
                      Row(
                        children: [
                          Text(
                            _formatDate(entry.date, context),
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${moodData.emoji} ${context.l10n.moodName(moodData.id)}',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (personality != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${personality.emoji} ${context.l10n.personalityName(personality.id)} · ${context.l10n.stageName(entry.stage)}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),

                      // 日记正文
                      Text(
                        entry.content,
                        style: textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr, BuildContext context) {
    try {
      final date = DateTime.parse(dateStr);
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.MMMd(locale).format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
