import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/widgets/emoji_picker.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// 3-step adoption flow: Define Habit → Adopt Cat → Name Cat.
/// Creates both a habit and its bound cat in Firestore on completion.
class AdoptionFlowScreen extends ConsumerStatefulWidget {
  final bool isFirstHabit;

  const AdoptionFlowScreen({super.key, this.isFirstHabit = false});

  @override
  ConsumerState<AdoptionFlowScreen> createState() =>
      _AdoptionFlowScreenState();
}

class _AdoptionFlowScreenState extends ConsumerState<AdoptionFlowScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Habit definition
  final _nameController = TextEditingController();
  String _selectedEmoji = '📚';
  int _goalMinutes = 25;
  int _targetHours = 100;
  bool _isCustomGoal = false;
  bool _isCustomTarget = false;
  String? _reminderTime;

  // Step 2: 3 cats to choose from
  List<Cat> _previewCats = [];
  int _selectedCatIndex = 0;

  // Step 3: Name cat
  final _catNameController = TextEditingController();

  static const List<int> goalOptions = [15, 25, 40, 60];
  static const List<int> targetHourOptions = [50, 100, 200, 500];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _catNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a quest name')),
        );
        return;
      }
      _generateCats();
    } else if (_currentStep == 1) {
      if (_previewCats.isEmpty) return;
      _catNameController.text = _previewCats[_selectedCatIndex].name;
    }

    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _generateCats() {
    final catGenService = ref.read(pixelCatGenerationServiceProvider);
    setState(() {
      _previewCats = List.generate(
        3,
        (_) => catGenService.generateCat(
          boundHabitId: '',
          targetMinutes: _targetHours * 60,
        ),
      );
      _selectedCatIndex = 0;
    });
  }

  void _regenerateSingleCat(int index) {
    final catGenService = ref.read(pixelCatGenerationServiceProvider);
    setState(() {
      _previewCats[index] = catGenService.generateCat(
        boundHabitId: '',
        targetMinutes: _targetHours * 60,
      );
      if (_selectedCatIndex == index) {
        // Keep selection, but update preview
      }
    });
  }

  Cat? get _selectedCat =>
      _previewCats.isEmpty ? null : _previewCats[_selectedCatIndex];

  Future<void> _adopt() async {
    if (_catNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please name your cat')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final selectedCat = _selectedCat!.copyWith(
        name: _catNameController.text.trim(),
      );

      final result = await ref.read(firestoreServiceProvider).createHabitWithCat(
            uid: uid,
            name: _nameController.text.trim(),
            icon: _selectedEmoji,
            targetHours: _targetHours,
            goalMinutes: _goalMinutes,
            reminderTime: _reminderTime,
            cat: selectedCat,
          );

      await ref.read(analyticsServiceProvider).logHabitCreated(
            habitName: _nameController.text.trim(),
            targetHours: _targetHours,
          );

      // Schedule daily reminder if user set a reminder time
      if (_reminderTime != null) {
        final notifService = NotificationService();
        var hasPermission = await notifService.isPermissionGranted();
        if (!hasPermission) {
          hasPermission = await notifService.requestPermission();
        }
        if (hasPermission) {
          final parts = _reminderTime!.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          await notifService.scheduleDailyReminder(
            habitId: result.habitId,
            habitName: _nameController.text.trim(),
            catName: _catNameController.text.trim(),
            hour: hour,
            minute: minute,
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirstHabit
            ? 'Adopt Your First Cat!'
            : 'New Quest'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Column(
        children: [
          _StepIndicator(
            currentStep: _currentStep,
            steps: const ['Define Quest', 'Adopt Cat', 'Name Cat'],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1HabitForm(theme),
                _buildStep2CatPreview(theme),
                _buildStep3NameCat(theme),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading
                      ? null
                      : (_currentStep == 2 ? _adopt : _nextStep),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _currentStep == 2 ? 'Adopt!' : 'Next',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 1: Define Habit ───

  Widget _buildStep1HabitForm(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isFirstHabit) ...[
            Text(
              'What quest do you want to start?',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'A kitten will be assigned to help you stay on track!',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Habit name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Quest name',
              hintText: 'e.g. Prepare interview questions',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),

          // Emoji picker
          Text('Choose an icon', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          EmojiPicker(
            selected: _selectedEmoji,
            onSelected: (emoji) => setState(() => _selectedEmoji = emoji),
          ),
          const SizedBox(height: 24),

          // Target hours with custom option
          Text('Total target hours', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Your cat grows as you accumulate focus time',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ...targetHourOptions.map((hours) {
                final isSelected = !_isCustomTarget && _targetHours == hours;
                return ChoiceChip(
                  label: Text('${hours}h'),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    _targetHours = hours;
                    _isCustomTarget = false;
                  }),
                );
              }),
              if (_isCustomTarget)
                ChoiceChip(
                  label: Text('${_targetHours}h'),
                  selected: true,
                  onSelected: (_) => _showCustomTargetDialog(),
                )
              else
                ActionChip(
                  label: const Text('Custom'),
                  avatar: const Icon(Icons.tune, size: 18),
                  onPressed: _showCustomTargetDialog,
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Daily goal time with custom option
          Text('Daily focus goal', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ...goalOptions.map((minutes) {
                final isSelected = !_isCustomGoal && _goalMinutes == minutes;
                return ChoiceChip(
                  label: Text('${minutes}min'),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    _goalMinutes = minutes;
                    _isCustomGoal = false;
                  }),
                );
              }),
              if (_isCustomGoal)
                ChoiceChip(
                  label: Text('${_goalMinutes}min'),
                  selected: true,
                  onSelected: (_) => _showCustomGoalDialog(),
                )
              else
                ActionChip(
                  label: const Text('Custom'),
                  avatar: const Icon(Icons.tune, size: 18),
                  onPressed: _showCustomGoalDialog,
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Reminder time
          Text('Daily reminder (optional)', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('None'),
                selected: _reminderTime == null,
                onSelected: (_) => setState(() => _reminderTime = null),
              ),
              ChoiceChip(
                label: const Text('7:00 AM'),
                selected: _reminderTime == '07:00',
                onSelected: (_) => setState(() => _reminderTime = '07:00'),
              ),
              ChoiceChip(
                label: const Text('8:00 AM'),
                selected: _reminderTime == '08:00',
                onSelected: (_) => setState(() => _reminderTime = '08:00'),
              ),
              ChoiceChip(
                label: const Text('9:00 PM'),
                selected: _reminderTime == '21:00',
                onSelected: (_) => setState(() => _reminderTime = '21:00'),
              ),
              ActionChip(
                label: const Text('Custom'),
                avatar: const Icon(Icons.access_time, size: 18),
                onPressed: () => _pickCustomTime(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCustomGoalDialog() {
    final controller = TextEditingController(
      text: _isCustomGoal ? '$_goalMinutes' : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom daily goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Minutes per day',
            hintText: '5 - 180',
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
              final value = int.tryParse(controller.text.trim());
              if (value == null || value < 5 || value > 180) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a value between 5 and 180')),
                );
                return;
              }
              setState(() {
                _goalMinutes = value;
                _isCustomGoal = true;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _showCustomTargetDialog() {
    final controller = TextEditingController(
      text: _isCustomTarget ? '$_targetHours' : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom target hours'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Total hours',
            hintText: '10 - 2000',
            suffixText: 'h',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value == null || value < 10 || value > 2000) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Enter a value between 10 and 2000')),
                );
                return;
              }
              setState(() {
                _targetHours = value;
                _isCustomTarget = true;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _reminderTime =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  // ─── Step 2: Choose from 3 cats ───

  Widget _buildStep2CatPreview(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final cat = _selectedCat;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Choose your kitten!',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Your companion for "${_nameController.text.trim()}"',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Large preview of selected cat
          if (cat != null) ...[
            TappableCatSprite(cat: cat, size: 120),
            const SizedBox(height: 12),
            Text(
              cat.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (cat.personalityData != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${cat.personalityData!.emoji} ${cat.personalityData!.name}',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            if (cat.personalityData != null) ...[
              const SizedBox(height: 8),
              Text(
                cat.personalityData!.flavorText,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
          const SizedBox(height: 24),

          // 3-cat selection row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              if (index >= _previewCats.length) return const SizedBox.shrink();
              final isSelected = _selectedCatIndex == index;
              final previewCat = _previewCats[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCatIndex = index),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        height: 96,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PixelCatSprite.fromCat(
                                cat: previewCat, size: 56),
                            const SizedBox(height: 4),
                            Text(
                              previewCat.name,
                              style: textTheme.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Refresh single cat icon
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () => _regenerateSingleCat(index),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.surfaceContainerHighest,
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            child: Icon(
                              Icons.refresh,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Reroll all button
          TextButton.icon(
            onPressed: _generateCats,
            icon: const Icon(Icons.refresh),
            label: const Text('Reroll All'),
          ),
        ],
      ),
    );
  }

  // ─── Step 3: Name Cat ───

  Widget _buildStep3NameCat(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final cat = _selectedCat;
    final personality = cat?.personalityData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Cat preview
          if (cat != null) ...[
            TappableCatSprite(cat: cat, size: 120),
            const SizedBox(height: 12),
            if (personality != null)
              Text(
                '${personality.emoji} ${personality.name}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
          const SizedBox(height: 32),

          // Name input
          Text(
            'Name your cat',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _catNameController,
            decoration: InputDecoration(
              labelText: 'Cat name',
              hintText: 'e.g. Mochi',
              prefixIcon: const Icon(Icons.pets),
              suffixIcon: IconButton(
                icon: const Icon(Icons.casino),
                tooltip: 'Random name',
                onPressed: () {
                  final names = randomCatNames;
                  final name = (names.toList()..shuffle()).first;
                  setState(() {
                    _catNameController.text = name;
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),

          Text(
            'Your cat will grow as you focus on "${_nameController.text.trim()}"! '
            'Target: ${_targetHours}h total.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Step indicator widget showing progress through the adoption flow.
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const _StepIndicator({required this.currentStep, required this.steps});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepIndex < currentStep
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep;
          final isCurrent = stepIndex == currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  border: isCurrent
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: stepIndex < currentStep
                      ? Icon(Icons.check,
                          size: 16, color: colorScheme.onPrimary)
                      : Text(
                          '${stepIndex + 1}',
                          style: textTheme.labelSmall?.copyWith(
                            color: isActive
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex],
                style: textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
