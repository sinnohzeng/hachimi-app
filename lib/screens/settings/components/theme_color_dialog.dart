import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// Theme color selection dialog with 8-color grid.
class ThemeColorDialog extends StatelessWidget {
  final Color currentColor;

  const ThemeColorDialog({super.key, required this.currentColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(context.l10n.settingsThemeColor),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AppTheme.presetColors.map((color) {
          final isSelected = color.toARGB32() == currentColor.toARGB32();
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(color),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: colorScheme.onSurface, width: 3)
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
      ],
    );
  }
}
