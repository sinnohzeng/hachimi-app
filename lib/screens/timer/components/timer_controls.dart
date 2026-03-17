import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';

/// 按钮高度常量 — 所有计时器控制按钮共享。
const double _buttonHeight = 56;

/// 计时器控制按钮区：根据 idle/running/paused 状态展示不同按钮组合。
class TimerControls extends StatelessWidget {
  final TimerStatus status;
  final TimerMode mode;
  final bool isLoading;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;

  const TimerControls({
    super.key,
    required this.status,
    required this.mode,
    this.isLoading = false,
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
    if (isLoading) {
      return SizedBox(
        width: double.infinity,
        height: _buttonHeight,
        child: FilledButton(
          onPressed: null,
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }
    return _TimerActionButton(
      onPressed: onStart,
      icon: Icons.play_arrow,
      label: context.l10n.timerStart,
      isPrimary: true,
      fullWidth: true,
    );
  }

  Widget _buildRunningButtons(BuildContext context) {
    if (mode != TimerMode.stopwatch) {
      return _TimerActionButton(
        onPressed: onPause,
        icon: Icons.pause,
        label: context.l10n.timerPause,
        fullWidth: true,
      );
    }
    return Row(
      children: [
        Expanded(
          child: _TimerActionButton(
            onPressed: onPause,
            icon: Icons.pause,
            label: context.l10n.timerPause,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _TimerActionButton(
            onPressed: onComplete,
            icon: Icons.check,
            label: context.l10n.timerDone,
            isPrimary: true,
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
          child: _TimerActionButton(
            onPressed: onResume,
            icon: Icons.play_arrow,
            label: l10n.timerResume,
            isPrimary: true,
          ),
        ),
        if (mode == TimerMode.stopwatch) ...[
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _TimerActionButton(
              onPressed: onComplete,
              icon: Icons.check,
              label: l10n.timerDone,
            ),
          ),
        ],
      ],
    );
  }
}

/// 计时器操作按钮 — 统一高度和样式，消除按钮布局重复。
class _TimerActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool fullWidth;

  const _TimerActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: isPrimary ? theme.colorScheme.onPrimary : null,
    );

    final button = isPrimary
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 28),
            label: Text(label, style: style),
          )
        : FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: Icon(icon, size: 28),
            label: Text(label, style: style),
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _buttonHeight,
      child: button,
    );
  }
}
