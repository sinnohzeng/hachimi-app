import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/providers/inspiration_provider.dart';

/// 灵感卡片 — 每日轮换提示，带星星装饰。
class InspirationCard extends ConsumerWidget {
  const InspirationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final prompt = ref.watch(dailyInspirationProvider);

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: AppShape.borderMedium),
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: colorScheme.primary.withValues(alpha: 0.7),
              size: 28,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                prompt,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.85),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
