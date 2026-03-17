import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    show FlutterForegroundTask;
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/providers/timer_persistence.dart';
import 'package:hachimi_app/services/atomic_island_service.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';

/// Timer status for focus sessions.
enum TimerStatus { idle, running, paused, completed, abandoned }

/// Timer mode — countdown or stopwatch.
enum TimerMode { countdown, stopwatch }

/// Focus timer state.
class FocusTimerState {
  final String habitId;
  final String catId;
  final String catName;
  final String habitName;
  final int totalSeconds; // Target duration (countdown mode)
  final int elapsedSeconds; // Actual focused time
  final int totalPausedSeconds; // Cumulative paused seconds for wall-clock calc
  final TimerStatus status;
  final TimerMode mode;
  final DateTime? startedAt;
  final DateTime? pausedAt;

  // L10N labels for notification text (set via configure(), empty = English fallback)
  final String labelRemaining;
  final String labelElapsed;
  final String labelFocusing;
  final String labelDefaultCat;
  final String labelInProgress;

  const FocusTimerState({
    this.habitId = '',
    this.catId = '',
    this.catName = '',
    this.habitName = '',
    this.totalSeconds = 1500, // 25 min default
    this.elapsedSeconds = 0,
    this.totalPausedSeconds = 0,
    this.status = TimerStatus.idle,
    this.mode = TimerMode.countdown,
    this.startedAt,
    this.pausedAt,
    this.labelRemaining = '',
    this.labelElapsed = '',
    this.labelFocusing = '',
    this.labelDefaultCat = '',
    this.labelInProgress = '',
  });

  /// Remaining seconds for countdown mode.
  int get remainingSeconds =>
      (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);

  /// Progress ratio (0.0 - 1.0).
  double get progress {
    if (totalSeconds <= 0) return 0;
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  /// Display time string (MM:SS or HH:MM:SS).
  String get displayTime {
    final seconds =
        mode == TimerMode.countdown ? remainingSeconds : elapsedSeconds;
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Focused minutes (rounded up, minimum 1 if any time passed).
  int get focusedMinutes {
    if (elapsedSeconds <= 0) return 0;
    return (elapsedSeconds / 60).ceil();
  }

  FocusTimerState copyWith({
    String? habitId,
    String? catId,
    String? catName,
    String? habitName,
    int? totalSeconds,
    int? elapsedSeconds,
    int? totalPausedSeconds,
    TimerStatus? status,
    TimerMode? mode,
    DateTime? startedAt,
    DateTime? pausedAt,
    bool clearPausedAt = false,
    String? labelRemaining,
    String? labelElapsed,
    String? labelFocusing,
    String? labelDefaultCat,
    String? labelInProgress,
  }) {
    return FocusTimerState(
      habitId: habitId ?? this.habitId,
      catId: catId ?? this.catId,
      catName: catName ?? this.catName,
      habitName: habitName ?? this.habitName,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      totalPausedSeconds: totalPausedSeconds ?? this.totalPausedSeconds,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      startedAt: startedAt ?? this.startedAt,
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
      labelRemaining: labelRemaining ?? this.labelRemaining,
      labelElapsed: labelElapsed ?? this.labelElapsed,
      labelFocusing: labelFocusing ?? this.labelFocusing,
      labelDefaultCat: labelDefaultCat ?? this.labelDefaultCat,
      labelInProgress: labelInProgress ?? this.labelInProgress,
    );
  }
}

/// Focus timer notifier — 纯状态机 + 通知更新。
///
/// 持久化逻辑委托给 [TimerPersistence]，壁钟计算也由其提供。
class FocusTimerNotifier extends Notifier<FocusTimerState> {
  Timer? _ticker;
  int _ticksSinceSave = 0;

  static const _autoCompleteThresholdMinutes = 30;
  static const _saveIntervalTicks = 5;

  TimerPersistence get _persistence => ref.read(timerPersistenceProvider);

  @override
  FocusTimerState build() {
    ref.keepAlive();
    ref.onDispose(() {
      _ticker?.cancel();
    });
    return const FocusTimerState();
  }

  // ─── 向后兼容的静态方法（委托到 TimerPersistence） ───

  /// Check if there's an interrupted session saved in SharedPreferences.
  static Future<bool> hasInterruptedSession() =>
      TimerPersistence().hasInterruptedSession();

  /// Get saved session info for the recovery dialog.
  static Future<Map<String, dynamic>?> getSavedSessionInfo() =>
      TimerPersistence().getSavedSessionInfo();

  /// Clear saved session data (called when user discards recovery).
  static Future<void> clearSavedState() =>
      TimerPersistence().clearSavedState();

  // ─── 配置 & 恢复 ───

  /// Initialize the timer with habit/cat info and duration.
  void configure({
    required String habitId,
    required String catId,
    required String catName,
    required String habitName,
    required int durationSeconds,
    required TimerMode mode,
    String labelRemaining = '',
    String labelElapsed = '',
    String labelFocusing = '',
    String labelDefaultCat = '',
    String labelInProgress = '',
  }) {
    _ticker?.cancel();
    state = FocusTimerState(
      habitId: habitId,
      catId: catId,
      catName: catName,
      habitName: habitName,
      totalSeconds: durationSeconds,
      elapsedSeconds: 0,
      status: TimerStatus.idle,
      mode: mode,
      labelRemaining: labelRemaining,
      labelElapsed: labelElapsed,
      labelFocusing: labelFocusing,
      labelDefaultCat: labelDefaultCat,
      labelInProgress: labelInProgress,
    );
  }

  /// Restore a previously interrupted session.
  Future<void> restoreSession() async {
    final restored = await _persistence.restoreSession();
    if (restored == null) return;

    state = restored;

    if (restored.status == TimerStatus.completed) {
      await _persistence.clearSavedState();
    }
  }

  // ─── 状态机：开始/暂停/恢复/完成/放弃/重置 ───

  /// Start the timer.
  void start() {
    if (state.status == TimerStatus.running) return;
    _ticker?.cancel();

    state = state.copyWith(
      status: TimerStatus.running,
      startedAt: state.startedAt ?? _persistence.now(),
    );

    _ticksSinceSave = 0;
    _persistence.saveState(state);
    _scheduleBackupAlarm();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    final startedAt = state.startedAt;
    if (startedAt == null) return;

    final newElapsed = _persistence.computeWallClockElapsed(
      startedAt,
      state.totalPausedSeconds,
    );

    // 倒计时归零
    if (state.mode == TimerMode.countdown &&
        newElapsed >= state.totalSeconds) {
      _handleCountdownComplete();
      return;
    }

    state = state.copyWith(elapsedSeconds: newElapsed);
    _updateNotification();

    _ticksSinceSave++;
    if (_ticksSinceSave >= _saveIntervalTicks) {
      _ticksSinceSave = 0;
      _persistence.saveState(state);
    }
  }

  /// 倒计时归零：停止计时、清理状态。
  /// 通知由 TimerScreen._navigateToResult() 统一发出（有 L10N 上下文）。
  void _handleCountdownComplete() {
    _ticker?.cancel();
    state = state.copyWith(
      elapsedSeconds: state.totalSeconds,
      status: TimerStatus.completed,
    );
    _persistence.clearSavedState();
    AtomicIslandService.cancel();
    FocusTimerService.stop();
    _cancelBackupAlarm();
  }

  /// Pause the timer.
  void pause() {
    _ticker?.cancel();
    _cancelBackupAlarm();
    state = state.copyWith(
      status: TimerStatus.paused,
      pausedAt: _persistence.now(),
    );
    _persistence.saveState(state);
  }

  /// Resume from pause — accumulate pause duration into totalPausedSeconds.
  void resume() {
    if (state.pausedAt != null) {
      final pauseDuration =
          _persistence.now().difference(state.pausedAt!).inSeconds;
      state = state.copyWith(
        totalPausedSeconds: state.totalPausedSeconds + pauseDuration,
        status: TimerStatus.running,
        clearPausedAt: true,
      );
    } else {
      state =
          state.copyWith(status: TimerStatus.running, clearPausedAt: true);
    }
    _ticker?.cancel();
    _ticksSinceSave = 0;
    _persistence.saveState(state);
    _scheduleBackupAlarm();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  /// Complete the session (stopwatch mode: user presses done).
  void complete() => _terminateSession(TimerStatus.completed);

  /// Abandon the session.
  void abandon() => _terminateSession(TimerStatus.abandoned);

  /// 统一的会话终止逻辑：停止计时、清理状态、记录分析。
  void _terminateSession(TimerStatus terminalStatus) {
    _ticker?.cancel();
    state = state.copyWith(status: terminalStatus);
    _persistence.clearSavedState();
    AtomicIslandService.cancel();
    FocusTimerService.stop();
    _cancelBackupAlarm();

    // Analytics: non-critical — failure must not break core flow
    try {
      final defaultRatio =
          terminalStatus == TimerStatus.completed ? 1.0 : 0.0;
      final completionRatio = state.totalSeconds > 0
          ? (state.elapsedSeconds / state.totalSeconds).clamp(0.0, 1.0)
          : defaultRatio;
      ref
          .read(analyticsServiceProvider)
          .logSessionQuality(
            sessionDuration: state.elapsedSeconds,
            completionRatio: completionRatio,
          );
    } catch (e) {
      debugPrint('[FocusTimer] analytics error: $e');
    }
  }

  /// Reset to idle state.
  void reset() {
    _ticker?.cancel();
    _persistence.clearSavedState();
    AtomicIslandService.cancel();
    _cancelBackupAlarm();
    state = const FocusTimerState();
  }

  // ─── App 生命周期 ───

  /// Handle app going to background.
  ///
  /// **State contract:** Sets [pausedAt] as a wall-clock anchor while keeping
  /// [status] as [TimerStatus.running]. This differs from user-initiated
  /// [pause()] which sets status to [TimerStatus.paused].
  void onAppBackgrounded() {
    if (state.status == TimerStatus.running) {
      state = state.copyWith(pausedAt: _persistence.now());
      _persistence.saveState(state);
      final focusingLabel = state.labelFocusing.isNotEmpty
          ? state.labelFocusing
          : 'focusing...';
      FocusTimerService.updateNotification(
        title: _notificationTitle,
        text: '${_resolveCatDisplayName()} $focusingLabel',
      );
    }
  }

  /// Handle app coming back to foreground.
  /// 先恢复 ticker 再异步检查前台服务，避免阻塞 UI。
  Future<void> onAppResumed() async {
    if (state.status != TimerStatus.running || state.pausedAt == null) return;
    if (state.startedAt == null) return;

    final newElapsed = _persistence.computeWallClockElapsed(
      state.startedAt!,
      state.totalPausedSeconds,
    );

    if (_shouldAutoComplete(newElapsed)) {
      _handleAutoComplete(newElapsed);
      return;
    }

    // 立即恢复 ticker（不等前台服务），确保 UI 无延迟
    state = state.copyWith(elapsedSeconds: newElapsed, clearPausedAt: true);
    _ticker?.cancel();
    _ticksSinceSave = 0;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    _updateNotification();

    // 前台服务恢复作为后台任务，不阻塞 UI
    _restartForegroundServiceIfNeeded();
  }

  // ─── 通知更新 ───

  /// 解析猫咪显示名称，按优先级回退：catName → labelDefaultCat → fallback。
  String _resolveCatDisplayName([String? fallback]) {
    if (state.catName.isNotEmpty) return state.catName;
    if (state.labelDefaultCat.isNotEmpty) return state.labelDefaultCat;
    return fallback ?? 'Your cat';
  }

  /// 通知标题统一入口 — habitName 为空时回退到英文默认值。
  String get _notificationTitle =>
      state.habitName.isNotEmpty ? state.habitName : 'Focus';

  /// 解析通知显示标签，使用 configure() 传入的 L10N 标签，英文兜底。
  ({String catName, String focusingLabel, String label})
      _resolveDisplayLabels() {
    final label = state.mode == TimerMode.countdown
        ? (state.labelRemaining.isNotEmpty
            ? state.labelRemaining
            : 'remaining')
        : (state.labelElapsed.isNotEmpty ? state.labelElapsed : 'elapsed');
    final focusingLabel = state.labelFocusing.isNotEmpty
        ? state.labelFocusing
        : 'focusing...';
    return (
      catName: _resolveCatDisplayName(),
      focusingLabel: focusingLabel,
      label: label,
    );
  }

  /// Update the foreground service notification with current timer state.
  void _updateNotification() {
    final labels = _resolveDisplayLabels();

    FocusTimerService.updateNotification(
      title: _notificationTitle,
      text:
          '${state.displayTime} ${labels.label} \u{00B7} ${labels.catName} ${labels.focusingLabel}',
    );

    _updateAtomicIsland(labels);
  }

  /// 更新 vivo 原子岛 / Android 16 ProgressStyle 富通知。
  void _updateAtomicIsland(
    ({String catName, String focusingLabel, String label}) labels,
  ) {
    if (state.startedAt == null) return;
    final isCountdown = state.mode == TimerMode.countdown;
    AtomicIslandService.updateNotification(
      title: _notificationTitle,
      text: '${labels.catName} ${labels.focusingLabel}',
      isCountdown: isCountdown,
      isPaused: state.status == TimerStatus.paused,
      endTimeMs: isCountdown
          ? state.startedAt!
                .add(
                  Duration(
                    seconds: state.totalSeconds + state.totalPausedSeconds,
                  ),
                )
                .millisecondsSinceEpoch
          : null,
      startTimeMs: state.startedAt!.millisecondsSinceEpoch,
    );
  }

  // ─── 备份闹钟 ───

  void _scheduleBackupAlarm() {
    try {
      if (state.mode != TimerMode.countdown) return;
      if (state.startedAt == null) return;

      final fireAt = state.startedAt!.add(
        Duration(seconds: state.totalSeconds + state.totalPausedSeconds),
      );
      if (fireAt.isBefore(_persistence.now())) return;

      ref
          .read(notificationServiceProvider)
          .scheduleTimerBackup(
            fireAt: fireAt,
            title: _notificationTitle,
            body:
                '${_resolveCatDisplayName()} \u{00B7} ${state.focusedMinutes} min',
          );
    } catch (e) {
      debugPrint('[FocusTimer] backup alarm schedule error: $e');
    }
  }

  void _cancelBackupAlarm() {
    try {
      ref.read(notificationServiceProvider).cancelTimerBackup();
    } catch (e) {
      debugPrint('[FocusTimer] backup alarm cancel error: $e');
    }
  }

  // ─── 内部辅助 ───

  bool _shouldAutoComplete(int newElapsed) {
    final awayMinutes =
        _persistence.now().difference(state.pausedAt!).inMinutes;
    final countdownDone = state.mode == TimerMode.countdown &&
        newElapsed >= state.totalSeconds;
    return awayMinutes > _autoCompleteThresholdMinutes || countdownDone;
  }

  void _handleAutoComplete(int newElapsed) {
    _ticker?.cancel();
    final cappedElapsed = state.mode == TimerMode.countdown
        ? state.totalSeconds
        : newElapsed;
    state = state.copyWith(
      elapsedSeconds: cappedElapsed,
      status: TimerStatus.completed,
      clearPausedAt: true,
    );
    _persistence.clearSavedState();
  }

  Future<void> _restartForegroundServiceIfNeeded() async {
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) {
      await FocusTimerService.start(
        habitName: state.habitName,
        catEmoji: '\u{1F431}',
        totalSeconds: state.totalSeconds,
        isCountdown: state.mode == TimerMode.countdown,
      );
    }
  }
}

/// Focus timer provider — global singleton (keepAlive).
/// Timer is a cross-screen concern that must survive navigation.
final focusTimerProvider =
    NotifierProvider<FocusTimerNotifier, FocusTimerState>(
      FocusTimerNotifier.new,
    );
