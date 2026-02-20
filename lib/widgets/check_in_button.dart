import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

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
      icon: Icon(hasCheckedInToday ? Icons.add : Icons.play_arrow),
      label: Text(
        hasCheckedInToday
            ? context.l10n.checkInButtonLogMore
            : context.l10n.checkInButtonStart,
      ),
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
