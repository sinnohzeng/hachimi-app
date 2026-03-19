import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 烦恼罐卡片 — 显示进行中的烦恼数量，点击进入烦恼处理器。
class WorryJarCard extends ConsumerWidget {
  const WorryJarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worriesAsync = ref.watch(activeWorriesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: AppShape.borderMedium,
        onTap: () => Navigator.of(context).pushNamed(AppRouter.worryProcessor),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: worriesAsync.when(
            data: (worries) {
              final count = worries.length;
              return Row(
                children: [
                  Icon(
                    Icons.cloud_outlined,
                    size: 20,
                    color: count > 0
                        ? colorScheme.secondary
                        : colorScheme.outline,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '烦恼罐', // TODO: l10n
                      style: textTheme.titleSmall,
                    ),
                  ),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: AppShape.borderFull,
                      ),
                      child: Text(
                        '$count',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: AppSpacing.paddingVSm,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) {
              debugPrint('[WorryJarCard] Load error: $e');
              return Text(
                '加载失败', // TODO: l10n
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              );
            },
          ),
        ),
      ),
    );
  }
}
