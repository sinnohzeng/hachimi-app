/// Analytics Events — Single Source of Truth for all Firebase Analytics event names and parameters.
/// See docs/firebase/analytics-events.md for the full specification.
///
/// Conversion funnel:
/// app_open → sign_up → first_habit_created → first_timer_started → daily_check_in → streak_7_days
class AnalyticsEvents {
  AnalyticsEvents._();

  // Event names
  static const String signUp = 'sign_up';
  static const String habitCreated = 'habit_created';
  static const String habitDeleted = 'habit_deleted';
  static const String timerStarted = 'timer_started';
  static const String timerCompleted = 'timer_completed';
  static const String dailyCheckIn = 'daily_check_in';
  static const String streakAchieved = 'streak_achieved';
  static const String goalProgress = 'goal_progress';
  static const String notificationOpened = 'notification_opened';

  // Parameter keys
  static const String paramMethod = 'method';
  static const String paramHabitName = 'habit_name';
  static const String paramTargetHours = 'target_hours';
  static const String paramDurationMinutes = 'duration_minutes';
  static const String paramStreakCount = 'streak_count';
  static const String paramMinutesToday = 'minutes_today';
  static const String paramMilestone = 'milestone';
  static const String paramPercentComplete = 'percent_complete';

  // User property keys
  static const String propTotalHabits = 'total_habits';
  static const String propLongestStreak = 'longest_streak';
  static const String propTotalHoursLogged = 'total_hours_logged';
  static const String propDaysSinceSignup = 'days_since_signup';

  // Streak milestones
  static const List<int> streakMilestones = [7, 14, 30, 60, 100];

  // Progress milestones (percent)
  static const List<int> progressMilestones = [25, 50, 75, 100];
}
