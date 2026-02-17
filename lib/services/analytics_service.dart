import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hachimi_app/core/constants/analytics_events.dart';

/// AnalyticsService — wraps Firebase Analytics for all custom event tracking.
/// Event definitions are in analytics_events.dart (SSOT for event names/params).
/// See docs/firebase/analytics-events.md for the full specification.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ─── Conversion Events ───

  Future<void> logSignUp({String method = 'email'}) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logHabitCreated({
    required String habitName,
    required int targetHours,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.habitCreated,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramTargetHours: targetHours,
      },
    );
  }

  Future<void> logHabitDeleted({required String habitName}) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.habitDeleted,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
      },
    );
  }

  // ─── Timer Events ───

  Future<void> logTimerStarted({required String habitName}) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.timerStarted,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
      },
    );
  }

  Future<void> logTimerCompleted({
    required String habitName,
    required int durationMinutes,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.timerCompleted,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramDurationMinutes: durationMinutes,
      },
    );
  }

  // ─── Check-in Events ───

  Future<void> logDailyCheckIn({
    required String habitName,
    required int streakCount,
    required int minutesToday,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.dailyCheckIn,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramStreakCount: streakCount,
        AnalyticsEvents.paramMinutesToday: minutesToday,
      },
    );
  }

  Future<void> logStreakAchieved({
    required String habitName,
    required int milestone,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.streakAchieved,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramMilestone: milestone,
      },
    );
  }

  Future<void> logGoalProgress({
    required String habitName,
    required int percentComplete,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEvents.goalProgress,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramPercentComplete: percentComplete,
      },
    );
  }

  Future<void> logNotificationOpened() async {
    await _analytics.logEvent(name: AnalyticsEvents.notificationOpened);
  }

  // ─── User Properties ───

  Future<void> setUserProperties({
    int? totalHabits,
    int? longestStreak,
    int? totalHoursLogged,
    int? daysSinceSignup,
  }) async {
    if (totalHabits != null) {
      await _analytics.setUserProperty(
        name: AnalyticsEvents.propTotalHabits,
        value: totalHabits.toString(),
      );
    }
    if (longestStreak != null) {
      await _analytics.setUserProperty(
        name: AnalyticsEvents.propLongestStreak,
        value: longestStreak.toString(),
      );
    }
    if (totalHoursLogged != null) {
      await _analytics.setUserProperty(
        name: AnalyticsEvents.propTotalHoursLogged,
        value: totalHoursLogged.toString(),
      );
    }
    if (daysSinceSignup != null) {
      await _analytics.setUserProperty(
        name: AnalyticsEvents.propDaysSinceSignup,
        value: daysSinceSignup.toString(),
      );
    }
  }
}
