import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';

/// 计时器控制按钮区：根据 idle/running/paused 状态展示不同按钮组合。
class TimerControls extends StatelessWidget {
  final TimerStatus status;
  final TimerMode mode;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;

  const TimerControls({
    super.key,
    required this.status,
    required this.mode,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: switch (status) {
        TimerStatus.idle => _buildIdleButton(context),
        TimerStatus.running => _buildRunningButtons(context),
        TimerStatus.paused => _buildPausedButtons(context),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildIdleButton(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow, size: 28),
        label: Text(
          context.l10n.timerStart,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRunningButtons(BuildContext context) {
    final theme = Theme.of(context);
    if (mode != TimerMode.stopwatch) {
      return _buildSinglePauseButton(context, theme);
    }
    return _buildPauseAndDoneRow(context, theme);
  }

  Widget _buildSinglePauseButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.tonalIcon(
        onPressed: onPause,
        icon: const Icon(Icons.pause, size: 28),
        label: Text(
          context.l10n.timerPause,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPauseAndDoneRow(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.tonalIcon(
              onPressed: onPause,
              icon: const Icon(Icons.pause, size: 28),
              label: Text(
                context.l10n.timerPause,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: onComplete,
              icon: const Icon(Icons.check, size: 28),
              label: Text(
                context.l10n.timerDone,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPausedButtons(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.timerResume),
            ),
          ),
        ),
        if (mode == TimerMode.stopwatch) ...[
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SizedBox(
              height: 56,
              child: FilledButton.tonalIcon(
                onPressed: onComplete,
                icon: const Icon(Icons.check),
                label: Text(l10n.timerDone),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
