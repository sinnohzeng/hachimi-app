import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    show FlutterForegroundTask;
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/services/atomic_island_service.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
// NotificationService accessed via notificationServiceProvider (from service_providers)

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
    if (mode == TimerMode.countdown) {
      return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
    }
    // Stopwatch: use elapsed relative to target as visual indicator
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  /// Display time string (MM:SS or HH:MM:SS).
  String get displayTime {
    final seconds = mode == TimerMode.countdown
        ? remainingSeconds
        : elapsedSeconds;
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

/// Focus timer notifier — manages the timer lifecycle, notification updates,
/// and SharedPreferences persistence for crash recovery.
class FocusTimerNotifier extends Notifier<FocusTimerState> {
  Timer? _ticker;
  int _ticksSinceSave = 0;

  // 常量定义
  static const _defaultDurationSeconds = 1500; // 25 分钟
  static const _autoCompleteThresholdMinutes = 30;
  static const _saveIntervalTicks = 5;
  static const _habitNameMaxLength = 20;

  // SharedPreferences key prefix
  static const _prefix = 'focus_timer_';
  static const _keyHabitId = '${_prefix}habitId';
  static const _keyCatId = '${_prefix}catId';
  static const _keyCatName = '${_prefix}catName';
  static const _keyHabitName = '${_prefix}habitName';
  static const _keyTotalSeconds = '${_prefix}totalSeconds';
  static const _keyElapsedSeconds = '${_prefix}elapsedSeconds';
  static const _keyMode = '${_prefix}mode';
  static const _keyStartedAt = '${_prefix}startedAt';
  static const _keyTotalPausedSeconds = '${_prefix}totalPausedSeconds';
  static const _keyPausedAt = '${_prefix}pausedAt';

  @override
  FocusTimerState build() {
    ref.keepAlive();
    ref.onDispose(() {
      _ticker?.cancel();
    });
    return const FocusTimerState();
  }

  /// Check if there's an interrupted session saved in SharedPreferences.
  static Future<bool> hasInterruptedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyStartedAt);
  }

  /// Get saved session info for the recovery dialog.
  static Future<Map<String, dynamic>?> getSavedSessionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final startedAtStr = prefs.getString(_keyStartedAt);
    if (startedAtStr == null) return null;

    final startedAt = DateTime.tryParse(startedAtStr);
    if (startedAt == null) return null;

    final totalPausedSeconds =
        (prefs.getInt(_keyTotalPausedSeconds) ?? 0) +
        _computePendingPauseDelta(prefs.getString(_keyPausedAt));
    final effectiveElapsed = _computeWallClockElapsed(
      startedAt,
      totalPausedSeconds,
    );

    return {
      'habitId': prefs.getString(_keyHabitId) ?? '',
      'habitName': prefs.getString(_keyHabitName) ?? 'Focus',
      'wallClockElapsed': effectiveElapsed,
      'totalSeconds': prefs.getInt(_keyTotalSeconds) ?? 0,
      'mode': TimerMode.values[prefs.getInt(_keyMode) ?? 0],
    };
  }

  /// Clear saved session data (called when user discards recovery).
  static Future<void> clearSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHabitId);
    await prefs.remove(_keyCatId);
    await prefs.remove(_keyCatName);
    await prefs.remove(_keyHabitName);
    await prefs.remove(_keyTotalSeconds);
    await prefs.remove(_keyElapsedSeconds);
    await prefs.remove(_keyMode);
    await prefs.remove(_keyStartedAt);
    await prefs.remove(_keyTotalPausedSeconds);
    await prefs.remove(_keyPausedAt);
  }

  /// Initialize the timer with habit/cat info and duration.
  /// L10N label parameters are optional; when empty, [_updateNotification]
  /// falls back to English defaults.
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
  /// Sets status to paused so user can manually resume.
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final startedAtStr = prefs.getString(_keyStartedAt);
    if (startedAtStr == null) return;

    final startedAt = DateTime.tryParse(startedAtStr);
    if (startedAt == null) return;

    final habitId = prefs.getString(_keyHabitId) ?? '';
    final catId = prefs.getString(_keyCatId) ?? '';
    final catName = prefs.getString(_keyCatName) ?? '';
    final habitName = prefs.getString(_keyHabitName) ?? '';
    final totalSeconds =
        prefs.getInt(_keyTotalSeconds) ?? _defaultDurationSeconds;
    final modeIndex = prefs.getInt(_keyMode) ?? 0;
    final mode = TimerMode.values[modeIndex];
    final restored = _computeRestoredElapsed(prefs, startedAt);

    // Countdown mode: check if would have completed
    final terminalStatus =
        (mode == TimerMode.countdown && restored.elapsed >= totalSeconds)
        ? TimerStatus.completed
        : TimerStatus.paused;

    state = FocusTimerState(
      habitId: habitId,
      catId: catId,
      catName: catName,
      habitName: habitName,
      totalSeconds: totalSeconds,
      elapsedSeconds: terminalStatus == TimerStatus.completed
          ? totalSeconds
          : restored.elapsed,
      totalPausedSeconds: restored.pausedSeconds,
      status: terminalStatus,
      mode: mode,
      startedAt: startedAt,
      pausedAt: terminalStatus == TimerStatus.paused ? DateTime.now() : null,
    );

    if (terminalStatus == TimerStatus.completed) {
      await FocusTimerNotifier.clearSavedState();
    }
  }

  /// 根据壁钟锚点计算有效专注秒数 = (now - startedAt) - totalPausedSeconds。
  static int _computeWallClockElapsed(
    DateTime startedAt,
    int totalPausedSeconds,
  ) {
    final wallTotal = DateTime.now().difference(startedAt).inSeconds;
    return (wallTotal - totalPausedSeconds).clamp(0, wallTotal);
  }

  /// 解析猫咪显示名称，按优先级回退：catName → labelDefaultCat → fallback。
  String _resolveCatDisplayName([String? fallback]) {
    if (state.catName.isNotEmpty) return state.catName;
    if (state.labelDefaultCat.isNotEmpty) return state.labelDefaultCat;
    return fallback ?? 'Your cat';
  }

  /// 从 SharedPreferences 解析未结算的暂停时长（app 被杀时正处于暂停/后台）。
  static int _computePendingPauseDelta(String? pausedAtStr) {
    if (pausedAtStr == null) return 0;
    final pausedAt = DateTime.tryParse(pausedAtStr);
    return pausedAt != null ? DateTime.now().difference(pausedAt).inSeconds : 0;
  }

  /// 计算恢复后的有效专注时间（扣除暂停时间）。
  ({int elapsed, int pausedSeconds}) _computeRestoredElapsed(
    SharedPreferences prefs,
    DateTime startedAt,
  ) {
    final totalPausedSeconds =
        (prefs.getInt(_keyTotalPausedSeconds) ?? 0) +
        _computePendingPauseDelta(prefs.getString(_keyPausedAt));
    final elapsed = _computeWallClockElapsed(startedAt, totalPausedSeconds);
    return (elapsed: elapsed, pausedSeconds: totalPausedSeconds);
  }

  /// Start the timer.
  void start() {
    if (state.status == TimerStatus.running) return;
    _ticker?.cancel();

    state = state.copyWith(
      status: TimerStatus.running,
      startedAt: state.startedAt ?? DateTime.now(),
    );

    _ticksSinceSave = 0;
    _saveState(); // Save immediately on start
    _scheduleBackupAlarm();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    final startedAt = state.startedAt;
    if (startedAt == null) return;

    final newElapsed = _computeWallClockElapsed(
      startedAt,
      state.totalPausedSeconds,
    );

    // Countdown: check if time is up
    if (state.mode == TimerMode.countdown && newElapsed >= state.totalSeconds) {
      _handleCountdownComplete();
      return;
    }

    state = state.copyWith(elapsedSeconds: newElapsed);
    _updateNotification();

    _ticksSinceSave++;
    if (_ticksSinceSave >= _saveIntervalTicks) {
      _ticksSinceSave = 0;
      _saveState();
    }
  }

  /// 倒计时归零：停止计时、清理状态、发送完成通知。
  void _handleCountdownComplete() {
    _ticker?.cancel();
    state = state.copyWith(
      elapsedSeconds: state.totalSeconds,
      status: TimerStatus.completed,
    );
    FocusTimerNotifier.clearSavedState();
    AtomicIslandService.cancel();
    FocusTimerService.stop();
    _cancelBackupAlarm();

    final labels = _resolveDisplayLabels();
    ref
        .read(notificationServiceProvider)
        .showFocusComplete(
          title: labels.catName,
          body: '${state.habitName} \u{00B7} ${state.focusedMinutes} min',
        );
  }

  /// 解析通知显示标签，使用 configure() 传入的 L10N 标签，英文兜底。
  ({String catName, String focusingLabel, String label})
  _resolveDisplayLabels() {
    final label = state.mode == TimerMode.countdown
        ? (state.labelRemaining.isNotEmpty ? state.labelRemaining : 'remaining')
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

    // 基础通知（fallback）— 时间优先显示，habitName 截断防止遮挡
    final truncatedHabit = state.habitName.length > _habitNameMaxLength
        ? '${state.habitName.substring(0, _habitNameMaxLength)}...'
        : state.habitName;
    FocusTimerService.updateNotification(
      title: '${labels.catName} ${labels.focusingLabel}',
      text: '${state.displayTime} ${labels.label} \u{00B7} $truncatedHabit',
    );

    // 富通知（触发 vivo 原子岛 + Android 16 ProgressStyle）
    _updateAtomicIsland(labels.catName);
  }

  /// 更新 vivo 原子岛 / Android 16 ProgressStyle 富通知。
  void _updateAtomicIsland(String catDisplayName) {
    if (state.startedAt == null) return;
    final isCountdown = state.mode == TimerMode.countdown;
    AtomicIslandService.updateNotification(
      title: '$catDisplayName focusing...',
      text: state.habitName,
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

  /// Pause the timer.
  void pause() {
    _ticker?.cancel();
    _cancelBackupAlarm();
    state = state.copyWith(
      status: TimerStatus.paused,
      pausedAt: DateTime.now(),
    );
    _saveState();
  }

  /// Resume from pause — accumulate pause duration into totalPausedSeconds.
  void resume() {
    if (state.pausedAt != null) {
      final pauseDuration = DateTime.now()
          .difference(state.pausedAt!)
          .inSeconds;
      state = state.copyWith(
        totalPausedSeconds: state.totalPausedSeconds + pauseDuration,
        status: TimerStatus.running,
        clearPausedAt: true,
      );
    } else {
      state = state.copyWith(status: TimerStatus.running, clearPausedAt: true);
    }
    _ticker?.cancel();
    _ticksSinceSave = 0;
    _saveState();
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
    FocusTimerNotifier.clearSavedState();
    AtomicIslandService.cancel();
    FocusTimerService.stop();
    _cancelBackupAlarm();

    // Analytics: non-critical — failure must not break core flow
    try {
      final defaultRatio = terminalStatus == TimerStatus.completed ? 1.0 : 0.0;
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

  /// Handle app going to background.
  ///
  /// **State contract:** Sets [pausedAt] as a wall-clock anchor while keeping
  /// [status] as [TimerStatus.running]. This is intentional — it differs from
  /// user-initiated [pause()] which sets status to [TimerStatus.paused].
  ///
  /// The [onAppResumed] method checks for this exact combination
  /// (`status == running && pausedAt != null`) to detect background recovery.
  /// This avoids introducing a separate `backgrounded` status that would
  /// complicate the state machine.
  void onAppBackgrounded() {
    if (state.status == TimerStatus.running) {
      state = state.copyWith(pausedAt: DateTime.now());
      _saveState();
      final focusingLabel = state.labelFocusing.isNotEmpty
          ? state.labelFocusing
          : 'focusing...';
      final inProgressLabel = state.labelInProgress.isNotEmpty
          ? state.labelInProgress
          : 'Focus session in progress';
      FocusTimerService.updateNotification(
        title: '${_resolveCatDisplayName()} $focusingLabel',
        text: inProgressLabel,
      );
    }
  }

  /// Handle app coming back to foreground.
  /// Uses wall-clock anchoring to compute the real elapsed time. The timer
  /// continues seamlessly — no time is ever lost.
  Future<void> onAppResumed() async {
    if (state.status != TimerStatus.running || state.pausedAt == null) return;
    if (state.startedAt == null) return;

    final newElapsed = _computeWallClockElapsed(
      state.startedAt!,
      state.totalPausedSeconds,
    );

    // Auto-complete: session timeout OR countdown finished in background
    if (_shouldAutoComplete(newElapsed)) {
      _handleAutoComplete(newElapsed);
      return;
    }

    await _restartForegroundServiceIfNeeded();

    // Normal resume — clear pausedAt, restart ticker, refresh display
    state = state.copyWith(elapsedSeconds: newElapsed, clearPausedAt: true);
    _ticker?.cancel();
    _ticksSinceSave = 0;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    _updateNotification();
  }

  /// 判断是否应自动完成：离开超过阈值或倒计时已归零。
  bool _shouldAutoComplete(int newElapsed) {
    final awayMinutes = DateTime.now().difference(state.pausedAt!).inMinutes;
    final countdownDone =
        state.mode == TimerMode.countdown && newElapsed >= state.totalSeconds;
    return awayMinutes > _autoCompleteThresholdMinutes || countdownDone;
  }

  /// 执行自动完成：清理计时器并设置终态。
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
    FocusTimerNotifier.clearSavedState();
  }

  /// 检查并重启被系统杀死的前台服务。
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

  /// Reset to idle state.
  void reset() {
    _ticker?.cancel();
    FocusTimerNotifier.clearSavedState();
    AtomicIslandService.cancel();
    _cancelBackupAlarm();
    state = const FocusTimerState();
  }

  /// Schedule a backup alarm for countdown mode.
  /// If the foreground service is killed, this ensures the user still
  /// gets a notification when the timer would have completed.
  /// Non-critical — failures are silently ignored (e.g. in test environments).
  void _scheduleBackupAlarm() {
    try {
      if (state.mode != TimerMode.countdown) return;
      if (state.startedAt == null) return;

      final fireAt = state.startedAt!.add(
        Duration(seconds: state.totalSeconds + state.totalPausedSeconds),
      );
      // 只在未来的时间点调度
      if (fireAt.isBefore(DateTime.now())) return;

      ref
          .read(notificationServiceProvider)
          .scheduleTimerBackup(
            fireAt: fireAt,
            title: _resolveCatDisplayName('Focus'),
            body: '${state.habitName} \u{00B7} ${state.focusedMinutes} min',
          );
    } catch (e) {
      debugPrint('[FocusTimer] backup alarm schedule error: $e');
    }
  }

  /// Cancel backup alarm. Non-critical — failures are silently ignored.
  void _cancelBackupAlarm() {
    try {
      ref.read(notificationServiceProvider).cancelTimerBackup();
    } catch (e) {
      debugPrint('[FocusTimer] backup alarm cancel error: $e');
    }
  }

  /// Persist current timer state to SharedPreferences.
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyHabitId, state.habitId);
    await prefs.setString(_keyCatId, state.catId);
    await prefs.setString(_keyCatName, state.catName);
    await prefs.setString(_keyHabitName, state.habitName);
    await prefs.setInt(_keyTotalSeconds, state.totalSeconds);
    await prefs.setInt(_keyElapsedSeconds, state.elapsedSeconds);
    await prefs.setInt(_keyTotalPausedSeconds, state.totalPausedSeconds);
    await prefs.setInt(_keyMode, state.mode.index);
    if (state.startedAt != null) {
      await prefs.setString(_keyStartedAt, state.startedAt!.toIso8601String());
    }
    if (state.pausedAt != null) {
      await prefs.setString(_keyPausedAt, state.pausedAt!.toIso8601String());
    } else {
      await prefs.remove(_keyPausedAt);
    }
  }
}

/// Focus timer provider — global singleton (keepAlive).
/// Timer is a cross-screen concern that must survive navigation.
final focusTimerProvider =
    NotifierProvider<FocusTimerNotifier, FocusTimerState>(
      FocusTimerNotifier.new,
    );
