// ---
// 📘 文件说明：
// 语言选择对话框 — 系统/英文/中文三选一，通过 RadioGroup 切换。
//
// 🧩 文件结构：
// - LanguageDialog：语言选择 StatelessWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// Language selection dialog.
class LanguageDialog extends StatelessWidget {
  final Locale? currentLocale;

  const LanguageDialog({super.key, required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final currentCode = currentLocale?.languageCode ?? 'system';

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
