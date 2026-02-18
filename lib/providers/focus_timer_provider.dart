import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timer status for focus sessions.
enum TimerStatus { idle, running, paused, completed, abandoned }

/// Timer mode — countdown or stopwatch.
enum TimerMode { countdown, stopwatch }

/// Focus timer state.
class FocusTimerState {
  final String habitId;
  final String catId;
  final int totalSeconds; // Target duration (countdown mode)
  final int elapsedSeconds; // Actual focused time
  final TimerStatus status;
  final TimerMode mode;
  final DateTime? startedAt;
  final DateTime? pausedAt;

  const FocusTimerState({
    this.habitId = '',
    this.catId = '',
    this.totalSeconds = 1500, // 25 min default
    this.elapsedSeconds = 0,
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
    int? totalSeconds,
    int? elapsedSeconds,
    TimerStatus? status,
    TimerMode? mode,
    DateTime? startedAt,
    DateTime? pausedAt,
  }) {
    return FocusTimerState(
      habitId: habitId ?? this.habitId,
      catId: catId ?? this.catId,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      startedAt: startedAt ?? this.startedAt,
      pausedAt: pausedAt ?? this.pausedAt,
    );
  }
}

/// Focus timer notifier — manages the timer lifecycle.
class FocusTimerNotifier extends StateNotifier<FocusTimerState> {
  Timer? _ticker;

  FocusTimerNotifier() : super(const FocusTimerState());

  /// Initialize the timer with habit/cat info and duration.
  void configure({
    required String habitId,
    required String catId,
    required int durationSeconds,
    required TimerMode mode,
  }) {
    _ticker?.cancel();
    state = FocusTimerState(
      habitId: habitId,
      catId: catId,
      totalSeconds: durationSeconds,
      elapsedSeconds: 0,
      status: TimerStatus.idle,
      mode: mode,
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

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final newElapsed = state.elapsedSeconds + 1;

      // Countdown: check if time is up
      if (state.mode == TimerMode.countdown && newElapsed >= state.totalSeconds) {
        _ticker?.cancel();
        state = state.copyWith(
          elapsedSeconds: state.totalSeconds,
          status: TimerStatus.completed,
        );
        return;
      }

      state = state.copyWith(elapsedSeconds: newElapsed);
    });
  }

  /// Pause the timer.
  void pause() {
    _ticker?.cancel();
    state = state.copyWith(
      status: TimerStatus.paused,
      pausedAt: DateTime.now(),
    );
  }

  /// Resume from pause.
  void resume() {
    state = state.copyWith(status: TimerStatus.running);
    start();
  }

  /// Complete the session (stopwatch mode: user presses done).
  void complete() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.completed);
  }

  /// Abandon the session.
  void abandon() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.abandoned);
  }

  /// Handle app going to background.
  void onAppBackgrounded() {
    if (state.status == TimerStatus.running) {
      state = state.copyWith(pausedAt: DateTime.now());
    }
  }

  /// Handle app coming back to foreground.
  void onAppResumed() {
    if (state.status != TimerStatus.running || state.pausedAt == null) return;

    final awayDuration = DateTime.now().difference(state.pausedAt!);

    // If away > 5 minutes, auto-complete/abandon
    if (awayDuration.inMinutes > 5) {
      _ticker?.cancel();
      final finalElapsed = state.elapsedSeconds + awayDuration.inSeconds;
      if (state.mode == TimerMode.countdown &&
          finalElapsed >= state.totalSeconds) {
        state = state.copyWith(
          elapsedSeconds: state.totalSeconds,
          status: TimerStatus.completed,
          pausedAt: null,
        );
      } else {
        state = state.copyWith(
          elapsedSeconds: state.elapsedSeconds + awayDuration.inSeconds,
          status: TimerStatus.completed,
          pausedAt: null,
        );
      }
      return;
    }

    // If away > 15 seconds, auto-pause
    if (awayDuration.inSeconds > 15) {
      _ticker?.cancel();
      state = state.copyWith(
        status: TimerStatus.paused,
        pausedAt: null,
      );
      return;
    }

    // Brief absence: add elapsed time and continue
    final newElapsed = state.elapsedSeconds + awayDuration.inSeconds;
    if (state.mode == TimerMode.countdown && newElapsed >= state.totalSeconds) {
      _ticker?.cancel();
      state = state.copyWith(
        elapsedSeconds: state.totalSeconds,
        status: TimerStatus.completed,
        pausedAt: null,
      );
    } else {
      state = state.copyWith(
        elapsedSeconds: newElapsed,
        pausedAt: null,
      );
    }
  }

  /// Reset to idle state.
  void reset() {
    _ticker?.cancel();
    state = const FocusTimerState();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

/// Focus timer provider.
final focusTimerProvider =
    StateNotifierProvider.autoDispose<FocusTimerNotifier, FocusTimerState>(
  (ref) {
    return FocusTimerNotifier();
  },
);
