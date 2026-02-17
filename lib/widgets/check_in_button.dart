import 'package:flutter/material.dart';

/// CheckInButton — primary action button for starting a timer or manual check-in.
class CheckInButton extends StatelessWidget {
  final bool hasCheckedInToday;
  final VoidCallback onPressed;

  const CheckInButton({
    super.key,
    required this.hasCheckedInToday,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(
        hasCheckedInToday ? Icons.add : Icons.play_arrow,
      ),
      label: Text(hasCheckedInToday ? 'Log more time' : 'Start timer'),
      style: FilledButton.styleFrom(
        backgroundColor: hasCheckedInToday
            ? colorScheme.secondaryContainer
            : colorScheme.primary,
        foregroundColor: hasCheckedInToday
            ? colorScheme.onSecondaryContainer
            : colorScheme.onPrimary,
      ),
    );
  }
}
