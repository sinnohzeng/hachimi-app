import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_icon_size.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/diary_provider.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_diary_entry.dart';
import 'package:hachimi_app/widgets/pixel_ui/retro_tiled_background.dart';
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

    return AppScaffold(
      pattern: PatternType.diagonal,
      appBar: AppBar(
        title: Text(
          context.l10n.diaryTitle(cat?.name ?? context.l10n.fallbackCatName),
          style: context.pixel.pixelTitle,
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
                    const Text(
                      '📖',
                      style: TextStyle(fontSize: AppIconSize.emoji),
                    ),
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
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final moodData = moodById(entry.mood);
              final personality = personalityMap[entry.personality];

              return PixelDiaryEntry(
                date: _formatDate(entry.date, context),
                content: entry.content,
                moodEmoji: moodData.emoji,
                moodName: context.l10n.moodName(moodData.id),
                personality: personality != null
                    ? '${personality.emoji} ${context.l10n.personalityName(personality.id)}'
                    : null,
                stage: context.l10n.stageName(entry.stage),
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
