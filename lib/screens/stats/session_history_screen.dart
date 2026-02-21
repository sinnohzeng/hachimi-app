import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/session_history_provider.dart';
import 'package:hachimi_app/widgets/empty_state.dart';
import 'package:intl/intl.dart';

/// 完整专注历史记录页面 — 支持分页加载、按习惯筛选、按日期分组。
class SessionHistoryScreen extends ConsumerStatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  ConsumerState<SessionHistoryScreen> createState() =>
      _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends ConsumerState<SessionHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 记录历史页浏览
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logHistoryViewed();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(sessionHistoryProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(sessionHistoryProvider);
    final habits = ref.watch(habitsProvider).value ?? <Habit>[];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    // 按日期分组
    final grouped = _groupByDate(historyState.sessions);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: Column(
        children: [
          // FilterChip 横向滚动
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(l10n.historyFilterAll),
                    selected: historyState.filterHabitId == null,
                    onSelected: (_) {
                      ref
                          .read(sessionHistoryProvider.notifier)
                          .setFilter(null);
                    },
                  ),
                ),
                ...habits.map((habit) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(habit.name),
                      selected: historyState.filterHabitId == habit.id,
                      onSelected: (_) {
                        ref
                            .read(sessionHistoryProvider.notifier)
                            .setFilter(habit.id);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // 内容区域
          Expanded(
            child: _buildContent(
              context,
              historyState,
              grouped,
              habits,
              colorScheme,
              textTheme,
              l10n,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SessionHistoryState historyState,
    List<_DateGroup> grouped,
    List<Habit> habits,
    ColorScheme colorScheme,
    TextTheme textTheme,
    S l10n,
  ) {
    // 首次加载中
    if (historyState.isLoading && historyState.sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 空状态
    if (!historyState.isLoading && historyState.sessions.isEmpty) {
      return EmptyState(
        icon: Icons.history,
        title: l10n.historyNoSessions,
        subtitle: l10n.historyNoSessionsHint,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: AppSpacing.paddingHBase,
      itemCount: grouped.length + (historyState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= grouped.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final group = grouped[index];
        return _DateGroupCard(
          group: group,
          habits: habits,
        );
      },
    );
  }

  /// 按日期分组会话记录。
  List<_DateGroup> _groupByDate(List<FocusSession> sessions) {
    final map = <String, List<FocusSession>>{};
    for (final session in sessions) {
      final key = DateFormat('yyyy-MM-dd').format(session.endedAt);
      map.putIfAbsent(key, () => []).add(session);
    }

    final sorted = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return sorted.map((entry) {
      final totalMinutes = entry.value.fold(
        0,
        (sum, s) => sum + s.durationMinutes,
      );
      return _DateGroup(
        dateKey: entry.key,
        sessions: entry.value,
        totalMinutes: totalMinutes,
      );
    }).toList();
  }
}

class _DateGroup {
  final String dateKey;
  final List<FocusSession> sessions;
  final int totalMinutes;

  const _DateGroup({
    required this.dateKey,
    required this.sessions,
    required this.totalMinutes,
  });
}

class _DateGroupCard extends StatelessWidget {
  final _DateGroup group;
  final List<Habit> habits;

  const _DateGroupCard({required this.group, required this.habits});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    final dateLabel = _formatDateLabel(context, group.dateKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期分组头
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
          child: Row(
            children: [
              Text(
                dateLabel,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                l10n.historySessionCount(group.sessions.length),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.historyTotalMinutes(group.totalMinutes),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // 会话列表
        Card(
          child: Column(
            children: [
              for (int i = 0; i < group.sessions.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
                _SessionItem(
                  session: group.sessions[i],
                  habitName: _habitName(group.sessions[i].habitId),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _habitName(String habitId) {
    final habit = habits.where((h) => h.id == habitId).firstOrNull;
    return habit?.name ?? '';
  }

  String _formatDateLabel(BuildContext context, String dateKey) {
    final l10n = context.l10n;
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return l10n.historyDateGroupToday;
    if (dateOnly == yesterday) return l10n.historyDateGroupYesterday;

    final locale = Localizations.localeOf(context).toString();
    if (date.year == now.year) {
      return DateFormat.MMMd(locale).format(date);
    }
    return DateFormat.yMMMd(locale).format(date);
  }
}

class _SessionItem extends StatelessWidget {
  final FocusSession session;
  final String habitName;

  const _SessionItem({required this.session, required this.habitName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    final statusLabel = session.isCompleted
        ? l10n.sessionCompleted
        : l10n.sessionAbandoned;
    final statusIcon = session.isCompleted
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;
    final statusColor = session.isCompleted
        ? colorScheme.primary
        : colorScheme.error;
    final modeLabel = session.mode == 'countdown'
        ? l10n.sessionCountdown
        : l10n.sessionStopwatch;
    final timeStr = DateFormat.Hm().format(session.endedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(statusIcon, size: 20, color: statusColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.durationMinutes} min · $modeLabel · $statusLabel',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (session.coinsEarned > 0)
                Text(
                  '+${session.coinsEarned}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
