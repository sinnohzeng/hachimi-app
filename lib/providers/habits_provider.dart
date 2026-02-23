import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Habits list — SSOT from local SQLite.
/// 监听 LedgerService 变更事件自动刷新。
final habitsProvider = StreamProvider<List<Habit>>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield [];
    return;
  }

  final habitRepo = ref.watch(localHabitRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  // 初始值：直接从 SQLite 读取
  yield await habitRepo.getActiveHabits(uid);

  // 监听变更：台账写入后 yield 最新数据
  await for (final change in ledger.changes) {
    if (change.type.startsWith('habit_') || change.type == 'focus_complete') {
      yield await habitRepo.getActiveHabits(uid);
    }
  }
});

/// Today's sessions — from local SQLite.
final todaySessionsProvider = FutureProvider<List<FocusSession>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final sessionRepo = ref.watch(localSessionRepositoryProvider);

  // 监听 focus_complete 变更以自动刷新
  ref.listen(ledgerChangesProvider, (_, _) {});

  return sessionRepo.getTodaySessions(uid);
});

/// LedgerService.changes 作为 StreamProvider，供其他 provider 监听。
final ledgerChangesProvider = StreamProvider<void>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return ledger.changes.map((_) {});
});

/// Today's minutes per habit — derived from todaySessionsProvider.
final todayMinutesPerHabitProvider = Provider<Map<String, int>>((ref) {
  final sessions = ref.watch(todaySessionsProvider).value ?? [];
  final map = <String, int>{};
  for (final session in sessions) {
    map[session.habitId] =
        (map[session.habitId] ?? 0) + session.durationMinutes;
  }
  return map;
});
