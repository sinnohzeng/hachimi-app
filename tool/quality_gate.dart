import 'dart:io';

const maxFileLines = 800;
const maxFunctionLines = 30;
const maxNestingDepth = 3;
const maxBranchCount = 3;

final _excludedPathPatterns = <Pattern>[
  RegExp(r'lib/l10n/app_localizations.*\.dart$'),
  RegExp(r'\.g\.dart$'),
  RegExp(r'\.freezed\.dart$'),
];

void main() {
  final root = Directory('lib');
  if (!root.existsSync()) {
    stderr.writeln('quality_gate: missing lib/ directory');
    exitCode = 1;
    return;
  }

  final files =
      root
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where((f) => !_isExcluded(f.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final violations = <String>[];
  for (final file in files) {
    final lines = file.readAsLinesSync();
    _checkFileLength(file.path, lines, violations);
    _checkTopLevelFunctions(file.path, lines, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('quality_gate: PASS (${files.length} files checked)');
    return;
  }

  stderr.writeln('quality_gate: FAIL (${violations.length} violations)');
  for (final violation in violations) {
    stderr.writeln('  - $violation');
  }
  exitCode = 1;
}

bool _isExcluded(String path) {
  return _excludedPathPatterns.any((pattern) {
    if (pattern is RegExp) return pattern.hasMatch(path);
    return path.contains(pattern.toString());
  });
}

void _checkFileLength(
  String path,
  List<String> lines,
  List<String> violations,
) {
  if (lines.length > maxFileLines) {
    violations.add('$path: file lines ${lines.length} > $maxFileLines');
  }
}

void _checkTopLevelFunctions(
  String path,
  List<String> lines,
  List<String> violations,
) {
  var braceDepth = 0;
  var i = 0;

  while (i < lines.length) {
    final line = lines[i];
    final trimmed = line.trim();
    final openCount = _countChar(line, '{');
    final closeCount = _countChar(line, '}');

    final isCandidate = braceDepth == 0 && _isTopLevelFunctionSignature(line);
    if (!isCandidate) {
      braceDepth += openCount - closeCount;
      i++;
      continue;
    }

    final name = _extractFunctionName(trimmed) ?? '<anonymous>';
    final start = i;
    var functionBraceDepth = openCount - closeCount;
    var maxDepth = functionBraceDepth;
    var branchCount = _countBranches(line);

    i++;
    while (i < lines.length && functionBraceDepth > 0) {
      final bodyLine = lines[i];
      branchCount += _countBranches(bodyLine);
      functionBraceDepth +=
          _countChar(bodyLine, '{') - _countChar(bodyLine, '}');
      if (functionBraceDepth > maxDepth) maxDepth = functionBraceDepth;
      i++;
    }

    braceDepth = 0;
    final functionLines = i - start;
    final nestedDepth = maxDepth <= 0 ? 0 : maxDepth - 1;

    if (functionLines > maxFunctionLines) {
      violations.add(
        '$path:${start + 1} function $name lines '
        '$functionLines > $maxFunctionLines',
      );
    }
    if (nestedDepth > maxNestingDepth) {
      violations.add(
        '$path:${start + 1} function $name nesting '
        '$nestedDepth > $maxNestingDepth',
      );
    }
    if (branchCount > maxBranchCount) {
      violations.add(
        '$path:${start + 1} function $name branches '
        '$branchCount > $maxBranchCount',
      );
    }
  }
}

bool _isTopLevelFunctionSignature(String line) {
  if (line.startsWith(' ') || line.startsWith('\t')) return false;

  final trimmed = line.trim();
  if (!trimmed.endsWith('{')) return false;
  if (!trimmed.contains('(') || !trimmed.contains(')')) return false;

  const blockedStarts = [
    'if ',
    'if(',
    'for ',
    'for(',
    'while ',
    'while(',
    'switch ',
    'switch(',
    'class ',
    'enum ',
    'mixin ',
    'extension ',
    'return ',
  ];

  return !blockedStarts.any(trimmed.startsWith);
}

String? _extractFunctionName(String signature) {
  final idxParen = signature.indexOf('(');
  if (idxParen <= 0) return null;
  final beforeParen = signature.substring(0, idxParen).trim();
  final parts = beforeParen.split(RegExp(r'\s+'));
  if (parts.isEmpty) return null;
  return parts.last;
}

int _countBranches(String line) {
  final compact = line.replaceAll(RegExp(r'//.*$'), '');
  final patterns = [
    RegExp(r'\bif\s*\('),
    RegExp(r'\bswitch\s*\('),
    RegExp(r'\bfor\s*\('),
    RegExp(r'\bwhile\s*\('),
    RegExp(r'\bcase\b'),
    RegExp(r'\bcatch\b'),
  ];

  var count = 0;
  for (final pattern in patterns) {
    count += pattern.allMatches(compact).length;
  }
  return count;
}

int _countChar(String input, String char) {
  var count = 0;
  for (final rune in input.runes) {
    if (rune == char.codeUnitAt(0)) count++;
  }
  return count;
}
