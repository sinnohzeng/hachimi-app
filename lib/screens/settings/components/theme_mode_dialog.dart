import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// Theme mode selection dialog.
class ThemeModeDialog extends StatelessWidget {
  final ThemeMode currentMode;

  const ThemeModeDialog({super.key, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsThemeMode),
      contentPadding: const EdgeInsets.only(top: 12),
      content: RadioGroup<ThemeMode>(
        groupValue: currentMode,
        onChanged: (value) => Navigator.of(context).pop(value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeModeSystem),
              value: ThemeMode.system,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeModeLight),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeModeDark),
              value: ThemeMode.dark,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ],
    );
  }
}
