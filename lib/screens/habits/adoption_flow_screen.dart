import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// 3-step adoption flow: Define Habit → Adopt Cat → Name Cat.
/// Creates both a habit and its bound cat in Firestore on completion.
class AdoptionFlowScreen extends ConsumerStatefulWidget {
  final bool isFirstHabit;

  const AdoptionFlowScreen({super.key, this.isFirstHabit = false});

  @override
  ConsumerState<AdoptionFlowScreen> createState() => _AdoptionFlowScreenState();
}

class _AdoptionFlowScreenState extends ConsumerState<AdoptionFlowScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Habit definition
  final _nameController = TextEditingController();
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
          SnackBar(content: Text(context.l10n.adoptionValidQuestName)),
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
        SnackBar(content: Text(context.l10n.adoptionValidCatName)),
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

      final result = await ref
          .read(firestoreServiceProvider)
          .createHabitWithCat(
            uid: uid,
            name: _nameController.text.trim(),
            targetHours: _targetHours,
            goalMinutes: _goalMinutes,
            reminderTime: _reminderTime,
            cat: selectedCat,
          );

      await ref
          .read(analyticsServiceProvider)
          .logHabitCreated(
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
          SnackBar(content: Text(context.l10n.adoptionError(e.toString()))),
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
        title: Text(
          widget.isFirstHabit
              ? context.l10n.adoptionTitleFirst
              : context.l10n.adoptionTitleNew,
        ),
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
            steps: [
              context.l10n.adoptionStepDefineQuest,
              context.l10n.adoptionStepAdoptCat2,
              context.l10n.adoptionStepNameCat2,
            ],
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
              padding: AppSpacing.paddingBase,
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
                              ? context.l10n.adoptionAdopt
                              : context.l10n.adoptionNext,
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
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isFirstHabit) ...[
            Text(
              context.l10n.adoptionQuestPrompt,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.adoptionKittenHint,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Habit name
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: context.l10n.adoptionQuestName,
              hintText: context.l10n.adoptionQuestHint,
              prefixIcon: const Icon(Icons.edit_outlined),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Target hours with custom option
          Text(context.l10n.adoptionTotalTarget, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.adoptionGrowthHint,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
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
                  label: Text(context.l10n.adoptionCustom),
                  avatar: const Icon(Icons.tune, size: 18),
                  onPressed: _showCustomTargetDialog,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Daily goal time with custom option
          Text(
            context.l10n.adoptionDailyGoalLabel,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
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
                  label: Text(context.l10n.adoptionCustom),
                  avatar: const Icon(Icons.tune, size: 18),
                  onPressed: _showCustomGoalDialog,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Reminder time
          Text(
            context.l10n.adoptionReminderLabel,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text(context.l10n.adoptionReminderNone),
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
                label: Text(context.l10n.adoptionCustom),
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
        title: Text(context.l10n.adoptionCustomGoalTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: context.l10n.adoptionMinutesPerDay,
            hintText: context.l10n.adoptionMinutesHint,
            suffixText: 'min',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value == null || value < 5 || value > 180) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.adoptionValidMinutes)),
                );
                return;
              }
              setState(() {
                _goalMinutes = value;
                _isCustomGoal = true;
              });
              Navigator.of(ctx).pop();
            },
            child: Text(context.l10n.adoptionSet),
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
        title: Text(context.l10n.adoptionCustomTargetTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: context.l10n.adoptionTotalHours,
            hintText: context.l10n.adoptionHoursHint,
            suffixText: 'h',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value == null || value < 10 || value > 2000) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.adoptionValidHours)),
                );
                return;
              }
              setState(() {
                _targetHours = value;
                _isCustomTarget = true;
              });
              Navigator.of(ctx).pop();
            },
            child: Text(context.l10n.adoptionSet),
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
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          Text(
            context.l10n.adoptionChooseKitten,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.adoptionCompanionFor(_nameController.text.trim()),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Large preview of selected cat
          if (cat != null) ...[
            TappableCatSprite(cat: cat, size: 120),
            const SizedBox(height: AppSpacing.md),
            Text(
              cat.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (cat.personalityData != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${cat.personalityData!.emoji} ${context.l10n.personalityName(cat.personalityData!.id)}',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            if (cat.personalityData != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.personalityFlavor(cat.personalityData!.id),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.lg),

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
                        padding: AppSpacing.paddingXs,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PixelCatSprite.fromCat(cat: previewCat, size: 56),
                            const SizedBox(height: AppSpacing.xs),
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
          const SizedBox(height: AppSpacing.base),

          // Reroll all button
          TextButton.icon(
            onPressed: _generateCats,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.adoptionRerollAll),
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
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),

          // Cat preview
          if (cat != null) ...[
            TappableCatSprite(cat: cat, size: 120),
            const SizedBox(height: AppSpacing.md),
            if (personality != null)
              Text(
                '${personality.emoji} ${context.l10n.personalityName(personality.id)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.xl),

          // Name input
          Text(
            context.l10n.adoptionNameYourCat2,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.base),
          TextFormField(
            controller: _catNameController,
            decoration: InputDecoration(
              labelText: context.l10n.adoptionCatName,
              hintText: context.l10n.adoptionCatHint,
              prefixIcon: const Icon(Icons.pets),
              suffixIcon: IconButton(
                icon: const Icon(Icons.casino),
                tooltip: context.l10n.adoptionRandomTooltip,
                onPressed: () {
                  const names = randomCatNames;
                  final name = (names.toList()..shuffle()).first;
                  setState(() {
                    _catNameController.text = name;
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.base),

          Text(
            context.l10n.adoptionGrowthTarget(
              _nameController.text.trim(),
              _targetHours,
            ),
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
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: colorScheme.onPrimary,
                        )
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
              const SizedBox(height: AppSpacing.xs),
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
