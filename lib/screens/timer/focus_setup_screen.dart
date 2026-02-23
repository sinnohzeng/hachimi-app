import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/widgets/circular_duration_picker.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// Focus setup screen — select duration and mode before starting a session.
/// Shows the cat companion and habit info prominently.
class FocusSetupScreen extends ConsumerStatefulWidget {
  final String habitId;

  const FocusSetupScreen({super.key, required this.habitId});

  @override
  ConsumerState<FocusSetupScreen> createState() => _FocusSetupScreenState();
}

class _FocusSetupScreenState extends ConsumerState<FocusSetupScreen> {
  int _selectedMinutes = 25;
  TimerMode _selectedMode = TimerMode.countdown;
  bool _initialized = false;

  static const List<int> presetOptions = [5, 10, 20, 30, 45, 60, 90, 120];

  void _startFocus() {
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    if (habit == null) return;

    final catId = habit.catId ?? '';
    final cat = catId.isNotEmpty ? ref.read(catByIdProvider(catId)) : null;
    final catName = cat?.name ?? context.l10n.focusCompleteYourCat;

    // Configure the timer with L10N labels for notification text
    final l10n = context.l10n;
    ref
        .read(focusTimerProvider.notifier)
        .configure(
          habitId: widget.habitId,
          catId: catId,
          catName: catName,
          habitName: habit.name,
          durationSeconds: _selectedMinutes * 60,
          mode: _selectedMode,
          labelRemaining: l10n.timerRemaining,
          labelElapsed: l10n.timerElapsed,
          labelFocusing: l10n.notifFocusing,
          labelDefaultCat: l10n.focusCompleteYourCat,
          labelInProgress: l10n.notifInProgress,
        );

    HapticFeedback.lightImpact();
    ErrorHandler.breadcrumb(
      'focus_started: ${habit.name}, ${_selectedMinutes}min, ${_selectedMode.name}',
    );

    // Navigate to focus timer screen
    Navigator.of(
      context,
    ).pushReplacementNamed(AppRouter.timer, arguments: widget.habitId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.watch(catByIdProvider(habit!.catId!))
        : null;

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.focusSetupQuestNotFound)),
      );
    }

    // Set default to habit's goal minutes (clamped to 1-120)
    if (!_initialized) {
      _initialized = true;
      _selectedMinutes = habit.goalMinutes.clamp(1, 120);
    }

    final bgColor = cat != null
        ? stageColor(cat.displayStage)
        : colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor.withValues(alpha: 0.1), colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Close',
                    ),
                    const Spacer(),
                    Text(
                      habit.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: AppSpacing.xxl,
                    ), // Balance close button
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Cat display
              if (cat != null) ...[
                TappableCatSprite(cat: cat, size: 120),
                const SizedBox(height: AppSpacing.md),
                Text(
                  cat.name,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  context.l10n.moodMessage(cat.personality, cat.computedMood),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (habit.motivationText != null &&
                    habit.motivationText!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      '"${habit.motivationText}"',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ] else ...[
                Icon(
                  Icons.self_improvement,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],

              const Spacer(flex: 1),

              // Circular duration picker
              CircularDurationPicker(
                value: _selectedMinutes,
                onChanged: (min) => setState(() {
                  _selectedMinutes = min;
                }),
              ),
              const SizedBox(height: AppSpacing.base),

              // Preset chips
              Padding(
                padding: AppSpacing.paddingHLg,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: presetOptions.map((min) {
                    final isSelected = _selectedMinutes == min;
                    return ChoiceChip(
                      label: Text('$min'),
                      selected: isSelected,
                      onSelected: (_) => setState(() {
                        _selectedMinutes = min;
                      }),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Mode toggle
              Padding(
                padding: AppSpacing.paddingHLg,
                child: SegmentedButton<TimerMode>(
                  segments: [
                    ButtonSegment(
                      value: TimerMode.countdown,
                      label: Text(context.l10n.focusSetupCountdown),
                      icon: const Icon(Icons.hourglass_bottom, size: 18),
                    ),
                    ButtonSegment(
                      value: TimerMode.stopwatch,
                      label: Text(context.l10n.focusSetupStopwatch),
                      icon: const Icon(Icons.timer, size: 18),
                    ),
                  ],
                  selected: {_selectedMode},
                  onSelectionChanged: (modes) => setState(() {
                    _selectedMode = modes.first;
                  }),
                ),
              ),

              const Spacer(flex: 2),

              // Start button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _startFocus,
                    child: Text(
                      context.l10n.focusSetupStartFocus,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
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
}
