import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/highlight_entry.dart';

/// 时刻卡片 — 展示幸福/高光时刻的单条记录。
class MomentCard extends StatelessWidget {
  final HighlightEntry entry;
  final VoidCallback? onTap;

  const MomentCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isHappy = entry.type == HighlightType.happy;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行：描述 + 评分
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.description,
                      style: textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildRating(isHappy, entry.rating, colorScheme),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // 伴侣/行动
              if (entry.companion != null && entry.companion!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Icon(
                        isHappy ? Icons.people_outline : Icons.bolt_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          isHappy
                              ? '和${entry.companion}一起'
                              : '我做了：${entry.companion}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // 感受
              if (entry.feeling != null && entry.feeling!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(
                    entry.feeling!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              // 日期
              Text(
                entry.date,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating(bool isHappy, int rating, ColorScheme colorScheme) {
    if (isHappy) {
      // 幸福时刻用 emoji 表情
      const emojis = ['', '😐', '🙂', '😊', '😄', '🥰'];
      return Text(
        emojis[rating.clamp(1, 5)],
        style: const TextStyle(fontSize: 20),
      );
    }
    // 高光时刻用奖牌图标
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rating.clamp(1, 5), (_) {
        return Icon(Icons.emoji_events, size: 14, color: colorScheme.tertiary);
      }),
    );
  }
}
