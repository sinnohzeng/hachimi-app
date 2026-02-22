import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
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
  final String? error; // 错误信息
  final DateTime? selectedMonth; // 月份筛选

  const SessionHistoryState({
    this.sessions = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.filterHabitId,
    this.lastDocument,
    this.error,
    this.selectedMonth,
  });

  SessionHistoryState copyWith({
    List<FocusSession>? sessions,
    bool? isLoading,
    bool? hasMore,
    String? Function()? filterHabitId,
    DocumentSnapshot? Function()? lastDocument,
    String? Function()? error,
    DateTime? Function()? selectedMonth,
  }) {
    return SessionHistoryState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      filterHabitId: filterHabitId != null
          ? filterHabitId()
          : this.filterHabitId,
      lastDocument: lastDocument != null ? lastDocument() : this.lastDocument,
      error: error != null ? error() : this.error,
      selectedMonth: selectedMonth != null
          ? selectedMonth()
          : this.selectedMonth,
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
    state = state.copyWith(isLoading: true, error: () => null);

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

      // 计算月份筛选的时间边界
      DateTime? startDate;
      DateTime? endDate;
      if (state.selectedMonth != null) {
        final m = state.selectedMonth!;
        startDate = DateTime(m.year, m.month);
        endDate = DateTime(m.year, m.month + 1);
      }

      final result = await ref
          .read(firestoreServiceProvider)
          .getSessionHistory(
            uid: uid,
            habitIds: habitIds,
            habitId: state.filterHabitId,
            limit: _pageSize,
            startAfter: state.lastDocument,
            startDate: startDate,
            endDate: endDate,
          );

      state = state.copyWith(
        sessions: [...state.sessions, ...result.sessions],
        isLoading: false,
        hasMore: result.sessions.length >= _pageSize,
        lastDocument: () => result.lastDoc,
      );
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'SessionHistoryNotifier',
        operation: 'loadMore',
      );
      state = state.copyWith(isLoading: false, error: e.toString);
    }
  }

  /// 切换 habit 筛选条件，重新加载。
  void setFilter(String? habitId) {
    state = SessionHistoryState(
      isLoading: true,
      filterHabitId: habitId,
      selectedMonth: state.selectedMonth,
    );
    Future.microtask(loadMore);
  }

  /// 切换月份筛选，重新加载。
  void setMonth(DateTime? month) {
    state = SessionHistoryState(
      isLoading: true,
      filterHabitId: state.filterHabitId,
      selectedMonth: month,
    );
    Future.microtask(loadMore);
  }

  /// 重试加载（清除错误状态后重新加载）。
  void retry() {
    state = SessionHistoryState(
      isLoading: true,
      filterHabitId: state.filterHabitId,
      selectedMonth: state.selectedMonth,
    );
    Future.microtask(loadMore);
  }
}

final sessionHistoryProvider =
    NotifierProvider<SessionHistoryNotifier, SessionHistoryState>(
      SessionHistoryNotifier.new,
    );
