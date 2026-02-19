import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/widgets/emoji_picker.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

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
  String? _reminderTime;

  // Step 2: Cat preview (single cat + refresh)
  Cat? _previewCat;

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
          const SnackBar(content: Text('Please enter a habit name')),
        );
        return;
      }
      _generateCat();
    } else if (_currentStep == 1) {
      if (_previewCat == null) return;
      _catNameController.text = _previewCat!.name;
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

  void _generateCat() {
    final catGenService = ref.read(pixelCatGenerationServiceProvider);
    setState(() {
      _previewCat = catGenService.generateCat(
        boundHabitId: '',
        targetMinutes: _targetHours * 60,
      );
    });
  }

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

      final selectedCat = _previewCat!.copyWith(
        name: _catNameController.text.trim(),
      );

      await ref.read(firestoreServiceProvider).createHabitWithCat(
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
            : 'New Habit'),
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
            steps: const ['Define Habit', 'Adopt Cat', 'Name Cat'],
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
              'What habit do you want to build?',
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
              labelText: 'Habit name',
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

          // Target hours
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
            children: targetHourOptions.map((hours) {
              final isSelected = _targetHours == hours;
              return ChoiceChip(
                label: Text('${hours}h'),
                selected: isSelected,
                onSelected: (_) => setState(() => _targetHours = hours),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Daily goal time
          Text('Daily focus goal', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: goalOptions.map((minutes) {
              final isSelected = _goalMinutes == minutes;
              return ChoiceChip(
                label: Text('${minutes}min'),
                selected: isSelected,
                onSelected: (_) => setState(() => _goalMinutes = minutes),
              );
            }).toList(),
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

  // ─── Step 2: Cat Preview (single + refresh) ───

  Widget _buildStep2CatPreview(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'A kitten is waiting for you!',
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
          const SizedBox(height: 32),

          // Cat sprite (large preview)
          if (_previewCat != null) ...[
            PixelCatSprite.fromCat(cat: _previewCat!, size: 160),
            const SizedBox(height: 16),
            Text(
              _previewCat!.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Personality tag
            if (_previewCat!.personalityData != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_previewCat!.personalityData!.emoji} ${_previewCat!.personalityData!.name}',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            if (_previewCat!.personalityData != null) ...[
              const SizedBox(height: 8),
              Text(
                _previewCat!.personalityData!.flavorText,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
          const SizedBox(height: 24),

          // Refresh button
          TextButton.icon(
            onPressed: _generateCat,
            icon: const Icon(Icons.refresh),
            label: const Text('Try another kitten'),
          ),
        ],
      ),
    );
  }

  // ─── Step 3: Name Cat ───

  Widget _buildStep3NameCat(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final personality = _previewCat?.personalityData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Cat preview
          if (_previewCat != null) ...[
            PixelCatSprite.fromCat(cat: _previewCat!, size: 120),
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
