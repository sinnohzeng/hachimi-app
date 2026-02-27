import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/background_color_utils.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/animated_mesh_background.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/core/utils/session_checksum.dart';
import 'package:hachimi_app/providers/app_info_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    show ServiceRequestFailure;
import 'package:uuid/uuid.dart';

/// Focus timer in-progress screen.
/// Full-screen immersive view with pixel cat, circular progress, and timer.
class TimerScreen extends ConsumerStatefulWidget {
  final String habitId;

  const TimerScreen({super.key, required this.habitId});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  bool _hasStarted = false;
  bool _sessionSaved = false;
  bool _showPermissionBanner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusTimerService.addActionListener(_onNotificationAction);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startTimer();
    });
  }

  @override
  void dispose() {
    FocusTimerService.removeActionListener(_onNotificationAction);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onNotificationAction(Object data) {
    if (data is Map<String, dynamic>) {
      if (data['action'] == 'pause') {
        final status = ref.read(focusTimerProvider).status;
        if (status == TimerStatus.running) {
          _pauseTimer();
        } else if (status == TimerStatus.paused) {
          _resumeTimer();
        }
      } else if (data['action'] == 'end') {
        _completeTimer();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timerNotifier = ref.read(focusTimerProvider.notifier);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      timerNotifier.onAppBackgrounded();
    } else if (state == AppLifecycleState.resumed) {
      timerNotifier.onAppResumed();
    }
  }

  // ─── Timer controls ───

  void _startTimer() async {
    final timerState = ref.read(focusTimerProvider);
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;

    await _ensureNotificationPermission();

    final result = await FocusTimerService.start(
      habitName: habit?.name ?? 'Focus',
      catEmoji: '🐱',
      totalSeconds: timerState.totalSeconds,
      isCountdown: timerState.mode == TimerMode.countdown,
    );
    if (result is ServiceRequestFailure && mounted) {
      setState(() => _showPermissionBanner = true);
    }

    if (!mounted) return;
    ref.read(focusTimerProvider.notifier).start();
    setState(() => _hasStarted = true);

    ref
        .read(analyticsServiceProvider)
        .logFocusSessionStarted(
          habitId: widget.habitId,
          timerMode: timerState.mode == TimerMode.countdown
              ? 'countdown'
              : 'stopwatch',
          targetMinutes: timerState.totalSeconds ~/ 60,
        );
  }

  Future<void> _ensureNotificationPermission() async {
    final notifService = ref.read(notificationServiceProvider);
    var hasPermission = await notifService.isPermissionGranted();
    if (!hasPermission) {
      hasPermission = await notifService.requestPermission();
    }
    if (!hasPermission && mounted) {
      setState(() => _showPermissionBanner = true);
    }
  }

  void _pauseTimer() => ref.read(focusTimerProvider.notifier).pause();
  void _resumeTimer() => ref.read(focusTimerProvider.notifier).resume();
  void _completeTimer() => ref.read(focusTimerProvider.notifier).complete();

  void _goBack() {
    FocusTimerService.stop();
    ref.read(focusTimerProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  Future<void> _giveUp() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.giveUpTitle),
        content: Text(l10n.giveUpMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.giveUpKeepGoing),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.giveUpConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      HapticFeedback.mediumImpact();
      ref.read(focusTimerProvider.notifier).abandon();
    }
  }

  // ─── Session save ───

  /// 监听计时器终态（完成/放弃），触发会话保存。
  void _onTimerTerminated(FocusTimerState? prev, FocusTimerState next) {
    if (_sessionSaved) return;
    final isTerminal =
        next.status == TimerStatus.completed ||
        next.status == TimerStatus.abandoned;
    if (!isTerminal) return;
    _sessionSaved = true;
    if (next.status == TimerStatus.completed) {
      HapticFeedback.heavyImpact();
    }
    _saveSession(next);
  }

  Future<void> _saveSession(FocusTimerState timerState) async {
    FocusTimerService.stop();

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    if (habit == null) return;

    final minutes = timerState.focusedMinutes;
    final isAbandoned = timerState.status == TimerStatus.abandoned;

    if (isAbandoned && minutes < 5) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final rewards = _calculateRewards(minutes, habit);
    final session = _buildSessionRecord(timerState, habit, minutes, rewards);
    ErrorHandler.breadcrumb(
      'focus_completed: ${habit.name}, ${minutes}min, ${rewards.coins}coins',
    );

    await _persistSession(uid, session, timerState, habit, minutes, rewards);
    if (mounted) _navigateToResult(timerState, habit, minutes, rewards);
  }

  _SessionRewards _calculateRewards(int minutes, Habit habit) {
    final coins = minutes * focusRewardCoinsPerMinute;
    final xpService = ref.read(xpServiceProvider);
    final todayMap = ref.read(todayMinutesPerHabitProvider);
    final habits = ref.read(habitsProvider).value ?? [];
    final activeHabits = habits.where((h) => h.isActive).toList();
    final allDone =
        activeHabits.isNotEmpty &&
        activeHabits.every((h) => (todayMap[h.id] ?? 0) >= h.goalMinutes);

    final xp = xpService.calculateXp(minutes: minutes, allHabitsDone: allDone);

    final cat = habit.catId != null
        ? ref.read(catByIdProvider(habit.catId!))
        : null;
    final stageUp = cat != null
        ? xpService.checkStageUp(
            oldTotalMinutes: cat.totalMinutes,
            newTotalMinutes: cat.totalMinutes + minutes,
          )
        : null;

    return _SessionRewards(coins: coins, xp: xp, stageUp: stageUp);
  }

  FocusSession _buildSessionRecord(
    FocusTimerState timerState,
    Habit habit,
    int minutes,
    _SessionRewards rewards,
  ) {
    final modeStr = timerState.mode == TimerMode.countdown
        ? 'countdown'
        : 'stopwatch';
    final targetMinutes = timerState.mode == TimerMode.countdown
        ? timerState.totalSeconds ~/ 60
        : 0;
    final completionRatio = targetMinutes > 0
        ? (minutes / targetMinutes).clamp(0.0, 1.0)
        : 1.0;
    final startedAt = timerState.startedAt ?? DateTime.now();
    final clientVersion = ref.read(appInfoProvider).value?.version ?? '';

    return FocusSession(
      id: const Uuid().v4(),
      habitId: widget.habitId,
      catId: habit.catId ?? '',
      startedAt: startedAt,
      endedAt: DateTime.now(),
      durationMinutes: minutes,
      targetDurationMinutes: targetMinutes,
      pausedSeconds: timerState.totalPausedSeconds,
      status: timerState.status == TimerStatus.completed
          ? 'completed'
          : 'abandoned',
      completionRatio: completionRatio,
      xpEarned: rewards.xp.totalXp,
      coinsEarned: rewards.coins,
      mode: modeStr,
      checksum: SessionChecksum.compute(
        habitId: widget.habitId,
        durationMinutes: minutes,
        coinsEarned: rewards.coins,
        xpEarned: rewards.xp.totalXp,
        startedAt: startedAt,
      ),
      clientVersion: clientVersion,
    );
  }

  Future<void> _persistSession(
    String uid,
    FocusSession session,
    FocusTimerState timerState,
    Habit habit,
    int minutes,
    _SessionRewards rewards,
  ) async {
    await ref.read(localSessionRepositoryProvider).logSession(uid, session);

    if (timerState.status == TimerStatus.completed) {
      await _updateHabitAndCatProgress(uid, habit, minutes);
    }

    if (rewards.coins > 0) {
      await ref
          .read(coinServiceProvider)
          .earnCoins(uid: uid, amount: rewards.coins);
    }
  }

  /// 更新习惯和猫的累计进度（仅已完成 session 调用）。
  Future<void> _updateHabitAndCatProgress(
    String uid,
    Habit habit,
    int minutes,
  ) async {
    final today = AppDateUtils.todayString();
    await ref
        .read(localHabitRepositoryProvider)
        .updateProgress(
          uid,
          widget.habitId,
          addMinutes: minutes,
          checkInDate: today,
        );
    if (habit.catId != null) {
      await ref
          .read(localCatRepositoryProvider)
          .updateProgress(
            uid,
            habit.catId!,
            addMinutes: minutes,
            sessionAt: DateTime.now(),
          );
    }
  }

  void _navigateToResult(
    FocusTimerState timerState,
    Habit habit,
    int minutes,
    _SessionRewards rewards,
  ) {
    final isCompleted = timerState.status == TimerStatus.completed;
    final isAbandoned = timerState.status == TimerStatus.abandoned;

    _logSessionAnalytics(timerState, minutes, rewards);

    if (isCompleted) {
      final cat = habit.catId != null
          ? ref.read(catByIdProvider(habit.catId!))
          : null;
      final catName = cat?.name ?? context.l10n.focusCompleteYourCat;
      ref
          .read(notificationServiceProvider)
          .showFocusComplete(
            title: context.l10n.focusCompleteNotifTitle,
            body: context.l10n.focusCompleteNotifBody(
              catName,
              rewards.xp.totalXp,
              minutes,
            ),
          );
    }

    Navigator.of(context).pushReplacementNamed(
      AppRouter.focusComplete,
      arguments: {
        'habitId': widget.habitId,
        'minutes': minutes,
        'xpResult': rewards.xp,
        'stageUp': rewards.stageUp,
        'isAbandoned': isAbandoned,
        'coinsEarned': rewards.coins,
      },
    );
  }

  void _logSessionAnalytics(
    FocusTimerState timerState,
    int minutes,
    _SessionRewards rewards,
  ) {
    final analytics = ref.read(analyticsServiceProvider);
    final targetMinutes = timerState.mode == TimerMode.countdown
        ? timerState.totalSeconds ~/ 60
        : 0;
    final completionRatio = targetMinutes > 0
        ? (minutes / targetMinutes).clamp(0.0, 1.0)
        : 1.0;

    if (timerState.status == TimerStatus.completed) {
      analytics.logFocusSessionCompleted(
        habitId: widget.habitId,
        actualMinutes: minutes,
        xpEarned: rewards.xp.totalXp,
        targetDurationMinutes: targetMinutes,
        pausedSeconds: timerState.totalPausedSeconds,
        completionRatio: completionRatio,
      );
    } else {
      analytics.logFocusSessionAbandoned(
        habitId: widget.habitId,
        minutesCompleted: minutes,
        reason: 'user_abandoned',
        targetDurationMinutes: targetMinutes,
        pausedSeconds: timerState.totalPausedSeconds,
        completionRatio: completionRatio,
      );
    }

    if (rewards.coins > 0) {
      analytics.logCoinsEarned(amount: rewards.coins, source: 'focus_session');
    }
  }

  // ─── UI ───

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timerState = ref.watch(focusTimerProvider);
    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.watch(catByIdProvider(habit!.catId!))
        : null;

    // 监听终态变化，触发保存（替代 build() 内副作用）
    ref.listen(focusTimerProvider, _onTimerTerminated);

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.timerQuestNotFound)),
      );
    }

    final bgColor = cat != null
        ? stageColor(cat.displayStage)
        : colorScheme.primary;
    final meshColors = timerMeshColors(bgColor, colorScheme);
    final isRunningOrPaused =
        timerState.status == TimerStatus.running ||
        timerState.status == TimerStatus.paused;
    final inGracePeriod = isRunningOrPaused && timerState.elapsedSeconds <= 10;

    return PopScope(
      canPop: !isRunningOrPaused || inGracePeriod,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          if (inGracePeriod) {
            FocusTimerService.stop();
            ref.read(focusTimerProvider.notifier).reset();
          }
          return;
        }
        _giveUp();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedMeshBackground(colors: meshColors, speed: 0.3),
            ),
            const Positioned.fill(
              child: IgnorePointer(
                child: ParticleOverlay(
                  mode: ParticleMode.dust,
                  child: SizedBox.expand(),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  if (_showPermissionBanner) _buildPermissionBanner(),
                  _buildHabitHeader(habit, theme),
                  const Spacer(flex: 2),
                  _buildCatProgress(cat, timerState, colorScheme),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTimerDisplay(timerState, theme),
                  const Spacer(flex: 3),
                  _buildControls(timerState, theme),
                  _buildGraceOrGiveUp(timerState, inGracePeriod, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionBanner() {
    return MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      content: Text(context.l10n.timerNotificationBanner),
      leading: const Icon(Icons.notifications_off_outlined),
      actions: [
        TextButton(
          onPressed: () => setState(() => _showPermissionBanner = false),
          child: Text(context.l10n.timerNotificationDismiss),
        ),
        TextButton(
          onPressed: () async {
            final granted = await ref
                .read(notificationServiceProvider)
                .requestPermission();
            if (mounted) {
              setState(() => _showPermissionBanner = !granted);
            }
          },
          child: Text(context.l10n.timerNotificationEnable),
        ),
      ],
    );
  }

  Widget _buildHabitHeader(Habit habit, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            habit.name,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (habit.totalCheckInDays > 0) ...[
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: AppShape.borderMedium,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '${habit.totalCheckInDays}d',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCatProgress(
    dynamic cat,
    FocusTimerState timerState,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ProgressRing(
            progress: timerState.progress,
            size: 240,
            strokeWidth: 8,
            child: const SizedBox(),
          ),
          if (cat != null)
            TappableCatSprite(cat: cat, size: 100)
          else
            Icon(
              Icons.self_improvement,
              size: 64,
              color: colorScheme.onSurfaceVariant,
              semanticLabel: 'Focus meditation',
            ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(FocusTimerState timerState, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Semantics(
          label: 'Timer: ${timerState.displayTime}',
          liveRegion: true,
          child: Text(
            timerState.displayTime,
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          timerState.mode == TimerMode.countdown
              ? context.l10n.timerRemaining
              : context.l10n.timerElapsed,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        if (timerState.status == TimerStatus.paused) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: AppShape.borderMedium,
            ),
            child: Text(
              context.l10n.timerPaused,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGraceOrGiveUp(
    FocusTimerState timerState,
    bool inGracePeriod,
    ThemeData theme,
  ) {
    final isActive =
        _hasStarted &&
        timerState.status != TimerStatus.completed &&
        timerState.status != TimerStatus.abandoned;
    if (!isActive) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: inGracePeriod
          ? TextButton(
              onPressed: _goBack,
              child: Text(
                context.l10n.timerGraceBack(10 - timerState.elapsedSeconds),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : TextButton(
              onPressed: _giveUp,
              child: Text(
                context.l10n.timerGiveUp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }

  Widget _buildControls(FocusTimerState timerState, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: switch (timerState.status) {
        TimerStatus.idle => _buildIdleButton(theme),
        TimerStatus.running => _buildRunningButtons(timerState, theme),
        TimerStatus.paused => _buildPausedButtons(timerState, theme),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildIdleButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: _startTimer,
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

  Widget _buildRunningButtons(FocusTimerState timerState, ThemeData theme) {
    if (timerState.mode != TimerMode.stopwatch) {
      return _buildCountdownRunningButton(theme);
    }
    return _buildStopwatchRunningButtons(theme);
  }

  Widget _buildCountdownRunningButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.tonalIcon(
        onPressed: _pauseTimer,
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

  Widget _buildStopwatchRunningButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.tonalIcon(
              onPressed: _pauseTimer,
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
              onPressed: _completeTimer,
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

  Widget _buildPausedButtons(FocusTimerState timerState, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _resumeTimer,
              icon: const Icon(Icons.play_arrow),
              label: Text(context.l10n.timerResume),
            ),
          ),
        ),
        if (timerState.mode == TimerMode.stopwatch) ...[
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SizedBox(
              height: 56,
              child: FilledButton.tonalIcon(
                onPressed: _completeTimer,
                icon: const Icon(Icons.check),
                label: Text(context.l10n.timerDone),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 会话奖励计算结果 — 在 _saveSession 子方法间传递。
class _SessionRewards {
  final int coins;
  final XpResult xp;
  final StageUpResult? stageUp;

  const _SessionRewards({required this.coins, required this.xp, this.stageUp});
}
