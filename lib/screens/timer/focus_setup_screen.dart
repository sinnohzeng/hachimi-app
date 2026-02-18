import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/widgets/cat_sprite.dart';

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
  bool _customSelected = false;
  final _customController = TextEditingController();

  static const List<int> durationOptions = [15, 25, 40, 60];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _startFocus() {
    final habits = ref.read(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    if (habit == null) return;

    final catId = habit.catId ?? '';

    // Configure the timer
    ref.read(focusTimerProvider.notifier).configure(
          habitId: widget.habitId,
          catId: catId,
          durationSeconds: _selectedMinutes * 60,
          mode: _selectedMode,
        );

    // Navigate to focus timer screen
    Navigator.of(context).pushReplacementNamed(
      AppRouter.timer,
      arguments: widget.habitId,
    );
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
        body: const Center(child: Text('Habit not found')),
      );
    }

    // Set default to habit's goal minutes
    if (!_customSelected &&
        durationOptions.contains(habit.goalMinutes) &&
        _selectedMinutes == 25) {
      _selectedMinutes = habit.goalMinutes;
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
              bgColor.withValues(alpha: 0.1),
              colorScheme.surface,
            ],
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
                    ),
                    const Spacer(),
                    Text(
                      habit.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance close button
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Cat display
              if (cat != null) ...[
                CatSprite.fromCat(
                  breed: cat.breed,
                  stage: cat.computedStage,
                  mood: cat.computedMood,
                  size: 120,
                ),
                const SizedBox(height: 12),
                Text(
                  cat.name,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cat.speechMessage,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ] else ...[
                CatSprite(breed: 'orange_tabby', size: 120),
                const SizedBox(height: 12),
                Text(
                  habit.icon,
                  style: const TextStyle(fontSize: 48),
                ),
              ],

              const Spacer(flex: 1),

              // Duration selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'Focus Duration',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ...durationOptions.map((min) {
                          final isSelected =
                              !_customSelected && _selectedMinutes == min;
                          return ChoiceChip(
                            label: Text('${min}min'),
                            selected: isSelected,
                            onSelected: (_) => setState(() {
                              _selectedMinutes = min;
                              _customSelected = false;
                            }),
                          );
                        }),
                        ActionChip(
                          label: Text(_customSelected
                              ? '${_selectedMinutes}min'
                              : 'Custom'),
                          avatar: const Icon(Icons.edit, size: 18),
                          onPressed: _showCustomDuration,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mode toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SegmentedButton<TimerMode>(
                  segments: const [
                    ButtonSegment(
                      value: TimerMode.countdown,
                      label: Text('Countdown'),
                      icon: Icon(Icons.hourglass_bottom, size: 18),
                    ),
                    ButtonSegment(
                      value: TimerMode.stopwatch,
                      label: Text('Stopwatch'),
                      icon: Icon(Icons.timer, size: 18),
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
                      'Start Focus',
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

  Future<void> _showCustomDuration() async {
    _customController.text = _selectedMinutes.toString();
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom Duration'),
        content: TextField(
          controller: _customController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Minutes',
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
              final value = int.tryParse(_customController.text);
              if (value != null && value > 0 && value <= 180) {
                Navigator.of(ctx).pop(value);
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _selectedMinutes = result;
        _customSelected = true;
      });
    }
  }
}
