import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';

/// 分页历史记录状态。
class SessionHistoryState {
  final List<FocusSession> sessions;
  final bool isLoading;
  final bool hasMore;
  final String? filterHabitId; // null = 全部
  final DocumentSnapshot? lastDocument; // Firestore 游标

  const SessionHistoryState({
    this.sessions = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.filterHabitId,
    this.lastDocument,
  });

  SessionHistoryState copyWith({
    List<FocusSession>? sessions,
    bool? isLoading,
    bool? hasMore,
    String? Function()? filterHabitId,
    DocumentSnapshot? Function()? lastDocument,
  }) {
    return SessionHistoryState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      filterHabitId:
          filterHabitId != null ? filterHabitId() : this.filterHabitId,
      lastDocument:
          lastDocument != null ? lastDocument() : this.lastDocument,
    );
  }
}

/// 历史记录 Notifier — 管理分页加载和筛选。
class SessionHistoryNotifier extends Notifier<SessionHistoryState> {
  static const _pageSize = 20;

  @override
  SessionHistoryState build() {
    // 首次构建时自动加载第一页
    Future.microtask(loadMore);
    return const SessionHistoryState(isLoading: true);
  }

  /// 加载下一页数据。
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) {
        state = state.copyWith(isLoading: false, hasMore: false);
        return;
      }

      final habits = ref.read(habitsProvider).value ?? [];
      final habitIds = habits.map((h) => h.id).toList();
      if (habitIds.isEmpty) {
        state = state.copyWith(isLoading: false, hasMore: false);
        return;
      }

      final result = await ref.read(firestoreServiceProvider).getSessionHistory(
        uid: uid,
        habitIds: habitIds,
        habitId: state.filterHabitId,
        limit: _pageSize,
        startAfter: state.lastDocument,
      );

      state = state.copyWith(
        sessions: [...state.sessions, ...result.sessions],
        isLoading: false,
        hasMore: result.sessions.length >= _pageSize,
        lastDocument: () => result.lastDoc,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 切换筛选条件，重新加载。
  void setFilter(String? habitId) {
    state = SessionHistoryState(
      isLoading: true,
      filterHabitId: habitId,
    );
    Future.microtask(loadMore);
  }
}

final sessionHistoryProvider =
    NotifierProvider<SessionHistoryNotifier, SessionHistoryState>(
  SessionHistoryNotifier.new,
);
