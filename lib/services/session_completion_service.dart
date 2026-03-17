import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/session_checksum.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/local_cat_repository.dart';
import 'package:hachimi_app/services/local_habit_repository.dart';
import 'package:hachimi_app/services/local_session_repository.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:uuid/uuid.dart';

/// 会话奖励计算结果。
class SessionRewards {
  final int coins;
  final XpResult xp;
  final StageUpResult? stageUp;

  const SessionRewards({required this.coins, required this.xp, this.stageUp});
}

/// 会话完成结果。
class SessionResult {
  final FocusSession? session;
  final SessionRewards? rewards;
  final int minutes;
  final bool isDiscarded;

  const SessionResult({
    this.session,
    this.rewards,
    this.minutes = 0,
    this.isDiscarded = false,
  });

  static const discarded = SessionResult(isDiscarded: true);
}

/// SessionCompletionService — 编排会话完成的全部业务逻辑。
///
/// 职责：奖励计算 → 会话记录构建 → 持久化 → 分析上报。
/// 不持有 Ref（Riverpod 最佳实践），通过构造函数注入所有依赖。
class SessionCompletionService {
  final LocalSessionRepository _sessions;
  final LocalHabitRepository _habits;
  final LocalCatRepository _cats;
  final CoinService _coins;
  final AnalyticsService _analytics;
  final XpService _xp;

  SessionCompletionService({
    required LocalSessionRepository sessions,
    required LocalHabitRepository habits,
    required LocalCatRepository cats,
    required CoinService coins,
    required AnalyticsService analytics,
    required XpService xp,
  }) : _sessions = sessions,
       _habits = habits,
       _cats = cats,
       _coins = coins,
       _analytics = analytics,
       _xp = xp;

  /// 完成会话：计算奖励 → 持久化 → 上报分析。
  ///
  /// 放弃且不足 5 分钟的会话直接丢弃（返回 [SessionResult.discarded]）。
  Future<SessionResult> completeSession({
    required String uid,
    required String habitId,
    required FocusTimerState timerState,
    required Habit habit,
    required String clientVersion,
    required Map<String, int> todayMinutesPerHabit,
    required List<Habit> activeHabits,
    dynamic cat,
  }) async {
    final minutes = timerState.focusedMinutes;
    final isAbandoned = timerState.status == TimerStatus.abandoned;

    // 放弃且不足 5 分钟 — 不记录
    if (isAbandoned && minutes < 5) return SessionResult.discarded;

    final rewards = _calculateRewards(
      minutes: minutes,
      habit: habit,
      cat: cat,
      todayMinutesPerHabit: todayMinutesPerHabit,
      activeHabits: activeHabits,
    );

    final completionRatio = _computeCompletionRatio(timerState, minutes);
    final session = _buildSession(
      timerState: timerState,
      habit: habit,
      habitId: habitId,
      minutes: minutes,
      rewards: rewards,
      completionRatio: completionRatio,
      clientVersion: clientVersion,
    );

    ErrorHandler.breadcrumb(
      'focus_completed: ${habit.name}, ${minutes}min, ${rewards.coins}coins',
    );

    await _persistSession(
      uid: uid,
      session: session,
      timerState: timerState,
      habit: habit,
      habitId: habitId,
      minutes: minutes,
      rewards: rewards,
    );

    _logAnalytics(
      timerState: timerState,
      habitId: habitId,
      minutes: minutes,
      rewards: rewards,
      completionRatio: completionRatio,
    );

    return SessionResult(session: session, rewards: rewards, minutes: minutes);
  }

  // ─── 内部方法 ───

  SessionRewards _calculateRewards({
    required int minutes,
    required Habit habit,
    required dynamic cat,
    required Map<String, int> todayMinutesPerHabit,
    required List<Habit> activeHabits,
  }) {
    final coins = minutes * focusRewardCoinsPerMinute;

    final allDone =
        activeHabits.isNotEmpty &&
        activeHabits.every(
          (h) => (todayMinutesPerHabit[h.id] ?? 0) >= h.goalMinutes,
        );
    final xp = _xp.calculateXp(minutes: minutes, allHabitsDone: allDone);

    final stageUp = cat != null
        ? _xp.checkStageUp(
            oldTotalMinutes: cat.totalMinutes,
            newTotalMinutes: cat.totalMinutes + minutes,
          )
        : null;

    return SessionRewards(coins: coins, xp: xp, stageUp: stageUp);
  }

  double _computeCompletionRatio(FocusTimerState timerState, int minutes) {
    final targetMinutes = timerState.mode == TimerMode.countdown
        ? timerState.totalSeconds ~/ 60
        : 0;
    return targetMinutes > 0 ? (minutes / targetMinutes).clamp(0.0, 1.0) : 1.0;
  }

  FocusSession _buildSession({
    required FocusTimerState timerState,
    required Habit habit,
    required String habitId,
    required int minutes,
    required SessionRewards rewards,
    required double completionRatio,
    required String clientVersion,
  }) {
    final targetMinutes = timerState.mode == TimerMode.countdown
        ? timerState.totalSeconds ~/ 60
        : 0;
    final modeStr = timerState.mode == TimerMode.countdown
        ? 'countdown'
        : 'stopwatch';
    final startedAt = timerState.startedAt ?? DateTime.now();

    return FocusSession(
      id: const Uuid().v4(),
      habitId: habitId,
      catId: habit.catId ?? '',
      startedAt: startedAt,
      endedAt: DateTime.now(),
      durationMinutes: minutes,
      targetDurationMinutes: targetMinutes,
      pausedSeconds: timerState.totalPausedSeconds,
      status: timerState.status == TimerStatus.completed
          ? 'completed'
          : 'abandoned',
      completionRatio: completionRatio,
      xpEarned: rewards.xp.totalXp,
      coinsEarned: rewards.coins,
      mode: modeStr,
      checksum: SessionChecksum.compute(
        habitId: habitId,
        durationMinutes: minutes,
        coinsEarned: rewards.coins,
        xpEarned: rewards.xp.totalXp,
        startedAt: startedAt,
      ),
      clientVersion: clientVersion,
    );
  }

  Future<void> _persistSession({
    required String uid,
    required FocusSession session,
    required FocusTimerState timerState,
    required Habit habit,
    required String habitId,
    required int minutes,
    required SessionRewards rewards,
  }) async {
    try {
      await _sessions.logSession(uid, session);

      if (timerState.status == TimerStatus.completed) {
        final today = AppDateUtils.todayString();
        await _habits.updateProgress(
          uid,
          habitId,
          addMinutes: minutes,
          checkInDate: today,
        );
        if (habit.catId != null) {
          await _cats.updateProgress(
            uid,
            habit.catId!,
            addMinutes: minutes,
            sessionAt: DateTime.now(),
          );
        }
      }

      if (rewards.coins > 0) {
        await _coins.earnCoins(uid: uid, amount: rewards.coins);
      }
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'SessionCompletion',
        operation: 'persistSession',
      );
    }
  }

  void _logAnalytics({
    required FocusTimerState timerState,
    required String habitId,
    required int minutes,
    required SessionRewards rewards,
    required double completionRatio,
  }) {
    try {
      final targetMinutes = timerState.mode == TimerMode.countdown
          ? timerState.totalSeconds ~/ 60
          : 0;

      if (timerState.status == TimerStatus.completed) {
        _analytics.logFocusSessionCompleted(
          habitId: habitId,
          actualMinutes: minutes,
          xpEarned: rewards.xp.totalXp,
          targetDurationMinutes: targetMinutes,
          pausedSeconds: timerState.totalPausedSeconds,
          completionRatio: completionRatio,
        );
      } else {
        _analytics.logFocusSessionAbandoned(
          habitId: habitId,
          minutesCompleted: minutes,
          reason: 'user_abandoned',
          targetDurationMinutes: targetMinutes,
          pausedSeconds: timerState.totalPausedSeconds,
          completionRatio: completionRatio,
        );
      }

      if (rewards.coins > 0) {
        _analytics.logCoinsEarned(
          amount: rewards.coins,
          source: 'focus_session',
        );
      }
    } catch (e) {
      debugPrint('[SessionCompletion] analytics error: $e');
    }
  }
}
