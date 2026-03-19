import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/lumi_constants.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// 灵感卡片 — 每日轮换提示，带星星装饰。
class InspirationCard extends StatelessWidget {
  const InspirationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 根据日期选择提示 — 每天固定一条
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    final prompts = LumiConstants.dailyLightPrompts;
    final prompt = prompts[dayOfYear % prompts.length];

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
