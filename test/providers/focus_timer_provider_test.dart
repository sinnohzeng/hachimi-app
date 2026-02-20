// ---
// 📘 文件说明：
// FocusTimerState 单元测试 — 验证计时器状态值对象的计算属性和 copyWith。
//
// 🧩 文件结构：
// - 默认状态
// - remainingSeconds
// - progress
// - displayTime (MM:SS, HH:MM:SS)
// - focusedMinutes
// - copyWith 行为
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter_test/flutter_test.dart';
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
  });
}
