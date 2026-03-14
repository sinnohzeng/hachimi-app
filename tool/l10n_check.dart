import 'dart:convert';
import 'dart:io';

/// l10n 完整性验证工具 — 守护 ARB 翻译文件的质量。
///
/// 检查项：
/// 1. Key 完整性：非模板 ARB 是否包含模板的全部 key
/// 2. 孤立 key：非模板 ARB 是否包含模板中不存在的 key
/// 3. 占位符一致性：参数化字符串的 {param} 是否匹配
/// 4. 空值检测：翻译值为空字符串
/// 5. 翻译长度预警：超过英语原文 200% 的翻译（warning，不阻断）
void main() {
  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    stderr.writeln('l10n_check: missing lib/l10n/ directory');
    exitCode = 1;
    return;
  }

  final templateFile = File('lib/l10n/app_en.arb');
  if (!templateFile.existsSync()) {
    stderr.writeln('l10n_check: missing template file app_en.arb');
    exitCode = 1;
    return;
  }

  final templateEntries = _parseArb(templateFile);
  final templateKeys = templateEntries.keys.toSet();

  final arbFiles =
      l10nDir
          .listSync()
          .whereType<File>()
          .where(
            (f) => f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb'),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (arbFiles.isEmpty) {
    stderr.writeln('l10n_check: no non-template ARB files found');
    exitCode = 1;
    return;
  }

  final violations = <String>[];
  final warnings = <String>[];

  for (final file in arbFiles) {
    final locale = _localeFromPath(file.path);
    final entries = _parseArb(file);
    final keys = entries.keys.toSet();

    _checkMissingKeys(locale, templateKeys, keys, violations);
    _checkOrphanKeys(locale, templateKeys, keys, violations);
    _checkPlaceholders(locale, templateEntries, entries, violations);
    _checkEmptyValues(locale, entries, violations);
    _checkTranslationLength(locale, templateEntries, entries, warnings);
  }

  // 输出 warnings（不阻断）
  for (final warning in warnings) {
    stdout.writeln('  ⚠ $warning');
  }

  if (violations.isEmpty) {
    stdout.writeln(
      'l10n_check: PASS (${arbFiles.length + 1} locales, '
      '${templateKeys.length} keys each)',
    );
    return;
  }

  stderr.writeln('l10n_check: FAIL (${violations.length} violations)');
  for (final v in violations) {
    stderr.writeln('  - $v');
  }
  exitCode = 1;
}

// --- 核心检查函数 ---

/// 检查非模板 ARB 中缺失的 key。
void _checkMissingKeys(
  String locale,
  Set<String> templateKeys,
  Set<String> targetKeys,
  List<String> violations,
) {
  final missing = templateKeys.difference(targetKeys);
  for (final key in missing) {
    violations.add('$locale: missing key "$key"');
  }
}

/// 检查非模板 ARB 中存在但模板中不存在的孤立 key。
void _checkOrphanKeys(
  String locale,
  Set<String> templateKeys,
  Set<String> targetKeys,
  List<String> violations,
) {
  final orphans = targetKeys.difference(templateKeys);
  for (final key in orphans) {
    violations.add('$locale: orphan key "$key" (not in template)');
  }
}

/// 检查参数化字符串的占位符是否与模板一致。
void _checkPlaceholders(
  String locale,
  Map<String, String> templateEntries,
  Map<String, String> targetEntries,
  List<String> violations,
) {
  for (final key in templateEntries.keys) {
    final templateValue = templateEntries[key]!;
    final targetValue = targetEntries[key];
    if (targetValue == null) continue; // 缺失 key 已在 _checkMissingKeys 报告

    final templateParams = _extractPlaceholders(templateValue);
    if (templateParams.isEmpty) continue;

    final targetParams = _extractPlaceholders(targetValue);
    if (!_setsEqual(templateParams, targetParams)) {
      violations.add(
        '$locale: placeholder mismatch in "$key" — '
        'expected $templateParams, got $targetParams',
      );
    }
  }
}

/// 检查空翻译值。
void _checkEmptyValues(
  String locale,
  Map<String, String> entries,
  List<String> violations,
) {
  for (final entry in entries.entries) {
    if (entry.value.trim().isEmpty) {
      violations.add('$locale: empty value for key "${entry.key}"');
    }
  }
}

/// 检查翻译长度异常（超过模板 200%）— 仅 warning。
void _checkTranslationLength(
  String locale,
  Map<String, String> templateEntries,
  Map<String, String> targetEntries,
  List<String> warnings,
) {
  const lengthThreshold = 2.0;
  const minLengthForCheck = 10; // 短字符串不检查

  for (final key in templateEntries.keys) {
    final templateValue = templateEntries[key]!;
    final targetValue = targetEntries[key];
    if (targetValue == null) continue;
    if (templateValue.length < minLengthForCheck) continue;

    final ratio = targetValue.length / templateValue.length;
    if (ratio > lengthThreshold) {
      warnings.add(
        '$locale: "$key" is ${(ratio * 100).toInt()}% of English length '
        '(${targetValue.length} vs ${templateValue.length} chars)',
      );
    }
  }
}

// --- 工具函数 ---

/// 解析 ARB 文件，返回翻译 key → value 的映射（排除元数据）。
Map<String, String> _parseArb(File file) {
  final content = file.readAsStringSync();
  final Map<String, dynamic> json;
  try {
    json = jsonDecode(content) as Map<String, dynamic>;
  } on FormatException catch (e) {
    stderr.writeln('l10n_check: invalid JSON in ${file.path}: $e');
    exitCode = 1;
    return {};
  }

  final entries = <String, String>{};
  for (final entry in json.entries) {
    // 跳过 @@locale 和 @key 元数据
    if (entry.key.startsWith('@')) continue;
    if (entry.value is String) {
      entries[entry.key] = entry.value as String;
    }
  }
  return entries;
}

/// 从文件路径提取 locale 标识符。
/// "lib/l10n/app_zh_Hant.arb" → "zh_Hant"
String _localeFromPath(String path) {
  final fileName = path.split('/').last; // app_zh_Hant.arb
  return fileName.replaceFirst('app_', '').replaceFirst('.arb', '');
}

/// 提取字符串中的 {placeholder} 名称集合。
Set<String> _extractPlaceholders(String value) {
  // \w+ 只匹配 ASCII，改用非括号字符匹配以支持 Unicode 占位符名
  final regex = RegExp(r'\{([^}]+)\}');
  return regex.allMatches(value).map((m) => m.group(1)!).toSet();
}

/// 比较两个 Set 是否结构相等（Dart Set 不重写 ==，不能直接用 !=）。
bool _setsEqual(Set<String> a, Set<String> b) {
  return a.length == b.length && a.containsAll(b);
}
