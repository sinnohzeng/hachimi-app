import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/weekly_review.dart';

WeeklyReview _createTestReview({
  String? happyMoment1,
  String? happyMoment2,
  String? happyMoment3,
  String? gratitude,
  String? learning,
  String? catWeeklySummary,
}) {
  return WeeklyReview(
    id: 'test-review-id',
    weekId: '2026-W12',
    weekStartDate: '2026-03-16',
    weekEndDate: '2026-03-22',
    happyMoment1: happyMoment1,
    happyMoment2: happyMoment2,
    happyMoment3: happyMoment3,
    gratitude: gratitude,
    learning: learning,
    catWeeklySummary: catWeeklySummary,
    createdAt: DateTime(2026, 3, 22, 20, 0),
    updatedAt: DateTime(2026, 3, 22, 20, 0),
  );
}

void main() {
  group('WeeklyReview.filledMomentCount', () {
    test('returns 0 when all moments are null', () {
      expect(_createTestReview().filledMomentCount, equals(0));
    });

    test('returns 0 when all moments are empty strings', () {
      final review = _createTestReview(
        happyMoment1: '',
        happyMoment2: '',
        happyMoment3: '',
      );
      expect(review.filledMomentCount, equals(0));
    });

    test('returns 1 when only first moment is filled', () {
      final review = _createTestReview(happyMoment1: '和家人吃饭');
      expect(review.filledMomentCount, equals(1));
    });

    test('returns 3 when all moments are filled', () {
      final review = _createTestReview(
        happyMoment1: '散步',
        happyMoment2: '读书',
        happyMoment3: '做饭',
      );
      expect(review.filledMomentCount, equals(3));
    });
  });

  group('WeeklyReview.isComplete', () {
    test('returns false when no moments and no reflection', () {
      expect(_createTestReview().isComplete, isFalse);
    });

    test('returns false with moments but no reflection', () {
      final review = _createTestReview(happyMoment1: '散步');
      expect(review.isComplete, isFalse);
    });

    test('returns false with gratitude but no moments', () {
      final review = _createTestReview(gratitude: '感恩家人');
      expect(review.isComplete, isFalse);
    });

    test('returns true with 1 moment + gratitude', () {
      final review = _createTestReview(happyMoment1: '散步', gratitude: '感恩家人');
      expect(review.isComplete, isTrue);
    });

    test('returns true with 1 moment + learning', () {
      final review = _createTestReview(happyMoment1: '散步', learning: '学到了冥想');
      expect(review.isComplete, isTrue);
    });
  });

  group('WeeklyReview SQLite roundtrip', () {
    test('minimal review roundtrips correctly', () {
      final review = _createTestReview();
      final sqlite = review.toSqlite('user-1');

      expect(sqlite['uid'], equals('user-1'));
      expect(sqlite['week_id'], equals('2026-W12'));

      final restored = WeeklyReview.fromSqlite(sqlite);
      expect(restored.weekId, equals('2026-W12'));
      expect(restored.happyMoment1, isNull);
      expect(restored.happyMoment1Tags, isEmpty);
    });

    test('full review roundtrips correctly', () {
      final review = WeeklyReview(
        id: 'test-id',
        weekId: '2026-W12',
        weekStartDate: '2026-03-16',
        weekEndDate: '2026-03-22',
        happyMoment1: '和家人散步',
        happyMoment1Tags: ['家人', '户外'],
        happyMoment2: '完成项目',
        happyMoment2Tags: ['工作'],
        gratitude: '感恩健康',
        learning: '学会了冥想',
        catWeeklySummary: '这周真棒喵~',
        createdAt: DateTime(2026, 3, 22),
        updatedAt: DateTime(2026, 3, 22),
      );
      final sqlite = review.toSqlite('user-1');

      expect(
        jsonDecode(sqlite['happy_moment_1_tags'] as String),
        equals(['家人', '户外']),
      );

      final restored = WeeklyReview.fromSqlite(sqlite);
      expect(restored.happyMoment1, equals('和家人散步'));
      expect(restored.happyMoment1Tags, equals(['家人', '户外']));
      expect(restored.happyMoment2Tags, equals(['工作']));
      expect(restored.catWeeklySummary, equals('这周真棒喵~'));
    });
  });

  group('WeeklyReview copyWith', () {
    test('clearHappyMoment1 sets to null', () {
      final review = _createTestReview(happyMoment1: '散步');
      final copy = review.copyWith(clearHappyMoment1: true);
      expect(copy.happyMoment1, isNull);
    });

    test('clearGratitude sets to null', () {
      final review = _createTestReview(gratitude: '感恩');
      final copy = review.copyWith(clearGratitude: true);
      expect(copy.gratitude, isNull);
    });
  });
}
