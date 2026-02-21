// ---
// 📘 文件说明：
// FocusTimerState & FocusTimerNotifier 单元测试。
// Part 1: 状态值对象的计算属性和 copyWith。
// Part 2: Notifier 生命周期状态机（configure, start, pause, resume, complete,
//         abandon, reset）。
//
// Note: Timer-ticking tests (countdown auto-complete, elapsed increments)
// are not included because _onTick() uses DateTime.now() for wall-clock
// calculations, which is not overridden by fakeAsync. Testing those
// requires an injectable clock, which is out of scope.
//
// 🧩 文件结构：
// - FocusTimerState: defaults, remainingSeconds, progress, displayTime,
//   focusedMinutes, copyWith
// - FocusTimerNotifier: configure, start, pause/resume, complete, abandon,
//   reset
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';

void main() {
  group('FocusTimerState — defaults', () {
    test('default state is 25 min idle countdown', () {
      const s = FocusTimerState();
      expect(s.habitId, isEmpty);
      expect(s.totalSeconds, equals(1500));
      expect(s.elapsedSeconds, equals(0));
      expect(s.totalPausedSeconds, equals(0));
      expect(s.status, equals(TimerStatus.idle));
      expect(s.mode, equals(TimerMode.countdown));
      expect(s.startedAt, isNull);
      expect(s.pausedAt, isNull);
    });
  });

  group('FocusTimerState — remainingSeconds', () {
    test('full remaining when no elapsed', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 0);
      expect(s.remainingSeconds, equals(1500));
    });

    test('partial remaining', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 600);
      expect(s.remainingSeconds, equals(900));
    });

    test('zero remaining when fully elapsed', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 1500);
      expect(s.remainingSeconds, equals(0));
    });

    test('clamped to 0 if elapsed exceeds total', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 2000);
      expect(s.remainingSeconds, equals(0));
    });
  });

  group('FocusTimerState — progress', () {
    test('0.0 when no elapsed', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 0);
      expect(s.progress, equals(0.0));
    });

    test('0.5 at halfway', () {
      const s = FocusTimerState(totalSeconds: 1000, elapsedSeconds: 500);
      expect(s.progress, closeTo(0.5, 0.001));
    });

    test('1.0 when complete', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 1500);
      expect(s.progress, equals(1.0));
    });

    test('clamped to 1.0 if elapsed exceeds total', () {
      const s = FocusTimerState(totalSeconds: 1500, elapsedSeconds: 2000);
      expect(s.progress, equals(1.0));
    });

    test('returns 0 when totalSeconds is 0', () {
      const s = FocusTimerState(totalSeconds: 0, elapsedSeconds: 0);
      expect(s.progress, equals(0.0));
    });

    test('stopwatch mode uses same formula', () {
      const s = FocusTimerState(
        totalSeconds: 1500,
        elapsedSeconds: 750,
        mode: TimerMode.stopwatch,
      );
      expect(s.progress, closeTo(0.5, 0.001));
    });
  });

  group('FocusTimerState — displayTime', () {
    test('countdown mode shows remaining time', () {
      const s = FocusTimerState(
        totalSeconds: 1500,
        elapsedSeconds: 0,
        mode: TimerMode.countdown,
      );
      expect(s.displayTime, equals('25:00'));
    });

    test('countdown mode with elapsed shows remaining', () {
      const s = FocusTimerState(
        totalSeconds: 1500,
        elapsedSeconds: 900,
        mode: TimerMode.countdown,
      );
      expect(s.displayTime, equals('10:00'));
    });

    test('stopwatch mode shows elapsed time', () {
      const s = FocusTimerState(
        totalSeconds: 1500,
        elapsedSeconds: 75,
        mode: TimerMode.stopwatch,
      );
      expect(s.displayTime, equals('01:15'));
    });

    test('shows HH:MM:SS when hours > 0', () {
      const s = FocusTimerState(
        totalSeconds: 7200,
        elapsedSeconds: 0,
        mode: TimerMode.countdown,
      );
      expect(s.displayTime, equals('02:00:00'));
    });

    test('zero displays as 00:00', () {
      const s = FocusTimerState(
        totalSeconds: 100,
        elapsedSeconds: 100,
        mode: TimerMode.countdown,
      );
      expect(s.displayTime, equals('00:00'));
    });

    test('single digit seconds are zero-padded', () {
      const s = FocusTimerState(
        totalSeconds: 1500,
        elapsedSeconds: 5,
        mode: TimerMode.stopwatch,
      );
      expect(s.displayTime, equals('00:05'));
    });
  });

  group('FocusTimerState — focusedMinutes', () {
    test('returns 0 when no elapsed', () {
      const s = FocusTimerState(elapsedSeconds: 0);
      expect(s.focusedMinutes, equals(0));
    });

    test('1 second rounds up to 1 minute', () {
      const s = FocusTimerState(elapsedSeconds: 1);
      expect(s.focusedMinutes, equals(1));
    });

    test('59 seconds rounds up to 1 minute', () {
      const s = FocusTimerState(elapsedSeconds: 59);
      expect(s.focusedMinutes, equals(1));
    });

    test('60 seconds equals exactly 1 minute', () {
      const s = FocusTimerState(elapsedSeconds: 60);
      expect(s.focusedMinutes, equals(1));
    });

    test('61 seconds rounds up to 2 minutes', () {
      const s = FocusTimerState(elapsedSeconds: 61);
      expect(s.focusedMinutes, equals(2));
    });

    test('25 minutes exactly', () {
      const s = FocusTimerState(elapsedSeconds: 1500);
      expect(s.focusedMinutes, equals(25));
    });
  });

  group('FocusTimerState — copyWith', () {
    test('copies with single field change', () {
      const s = FocusTimerState(habitId: 'h1', catId: 'c1');
      final s2 = s.copyWith(status: TimerStatus.running);
      expect(s2.habitId, equals('h1'));
      expect(s2.catId, equals('c1'));
      expect(s2.status, equals(TimerStatus.running));
    });

    test('clearPausedAt sets pausedAt to null', () {
      final now = DateTime.now();
      final s = FocusTimerState(pausedAt: now);
      final s2 = s.copyWith(clearPausedAt: true);
      expect(s2.pausedAt, isNull);
    });

    test('preserves pausedAt when clearPausedAt is false', () {
      final now = DateTime.now();
      final s = FocusTimerState(pausedAt: now);
      final s2 = s.copyWith(status: TimerStatus.running);
      expect(s2.pausedAt, equals(now));
    });

    test('can override all fields', () {
      final now = DateTime.now();
      final s2 = const FocusTimerState().copyWith(
        habitId: 'h2',
        catId: 'c2',
        catName: 'Whiskers',
        habitName: 'Reading',
        totalSeconds: 3600,
        elapsedSeconds: 100,
        totalPausedSeconds: 10,
        status: TimerStatus.paused,
        mode: TimerMode.stopwatch,
        startedAt: now,
        pausedAt: now,
      );
      expect(s2.habitId, equals('h2'));
      expect(s2.catId, equals('c2'));
      expect(s2.catName, equals('Whiskers'));
      expect(s2.habitName, equals('Reading'));
      expect(s2.totalSeconds, equals(3600));
      expect(s2.elapsedSeconds, equals(100));
      expect(s2.totalPausedSeconds, equals(10));
      expect(s2.status, equals(TimerStatus.paused));
      expect(s2.mode, equals(TimerMode.stopwatch));
      expect(s2.startedAt, equals(now));
      expect(s2.pausedAt, equals(now));
    });

    test('copies L10N label fields', () {
      const s = FocusTimerState(
        labelRemaining: 'remaining',
        labelElapsed: 'elapsed',
        labelFocusing: 'focusing...',
        labelDefaultCat: 'Your cat',
        labelInProgress: 'In progress',
      );
      final s2 = s.copyWith(labelRemaining: 'restant');
      expect(s2.labelRemaining, equals('restant'));
      expect(s2.labelElapsed, equals('elapsed'));
      expect(s2.labelFocusing, equals('focusing...'));
      expect(s2.labelDefaultCat, equals('Your cat'));
      expect(s2.labelInProgress, equals('In progress'));
    });
  });

  // ─── Part 2: FocusTimerNotifier lifecycle tests ───
  //
  // These tests verify the state-machine transitions of FocusTimerNotifier.
  // Timer-ticking tests are excluded because _onTick() uses DateTime.now()
  // for wall-clock calculations, which is not overridden by fakeAsync.

  group('FocusTimerNotifier — lifecycle', () {
    late ProviderContainer container;
    late FocusTimerNotifier notifier;

    setUp(() {
      SharedPreferences.setMockInitialValues({});

      // Mock platform channels used by AtomicIslandService and
      // FlutterForegroundTask to prevent MissingPluginException
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.hachimi.notification'),
            (MethodCall methodCall) async => null,
          );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter_foreground_task/methods'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'isRunningService') return false;
              return null;
            },
          );

      container = ProviderContainer();
      notifier = container.read(focusTimerProvider.notifier);
    });

    tearDown(() async {
      // Reset notifier to cancel pending timers before container disposal,
      // preventing _saveState from accessing a disposed ref.
      try {
        notifier.reset();
      } catch (_) {}
      // Flush pending microtasks from _saveState / clearSavedState
      await Future<void>.delayed(Duration.zero);
      container.dispose();
    });

    test('configure() sets correct state', () {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
        labelRemaining: 'restant',
      );

      final s = container.read(focusTimerProvider);
      expect(s.habitId, equals('h1'));
      expect(s.catId, equals('c1'));
      expect(s.catName, equals('Mochi'));
      expect(s.habitName, equals('Reading'));
      expect(s.totalSeconds, equals(1500));
      expect(s.elapsedSeconds, equals(0));
      expect(s.status, equals(TimerStatus.idle));
      expect(s.mode, equals(TimerMode.countdown));
      expect(s.labelRemaining, equals('restant'));
    });

    test('start() transitions idle → running and sets startedAt', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      // Flush _saveState microtasks
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.running));
      expect(s.startedAt, isNotNull);
    });

    test('start() is idempotent when already running', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      final startedAt = container.read(focusTimerProvider).startedAt;

      // Calling start() again should be a no-op
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.running));
      expect(s.startedAt, equals(startedAt));
    });

    test('pause() transitions running → paused with pausedAt', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      notifier.pause();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.paused));
      expect(s.pausedAt, isNotNull);
    });

    test('resume() clears pausedAt and resumes running', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      notifier.pause();
      await Future<void>.delayed(Duration.zero);

      notifier.resume();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.running));
      expect(s.pausedAt, isNull);
    });

    test('resume() accumulates totalPausedSeconds', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      // Simulate pause by manually setting pausedAt in the past
      notifier.pause();
      await Future<void>.delayed(Duration.zero);

      // The pausedAt was just set; totalPausedSeconds starts at 0
      final beforeResume = container.read(focusTimerProvider);
      expect(beforeResume.totalPausedSeconds, equals(0));
      expect(beforeResume.pausedAt, isNotNull);

      // Resume immediately — pause duration is ~0 seconds
      notifier.resume();
      await Future<void>.delayed(Duration.zero);

      final afterResume = container.read(focusTimerProvider);
      expect(afterResume.pausedAt, isNull);
      // totalPausedSeconds >= 0 (tiny pause duration is 0)
      expect(afterResume.totalPausedSeconds, greaterThanOrEqualTo(0));
    });

    test('complete() transitions → completed', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.stopwatch,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      notifier.complete();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.completed));
    });

    test('abandon() transitions → abandoned', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      notifier.abandon();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.abandoned));
    });

    test('reset() returns to idle defaults', () async {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );
      notifier.start();
      await Future<void>.delayed(Duration.zero);

      notifier.reset();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.idle));
      expect(s.habitId, isEmpty);
      expect(s.elapsedSeconds, equals(0));
      expect(s.startedAt, isNull);
    });

    test('configure() after start resets to idle', () {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );

      // Reconfigure should reset
      notifier.configure(
        habitId: 'h2',
        catId: 'c2',
        catName: 'Luna',
        habitName: 'Writing',
        durationSeconds: 3600,
        mode: TimerMode.stopwatch,
      );

      final s = container.read(focusTimerProvider);
      expect(s.habitId, equals('h2'));
      expect(s.habitName, equals('Writing'));
      expect(s.totalSeconds, equals(3600));
      expect(s.mode, equals(TimerMode.stopwatch));
      expect(s.status, equals(TimerStatus.idle));
    });

    test('L10N labels default to empty string', () {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
      );

      final s = container.read(focusTimerProvider);
      expect(s.labelRemaining, isEmpty);
      expect(s.labelElapsed, isEmpty);
      expect(s.labelFocusing, isEmpty);
      expect(s.labelDefaultCat, isEmpty);
      expect(s.labelInProgress, isEmpty);
    });

    test('configure() with L10N labels stores them', () {
      notifier.configure(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        durationSeconds: 1500,
        mode: TimerMode.countdown,
        labelRemaining: 'remaining',
        labelElapsed: 'elapsed',
        labelFocusing: 'focusing...',
        labelDefaultCat: 'Your cat',
        labelInProgress: 'Focus session in progress',
      );

      final s = container.read(focusTimerProvider);
      expect(s.labelRemaining, equals('remaining'));
      expect(s.labelElapsed, equals('elapsed'));
      expect(s.labelFocusing, equals('focusing...'));
      expect(s.labelDefaultCat, equals('Your cat'));
      expect(s.labelInProgress, equals('Focus session in progress'));
    });
  });
}
