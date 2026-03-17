// ---
// 📘 FocusTimerNotifier 高级测试
// 覆盖 _onTick、_handleCountdownComplete、onAppResumed、restoreSession
// 等核心时序路径。通过 Clock 注入实现确定性验证。
//
// 🕒 创建时间：2026-03-17
// ---

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/providers/timer_persistence.dart';

void main() {
  late DateTime testNow;
  late ProviderContainer container;
  late FocusTimerNotifier notifier;
  late TimerPersistence persistence;

  setUp(() {
    testNow = DateTime(2026, 3, 17, 10, 0, 0);
    SharedPreferences.setMockInitialValues({});

    TestWidgetsFlutterBinding.ensureInitialized();
    // 平台通道 mock — AtomicIslandService + FlutterForegroundTask
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

    persistence = TimerPersistence(clock: () => testNow);
    container = ProviderContainer(
      overrides: [timerPersistenceProvider.overrideWithValue(persistence)],
    );
    notifier = container.read(focusTimerProvider.notifier);
  });

  tearDown(() async {
    try {
      notifier.reset();
    } catch (_) {}
    await Future<void>.delayed(Duration.zero);
    container.dispose();
  });

  /// 配置并启动倒计时 timer 的辅助方法。
  void configureAndStart({
    int durationSeconds = 1500,
    TimerMode mode = TimerMode.countdown,
  }) {
    notifier.configure(
      habitId: 'h1',
      catId: 'c1',
      catName: 'Mochi',
      habitName: 'Reading',
      durationSeconds: durationSeconds,
      mode: mode,
    );
    notifier.start();
  }

  // ─── _onTick() 行为 ───

  group('_onTick — wall-clock elapsed', () {
    test('updates elapsedSeconds after clock advances', () async {
      configureAndStart();
      await Future<void>.delayed(Duration.zero);

      // 推进时钟 10 秒
      testNow = testNow.add(const Duration(seconds: 10));

      // 等待 ticker 触发
      await Future<void>.delayed(const Duration(seconds: 1));

      final s = container.read(focusTimerProvider);
      expect(s.elapsedSeconds, greaterThanOrEqualTo(10));
      expect(s.status, equals(TimerStatus.running));
    });

    test(
      'countdown auto-completes when elapsed reaches totalSeconds',
      () async {
        configureAndStart(durationSeconds: 60);
        await Future<void>.delayed(Duration.zero);

        // 推进时钟超过 60 秒
        testNow = testNow.add(const Duration(seconds: 65));

        await Future<void>.delayed(const Duration(seconds: 1));

        final s = container.read(focusTimerProvider);
        expect(s.status, equals(TimerStatus.completed));
        expect(s.elapsedSeconds, equals(60));
      },
    );

    test('stopwatch mode does NOT auto-complete', () async {
      configureAndStart(durationSeconds: 60, mode: TimerMode.stopwatch);
      await Future<void>.delayed(Duration.zero);

      // 推进时钟远超 totalSeconds
      testNow = testNow.add(const Duration(seconds: 120));

      await Future<void>.delayed(const Duration(seconds: 1));

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.running));
      expect(s.elapsedSeconds, greaterThanOrEqualTo(120));
    });

    test('periodic save every _saveIntervalTicks (5) ticks', () async {
      configureAndStart(durationSeconds: 300);
      await Future<void>.delayed(Duration.zero);

      // 清除 start() 的初始 save
      await persistence.clearSavedState();
      expect(await persistence.hasInterruptedSession(), isFalse);

      // 推进 5 次 tick（每次 1 秒）
      for (int i = 1; i <= 5; i++) {
        testNow = testNow.add(const Duration(seconds: 1));
        await Future<void>.delayed(const Duration(seconds: 1));
      }

      // 5 次 tick 后应当有持久化数据
      expect(await persistence.hasInterruptedSession(), isTrue);
    });
  });

  // ─── _handleCountdownComplete() 副作用 ───

  group('_handleCountdownComplete — side effects', () {
    test('sets elapsed to totalSeconds and status to completed', () async {
      configureAndStart(durationSeconds: 30);
      await Future<void>.delayed(Duration.zero);

      testNow = testNow.add(const Duration(seconds: 35));
      await Future<void>.delayed(const Duration(seconds: 1));

      final s = container.read(focusTimerProvider);
      expect(s.elapsedSeconds, equals(30));
      expect(s.status, equals(TimerStatus.completed));
    });

    test('clears persisted crash recovery data', () async {
      configureAndStart(durationSeconds: 30);
      await Future<void>.delayed(Duration.zero);
      expect(await persistence.hasInterruptedSession(), isTrue);

      testNow = testNow.add(const Duration(seconds: 35));
      await Future<void>.delayed(const Duration(seconds: 1));

      // 完成后持久化数据已清除
      expect(await persistence.hasInterruptedSession(), isFalse);
    });
  });

  // ─── onAppResumed() 后台恢复 ───

  group('onAppResumed — background recovery', () {
    test('early return when status is not running', () async {
      configureAndStart();
      await Future<void>.delayed(Duration.zero);
      notifier.pause();
      await Future<void>.delayed(Duration.zero);

      final before = container.read(focusTimerProvider);
      expect(before.status, equals(TimerStatus.paused));

      await notifier.onAppResumed();
      await Future<void>.delayed(Duration.zero);

      // 状态不变
      final after = container.read(focusTimerProvider);
      expect(after.status, equals(TimerStatus.paused));
    });

    test('early return when pausedAt is null', () async {
      configureAndStart();
      await Future<void>.delayed(Duration.zero);

      // running 但没有 pausedAt（未进入后台）
      final before = container.read(focusTimerProvider);
      expect(before.status, equals(TimerStatus.running));
      expect(before.pausedAt, isNull);

      await notifier.onAppResumed();
      await Future<void>.delayed(Duration.zero);

      final after = container.read(focusTimerProvider);
      expect(after.status, equals(TimerStatus.running));
    });

    test('resumes ticker after short background (<30 min)', () async {
      configureAndStart(durationSeconds: 1500);
      await Future<void>.delayed(Duration.zero);

      // 模拟进入后台
      notifier.onAppBackgrounded();
      await Future<void>.delayed(Duration.zero);

      final backgrounded = container.read(focusTimerProvider);
      expect(backgrounded.pausedAt, isNotNull);
      expect(backgrounded.status, equals(TimerStatus.running));

      // 推进 5 分钟（< 30 分钟阈值）
      testNow = testNow.add(const Duration(minutes: 5));

      await notifier.onAppResumed();
      await Future<void>.delayed(Duration.zero);

      final resumed = container.read(focusTimerProvider);
      expect(resumed.status, equals(TimerStatus.running));
      expect(resumed.pausedAt, isNull);
      expect(resumed.elapsedSeconds, greaterThanOrEqualTo(300));
    });

    test('auto-completes after long background (>30 min)', () async {
      configureAndStart(durationSeconds: 1500);
      await Future<void>.delayed(Duration.zero);

      notifier.onAppBackgrounded();
      await Future<void>.delayed(Duration.zero);

      // 推进 31 分钟（> 30 分钟阈值）
      testNow = testNow.add(const Duration(minutes: 31));

      await notifier.onAppResumed();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.completed));
    });

    test(
      'auto-completes when countdown expired during short background',
      () async {
        // 10 秒倒计时
        configureAndStart(durationSeconds: 10);
        await Future<void>.delayed(Duration.zero);

        notifier.onAppBackgrounded();
        await Future<void>.delayed(Duration.zero);

        // 推进 15 秒（< 30 分钟，但倒计时已过期）
        testNow = testNow.add(const Duration(seconds: 15));

        await notifier.onAppResumed();
        await Future<void>.delayed(Duration.zero);

        final s = container.read(focusTimerProvider);
        expect(s.status, equals(TimerStatus.completed));
        expect(s.elapsedSeconds, equals(10)); // 封顶到 totalSeconds
      },
    );
  });

  // ─── _shouldAutoComplete 边界 ───

  group('_shouldAutoComplete — boundary', () {
    test('exactly 30 minutes does NOT trigger auto-complete', () async {
      configureAndStart(durationSeconds: 3600); // 60 分钟，不会因倒计时过期
      await Future<void>.delayed(Duration.zero);

      notifier.onAppBackgrounded();
      await Future<void>.delayed(Duration.zero);

      // 恰好 30 分钟
      testNow = testNow.add(const Duration(minutes: 30));

      await notifier.onAppResumed();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.running));
    });

    test('31 minutes triggers auto-complete', () async {
      configureAndStart(durationSeconds: 3600);
      await Future<void>.delayed(Duration.zero);

      notifier.onAppBackgrounded();
      await Future<void>.delayed(Duration.zero);

      testNow = testNow.add(const Duration(minutes: 31));

      await notifier.onAppResumed();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.completed));
    });
  });

  // ─── restoreSession() 恢复路径 ───

  group('restoreSession — recovery', () {
    test('no saved data leaves state idle', () async {
      await notifier.restoreSession();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.idle));
    });

    test('restores completed session and clears persistence', () async {
      // 手动保存一个已过期的会话状态
      final startedAt = testNow.subtract(const Duration(minutes: 30));
      final savedState = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500, // 25 分钟
        elapsedSeconds: 600,
        totalPausedSeconds: 0,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: startedAt,
      );
      await persistence.saveState(savedState);
      expect(await persistence.hasInterruptedSession(), isTrue);

      await notifier.restoreSession();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      // 30 分钟壁钟 > 25 分钟倒计时 → completed
      expect(s.status, equals(TimerStatus.completed));
      expect(s.elapsedSeconds, equals(1500));
      // 恢复完成后清除持久化
      expect(await persistence.hasInterruptedSession(), isFalse);
    });

    test('restores in-progress session as paused', () async {
      final startedAt = testNow.subtract(const Duration(minutes: 10));
      final savedState = FocusTimerState(
        habitId: 'h1',
        catId: 'c1',
        catName: 'Mochi',
        habitName: 'Reading',
        totalSeconds: 1500,
        elapsedSeconds: 200,
        totalPausedSeconds: 0,
        status: TimerStatus.running,
        mode: TimerMode.countdown,
        startedAt: startedAt,
      );
      await persistence.saveState(savedState);

      await notifier.restoreSession();
      await Future<void>.delayed(Duration.zero);

      final s = container.read(focusTimerProvider);
      expect(s.status, equals(TimerStatus.paused));
      expect(s.elapsedSeconds, equals(600)); // 10 分钟壁钟
      expect(s.pausedAt, equals(testNow));
    });
  });
}
