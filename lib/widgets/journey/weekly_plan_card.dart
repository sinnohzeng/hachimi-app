import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/weekly_plan.dart';
import 'package:hachimi_app/providers/journey_providers.dart';

/// 周计划摘要卡 — 显示一句话 + 四象限概要，点击进入编辑。
class WeeklyPlanCard extends ConsumerWidget {
  final VoidCallback onTap;

  const WeeklyPlanCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(currentWeekPlanProvider);
    return Card(
      child: InkWell(
        borderRadius: AppShape.borderMedium,
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: planAsync.when(
            data: (plan) => plan != null
                ? _buildContent(context, plan)
                : _buildEmpty(context),
            loading: () => const Padding(
              padding: AppSpacing.paddingVBase,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) {
              debugPrint('[WeeklyPlanCard] Load error: $e');
              return _buildEmpty(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WeeklyPlan plan) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final totalItems =
        plan.urgentImportant.length +
        plan.importantNotUrgent.length +
        plan.urgentNotImportant.length +
        plan.wantToDo.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.checklist, size: 20, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.weeklyPlanCardTitle, style: textTheme.titleSmall),
            const Spacer(),
            Text(
              l10n.weeklyPlanItemCount(totalItems),
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (plan.oneLineForSelf != null && plan.oneLineForSelf!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            '"${plan.oneLineForSelf}"',
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.checklist, size: 20, color: colorScheme.outline),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            context.l10n.weeklyPlanEmpty,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.outline),
      ],
    );
  }
}
