// ---
// 📘 文件说明：
// 猫猫日记列表页 — 按日期倒序展示所有 AI 生成的日记条目。
// 每条日记包含日期、心情 emoji、性格快照和完整日记文本。
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/diary_provider.dart';

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
        title: Text('${cat?.name ?? "Cat"} Diary'),
      ),
      body: diaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text('Failed to load diary',
                  style: textTheme.bodyLarge),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => ref.invalidate(diaryEntriesProvider(catId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('📖', style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text(
                      'No diary entries yet',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete a focus session and your cat will write their first diary entry!',
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
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final moodData = moodById(entry.mood);
              final personality = personalityMap[entry.personality];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 日期 + 心情
                      Row(
                        children: [
                          Text(
                            _formatDate(entry.date),
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
                              '${moodData.emoji} ${moodData.name}',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (personality != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${personality.emoji} ${personality.name} · ${entry.stage}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),

                      // 日记正文
                      Text(
                        entry.content,
                        style: textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
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

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[month - 1]} $day';
    } catch (_) {
      return dateStr;
    }
  }
}
