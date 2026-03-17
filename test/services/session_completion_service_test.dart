// ---
// 📘 SessionCompletionService 单元测试
// 验证会话完成的业务编排逻辑：奖励计算、持久化、分析上报。
// 使用 Fake 实现注入依赖，无 Mockito。
//
// 🕒 创建时间：2026-03-17
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/session_completion_service.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/coin_service.dart';
import 'package:hachimi_app/services/local_cat_repository.dart';
import 'package:hachimi_app/services/local_habit_repository.dart';
import 'package:hachimi_app/services/local_session_repository.dart';
import 'package:hachimi_app/services/xp_service.dart';

// ─── Fakes ───

class FakeLocalSessionRepository implements LocalSessionRepository {
  final loggedSessions = <FocusSession>[];

  @override
  Future<void> logSession(String uid, FocusSession session) async {
    loggedSessions.add(session);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeLocalHabitRepository implements LocalHabitRepository {
  final updates = <Map<String, dynamic>>[];

  @override
  Future<void> updateProgress(
    String uid,
    String habitId, {
    required int addMinutes,
    required String checkInDate,
  }) async {
    updates.add({
      'uid': uid,
      'habitId': habitId,
      'addMinutes': addMinutes,
      'checkInDate': checkInDate,
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeLocalCatRepository implements LocalCatRepository {
  final updates = <Map<String, dynamic>>[];

  @override
  Future<void> updateProgress(
    String uid,
    String catId, {
    required int addMinutes,
    required DateTime sessionAt,
  }) async {
    updates.add({
      'uid': uid,
      'catId': catId,
      'addMinutes': addMinutes,
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeCoinService implements CoinService {
  int totalCoinsEarned = 0;

  @override
  Future<void> earnCoins({required String uid, required int amount}) async {
    totalCoinsEarned += amount;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeAnalyticsService implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> logFocusSessionCompleted({
    required String habitId,
    required int actualMinutes,
    required int xpEarned,
    int? targetDurationMinutes,
    int? pausedSeconds,
    double? completionRatio,
  }) async {
    events.add('completed:$habitId:${actualMinutes}min');
  }

  @override
  Future<void> logFocusSessionAbandoned({
    required String habitId,
    required int minutesCompleted,
    required String reason,
    int? targetDurationMinutes,
    int? pausedSeconds,
    double? completionRatio,
  }) async {
    events.add('abandoned:$habitId:${minutesCompleted}min');
  }

  @override
  Future<void> logCoinsEarned({required int amount, required String source}) async {
    events.add('coins:$amount:$source');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// ─── Test Helpers ───

Habit _makeHabit({String id = 'h1', String? catId = 'c1'}) => Habit(
      id: id,
      name: 'Reading',
      catId: catId,
      goalMinutes: 25,
      createdAt: DateTime(2026, 1, 1),
    );

FocusTimerState _makeTimerState({
  int totalSeconds = 1500,
  int elapsedSeconds = 1500,
  TimerStatus status = TimerStatus.completed,
  TimerMode mode = TimerMode.countdown,
}) =>
    FocusTimerState(
      habitId: 'h1',
      catId: 'c1',
      catName: 'Mochi',
      habitName: 'Reading',
      totalSeconds: totalSeconds,
      elapsedSeconds: elapsedSeconds,
      status: status,
      mode: mode,
      startedAt: DateTime(2026, 3, 17, 10, 0, 0),
    );

// ─── Tests ───

void main() {
  late FakeLocalSessionRepository fakeSessions;
  late FakeLocalHabitRepository fakeHabits;
  late FakeLocalCatRepository fakeCats;
  late FakeCoinService fakeCoins;
  late FakeAnalyticsService fakeAnalytics;
  late SessionCompletionService service;

  setUp(() {
    fakeSessions = FakeLocalSessionRepository();
    fakeHabits = FakeLocalHabitRepository();
    fakeCats = FakeLocalCatRepository();
    fakeCoins = FakeCoinService();
    fakeAnalytics = FakeAnalyticsService();

    service = SessionCompletionService(
      sessions: fakeSessions,
      habits: fakeHabits,
      cats: fakeCats,
      coins: fakeCoins,
      analytics: fakeAnalytics,
      xp: XpService(),
    );
  });

  group('SessionCompletionService', () {
    test('discards abandoned session under 5 minutes', () async {
      final result = await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(
          elapsedSeconds: 180, // 3 min
          status: TimerStatus.abandoned,
        ),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(result.isDiscarded, isTrue);
      expect(fakeSessions.loggedSessions, isEmpty);
      expect(fakeHabits.updates, isEmpty);
      expect(fakeCoins.totalCoinsEarned, equals(0));
    });

    test('keeps abandoned session at 5+ minutes', () async {
      final result = await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(
          elapsedSeconds: 300, // 5 min
          status: TimerStatus.abandoned,
        ),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(result.isDiscarded, isFalse);
      expect(result.minutes, equals(5));
      expect(fakeSessions.loggedSessions, hasLength(1));
      expect(fakeSessions.loggedSessions.first.status, equals('abandoned'));
    });

    test('calculates correct coins from minutes', () async {
      final result = await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(elapsedSeconds: 1500), // 25 min
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      // 25 min × focusRewardCoinsPerMinute (= 2) = 50 coins
      expect(result.rewards!.coins, equals(50));
      expect(fakeCoins.totalCoinsEarned, equals(50));
    });

    test('persists session to local repository', () async {
      await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(fakeSessions.loggedSessions, hasLength(1));
      final session = fakeSessions.loggedSessions.first;
      expect(session.habitId, equals('h1'));
      expect(session.status, equals('completed'));
      expect(session.durationMinutes, equals(25));
    });

    test('updates habit and cat progress on completion', () async {
      await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(),
        habit: _makeHabit(catId: 'c1'),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(fakeHabits.updates, hasLength(1));
      expect(fakeHabits.updates.first['habitId'], equals('h1'));
      expect(fakeHabits.updates.first['addMinutes'], equals(25));

      expect(fakeCats.updates, hasLength(1));
      expect(fakeCats.updates.first['catId'], equals('c1'));
      expect(fakeCats.updates.first['addMinutes'], equals(25));
    });

    test('does not update habit/cat progress on abandoned session', () async {
      await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(
          elapsedSeconds: 600, // 10 min
          status: TimerStatus.abandoned,
        ),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      // 放弃的会话不更新进度
      expect(fakeHabits.updates, isEmpty);
      expect(fakeCats.updates, isEmpty);
    });

    test('logs analytics for completed session', () async {
      await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(
        fakeAnalytics.events,
        contains(startsWith('completed:h1:')),
      );
      expect(
        fakeAnalytics.events,
        contains(startsWith('coins:')),
      );
    });

    test('logs analytics for abandoned session', () async {
      await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(
          elapsedSeconds: 600,
          status: TimerStatus.abandoned,
        ),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(
        fakeAnalytics.events,
        contains(startsWith('abandoned:h1:')),
      );
    });

    test('skips cat update when habit has no catId', () async {
      await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(),
        habit: _makeHabit(catId: null),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(fakeHabits.updates, hasLength(1));
      expect(fakeCats.updates, isEmpty);
    });

    test('XP includes full-house bonus when all habits done', () async {
      final habits = [
        _makeHabit(id: 'h1'),
        _makeHabit(id: 'h2'),
      ];

      final result = await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(elapsedSeconds: 1500),
        habit: habits.first,
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {'h1': 25, 'h2': 30},
        activeHabits: habits,
      );

      // 全勤奖 = 10 XP
      expect(result.rewards!.xp.fullHouseBonus, equals(10));
      expect(result.rewards!.xp.totalXp, equals(25 + 10));
    });

    test('stopwatch mode returns completionRatio 1.0', () async {
      final result = await service.completeSession(
        uid: 'u1',
        habitId: 'h1',
        timerState: _makeTimerState(
          mode: TimerMode.stopwatch,
          elapsedSeconds: 600,
        ),
        habit: _makeHabit(),
        clientVersion: '1.0.0',
        todayMinutesPerHabit: {},
        activeHabits: [],
      );

      expect(result.session!.completionRatio, equals(1.0));
    });
  });
}
