import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 成长之路说明卡片 — 展示猫咪 4 阶段固定阶梯 + 研究支撑文案。
/// 用于 Quest 创建流程和猫咪详情页，始终完整展示。
class GrowthPathCard extends StatelessWidget {
  const GrowthPathCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Row(
              children: [
                Icon(Icons.auto_stories, color: colorScheme.primary, size: 22),
                const SizedBox(width: 12),
                Text(
                  l10n.growthPathTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _StageRow(
              icon: Icons.pets,
              stage: l10n.stageKitten,
              hours: '0h',
              desc: l10n.growthPathKitten,
              color: stageColor('kitten'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StageRow(
              icon: Icons.trending_up,
              stage: l10n.stageAdolescent,
              hours: '20h',
              desc: l10n.growthPathAdolescent,
              color: stageColor('adolescent'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StageRow(
              icon: Icons.emoji_events,
              stage: l10n.stageAdult,
              hours: '100h',
              desc: l10n.growthPathAdult,
              color: stageColor('adult'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StageRow(
              icon: Icons.auto_awesome,
              stage: l10n.stageSenior,
              hours: '200h',
              desc: l10n.growthPathSenior,
              color: stageColor('senior'),
            ),
            const SizedBox(height: AppSpacing.md),
            // 研究 tip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.growthPathTip,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  final IconData icon;
  final String stage;
  final String hours;
  final String desc;
  final Color color;

  const _StageRow({
    required this.icon,
    required this.stage,
    required this.hours,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    stage,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hours,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                desc,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
