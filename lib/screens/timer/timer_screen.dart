import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/analytics_events.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/timer_display.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:hachimi_app/services/remote_config_service.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final String habitId;

  const TimerScreen({super.key, required this.habitId});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start(String habitName) {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });

    // Log timer_started event
    ref.read(analyticsServiceProvider).logTimerStarted(habitName: habitName);
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resume() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _complete(Habit habit) async {
    _timer?.cancel();
    setState(() => _isRunning = false);

    final minutes = (_elapsed.inSeconds / 60).ceil().clamp(1, 9999);
    await _logTime(habit, minutes);
  }

  Future<void> _showManualEntry(Habit habit) async {
    final controller = TextEditingController();
    final minutes = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter minutes'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Minutes invested',
            suffixText: 'min',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.of(ctx).pop(value);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (minutes != null && minutes > 0) {
      await _logTime(habit, minutes);
    }
  }

  Future<void> _logTime(Habit habit, int minutes) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    final analyticsService = ref.read(analyticsServiceProvider);

    await firestoreService.logCheckIn(
      uid: uid,
      habitId: habit.id,
      habitName: habit.name,
      minutes: minutes,
    );

    // Log analytics events
    await analyticsService.logTimerCompleted(
      habitName: habit.name,
      durationMinutes: minutes,
    );

    final newStreak = habit.currentStreak + 1;
    await analyticsService.logDailyCheckIn(
      habitName: habit.name,
      streakCount: newStreak,
      minutesToday: minutes,
    );

    // Check streak milestones
    for (final milestone in AnalyticsEvents.streakMilestones) {
      if (newStreak == milestone) {
        await analyticsService.logStreakAchieved(
          habitName: habit.name,
          milestone: milestone,
        );
      }
    }

    // Check progress milestones
    final newTotalMinutes = habit.totalMinutes + minutes;
    final targetMinutes = habit.targetHours * 60;
    if (targetMinutes > 0) {
      final newPercent = ((newTotalMinutes / targetMinutes) * 100).round();
      final oldPercent = ((habit.totalMinutes / targetMinutes) * 100).round();
      for (final milestone in AnalyticsEvents.progressMilestones) {
        if (oldPercent < milestone && newPercent >= milestone) {
          await analyticsService.logGoalProgress(
            habitName: habit.name,
            percentComplete: milestone,
          );
        }
      }
    }

    if (mounted) {
      // Show success message from Remote Config
      final remoteConfig = RemoteConfigService();
      final message = remoteConfig.checkInSuccessMessage
          .replaceAll('{streak}', '$newStreak')
          .replaceAll('{percent}',
              '${((newTotalMinutes / targetMinutes) * 100).round()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$minutes min logged! $message')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final todayMinutes = ref.watch(todayMinutesPerHabitProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return habitsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (habits) {
        final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Habit not found')),
          );
        }

        final todayMin = todayMinutes[habit.id] ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress ring with timer
                  ProgressRing(
                    progress: habit.progressPercent,
                    size: 200,
                    strokeWidth: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimerDisplay(elapsed: _elapsed),
                        if (todayMin > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Today: ${todayMin}min',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress text
                  Text(
                    habit.progressText,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${(habit.progressPercent * 100).toStringAsFixed(1)}% complete',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Timer controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isRunning && _elapsed == Duration.zero)
                        FilledButton.icon(
                          onPressed: () => _start(habit.name),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start'),
                        )
                      else if (_isRunning)
                        FilledButton.tonalIcon(
                          onPressed: _pause,
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                        )
                      else ...[
                        FilledButton.tonalIcon(
                          onPressed: _resume,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Resume'),
                        ),
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          onPressed: () => _complete(habit),
                          icon: const Icon(Icons.check),
                          label: const Text('Done'),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Manual entry
                  TextButton.icon(
                    onPressed: () => _showManualEntry(habit),
                    icon: const Icon(Icons.edit),
                    label: const Text('Enter manually'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
