import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// 统计摘要卡片 — 显示单个统计指标（如总时长、习惯数等）。
class OverviewStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color onColor;

  const OverviewStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: color,
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: onColor),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: onColor,
              ),
            ),
            Text(label, style: textTheme.bodySmall?.copyWith(color: onColor)),
          ],
        ),
      ),
    );
  }
}
