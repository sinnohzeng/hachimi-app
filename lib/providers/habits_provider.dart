import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

/// Habits list — SSOT from local SQLite.
/// 监听 LedgerService 变更事件自动刷新。
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<Habit>[]);

  final habitRepo = ref.watch(localHabitRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type.isHabitAction ||
        c.type == ActionType.focusComplete,
    read: () => habitRepo.getActiveHabits(uid),
  );
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
