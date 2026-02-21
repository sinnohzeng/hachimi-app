import 'package:flutter/material.dart';

/// A single row in the focus completion stats card.
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isBold;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: (isBold ? textTheme.titleSmall : textTheme.bodyMedium)
              ?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: (isBold ? textTheme.titleSmall : textTheme.bodyMedium)
              ?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
