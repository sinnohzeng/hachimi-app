import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

// ─── 清单 ───

/// 当前年度所有清单 — 台账变更自动刷新。
final currentYearListsProvider = StreamProvider<List<UserList>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<UserList>[]);

  final repo = ref.watch(listHighlightRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.listUpdated,
    read: () => repo.getListsByYear(uid, DateTime.now().year),
  );
});

// ─── 高光时刻 ───

/// 当前年度幸福时刻 — 台账变更自动刷新。
final happyMomentsProvider = StreamProvider<List<HighlightEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<HighlightEntry>[]);

  final repo = ref.watch(listHighlightRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.highlightRecorded,
    read: () =>
        repo.getHighlightsByYear(uid, DateTime.now().year, HighlightType.happy),
  );
});

/// 当前年度高光时刻 — 台账变更自动刷新。
final highlightMomentsProvider = StreamProvider<List<HighlightEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<HighlightEntry>[]);

  final repo = ref.watch(listHighlightRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.highlightRecorded,
    read: () => repo.getHighlightsByYear(
      uid,
      DateTime.now().year,
      HighlightType.highlight,
    ),
  );
});
