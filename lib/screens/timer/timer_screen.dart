import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/background_color_utils.dart';
import 'package:hachimi_app/widgets/animated_mesh_background.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/app_info_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/screens/timer/components/timer_controls.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    show ServiceRequestFailure;

/// Focus timer in-progress screen with pixel cat, circular progress, and timer.
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
  bool _isStarting = false;

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

  Future<void> _startTimer() async {
    final timerState = ref.read(focusTimerProvider);
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;

    setState(() => _isStarting = true);

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
    setState(() {
      _hasStarted = true;
      _isStarting = false;
    });

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

  // ─── Session save (delegates to SessionCompletionService) ───

  /// 监听计时器终态（完成/放弃），触发会话保存。
  void _onTimerTerminated(FocusTimerState? prev, FocusTimerState next) {
    if (_sessionSaved) return;
    final isTerminal = next.status == TimerStatus.completed ||
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

    final cat = habit.catId != null
        ? ref.read(catByIdProvider(habit.catId!))
        : null;
    final todayMap = ref.read(todayMinutesPerHabitProvider);
    final activeHabits =
        habits.where((h) => h.isActive).toList();
    final clientVersion = ref.read(appInfoProvider).value?.version ?? '';

    final result = await ref
        .read(sessionCompletionServiceProvider)
        .completeSession(
          uid: uid,
          habitId: widget.habitId,
          timerState: timerState,
          habit: habit,
          clientVersion: clientVersion,
          todayMinutesPerHabit: todayMap,
          activeHabits: activeHabits,
          cat: cat,
        );

    if (result.isDiscarded) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    if (mounted) _navigateToResult(timerState, result);
  }

  void _navigateToResult(FocusTimerState timerState, dynamic result) {
    final isCompleted = timerState.status == TimerStatus.completed;
    final isAbandoned = timerState.status == TimerStatus.abandoned;
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;

    // 完成通知（仅成功完成时）
    if (isCompleted && habit != null) {
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
              result.rewards?.xp.totalXp ?? 0,
              result.minutes,
            ),
          );
    }

    Navigator.of(context).pushReplacementNamed(
      AppRouter.focusComplete,
      arguments: {
        'habitId': widget.habitId,
        'minutes': result.minutes,
        'xpResult': result.rewards?.xp,
        'stageUp': result.rewards?.stageUp,
        'isAbandoned': isAbandoned,
        'coinsEarned': result.rewards?.coins ?? 0,
      },
    );
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

    // 监听终态变化，触发保存
    ref.listen(focusTimerProvider, _onTimerTerminated);

    if (habit == null) {
      return AppScaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.timerQuestNotFound)),
      );
    }

    final bgColor =
        cat != null ? stageColor(cat.displayStage) : colorScheme.primary;
    final meshColors = timerMeshColors(bgColor, colorScheme);
    final isRunningOrPaused = timerState.status == TimerStatus.running ||
        timerState.status == TimerStatus.paused;
    final inGracePeriod =
        isRunningOrPaused && timerState.elapsedSeconds <= 10;

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
      child: AppScaffold(
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
                  TimerControls(
                    status: timerState.status,
                    mode: timerState.mode,
                    isLoading: _isStarting,
                    onStart: _startTimer,
                    onPause: _pauseTimer,
                    onResume: _resumeTimer,
                    onComplete: _completeTimer,
                  ),
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
      padding: AppSpacing.paddingListTile,
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

  Widget _buildHabitHeader(dynamic habit, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: AppSpacing.paddingScreenBodyCompact,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            habit.name,
            style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
    final isActive = _hasStarted &&
        timerState.status != TimerStatus.completed &&
        timerState.status != TimerStatus.abandoned;
    if (!isActive) return const SizedBox.shrink();

    return Padding(
      padding: AppSpacing.paddingBottomBase,
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
}
