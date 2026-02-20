// ---
// 📘 文件说明：
// 专注计时器页面 — 沉浸式全屏视图，显示像素猫、环形进度条和计时器。
// 支持倒计时 / 正计时两种模式，后台前台 Service 通知。
//
// 📋 程序整体伪代码（中文）：
// 1. 从 Provider 获取 habit 和 cat 数据；
// 2. 管理计时器状态（idle/running/paused/completed/abandoned）；
// 3. 前台 Service 推送通知；
// 4. 完成后计算 XP、检测阶段跃迁、保存 session、跳转完成页；
//
// 🧩 文件结构：
// - TimerScreen：主页面 ConsumerStatefulWidget；
// - _buildControls：根据状态渲染不同按钮；
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/background_color_utils.dart';
import 'package:hachimi_app/widgets/animated_mesh_background.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

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
    // Auto-start timer on entry — user already expressed intent on FocusSetupScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startTimer();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  void _startTimer() async {
    final timerState = ref.read(focusTimerProvider);
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;

    // Check notification permission — request if not granted
    final notifService = NotificationService();
    var hasPermission = await notifService.isPermissionGranted();
    if (!hasPermission) {
      hasPermission = await notifService.requestPermission();
    }
    if (!hasPermission && mounted) {
      setState(() => _showPermissionBanner = true);
    }

    ref.read(focusTimerProvider.notifier).start();
    setState(() => _hasStarted = true);

    // Start foreground service
    FocusTimerService.start(
      habitName: habit?.name ?? 'Focus',
      catEmoji: '🐱',
      totalSeconds: timerState.totalSeconds,
      isCountdown: timerState.mode == TimerMode.countdown,
    );
  }

  void _pauseTimer() {
    ref.read(focusTimerProvider.notifier).pause();
  }

  void _resumeTimer() {
    ref.read(focusTimerProvider.notifier).resume();
  }

  void _completeTimer() {
    ref.read(focusTimerProvider.notifier).complete();
  }

  /// Grace-period back: stop service, reset state, pop without confirmation.
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

  Future<void> _saveSession(FocusTimerState timerState) async {
    // Stop foreground service
    FocusTimerService.stop();

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    if (habit == null) return;

    final minutes = timerState.focusedMinutes;
    final isCompleted = timerState.status == TimerStatus.completed;
    final isAbandoned = timerState.status == TimerStatus.abandoned;

    // No reward if < 5 minutes and abandoned
    if (isAbandoned && minutes < 5) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    // Calculate coins earned (durationMinutes × 10)
    final coinsEarned = minutes * focusRewardCoinsPerMinute;

    // Calculate XP (still used for display)
    final xpService = ref.read(xpServiceProvider);
    final streakDays = habit.currentStreak;
    const allHabitsDone = false; // TODO: check if all habits done today
    final xpResult = xpService.calculateXp(
      minutes: minutes,
      streakDays: streakDays,
      allHabitsDone: allHabitsDone,
    );

    // Check for stage-up (time-based growth)
    final cat =
        habit.catId != null ? ref.read(catByIdProvider(habit.catId!)) : null;
    final stageUp = cat != null
        ? xpService.checkStageUp(
            oldTotalMinutes: cat.totalMinutes,
            newTotalMinutes: cat.totalMinutes + minutes,
            targetMinutes: cat.targetMinutes,
          )
        : null;

    // Save to Firestore
    final session = FocusSession(
      id: '',
      habitId: widget.habitId,
      catId: habit.catId ?? '',
      startedAt: timerState.startedAt ?? DateTime.now(),
      endedAt: DateTime.now(),
      durationMinutes: minutes,
      xpEarned: xpResult.totalXp,
      mode: timerState.mode == TimerMode.countdown ? 'countdown' : 'stopwatch',
      completed: isCompleted,
      coinsEarned: coinsEarned,
    );

    await ref.read(firestoreServiceProvider).logFocusSession(
          uid: uid,
          session: session,
          habitName: habit.name,
        );

    if (mounted) {
      // Send completion notification (only on successful completion)
      if (isCompleted) {
        final catName = cat?.name ?? context.l10n.focusCompleteYourCat;
        NotificationService().showFocusComplete(
          title: context.l10n.focusCompleteNotifTitle,
          body: context.l10n.focusCompleteNotifBody(catName, xpResult.totalXp, minutes),
        );
      }

      // Navigate to completion screen
      Navigator.of(context).pushReplacementNamed(
        AppRouter.focusComplete,
        arguments: {
          'habitId': widget.habitId,
          'minutes': minutes,
          'xpResult': xpResult,
          'stageUp': stageUp,
          'isAbandoned': isAbandoned,
          'coinsEarned': coinsEarned,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final timerState = ref.watch(focusTimerProvider);
    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.watch(catByIdProvider(habit!.catId!))
        : null;

    // Notification updates are now driven by FocusTimerNotifier._onTick()
    // so they work even when the app is in the background.

    // Handle completed/abandoned state — guard with _sessionSaved to prevent
    // multiple postFrameCallbacks being registered across successive builds.
    if (!_sessionSaved &&
        (timerState.status == TimerStatus.completed ||
            timerState.status == TimerStatus.abandoned)) {
      _sessionSaved = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (timerState.status == TimerStatus.completed) {
            HapticFeedback.heavyImpact();
          }
          _saveSession(timerState);
        }
      });
    }

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.timerQuestNotFound)),
      );
    }

    // Use stage color for mesh gradient background
    final bgColor = cat != null
        ? stageColor(cat.computedStage)
        : colorScheme.primary;
    final meshColors = timerMeshColors(bgColor, colorScheme);

    // Grace period: first 10 seconds allow free exit
    final isRunningOrPaused = timerState.status == TimerStatus.running ||
        timerState.status == TimerStatus.paused;
    final inGracePeriod =
        isRunningOrPaused && timerState.elapsedSeconds <= 10;
    // Allow pop freely when idle/completed/abandoned or during grace period
    final allowPop = !isRunningOrPaused || inGracePeriod;

    return PopScope(
      canPop: allowPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          // Pop already happened — clean up if in grace period
          if (inGracePeriod) {
            FocusTimerService.stop();
            ref.read(focusTimerProvider.notifier).reset();
          }
          return;
        }
        // didPop == false means canPop was false → past grace period
        _giveUp();
      },
      child: Scaffold(
      body: Stack(
        children: [
          // Layer 1: Slow breathing mesh gradient
          Positioned.fill(
            child: AnimatedMeshBackground(
              colors: meshColors,
              speed: 0.3,
            ),
          ),
          // Layer 2: Subtle floating dust particles
          const Positioned.fill(
            child: IgnorePointer(
              child: ParticleOverlay(
                mode: ParticleMode.dust,
                child: SizedBox.expand(),
              ),
            ),
          ),
          // Layer 3: Original content
          SafeArea(
          child: Column(
            children: [
              // Notification permission banner
              if (_showPermissionBanner)
                MaterialBanner(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  content: Text(context.l10n.timerNotificationBanner),
                  leading: const Icon(Icons.notifications_off_outlined),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          setState(() => _showPermissionBanner = false),
                      child: Text(context.l10n.timerNotificationDismiss),
                    ),
                    TextButton(
                      onPressed: () async {
                        final granted =
                            await NotificationService().requestPermission();
                        if (mounted) {
                          setState(() =>
                              _showPermissionBanner = !granted);
                        }
                      },
                      child: Text(context.l10n.timerNotificationEnable),
                    ),
                  ],
                ),

              // Top bar: habit name + streak
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      habit.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (habit.currentStreak > 0) ...[
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${habit.currentStreak}',
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
              ),

              const Spacer(flex: 2),

              // Cat + circular progress
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress ring
                    ProgressRing(
                      progress: timerState.progress,
                      size: 240,
                      strokeWidth: 8,
                      child: const SizedBox(),
                    ),
                    // Cat sprite
                    if (cat != null)
                      TappableCatSprite(cat: cat, size: 100)
                    else
                      Icon(Icons.self_improvement,
                          size: 64,
                          color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Timer display
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

              // Mode indicator
              Text(
                timerState.mode == TimerMode.countdown
                    ? context.l10n.timerRemaining
                    : context.l10n.timerElapsed,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              // Paused indicator
              if (timerState.status == TimerStatus.paused) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
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

              const Spacer(flex: 3),

              // Controls
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: _buildControls(timerState, theme),
              ),

              // Bottom button: grace-period "返回" or "Give Up"
              if (_hasStarted &&
                  timerState.status != TimerStatus.completed &&
                  timerState.status != TimerStatus.abandoned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: inGracePeriod
                      ? TextButton(
                          onPressed: _goBack,
                          child: Text(
                            context.l10n.timerGraceBack(10 - timerState.elapsedSeconds),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: _giveUp,
                          child: Text(
                            context.l10n.timerGiveUp,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
            ],
          ),
        ),
        ],
      ),
    ));
  }

  Widget _buildControls(FocusTimerState timerState, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (timerState.status) {
      case TimerStatus.idle:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow, size: 28),
            label: Text(
              context.l10n.timerStart,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      case TimerStatus.running:
        // Stopwatch mode: show Pause + Done side-by-side
        if (timerState.mode == TimerMode.stopwatch) {
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
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        // Countdown mode: only Pause
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

      case TimerStatus.paused:
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

      default:
        return const SizedBox.shrink();
    }
  }
}
