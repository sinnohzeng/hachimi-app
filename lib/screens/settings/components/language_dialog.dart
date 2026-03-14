import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 支持的语言代码列表 — 新增语言只需在此添加一行。
const _localeCodes = [
  'system',
  'en',
  'zh',
  'zh_Hant',
  'ja',
  'ko',
  'es',
  'pt',
  'fr',
  'de',
  'it',
  'hi',
  'th',
  'vi',
  'id',
  'tr',
];

/// Language selection dialog.
class LanguageDialog extends StatelessWidget {
  final Locale? currentLocale;

  const LanguageDialog({super.key, required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final currentCode = _localeToCode(currentLocale);
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.settingsLanguage),
      contentPadding: const EdgeInsets.only(top: 12),
      content: SingleChildScrollView(
        child: RadioGroup<String>(
          groupValue: currentCode,
          onChanged: (value) => Navigator.of(context).pop(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final code in _localeCodes)
                RadioListTile<String>(
                  title: Text(_langLabel(l10n, code)),
                  value: code,
                ),
            ],
          ),
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

  /// Locale → locale code 字符串（与 _localeCodes 中的值对应）。
  static String _localeToCode(Locale? locale) {
    if (locale == null) return 'system';
    if (locale.scriptCode == 'Hant') return 'zh_Hant';
    return locale.languageCode;
  }
}

/// 将 locale code 映射到本地化的语言名称。
String _langLabel(S l10n, String code) => switch (code) {
  'system' => l10n.settingsLanguageSystem,
  'en' => l10n.settingsLanguageEnglish,
  'zh' => l10n.settingsLanguageChinese,
  'zh_Hant' => l10n.settingsLanguageTraditionalChinese,
  'ja' => l10n.settingsLanguageJapanese,
  'ko' => l10n.settingsLanguageKorean,
  'es' => l10n.settingsLanguageSpanish,
  'pt' => l10n.settingsLanguagePortuguese,
  'fr' => l10n.settingsLanguageFrench,
  'de' => l10n.settingsLanguageGerman,
  'it' => l10n.settingsLanguageItalian,
  'hi' => l10n.settingsLanguageHindi,
  'th' => l10n.settingsLanguageThai,
  'vi' => l10n.settingsLanguageVietnamese,
  'id' => l10n.settingsLanguageIndonesian,
  'tr' => l10n.settingsLanguageTurkish,
  _ => code,
};
