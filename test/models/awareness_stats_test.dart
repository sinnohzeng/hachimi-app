import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/awareness_stats.dart';

void main() {
  group('AwarenessStats', () {
    test('worryResolutionRate returns 0 when totalWorriesAll is 0', () {
      const stats = AwarenessStats(
        totalLightDays: 5,
        totalWeeklyReviews: 2,
        totalWorriesResolved: 0,
        totalWorriesAll: 0,
      );
      expect(stats.worryResolutionRate, 0.0);
    });

    test('worryResolutionRate calculates correctly', () {
      const stats = AwarenessStats(
        totalLightDays: 10,
        totalWeeklyReviews: 3,
        totalWorriesResolved: 3,
        totalWorriesAll: 10,
      );
      expect(stats.worryResolutionRate, 30.0);
    });

    test('fromMap with empty map returns zeros', () {
      final stats = AwarenessStats.fromMap({});
      expect(stats.totalLightDays, 0);
      expect(stats.totalWeeklyReviews, 0);
      expect(stats.totalWorriesResolved, 0);
      expect(stats.totalWorriesAll, 0);
      expect(stats.worryResolutionRate, 0.0);
    });

    test('fromMap with valid data', () {
      final stats = AwarenessStats.fromMap({
        'totalLightDays': 15,
        'totalWeeklyReviews': 4,
        'totalWorriesResolved': 7,
        'totalWorriesAll': 12,
      });
      expect(stats.totalLightDays, 15);
      expect(stats.totalWeeklyReviews, 4);
      expect(stats.totalWorriesResolved, 7);
      expect(stats.totalWorriesAll, 12);
    });
  });
}
