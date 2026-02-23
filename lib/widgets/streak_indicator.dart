import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';

/// StreakIndicator — badge showing consecutive check-in days.
class StreakIndicator extends StatelessWidget {
  final int streak;

  const StreakIndicator({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: '$streak day streak',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: AppShape.borderMedium,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 16,
              color: colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: 2),
            Text(
              '$streak',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
