import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// Growth stage milestone indicator dot + label.
class StageMilestone extends StatelessWidget {
  final String name;
  final bool isReached;
  final Color color;

  const StageMilestone({
    super.key,
    required this.name,
    required this.isReached,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReached
                ? color
                : colorScheme.outlineVariant.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.7
                        : 0.4,
                  ),
          ),
          child: isReached
              ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
              : null,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name,
          style: textTheme.labelSmall?.copyWith(
            color: isReached ? color : colorScheme.onSurfaceVariant,
            fontWeight: isReached ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
