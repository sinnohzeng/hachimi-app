import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// Language selection dialog.
class LanguageDialog extends StatelessWidget {
  final Locale? currentLocale;

  const LanguageDialog({super.key, required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    // 构建当前 locale 的复合标识符
    final String currentCode;
    if (currentLocale == null) {
      currentCode = 'system';
    } else if (currentLocale!.scriptCode == 'Hant') {
      currentCode = 'zh_Hant';
    } else {
      currentCode = currentLocale!.languageCode;
    }

    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsLanguage),
      contentPadding: const EdgeInsets.only(top: 12),
      content: RadioGroup<String>(
        groupValue: currentCode,
        onChanged: (value) => Navigator.of(context).pop(value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageSystem),
              value: 'system',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageEnglish),
              value: 'en',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageChinese),
              value: 'zh',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageTraditionalChinese),
              value: 'zh_Hant',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageJapanese),
              value: 'ja',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageKorean),
              value: 'ko',
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
