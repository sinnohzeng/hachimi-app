import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/motivation_quotes.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:uuid/uuid.dart';
import 'components/adoption_step1_form.dart';
import 'components/adoption_step2_cat_preview.dart';
import 'components/adoption_step3_name_cat.dart';
import 'components/step_indicator.dart';

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
  final _step1Key = GlobalKey<AdoptionStep1FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers（父级持有，传给子 widget）
  final _nameController = TextEditingController();
  late final TextEditingController _motivationController;
  final _catNameController = TextEditingController();
  bool _motivationInitialized = false;

  // Step 2: 3 cats to choose from
  List<Cat> _previewCats = [];
  int _selectedCatIndex = 0;

  Cat? get _selectedCat =>
      _previewCats.isEmpty ? null : _previewCats[_selectedCatIndex];

  @override
  void initState() {
    super.initState();
    _motivationController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_motivationInitialized) {
      _motivationInitialized = true;
      _motivationController.text = randomMotivationQuote(
        Localizations.localeOf(context),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _motivationController.dispose();
    _catNameController.dispose();
    super.dispose();
  }

  // ─── 导航 ───

  void _nextStep() {
    FocusScope.of(context).unfocus();

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
      duration: AppMotion.durationMedium4,
      curve: AppMotion.standard,
    );
  }

  void _previousStep() {
    FocusScope.of(context).unfocus();

    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: AppMotion.durationMedium4,
        curve: AppMotion.standard,
      );
    }
  }

  // ─── 猫生成 ───

  void _generateCats() {
    final catGenService = ref.read(pixelCatGenerationServiceProvider);
    setState(() {
      _previewCats = List.generate(
        3,
        (_) => catGenService.generateCat(boundHabitId: ''),
      );
      _selectedCatIndex = 0;
    });
  }

  void _regenerateSingleCat(int index) {
    final catGenService = ref.read(pixelCatGenerationServiceProvider);
    setState(() {
      _previewCats[index] = catGenService.generateCat(boundHabitId: '');
    });
  }

  // ─── 领养提交 ───

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

      final result = await _createHabitAndCat(uid);
      await _scheduleReminders(result.habitId, result.reminders);

      if (mounted) Navigator.of(context).pop(true);
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

  Future<_AdoptionResult> _createHabitAndCat(String uid) async {
    const uuid = Uuid();
    final habitId = uuid.v4();
    final catId = uuid.v4();
    final now = DateTime.now();
    final step1 = _step1Key.currentState!;

    final motivationText = _motivationController.text.trim().isNotEmpty
        ? _motivationController.text.trim()
        : null;

    final cat = _selectedCat!.copyWith(
      id: catId,
      name: _catNameController.text.trim(),
      boundHabitId: habitId,
    );

    final habit = Habit(
      id: habitId,
      name: _nameController.text.trim(),
      targetHours: step1.isUnlimitedMode ? null : step1.targetHours,
      goalMinutes: step1.goalMinutes,
      reminders: step1.reminders,
      motivationText: motivationText,
      catId: catId,
      deadlineDate: step1.isUnlimitedMode ? null : step1.deadlineDate,
      createdAt: now,
    );

    await ref.read(localCatRepositoryProvider).create(uid, cat);
    await ref.read(localHabitRepositoryProvider).create(uid, habit);

    ErrorHandler.breadcrumb(
      'cat_adopted: ${_catNameController.text.trim()}, '
      'habit=${_nameController.text.trim()}',
    );
    await ref
        .read(analyticsServiceProvider)
        .logHabitCreated(
          habitName: _nameController.text.trim(),
          targetHours: step1.isUnlimitedMode ? 0 : (step1.targetHours ?? 0),
        );

    return _AdoptionResult(habitId: habitId, reminders: step1.reminders);
  }

  Future<void> _scheduleReminders(
    String habitId,
    List<ReminderConfig> reminders,
  ) async {
    if (reminders.isEmpty) return;

    final notifService = ref.read(notificationServiceProvider);
    var hasPermission = await notifService.isPermissionGranted();
    if (!hasPermission) {
      hasPermission = await notifService.requestPermission();
    }
    if (hasPermission && mounted) {
      final l10n = context.l10n;
      await notifService.scheduleReminders(
        habitId: habitId,
        habitName: _nameController.text.trim(),
        catName: _catNameController.text.trim(),
        reminders: reminders,
        title: l10n.reminderNotificationTitle(_catNameController.text.trim()),
        body: l10n.reminderNotificationBody(_nameController.text.trim()),
      );
    }
  }

  // ─── UI ───

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final step1 = _step1Key.currentState;

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
                tooltip: context.l10n.adoptionBack,
              )
            : null,
      ),
      body: Column(
        children: [
          StepIndicator(
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
                AdoptionStep1Form(
                  key: _step1Key,
                  isFirstHabit: widget.isFirstHabit,
                  nameController: _nameController,
                  motivationController: _motivationController,
                ),
                AdoptionStep2CatPreview(
                  habitName: _nameController.text.trim(),
                  previewCats: _previewCats,
                  selectedCatIndex: _selectedCatIndex,
                  onSelectCat: (i) => setState(() => _selectedCatIndex = i),
                  onRegenerateCat: _regenerateSingleCat,
                  onRerollAll: _generateCats,
                ),
                AdoptionStep3NameCat(
                  selectedCat: _selectedCat,
                  catNameController: _catNameController,
                  isUnlimitedMode: step1?.isUnlimitedMode ?? false,
                  habitName: _nameController.text.trim(),
                  targetHours: step1?.targetHours ?? 100,
                ),
              ],
            ),
          ),
          _buildBottomButton(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme, ColorScheme colorScheme) {
    return SafeArea(
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
    );
  }
}

/// 领养结果 — 用于在 _adopt → _scheduleReminders 间传递数据。
class _AdoptionResult {
  final String habitId;
  final List<ReminderConfig> reminders;

  const _AdoptionResult({required this.habitId, required this.reminders});
}
