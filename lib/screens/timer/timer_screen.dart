import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:hachimi_app/widgets/cat_sprite.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

/// Focus timer in-progress screen.
/// Full-screen immersive view with cat, circular progress, and timer.
class TimerScreen extends ConsumerStatefulWidget {
  final String habitId;

  const TimerScreen({super.key, required this.habitId});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  final XpService _xpService = XpService();
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  void _startTimer() {
    final timerState = ref.read(focusTimerProvider);
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.read(catByIdProvider(habit!.catId!))
        : null;

    ref.read(focusTimerProvider.notifier).start();
    setState(() => _hasStarted = true);

    // Start foreground service
    FocusTimerService.start(
      habitName: habit?.name ?? 'Focus',
      catEmoji: cat != null ? '🐱' : '⏱️',
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

  Future<void> _giveUp() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Give up?'),
        content: const Text(
          'If you focused for at least 5 minutes, you\'ll earn partial XP. '
          'Your cat will understand!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep Going'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Give Up'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
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

    // No XP if < 5 minutes and abandoned
    if (isAbandoned && minutes < 5) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    // Calculate XP
    final streakDays = habit.currentStreak;
    final allHabitsDone = false; // TODO: check if all habits done today
    final xpResult = _xpService.calculateXp(
      minutes: minutes,
      streakDays: streakDays,
      allHabitsDone: allHabitsDone,
    );

    // Check for level-up
    final cat =
        habit.catId != null ? ref.read(catByIdProvider(habit.catId!)) : null;
    LevelUpResult? levelUp;
    if (cat != null) {
      levelUp = _xpService.checkLevelUp(cat.xp, cat.xp + xpResult.totalXp);
    }

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
    );

    await ref.read(firestoreServiceProvider).logFocusSession(
          uid: uid,
          session: session,
        );

    if (mounted) {
      // Navigate to completion screen
      Navigator.of(context).pushReplacementNamed(
        AppRouter.focusComplete,
        arguments: {
          'habitId': widget.habitId,
          'minutes': minutes,
          'xpResult': xpResult,
          'levelUp': levelUp,
          'isAbandoned': isAbandoned,
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

    // Update foreground notification with current time
    if (_hasStarted &&
        timerState.status == TimerStatus.running) {
      FocusTimerService.updateNotification(
        title: '🐱 ${habit?.name ?? "Focus"}',
        text: '${timerState.displayTime} ${timerState.mode == TimerMode.countdown ? "remaining" : "elapsed"}',
      );
    }

    // Handle completed/abandoned state
    if (timerState.status == TimerStatus.completed ||
        timerState.status == TimerStatus.abandoned) {
      // Save session on next frame to avoid build-phase side effects
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _saveSession(timerState);
      });
    }

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Habit not found')),
      );
    }

    final breedData = cat != null ? breedMap[cat.breed] : null;
    final bgColor = breedData?.colors.base ?? colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgColor.withValues(alpha: 0.15),
              bgColor.withValues(alpha: 0.05),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar: habit name + streak
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      habit.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      habit.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (habit.currentStreak > 0) ...[
                      const SizedBox(width: 12),
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
                            const Icon(Icons.local_fire_department,
                                size: 14),
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
                      CatSprite.fromCat(
                        breed: cat.breed,
                        stage: cat.computedStage,
                        mood: cat.computedMood,
                        size: 100,
                      )
                    else
                      Text(habit.icon,
                          style: const TextStyle(fontSize: 64)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Timer display
              Text(
                timerState.displayTime,
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),

              // Mode indicator
              Text(
                timerState.mode == TimerMode.countdown
                    ? 'remaining'
                    : 'elapsed',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              // Paused indicator
              if (timerState.status == TimerStatus.paused) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PAUSED',
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

              // Give up button (small, at bottom)
              if (_hasStarted &&
                  timerState.status != TimerStatus.completed &&
                  timerState.status != TimerStatus.abandoned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: _giveUp,
                    child: Text(
                      'Give Up',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
              'Start',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      case TimerStatus.running:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.tonalIcon(
            onPressed: _pauseTimer,
            icon: const Icon(Icons.pause, size: 28),
            label: Text(
              'Pause',
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
                  label: const Text('Resume'),
                ),
              ),
            ),
            if (timerState.mode == TimerMode.stopwatch) ...[
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: FilledButton.tonalIcon(
                    onPressed: _completeTimer,
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
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
