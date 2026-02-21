import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hachimi_app/core/constants/analytics_events.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// AnalyticsService — wraps Firebase Analytics for all custom event tracking.
/// Event definitions are in analytics_events.dart (SSOT for event names/params).
/// See docs/firebase/analytics-events.md for the full specification.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// 安全执行分析事件 — 捕获所有异常并静默处理。
  Future<void> _safeLog(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AnalyticsService',
        operation: '_safeLog',
      );
    }
  }

  // ─── Auth Events ───

  Future<void> logSignUp({String method = 'email'}) =>
      _safeLog(() => _analytics.logSignUp(signUpMethod: method));

  // ─── Habit Lifecycle Events ───

  Future<void> logHabitCreated({
    required String habitName,
    required int targetHours,
    int? goalMinutes,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.habitCreated,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramTargetHours: targetHours,
        if (goalMinutes != null) AnalyticsEvents.paramGoalMinutes: goalMinutes,
      },
    ),
  );

  Future<void> logHabitDeleted({required String habitName}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.habitDeleted,
      parameters: {AnalyticsEvents.paramHabitName: habitName},
    ),
  );

  // ─── Cat Lifecycle Events ───

  Future<void> logCatAdopted({
    required String breed,
    required String pattern,
    required String personality,
    required String rarity,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.catAdopted,
      parameters: {
        AnalyticsEvents.paramBreed: breed,
        AnalyticsEvents.paramPattern: pattern,
        AnalyticsEvents.paramPersonality: personality,
        AnalyticsEvents.paramRarity: rarity,
      },
    ),
  );

  Future<void> logCatLevelUp({
    required String catId,
    required int newLevel,
    required int newStage,
    required int totalXp,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.catLevelUp,
      parameters: {
        AnalyticsEvents.paramCatId: catId,
        AnalyticsEvents.paramNewLevel: newLevel,
        AnalyticsEvents.paramNewStage: newStage,
        AnalyticsEvents.paramTotalXp: totalXp,
      },
    ),
  );

  Future<void> logCatStageEvolved({
    required String catId,
    required String newStage,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.catStageEvolved,
      parameters: {
        AnalyticsEvents.paramCatId: catId,
        AnalyticsEvents.paramNewStage: newStage,
      },
    ),
  );

  // ─── Focus Session Events ───

  Future<void> logFocusSessionStarted({
    required String habitId,
    required String timerMode,
    required int targetMinutes,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.focusSessionStarted,
      parameters: {
        AnalyticsEvents.paramHabitId: habitId,
        AnalyticsEvents.paramTimerMode: timerMode,
        AnalyticsEvents.paramTargetMinutes: targetMinutes,
      },
    ),
  );

  Future<void> logFocusSessionCompleted({
    required String habitId,
    required int actualMinutes,
    required int xpEarned,
    required int streakDays,
    int? targetDurationMinutes,
    int? pausedSeconds,
    double? completionRatio,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.focusSessionCompleted,
      parameters: {
        AnalyticsEvents.paramHabitId: habitId,
        AnalyticsEvents.paramActualMinutes: actualMinutes,
        AnalyticsEvents.paramXpEarned: xpEarned,
        AnalyticsEvents.paramStreakDays: streakDays,
        if (targetDurationMinutes != null)
          AnalyticsEvents.paramTargetDurationMinutes: targetDurationMinutes,
        if (pausedSeconds != null)
          AnalyticsEvents.paramPausedSeconds: pausedSeconds,
        if (completionRatio != null)
          AnalyticsEvents.paramCompletionRatio: completionRatio,
      },
    ),
  );

  Future<void> logFocusSessionAbandoned({
    required String habitId,
    required int minutesCompleted,
    required String reason,
    int? targetDurationMinutes,
    int? pausedSeconds,
    double? completionRatio,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.focusSessionAbandoned,
      parameters: {
        AnalyticsEvents.paramHabitId: habitId,
        AnalyticsEvents.paramMinutesCompleted: minutesCompleted,
        AnalyticsEvents.paramReason: reason,
        if (targetDurationMinutes != null)
          AnalyticsEvents.paramTargetDurationMinutes: targetDurationMinutes,
        if (pausedSeconds != null)
          AnalyticsEvents.paramPausedSeconds: pausedSeconds,
        if (completionRatio != null)
          AnalyticsEvents.paramCompletionRatio: completionRatio,
      },
    ),
  );

  // ─── Progress Events ───

  Future<void> logAllHabitsDone({
    required int habitCount,
    required int totalBonusXp,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.allHabitsDone,
      parameters: {
        AnalyticsEvents.paramHabitCount: habitCount,
        AnalyticsEvents.paramTotalBonusXp: totalBonusXp,
      },
    ),
  );

  Future<void> logStreakAchieved({
    required String habitName,
    required int milestone,
    String? habitId,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.streakAchieved,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramStreakDays: milestone,
        if (habitId != null) AnalyticsEvents.paramHabitId: habitId,
      },
    ),
  );

  // ─── Stats & History Events ───

  Future<void> logStatsViewed() => _safeLog(
    () => _analytics.logEvent(name: AnalyticsEvents.statsViewed),
  );

  Future<void> logHistoryViewed({String? habitId}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.historyViewed,
      parameters: {
        if (habitId != null) AnalyticsEvents.paramHabitId: habitId,
      },
    ),
  );

  // ─── Navigation Events ───

  Future<void> logCatRoomViewed({required int catCount}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.catRoomViewed,
      parameters: {AnalyticsEvents.paramCatCount: catCount},
    ),
  );

  Future<void> logCatTapped({required String catId, required String action}) =>
      _safeLog(
        () => _analytics.logEvent(
          name: AnalyticsEvents.catTapped,
          parameters: {
            AnalyticsEvents.paramCatId: catId,
            AnalyticsEvents.paramAction: action,
          },
        ),
      );

  // ─── Notification Events ───

  Future<void> logNotificationOpened({String? notificationType}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.notificationOpened,
      parameters: {
        if (notificationType != null)
          AnalyticsEvents.paramNotificationType: notificationType,
      },
    ),
  );

  // ─── Legacy Events (backward compat) ───

  Future<void> logTimerStarted({required String habitName}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.timerStarted,
      parameters: {AnalyticsEvents.paramHabitName: habitName},
    ),
  );

  Future<void> logTimerCompleted({
    required String habitName,
    required int durationMinutes,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.timerCompleted,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramDurationMinutes: durationMinutes,
      },
    ),
  );

  Future<void> logDailyCheckIn({
    required String habitName,
    required int streakCount,
    required int minutesToday,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.dailyCheckIn,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramStreakCount: streakCount,
        AnalyticsEvents.paramMinutesToday: minutesToday,
      },
    ),
  );

  Future<void> logGoalProgress({
    required String habitName,
    required int percentComplete,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.goalProgress,
      parameters: {
        AnalyticsEvents.paramHabitName: habitName,
        AnalyticsEvents.paramPercentComplete: percentComplete,
      },
    ),
  );

  // ─── Engagement Depth Events ───

  Future<void> logFeatureUsed({required String feature}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.featureUsed,
      parameters: {AnalyticsEvents.paramFeature: feature},
    ),
  );

  Future<void> logAiChatStarted({required String catId}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.aiChatStarted,
      parameters: {AnalyticsEvents.paramCatId: catId},
    ),
  );

  Future<void> logAiDiaryGenerated({required String catId}) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.aiDiaryGenerated,
      parameters: {AnalyticsEvents.paramCatId: catId},
    ),
  );

  // ─── Session Quality Events ───

  Future<void> logSessionQuality({
    required int sessionDuration,
    required double completionRatio,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.sessionQuality,
      parameters: {
        AnalyticsEvents.paramSessionDuration: sessionDuration,
        AnalyticsEvents.paramCompletionRatio: completionRatio,
      },
    ),
  );

  // ─── Retention Signal Events ───

  Future<void> logAppOpened({
    required int daysSinceLast,
    required int consecutiveDays,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.appOpened,
      parameters: {
        AnalyticsEvents.paramDaysSinceLast: daysSinceLast,
        AnalyticsEvents.paramConsecutiveDays: consecutiveDays,
      },
    ),
  );

  // ─── Economy System Events ───

  Future<void> logCoinsEarned({required int amount, required String source}) =>
      _safeLog(
        () => _analytics.logEvent(
          name: AnalyticsEvents.coinsEarned,
          parameters: {
            AnalyticsEvents.paramCoinAmount: amount,
            AnalyticsEvents.paramCoinSource: source,
          },
        ),
      );

  Future<void> logCoinsSpent({
    required int amount,
    required String accessoryId,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.coinsSpent,
      parameters: {
        AnalyticsEvents.paramCoinAmount: amount,
        AnalyticsEvents.paramAccessoryId: accessoryId,
      },
    ),
  );

  Future<void> logAccessoryEquipped({
    required String catId,
    required String accessoryId,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.accessoryEquipped,
      parameters: {
        AnalyticsEvents.paramCatId: catId,
        AnalyticsEvents.paramAccessoryId: accessoryId,
      },
    ),
  );

  Future<void> logAccessoryPurchased({
    required String accessoryId,
    required int price,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.accessoryPurchased,
      parameters: {
        AnalyticsEvents.paramAccessoryId: accessoryId,
        AnalyticsEvents.paramPrice: price,
      },
    ),
  );

  // ─── User Lifecycle Events ───

  Future<void> logOnboardingCompleted() => _safeLog(
    () => _analytics.logEvent(name: AnalyticsEvents.onboardingCompleted),
  );

  Future<void> logFirstSessionCompleted({
    required String habitId,
    required int actualMinutes,
  }) => _safeLog(
    () => _analytics.logEvent(
      name: AnalyticsEvents.firstSessionCompleted,
      parameters: {
        AnalyticsEvents.paramHabitId: habitId,
        AnalyticsEvents.paramActualMinutes: actualMinutes,
      },
    ),
  );

  // ─── User Properties ───

  Future<void> setUserProperties({
    int? totalHabits,
    int? catCount,
    int? maxCatLevel,
    int? longestStreak,
    int? totalFocusMinutes,
    int? totalHoursLogged,
    int? daysActive,
    int? daysSinceSignup,
  }) async {
    if (totalHabits != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propTotalHabits,
          value: totalHabits.toString(),
        ),
      );
    }
    if (catCount != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propCatCount,
          value: catCount.toString(),
        ),
      );
    }
    if (maxCatLevel != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propMaxCatLevel,
          value: maxCatLevel.toString(),
        ),
      );
    }
    if (longestStreak != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propLongestStreak,
          value: longestStreak.toString(),
        ),
      );
    }
    if (totalFocusMinutes != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propTotalFocusMinutes,
          value: totalFocusMinutes.toString(),
        ),
      );
    }
    if (totalHoursLogged != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propTotalHoursLogged,
          value: totalHoursLogged.toString(),
        ),
      );
    }
    if (daysActive != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propDaysActive,
          value: daysActive.toString(),
        ),
      );
    }
    if (daysSinceSignup != null) {
      await _safeLog(
        () => _analytics.setUserProperty(
          name: AnalyticsEvents.propDaysSinceSignup,
          value: daysSinceSignup.toString(),
        ),
      );
    }
  }
}
