// ---
// 📘 文件说明：
// 语言选择对话框 — 系统/英文/简体中文/繁体中文/日文/韩文，通过 RadioGroup 切换。
//
// 🧩 文件结构：
// - LanguageDialog：语言选择 StatelessWidget；
//
// 🕒 创建时间：2026-02-19
// 🔄 更新：2026-02-21 — 添加繁体中文、日文、韩文
// ---

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
