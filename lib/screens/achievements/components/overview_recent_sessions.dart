import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/session_stats_provider.dart';
import 'package:intl/intl.dart';

/// 最近会话卡片 — 显示最近的专注会话列表及「查看全部」入口。
class OverviewRecentSessions extends ConsumerWidget {
  const OverviewRecentSessions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(recentSessionsProvider);
    final habits = ref.watch(habitsProvider).value ?? [];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: AppSpacing.paddingHBase,
      child: Card(
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: sessionsAsync.when(
            loading: () => const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => const SizedBox(height: 80),
            data: (sessions) {
              if (sessions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      l10n.historyNoSessions,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...sessions.map((session) {
                    final habit = habits
                        .where((h) => h.id == session.habitId)
                        .firstOrNull;
                    return _SessionTile(
                      session: session,
                      habitName: habit?.name ?? '',
                    );
                  }),
                  const Divider(height: 1),
                  TextButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRouter.sessionHistory),
                    child: Text(l10n.statsViewAllHistory),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final FocusSession session;
  final String habitName;

  const _SessionTile({required this.session, required this.habitName});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final modeLabel = session.mode == 'countdown'
        ? l10n.sessionCountdown
        : l10n.sessionStopwatch;
    final statusIcon = session.isCompleted
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;
    final statusColor = session.isCompleted
        ? colorScheme.primary
        : colorScheme.error;
    final timeStr = DateFormat.Hm().format(session.endedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${session.durationMinutes} min · $modeLabel · $timeStr',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (session.coinsEarned > 0)
            Text(
              '+${session.coinsEarned}',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
