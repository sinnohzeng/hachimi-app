import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/worry.dart';

Worry _createTestWorry({
  WorryStatus status = WorryStatus.ongoing,
  String? solution,
  DateTime? resolvedAt,
}) {
  return Worry(
    id: 'test-worry-id',
    description: '担心项目进度',
    solution: solution,
    status: status,
    resolvedAt: resolvedAt,
    createdAt: DateTime(2026, 3, 17),
    updatedAt: DateTime(2026, 3, 17),
  );
}

void main() {
  group('WorryStatus', () {
    test('fromValue roundtrips all values', () {
      for (final status in WorryStatus.values) {
        expect(WorryStatus.fromValue(status.value), equals(status));
      }
    });

    test('fromValue throws for invalid value', () {
      expect(() => WorryStatus.fromValue('unknown'), throwsArgumentError);
      expect(() => WorryStatus.fromValue(''), throwsArgumentError);
    });
  });

  group('Worry.isSettled', () {
    test('returns false for ongoing', () {
      expect(_createTestWorry().isSettled, isFalse);
    });

    test('returns true for resolved', () {
      expect(_createTestWorry(status: WorryStatus.resolved).isSettled, isTrue);
    });

    test('returns true for disappeared', () {
      expect(
        _createTestWorry(status: WorryStatus.disappeared).isSettled,
        isTrue,
      );
    });
  });

  group('Worry SQLite roundtrip', () {
    test('minimal worry roundtrips correctly', () {
      final worry = _createTestWorry();
      final sqlite = worry.toSqlite('user-1');

      expect(sqlite['uid'], equals('user-1'));
      expect(sqlite['status'], equals('ongoing'));
      expect(sqlite['resolved_at'], isNull);

      final restored = Worry.fromSqlite(sqlite);
      expect(restored.description, equals('担心项目进度'));
      expect(restored.status, equals(WorryStatus.ongoing));
      expect(restored.solution, isNull);
      expect(restored.resolvedAt, isNull);
    });

    test('resolved worry roundtrips correctly', () {
      final resolvedAt = DateTime(2026, 3, 20);
      final worry = _createTestWorry(
        status: WorryStatus.resolved,
        solution: '拆分任务',
        resolvedAt: resolvedAt,
      );
      final sqlite = worry.toSqlite('user-1');

      expect(sqlite['status'], equals('resolved'));
      expect(sqlite['resolved_at'], equals(resolvedAt.millisecondsSinceEpoch));

      final restored = Worry.fromSqlite(sqlite);
      expect(restored.status, equals(WorryStatus.resolved));
      expect(restored.solution, equals('拆分任务'));
      expect(
        restored.resolvedAt!.millisecondsSinceEpoch,
        equals(resolvedAt.millisecondsSinceEpoch),
      );
    });

    test('status defaults to ongoing for null/missing', () {
      final sqlite = {
        'id': 'w1',
        'description': 'test',
        'solution': null,
        'status': null,
        'resolved_at': null,
        'created_at': DateTime(2026).millisecondsSinceEpoch,
        'updated_at': DateTime(2026).millisecondsSinceEpoch,
      };
      final worry = Worry.fromSqlite(sqlite);
      expect(worry.status, equals(WorryStatus.ongoing));
    });
  });

  group('Worry copyWith', () {
    test('clearSolution sets solution to null', () {
      final worry = _createTestWorry(solution: '拆分任务');
      final copy = worry.copyWith(clearSolution: true);
      expect(copy.solution, isNull);
    });

    test('clearResolvedAt sets resolvedAt to null', () {
      final worry = _createTestWorry(resolvedAt: DateTime(2026, 3, 20));
      final copy = worry.copyWith(clearResolvedAt: true);
      expect(copy.resolvedAt, isNull);
    });

    test('status change preserves other fields', () {
      final worry = _createTestWorry(solution: '拆分任务');
      final copy = worry.copyWith(status: WorryStatus.resolved);
      expect(copy.status, equals(WorryStatus.resolved));
      expect(copy.solution, equals('拆分任务'));
      expect(copy.description, equals('担心项目进度'));
    });
  });
}
