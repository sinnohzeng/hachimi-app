import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 分页历史记录状态。
class SessionHistoryState {
  final List<FocusSession> sessions;
  final bool isLoading;
  final bool hasMore;
  final String? filterHabitId;
  final int offset; // SQLite offset 游标
  final String? error;
  final DateTime? selectedMonth;

  const SessionHistoryState({
    this.sessions = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.filterHabitId,
    this.offset = 0,
    this.error,
    this.selectedMonth,
  });

  SessionHistoryState copyWith({
    List<FocusSession>? sessions,
    bool? isLoading,
    bool? hasMore,
    String? Function()? filterHabitId,
    int? offset,
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
      offset: offset ?? this.offset,
      error: error != null ? error() : this.error,
      selectedMonth: selectedMonth != null
          ? selectedMonth()
          : this.selectedMonth,
    );
  }
}

/// 历史记录 Notifier — 管理分页加载和筛选（SQLite 版）。
class SessionHistoryNotifier extends Notifier<SessionHistoryState> {
  static const _pageSize = 20;

  @override
  SessionHistoryState build() {
    Future.microtask(loadMore);
    return const SessionHistoryState(isLoading: true);
  }

  /// 加载下一页数据。
  Future<void> loadMore() async {
    if (state.isLoading && state.sessions.isNotEmpty) return;
    if (!state.hasMore) return;
    state = state.copyWith(isLoading: true, error: () => null);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) {
        state = state.copyWith(isLoading: false, hasMore: false);
        return;
      }

      // 月份筛选格式
      String? monthStr;
      if (state.selectedMonth != null) {
        final m = state.selectedMonth!;
        monthStr = '${m.year}-${m.month.toString().padLeft(2, '0')}';
      }

      final sessionRepo = ref.read(localSessionRepositoryProvider);
      final result = await sessionRepo.getSessionHistory(
        uid,
        habitId: state.filterHabitId,
        month: monthStr,
        limit: _pageSize,
        offset: state.offset,
      );

      state = state.copyWith(
        sessions: [...state.sessions, ...result],
        isLoading: false,
        hasMore: result.length >= _pageSize,
        offset: state.offset + result.length,
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

  /// 重试加载。
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
