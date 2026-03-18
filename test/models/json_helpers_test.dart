// ---
// JSON 辅助函数单元测试 — 验证 decodeJsonStringList 和 decodeJsonBoolMap
// 的正常路径和损坏数据降级行为。
//
// 纯单元测试，无数据库依赖。
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/json_helpers.dart';

void main() {
  group('decodeJsonStringList', () {
    test('valid JSON list returns correct List<String>', () {
      expect(decodeJsonStringList('["a","b","c"]'), equals(['a', 'b', 'c']));
    });

    test('empty JSON list returns empty list', () {
      expect(decodeJsonStringList('[]'), isEmpty);
    });

    test('null input returns empty list', () {
      expect(decodeJsonStringList(null), isEmpty);
    });

    test('corrupted JSON string returns empty list', () {
      expect(decodeJsonStringList('{not valid json'), isEmpty);
    });

    test('non-string input type returns empty list', () {
      expect(decodeJsonStringList(42), isEmpty);
      expect(decodeJsonStringList(true), isEmpty);
    });

    test('non-list JSON returns empty list', () {
      expect(decodeJsonStringList('{"key":"value"}'), isEmpty);
      expect(decodeJsonStringList('"just a string"'), isEmpty);
      expect(decodeJsonStringList('42'), isEmpty);
    });

    test('mixed types in list keeps only strings', () {
      expect(
        decodeJsonStringList('["hello", 42, true, "world", null]'),
        equals(['hello', 'world']),
      );
    });

    test('list of non-strings returns empty list', () {
      expect(decodeJsonStringList('[1, 2, 3]'), isEmpty);
    });
  });

  group('decodeJsonBoolMap', () {
    test('valid JSON bool map returns correct Map<String, bool>', () {
      expect(
        decodeJsonBoolMap('{"a":true,"b":false}'),
        equals({'a': true, 'b': false}),
      );
    });

    test('empty JSON object returns empty map', () {
      expect(decodeJsonBoolMap('{}'), isEmpty);
    });

    test('null input returns empty map', () {
      expect(decodeJsonBoolMap(null), isEmpty);
    });

    test('corrupted JSON string returns empty map', () {
      expect(decodeJsonBoolMap('not json at all'), isEmpty);
    });

    test('non-string input type returns empty map', () {
      expect(decodeJsonBoolMap(123), isEmpty);
    });

    test('non-map JSON returns empty map', () {
      expect(decodeJsonBoolMap('["a","b"]'), isEmpty);
      expect(decodeJsonBoolMap('"string"'), isEmpty);
    });

    test('null values in map default to false', () {
      expect(decodeJsonBoolMap('{"key":null}'), equals({'key': false}));
    });
  });
}
