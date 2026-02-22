/// Analytics Events — Single Source of Truth for all Firebase Analytics event names and parameters.
/// See docs/firebase/analytics-events.md for the full specification.
///
/// Conversion funnel:
/// app_open → sign_up → cat_adopted → focus_session_completed → cat_level_up → streak_achieved_7
class AnalyticsEvents {
  AnalyticsEvents._();

  // ─── Event Names ───

  // Auth
  static const String signUp = 'sign_up';

  // Habit lifecycle
  static const String habitCreated = 'habit_created';
  static const String habitDeleted = 'habit_deleted';
  static const String habitArchived = 'habit_archived';

  // Cat lifecycle
  static const String catAdopted = 'cat_adopted';
  static const String catLevelUp = 'cat_level_up';
  static const String catStageEvolved = 'cat_stage_evolved';

  // Focus sessions
  static const String focusSessionStarted = 'focus_session_started';
  static const String focusSessionCompleted = 'focus_session_completed';
  static const String focusSessionAbandoned = 'focus_session_abandoned';

  // Progress
  static const String allHabitsDone = 'all_habits_done';
  static const String streakAchieved = 'streak_achieved';

  // Navigation
  static const String catRoomViewed = 'cat_room_viewed';
  static const String catTapped = 'cat_tapped';

  // Notifications
  static const String notificationOpened = 'notification_opened';

  // Error tracking
  static const String appError = 'app_error';

  // Engagement depth
  static const String featureUsed = 'feature_used';
  static const String aiChatStarted = 'ai_chat_started';
  static const String aiDiaryGenerated = 'ai_diary_generated';

  // Session quality
  static const String sessionQuality = 'session_quality';

  // Retention signals
  static const String appOpened = 'app_opened';

  // Economy system
  static const String coinsEarned = 'coins_earned';
  static const String coinsSpent = 'coins_spent';
  static const String accessoryEquipped = 'accessory_equipped';
  static const String accessoryPurchased = 'accessory_purchased';

  // Stats & History
  static const String statsViewed = 'stats_viewed';
  static const String historyViewed = 'history_viewed';

  // Achievements
  static const String achievementUnlocked = 'achievement_unlocked';

  // User lifecycle
  static const String onboardingCompleted = 'onboarding_completed';
  static const String firstSessionCompleted = 'first_session_completed';

  // Legacy (kept for backward compat with existing screens)
  static const String timerStarted = 'timer_started';
  static const String timerCompleted = 'timer_completed';
  static const String dailyCheckIn = 'daily_check_in';
  static const String goalProgress = 'goal_progress';

  // ─── Parameter Keys ───

  static const String paramMethod = 'method';
  static const String paramHabitName = 'habit_name';
  static const String paramHabitId = 'habit_id';
  static const String paramGoalMinutes = 'goal_minutes';
  static const String paramTargetHours = 'target_hours';
  static const String paramTimerMode = 'timer_mode';
  static const String paramTargetMinutes = 'target_minutes';
  static const String paramActualMinutes = 'actual_minutes';
  static const String paramXpEarned = 'xp_earned';
  static const String paramStreakDays = 'streak_days';
  static const String paramMinutesCompleted = 'minutes_completed';
  static const String paramReason = 'reason';
  static const String paramHabitCount = 'habit_count';
  static const String paramTotalBonusXp = 'total_bonus_xp';
  static const String paramCatId = 'cat_id';
  static const String paramBreed = 'breed';
  static const String paramPattern = 'pattern';
  static const String paramPersonality = 'personality';
  static const String paramRarity = 'rarity';
  static const String paramNewLevel = 'new_level';
  static const String paramNewStage = 'new_stage';
  static const String paramTotalXp = 'total_xp';
  static const String paramCatCount = 'cat_count';
  static const String paramAction = 'action';
  static const String paramNotificationType = 'notification_type';
  static const String paramDurationMinutes = 'duration_minutes';
  static const String paramStreakCount = 'streak_count';
  static const String paramMinutesToday = 'minutes_today';
  static const String paramMilestone = 'milestone';
  static const String paramPercentComplete = 'percent_complete';

  // Error tracking params
  static const String paramErrorType = 'error_type';
  static const String paramErrorSource = 'error_source';
  static const String paramErrorOperation = 'error_operation';
  static const String paramScreen = 'screen';
  static const String paramService = 'service';

  // Engagement depth params
  static const String paramFeature = 'feature';

  // Enhanced session params
  static const String paramTargetDurationMinutes = 'target_duration_minutes';
  static const String paramPausedSeconds = 'paused_seconds';
  static const String paramSessionStatus = 'session_status';

  // Session quality params
  static const String paramSessionDuration = 'session_duration';
  static const String paramCompletionRatio = 'completion_ratio';

  // Retention signal params
  static const String paramDaysSinceLast = 'days_since_last';
  static const String paramConsecutiveDays = 'consecutive_days';

  // Achievement params
  static const String paramAchievementId = 'achievement_id';

  // Economy params
  static const String paramCoinAmount = 'coin_amount';
  static const String paramCoinSource = 'coin_source';
  static const String paramAccessoryId = 'accessory_id';
  static const String paramPrice = 'price';

  // ─── User Property Keys ───

  static const String propTotalHabits = 'total_habits';
  static const String propCatCount = 'cat_count';
  static const String propMaxCatLevel = 'max_cat_level';
  static const String propLongestStreak = 'longest_streak';
  static const String propTotalFocusMinutes = 'total_focus_minutes';
  static const String propTotalHoursLogged = 'total_hours_logged';
  static const String propDaysActive = 'days_active';
  static const String propDaysSinceSignup = 'days_since_signup';

  // ─── Milestones ───

  static const List<int> streakMilestones = [3, 7, 14, 30, 60, 100];
  static const List<int> progressMilestones = [25, 50, 75, 100];
}
