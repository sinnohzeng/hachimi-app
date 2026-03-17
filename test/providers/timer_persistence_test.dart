// ---
// 📘 TimerPersistence 单元测试
// 崩溃恢复路径（save → restore → clear）与壁钟计算的完整覆盖。
// 通过注入可控 Clock 实现确定性测试。
//
// 🕒 创建时间：2026-03-17
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/providers/timer_persistence.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';

void main() {
  late TimerPersistence persistence;
  late DateTime fixedNow;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fixedNow = DateTime(2026, 3, 17, 10, 0, 0);
    persistence = TimerPersistence(clock: () => fixedNow);
  });

  // ─── 壁钟计算 ───

  group('computeWallClockElapsed', () {
    test('returns elapsed minus paused seconds', () {
      final startedAt = fixedNow.subtract(const Duration(minutes: 10));
      final result = persistence.computeWallClockElapsed(startedAt, 120);
      // 10 min = 600s, minus 120s paused = 480s
      expect(result, equals(480));
    });

    test('clamps to 0 when paused exceeds wall time', () {
      final startedAt = fixedNow.subtract(const Duration(minutes: 5));
      // 300s wall time but 400s paused — should clamp to 0
      final result = persistence.computeWallClockElapsed(startedAt, 400);
      expect(result, equals(0));
    });

    test('returns full wall time when no pause', () {
      final startedAt = fixedNow.subtract(const Duration(minutes: 25));
      final result = persistence.computeWallClockElapsed(startedAt, 0);
      expect(result, equals(1500));
    });
  });

  group('computePendingPauseDelta', () {
    test('returns 0 for null pausedAt', () {
      expect(persistence.computePendingPauseDelta(null), equals(0));
    });

    test('returns 0 for invalid date string', () {
      expect(persistence.computePendingPauseDelta('not-a-date'), equals(0));
    });

    test('returns seconds since pausedAt', () {
      final pausedAt = fixedNow.subtract(const Duration(minutes: 3));
      final delta =
          persistence.computePendingPauseDelta(pausedAt.toIso8601String());
      expect(delta, equals(180));
    });
  });

  // ─── 崩溃恢复：hasInterruptedSession ───

  group('hasInterruptedSession', () {
    test('returns false when no data saved', () async {
      expect(await persistence.hasInterruptedSession(), isFalse);
    });

    test('returns true when startedAt is saved', () async {
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 300,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: fixedNow.subtract(const Duration(minutes: 5)),
      );
      await persistence.saveState(state);

      expect(await persistence.hasInterruptedSession(), isTrue);
    });
  });

  // ─── 崩溃恢复：getSavedSessionInfo ───

  group('getSavedSessionInfo', () {
    test('returns null when no data saved', () async {
      expect(await persistence.getSavedSessionInfo(), isNull);
    });

    test('returns correct info with wall-clock elapsed', () async {
      final startedAt = fixedNow.subtract(const Duration(minutes: 10));
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 300,
        totalPausedSeconds: 60,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: startedAt,
      );
      await persistence.saveState(state);

      final info = await persistence.getSavedSessionInfo();
      expect(info, isNotNull);
      expect(info!['habitId'], equals('h1'));
      expect(info['habitName'], equals('Reading'));
      // 10min wall = 600s, minus 60s paused = 540s
      expect(info['wallClockElapsed'], equals(540));
      expect(info['totalSeconds'], equals(1500));
      expect(info['mode'], equals(TimerMode.countdown));
    });

    test('accounts for pending pause delta', () async {
      final startedAt = fixedNow.subtract(const Duration(minutes: 10));
      final pausedAt = fixedNow.subtract(const Duration(minutes: 2));
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 300,
        totalPausedSeconds: 60,
        status: TimerStatus.paused,
        mode: TimerMode.countdown,
        startedAt: startedAt,
        pausedAt: pausedAt,
      );
      await persistence.saveState(state);

      final info = await persistence.getSavedSessionInfo();
      // totalPaused = 60 (saved) + 120 (pending since pausedAt) = 180
      // wallClock = 600 - 180 = 420
      expect(info!['wallClockElapsed'], equals(420));
    });
  });

  // ─── 崩溃恢复：restoreSession ───

  group('restoreSession', () {
    test('returns null when no data saved', () async {
      expect(await persistence.restoreSession(), isNull);
    });

    test('restores paused state for in-progress countdown', () async {
      final startedAt = fixedNow.subtract(const Duration(minutes: 10));
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 300,
        totalPausedSeconds: 0,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: startedAt,
      );
      await persistence.saveState(state);

      final restored = await persistence.restoreSession();
      expect(restored, isNotNull);
      expect(restored!.habitId, equals('h1'));
      expect(restored.catName, equals('Mochi'));
      expect(restored.status, equals(TimerStatus.paused));
      expect(restored.elapsedSeconds, equals(600)); // 10 min wall clock
      expect(restored.pausedAt, equals(fixedNow));
    });

    test('restores completed state when countdown time exceeded', () async {
      // Started 30 min ago, countdown was 25 min — should be completed
      final startedAt = fixedNow.subtract(const Duration(minutes: 30));
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500, // 25 min
        elapsedSeconds: 300,
        totalPausedSeconds: 0,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: startedAt,
      );
      await persistence.saveState(state);

      final restored = await persistence.restoreSession();
      expect(restored!.status, equals(TimerStatus.completed));
      expect(restored.elapsedSeconds, equals(1500)); // capped to total
    });

    test('restores stopwatch as paused (never auto-completes)', () async {
      final startedAt = fixedNow.subtract(const Duration(hours: 2));
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 100,
        totalPausedSeconds: 0,
        status: TimerStatus.running,
        mode: TimerMode.stopwatch,
        startedAt: startedAt,
      );
      await persistence.saveState(state);

      final restored = await persistence.restoreSession();
      expect(restored!.status, equals(TimerStatus.paused));
      expect(restored.elapsedSeconds, equals(7200)); // 2 hours
    });
  });

  // ─── clearSavedState ───

  group('clearSavedState', () {
    test('removes all keys', () async {
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 300,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: fixedNow,
      );
      await persistence.saveState(state);
      expect(await persistence.hasInterruptedSession(), isTrue);

      await persistence.clearSavedState();
      expect(await persistence.hasInterruptedSession(), isFalse);
      expect(await persistence.restoreSession(), isNull);
    });
  });

  // ─── saveState 错误容忍 ───

  group('saveState — error resilience', () {
    test('does not throw on save', () async {
      // 正常保存不应抛异常
      final state = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 0,
        status: TimerStatus.idle,
        mode: TimerMode.countdown,
      );
      // 不应抛异常
      await expectLater(persistence.saveState(state), completes);
    });
  });

  // ─── Clock 注入 ───

  group('Clock injection', () {
    test('now() returns injected clock value', () {
      expect(persistence.now(), equals(fixedNow));
    });

    test('advancing clock changes computations', () {
      var currentTime = DateTime(2026, 1, 1, 12, 0, 0);
      final advancing = TimerPersistence(clock: () => currentTime);

      final startedAt = DateTime(2026, 1, 1, 11, 50, 0);

      // 初始时刻：10 分钟已过
      expect(advancing.computeWallClockElapsed(startedAt, 0), equals(600));

      // 推进时钟 5 分钟
      currentTime = DateTime(2026, 1, 1, 12, 5, 0);
      expect(advancing.computeWallClockElapsed(startedAt, 0), equals(900));
    });
  });
}
