import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const SummaryItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, color: colorScheme.onPrimaryContainer, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
