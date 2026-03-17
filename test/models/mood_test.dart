import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/mood.dart';

void main() {
  group('Mood', () {
    test('has 5 values covering the full spectrum', () {
      expect(Mood.values.length, equals(5));
    });

    test('values are ordered from positive to negative', () {
      expect(Mood.veryHappy.value, lessThan(Mood.happy.value));
      expect(Mood.happy.value, lessThan(Mood.calm.value));
      expect(Mood.calm.value, lessThan(Mood.down.value));
      expect(Mood.down.value, lessThan(Mood.veryDown.value));
    });

    test('each value has a non-empty emoji', () {
      for (final mood in Mood.values) {
        expect(mood.emoji, isNotEmpty);
      }
    });
  });

  group('Mood.fromValue', () {
    test('roundtrips all enum values', () {
      for (final mood in Mood.values) {
        expect(Mood.fromValue(mood.value), equals(mood));
      }
    });

    test('throws ArgumentError for invalid value', () {
      expect(() => Mood.fromValue(-1), throwsArgumentError);
      expect(() => Mood.fromValue(5), throwsArgumentError);
      expect(() => Mood.fromValue(99), throwsArgumentError);
    });
  });
}
