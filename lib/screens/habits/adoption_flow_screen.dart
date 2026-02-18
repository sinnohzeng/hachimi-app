import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/widgets/emoji_picker.dart';
import 'package:hachimi_app/widgets/cat_preview_card.dart';

/// 3-step adoption flow: Define Habit → Adopt Cat → Name Cat.
/// Creates both a habit and its bound cat in Firestore on completion.
class AdoptionFlowScreen extends ConsumerStatefulWidget {
  /// If true, shows first-time-user messaging.
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
  String? _reminderTime;

  // Step 2: Cat draft
  List<Cat> _draftCats = [];
  int _selectedCatIndex = -1;

  // Step 3: Name cat
  final _catNameController = TextEditingController();

  static const List<int> goalOptions = [15, 25, 40, 60];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _catNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate step 1
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a habit name')),
        );
        return;
      }
      // Generate cat draft
      _generateDraft();
    } else if (_currentStep == 1) {
      // Validate step 2
      if (_selectedCatIndex < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a kitten to adopt')),
        );
        return;
      }
      // Pre-fill cat name
      _catNameController.text = _draftCats[_selectedCatIndex].name;
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

  void _generateDraft() {
    final catGenService = ref.read(catGenerationServiceProvider);
    final ownedBreeds = ref.read(ownedBreedsProvider);
    setState(() {
      _draftCats = catGenService.generateDraft(
        userOwnedBreeds: ownedBreeds,
        boundHabitId: '', // Will be set on creation
      );
      _selectedCatIndex = -1;
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

      final selectedCat = _draftCats[_selectedCatIndex].copyWith(
        name: _catNameController.text.trim(),
      );

      await ref.read(firestoreServiceProvider).createHabitWithCat(
            uid: uid,
            name: _nameController.text.trim(),
            icon: _selectedEmoji,
            goalMinutes: _goalMinutes,
            reminderTime: _reminderTime,
            cat: selectedCat,
          );

      // Log analytics
      await ref.read(analyticsServiceProvider).logHabitCreated(
            habitName: _nameController.text.trim(),
            targetHours: 0,
          );

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
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
          // Step indicator
          _StepIndicator(
            currentStep: _currentStep,
            steps: const ['Define Habit', 'Adopt Cat', 'Name Cat'],
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1HabitForm(theme),
                _buildStep2CatDraft(theme),
                _buildStep3NameCat(theme),
              ],
            ),
          ),

          // Bottom action button
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
                          _currentStep == 2
                              ? '🐱 Adopt!'
                              : 'Next',
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
              'What habit do you want to build? 🌱',
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

          // Reminder time (optional)
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

  // ─── Step 2: Cat Draft ───

  Widget _buildStep2CatDraft(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '🐱',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 12),
          Text(
            'A kitten is waiting for you!',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Choose your companion for "${_nameController.text.trim()}"',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 3 cat candidates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_draftCats.length, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CatPreviewCard(
                    cat: _draftCats[index],
                    isSelected: _selectedCatIndex == index,
                    onTap: () => setState(() => _selectedCatIndex = index),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Refresh draft button
          TextButton.icon(
            onPressed: _generateDraft,
            icon: const Icon(Icons.refresh),
            label: const Text('Show different kittens'),
          ),
        ],
      ),
    );
  }

  // ─── Step 3: Name Cat ───

  Widget _buildStep3NameCat(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final selectedCat =
        _selectedCatIndex >= 0 ? _draftCats[_selectedCatIndex] : null;
    final breed = selectedCat != null
        ? breedMap[selectedCat.breed]
        : null;
    final personality = selectedCat != null
        ? personalityMap[selectedCat.personality]
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Cat preview
          if (selectedCat != null) ...[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: (breed?.colors.base ?? colorScheme.primary)
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: (breed?.colors.base ?? colorScheme.primary)
                      .withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
              child: const Center(
                child: Text('🐱', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 12),

            // Breed + personality
            Text(
              breed?.name ?? selectedCat.breed,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${personality?.emoji ?? ''} ${personality?.name ?? selectedCat.personality}',
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
                  final catGenService = ref.read(catGenerationServiceProvider);
                  setState(() {
                    _catNameController.text = catGenService.randomName();
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),

          Text(
            'Your cat will help you stay focused on "${_nameController.text.trim()}" '
            'and grow as you build your habit!',
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
            // Connector line
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
                      ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary)
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
