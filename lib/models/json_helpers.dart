import 'dart:convert';

/// 共享 JSON 反序列化辅助函数 — 用于 SQLite 列中存储的 JSON 字符串。

/// 将 SQLite 中 JSON 编码的字符串列表解码为 `List<String>`。
/// 损坏数据静默降级为空列表。
List<String> decodeJsonStringList(dynamic raw) {
  if (raw is String) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.whereType<String>().toList();
    } on FormatException {
      // 损坏数据静默降级为空列表
    }
  }
  return [];
}

/// 将 SQLite 中 JSON 编码的 bool Map 解码为 `Map<String, bool>`。
/// 损坏数据静默降级为空 Map。
Map<String, bool> decodeJsonBoolMap(dynamic raw) {
  if (raw is String) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded.map((k, v) => MapEntry(k, v as bool? ?? false));
      }
    } on FormatException {
      // 损坏数据静默降级为空 Map
    }
  }
  return {};
}
