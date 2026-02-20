// ---
// 📘 文件说明：
// 专注计时器 Provider — 管理计时器生命周期、通知更新和崩溃恢复。
// 使用 SharedPreferences 持久化活跃会话，App 被杀后可恢复。
//
// 📋 程序整体伪代码（中文）：
// 1. configure() 初始化计时器参数（含 habitName）；
// 2. start() 启动周期性心跳，每秒更新 state 并刷新通知；
// 3. 每 5 秒自动保存状态到 SharedPreferences；
// 4. complete/abandon/reset 时清除持久化数据；
// 5. 静态方法 hasInterruptedSession() 检测未完成会话；
// 6. restoreSession() 从 SharedPreferences 恢复状态；
//
// 🧩 文件结构：
// - TimerStatus/TimerMode：枚举；
// - FocusTimerState：状态值对象；
// - FocusTimerNotifier：Notifier + 持久化逻辑；
// - focusTimerProvider：全局 Provider（keepAlive）；
// ---

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  });

  /// Remaining seconds for countdown mode.
  int get remainingSeconds => (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);

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
    final seconds = mode == TimerMode.countdown ? remainingSeconds : elapsedSeconds;
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
    );
  }
}

/// Focus timer notifier — manages the timer lifecycle, notification updates,
/// and SharedPreferences persistence for crash recovery.
class FocusTimerNotifier extends Notifier<FocusTimerState> {
  Timer? _ticker;
  int _ticksSinceSave = 0;

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

    final habitName = prefs.getString(_keyHabitName) ?? 'Focus';
    final habitId = prefs.getString(_keyHabitId) ?? '';
    final total = prefs.getInt(_keyTotalSeconds) ?? 0;
    final modeIndex = prefs.getInt(_keyMode) ?? 0;
    final totalPausedSeconds = prefs.getInt(_keyTotalPausedSeconds) ?? 0;

    // Account for pending pause time if app was killed while paused/backgrounded
    final pausedAtStr = prefs.getString(_keyPausedAt);
    int pendingPause = 0;
    if (pausedAtStr != null) {
      final pausedAt = DateTime.tryParse(pausedAtStr);
      if (pausedAt != null) {
        pendingPause = DateTime.now().difference(pausedAt).inSeconds;
      }
    }

    // Wall-clock elapsed minus all paused time
    final wallTotal = DateTime.now().difference(startedAt).inSeconds;
    final effectiveElapsed = (wallTotal - totalPausedSeconds - pendingPause)
        .clamp(0, wallTotal);

    return {
      'habitId': habitId,
      'habitName': habitName,
      'wallClockElapsed': effectiveElapsed,
      'totalSeconds': total,
      'mode': TimerMode.values[modeIndex],
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
  void configure({
    required String habitId,
    required String catId,
    required String catName,
    required String habitName,
    required int durationSeconds,
    required TimerMode mode,
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
    final totalSeconds = prefs.getInt(_keyTotalSeconds) ?? 1500;
    final modeIndex = prefs.getInt(_keyMode) ?? 0;
    final mode = TimerMode.values[modeIndex];
    var totalPausedSeconds = prefs.getInt(_keyTotalPausedSeconds) ?? 0;

    // Account for pending pause (app was killed while paused/backgrounded)
    final pausedAtStr = prefs.getString(_keyPausedAt);
    if (pausedAtStr != null) {
      final pausedAt = DateTime.tryParse(pausedAtStr);
      if (pausedAt != null) {
        totalPausedSeconds += DateTime.now().difference(pausedAt).inSeconds;
      }
    }

    // Wall-clock elapsed minus paused time
    final wallTotal = DateTime.now().difference(startedAt).inSeconds;
    final effectiveElapsed = (wallTotal - totalPausedSeconds).clamp(0, wallTotal);

    // Countdown mode: check if would have completed
    if (mode == TimerMode.countdown && effectiveElapsed >= totalSeconds) {
      state = FocusTimerState(
        habitId: habitId,
        catId: catId,
        catName: catName,
        habitName: habitName,
        totalSeconds: totalSeconds,
        elapsedSeconds: totalSeconds,
        totalPausedSeconds: totalPausedSeconds,
        status: TimerStatus.completed,
        mode: mode,
        startedAt: startedAt,
      );
      await _clearSavedState();
      return;
    }

    // Otherwise restore as paused (add current time to paused total)
    state = FocusTimerState(
      habitId: habitId,
      catId: catId,
      catName: catName,
      habitName: habitName,
      totalSeconds: totalSeconds,
      elapsedSeconds: effectiveElapsed,
      totalPausedSeconds: totalPausedSeconds,
      status: TimerStatus.paused,
      mode: mode,
      startedAt: startedAt,
      pausedAt: DateTime.now(),
    );
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

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    if (state.startedAt == null) return;

    // Wall-clock calculation: elapsed = (now - startedAt) - totalPausedSeconds
    final wallTotal = DateTime.now().difference(state.startedAt!).inSeconds;
    final newElapsed = (wallTotal - state.totalPausedSeconds).clamp(0, wallTotal);

    // Countdown: check if time is up
    if (state.mode == TimerMode.countdown && newElapsed >= state.totalSeconds) {
      _ticker?.cancel();
      state = state.copyWith(
        elapsedSeconds: state.totalSeconds,
        status: TimerStatus.completed,
      );
      _clearSavedState();
      AtomicIslandService.cancel();
      return;
    }

    state = state.copyWith(elapsedSeconds: newElapsed);

    // Update foreground notification
    _updateNotification();

    // Save state every 5 seconds
    _ticksSinceSave++;
    if (_ticksSinceSave >= 5) {
      _ticksSinceSave = 0;
      _saveState();
    }
  }

  void _updateNotification() {
    final label = state.mode == TimerMode.countdown ? 'remaining' : 'elapsed';
    final catDisplayName = state.catName.isNotEmpty ? state.catName : 'Your cat';

    // 基础通知（fallback）
    FocusTimerService.updateNotification(
      title: '$catDisplayName focusing...',
      text: '${state.habitName} \u{00B7} ${state.displayTime} $label',
    );

    // 富通知（触发 vivo 原子岛 + Android 16 ProgressStyle）
    if (state.startedAt != null) {
      final isCountdown = state.mode == TimerMode.countdown;
      AtomicIslandService.updateNotification(
        title: '$catDisplayName focusing...',
        text: state.habitName,
        isCountdown: isCountdown,
        isPaused: state.status == TimerStatus.paused,
        endTimeMs: isCountdown
            ? state.startedAt!
                .add(Duration(
                    seconds: state.totalSeconds + state.totalPausedSeconds))
                .millisecondsSinceEpoch
            : null,
        startTimeMs: state.startedAt!.millisecondsSinceEpoch,
      );
    }
  }

  /// Pause the timer.
  void pause() {
    _ticker?.cancel();
    state = state.copyWith(
      status: TimerStatus.paused,
      pausedAt: DateTime.now(),
    );
    _saveState();
  }

  /// Resume from pause — accumulate pause duration into totalPausedSeconds.
  void resume() {
    if (state.pausedAt != null) {
      final pauseDuration = DateTime.now().difference(state.pausedAt!).inSeconds;
      state = state.copyWith(
        totalPausedSeconds: state.totalPausedSeconds + pauseDuration,
        status: TimerStatus.running,
        clearPausedAt: true,
      );
    } else {
      state = state.copyWith(
        status: TimerStatus.running,
        clearPausedAt: true,
      );
    }
    _ticker?.cancel();
    _ticksSinceSave = 0;
    _saveState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  /// Complete the session (stopwatch mode: user presses done).
  void complete() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.completed);
    _clearSavedState();
    AtomicIslandService.cancel();
  }

  /// Abandon the session.
  void abandon() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.abandoned);
    _clearSavedState();
    AtomicIslandService.cancel();
  }

  /// Handle app going to background.
  /// Records pausedAt for tracking background time, saves state, and updates
  /// the foreground notification to static text. The timer state stays
  /// "running" — wall-clock anchoring will catch up on resume.
  void onAppBackgrounded() {
    if (state.status == TimerStatus.running) {
      state = state.copyWith(pausedAt: DateTime.now());
      _saveState();
      final catDisplayName =
          state.catName.isNotEmpty ? state.catName : 'Your cat';
      FocusTimerService.updateNotification(
        title: '$catDisplayName focusing...',
        text: 'Focus session in progress',
      );
    }
  }

  /// Handle app coming back to foreground.
  /// Uses wall-clock anchoring to compute the real elapsed time. The timer
  /// continues seamlessly — no time is ever lost.
  void onAppResumed() {
    if (state.status != TimerStatus.running || state.pausedAt == null) return;
    if (state.startedAt == null) return;

    // Wall-clock total elapsed minus paused time
    final wallTotal = DateTime.now().difference(state.startedAt!).inSeconds;
    final newElapsed = (wallTotal - state.totalPausedSeconds)
        .clamp(0, wallTotal);

    // Auto-complete if away > 30 minutes (user forgot about it)
    final awayDuration = DateTime.now().difference(state.pausedAt!);
    if (awayDuration.inMinutes > 30) {
      _ticker?.cancel();
      final cappedElapsed = state.mode == TimerMode.countdown
          ? newElapsed.clamp(0, state.totalSeconds)
          : newElapsed;
      state = state.copyWith(
        elapsedSeconds: cappedElapsed,
        status: TimerStatus.completed,
        clearPausedAt: true,
      );
      _clearSavedState();
      return;
    }

    // Countdown completed while in background
    if (state.mode == TimerMode.countdown && newElapsed >= state.totalSeconds) {
      _ticker?.cancel();
      state = state.copyWith(
        elapsedSeconds: state.totalSeconds,
        status: TimerStatus.completed,
        clearPausedAt: true,
      );
      _clearSavedState();
      return;
    }

    // Normal resume — clear pausedAt, restart ticker, refresh display
    state = state.copyWith(
      elapsedSeconds: newElapsed,
      clearPausedAt: true,
    );
    _ticker?.cancel();
    _ticksSinceSave = 0;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    _updateNotification();
  }

  /// Reset to idle state.
  void reset() {
    _ticker?.cancel();
    _clearSavedState();
    AtomicIslandService.cancel();
    state = const FocusTimerState();
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

  /// Clear persisted state.
  Future<void> _clearSavedState() async {
    await FocusTimerNotifier.clearSavedState();
  }
}

/// Focus timer provider — global singleton (keepAlive).
/// Timer is a cross-screen concern that must survive navigation.
final focusTimerProvider =
    NotifierProvider<FocusTimerNotifier, FocusTimerState>(
  FocusTimerNotifier.new,
);
