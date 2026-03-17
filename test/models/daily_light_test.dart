import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';

DailyLight _createTestLight({
  Mood mood = Mood.happy,
  String? lightText,
  List<String> tags = const [],
  List<String>? timelineEvents,
  Map<String, bool>? habitCompletions,
}) {
  return DailyLight(
    id: 'test-light-id',
    date: '2026-03-17',
    mood: mood,
    lightText: lightText,
    tags: tags,
    timelineEvents: timelineEvents,
    habitCompletions: habitCompletions,
    createdAt: DateTime(2026, 3, 17, 22, 0),
    updatedAt: DateTime(2026, 3, 17, 22, 0),
  );
}

void main() {
  group('DailyLight 计算属性', () {
    test('hasText returns false for null lightText', () {
      expect(_createTestLight().hasText, isFalse);
    });

    test('hasText returns false for empty lightText', () {
      expect(_createTestLight(lightText: '').hasText, isFalse);
    });

    test('hasText returns true for non-empty lightText', () {
      expect(_createTestLight(lightText: '今天很开心').hasText, isTrue);
    });

    test('hasTags returns false for empty tags', () {
      expect(_createTestLight().hasTags, isFalse);
    });

    test('hasTags returns true for non-empty tags', () {
      expect(_createTestLight(tags: ['家人']).hasTags, isTrue);
    });
  });

  group('DailyLight SQLite roundtrip', () {
    test('minimal light serializes and deserializes correctly', () {
      final light = _createTestLight();
      final sqlite = light.toSqlite('user-1');

      expect(sqlite['uid'], equals('user-1'));
      expect(sqlite['mood'], equals(Mood.happy.value));
      expect(sqlite['tags'], equals('[]'));

      final restored = DailyLight.fromSqlite(sqlite);
      expect(restored.id, equals(light.id));
      expect(restored.date, equals(light.date));
      expect(restored.mood, equals(light.mood));
      expect(restored.lightText, isNull);
      expect(restored.tags, isEmpty);
      expect(restored.timelineEvents, isNull);
      expect(restored.habitCompletions, isNull);
    });

    test('full light serializes and deserializes correctly', () {
      final light = _createTestLight(
        lightText: '阳光很好',
        tags: ['户外', '朋友'],
        timelineEvents: ['早上散步', '下午读书'],
        habitCompletions: {'habit-1': true, 'habit-2': false},
      );
      final sqlite = light.toSqlite('user-1');

      expect(sqlite['light_text'], equals('阳光很好'));
      expect(jsonDecode(sqlite['tags'] as String), equals(['户外', '朋友']));

      final restored = DailyLight.fromSqlite(sqlite);
      expect(restored.lightText, equals('阳光很好'));
      expect(restored.tags, equals(['户外', '朋友']));
      expect(restored.timelineEvents, equals(['早上散步', '下午读书']));
      expect(
        restored.habitCompletions,
        equals({'habit-1': true, 'habit-2': false}),
      );
    });

    test('DateTime stored as millisecondsSinceEpoch', () {
      final light = _createTestLight();
      final sqlite = light.toSqlite('user-1');
      expect(sqlite['created_at'], isA<int>());
      expect(sqlite['updated_at'], isA<int>());
    });
  });

  group('DailyLight copyWith', () {
    test('returns identical instance when no arguments', () {
      final light = _createTestLight(lightText: 'hello', tags: ['工作']);
      final copy = light.copyWith();
      expect(copy.lightText, equals('hello'));
      expect(copy.tags, equals(['工作']));
    });

    test('clearLightText sets lightText to null', () {
      final light = _createTestLight(lightText: 'hello');
      final copy = light.copyWith(clearLightText: true);
      expect(copy.lightText, isNull);
    });

    test('overrides mood correctly', () {
      final light = _createTestLight(mood: Mood.happy);
      final copy = light.copyWith(mood: Mood.veryDown);
      expect(copy.mood, equals(Mood.veryDown));
    });
  });
}
