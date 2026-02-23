import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/motivation_quotes.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/services/achievement_trigger_helper.dart';
import 'package:hachimi_app/widgets/growth_path_card.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/reminder_picker_sheet.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
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
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Habit definition
  final _nameController = TextEditingController();
  late final TextEditingController _motivationController;
  int _goalMinutes = 25;
  int? _targetHours = 100; // null = 永续模式
  bool _isUnlimitedMode = true; // 默认永续模式
  bool _isCustomGoal = false;
  bool _isCustomTarget = false;
  final List<ReminderConfig> _reminders = [];
  DateTime? _deadlineDate;
  bool _motivationInitialized = false;

  // Step 2: 3 cats to choose from
  List<Cat> _previewCats = [];
  int _selectedCatIndex = 0;

  // Step 3: Name cat
  final _catNameController = TextEditingController();

  static const List<int> goalOptions = [15, 25, 40, 60];
  static const List<int> targetHourOptions = [50, 100, 200, 500];

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

      final motivationText = _motivationController.text.trim().isNotEmpty
          ? _motivationController.text.trim()
          : null;

      final result = await ref
          .read(firestoreServiceProvider)
          .createHabitWithCat(
            uid: uid,
            name: _nameController.text.trim(),
            targetHours: _isUnlimitedMode ? null : _targetHours,
            goalMinutes: _goalMinutes,
            reminders: _reminders.isNotEmpty ? _reminders : null,
            motivationText: motivationText,
            deadlineDate: _isUnlimitedMode ? null : _deadlineDate,
            cat: selectedCat,
          );

      ErrorHandler.breadcrumb(
        'cat_adopted: ${_catNameController.text.trim()}, habit=${_nameController.text.trim()}',
      );
      await ref
          .read(analyticsServiceProvider)
          .logHabitCreated(
            habitName: _nameController.text.trim(),
            targetHours: _isUnlimitedMode ? 0 : (_targetHours ?? 0),
          );

      // 调度提醒通知
      if (_reminders.isNotEmpty) {
        final notifService = ref.read(notificationServiceProvider);
        var hasPermission = await notifService.isPermissionGranted();
        if (!hasPermission) {
          hasPermission = await notifService.requestPermission();
        }
        if (hasPermission && mounted) {
          final l10n = context.l10n;
          await notifService.scheduleReminders(
            habitId: result.habitId,
            habitName: _nameController.text.trim(),
            catName: _catNameController.text.trim(),
            reminders: _reminders,
            title: l10n.reminderNotificationTitle(
              _catNameController.text.trim(),
            ),
            body: l10n.reminderNotificationBody(_nameController.text.trim()),
          );
        }
      }

      // 触发成就评估（新建任务后）
      triggerAchievementEvaluation(ref, AchievementTrigger.habitCreated);

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
      padding: AppSpacing.paddingBase,
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

          // ── 基础信息 ──
          Text(
            context.l10n.adoptionBasicInfo,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: context.l10n.adoptionQuestName,
              hintText: context.l10n.adoptionQuestHint,
              prefixIcon: const Icon(Icons.edit_outlined),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _motivationController,
            maxLength: 240,
            maxLines: 4,
            minLines: 2,
            decoration: InputDecoration(
              labelText: context.l10n.adoptionMotivationLabel,
              hintText: context.l10n.adoptionMotivationHint,
              prefixIcon: const Icon(Icons.format_quote),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adoptionMotivationSwap,
                onPressed: () {
                  final current = _motivationController.text;
                  final locale = Localizations.localeOf(context);
                  _motivationController.text = randomMotivationQuote(
                    locale,
                    exclude: current,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── 目标设置 ──
          Text(
            context.l10n.adoptionGoals,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.adoptionGrowthHint,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 目标模式切换
          _buildModeToggle(theme),
          const SizedBox(height: AppSpacing.md),

          // 里程碑模式：目标小时数 + 截止日期
          if (!_isUnlimitedMode) ...[
            Text(context.l10n.adoptionTotalTarget, style: textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
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
            const SizedBox(height: AppSpacing.md),

            // 截止日期（可选）
            _buildDeadlinePicker(theme),
            const SizedBox(height: AppSpacing.md),
          ],

          // 每日目标（始终显示）
          Text(
            context.l10n.adoptionDailyGoalLabel,
            style: textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
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

          // ── 提醒 ──
          Text(
            context.l10n.adoptionReminderSection,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildReminderList(theme),
          const SizedBox(height: AppSpacing.lg),

          // ── 成长之路说明卡片 ──
          const GrowthPathCard(),
        ],
      ),
    );
  }

  /// 提醒列表 UI：已添加的提醒 + 添加按钮。
  Widget _buildReminderList(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 已添加的提醒列表
        for (int i = 0; i < _reminders.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 20,
                  color: colorScheme.primary,
                  semanticLabel: 'Reminder',
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _reminderDescription(_reminders[i]),
                    style: textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: colorScheme.error),
                  onPressed: () => setState(() => _reminders.removeAt(i)),
                  tooltip: context.l10n.catDetailRemoveReminder,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

        // 添加提醒按钮
        if (_reminders.length < 5)
          TextButton.icon(
            onPressed: _addReminder,
            icon: const Icon(Icons.add_alarm, size: 18),
            label: Text(l10n.reminderAddMore),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.reminderMaxReached,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  /// 生成提醒描述文案。
  String _reminderDescription(ReminderConfig reminder) =>
      reminder.localizedDescription(context.l10n);

  Future<void> _addReminder() async {
    final result = await showReminderPickerSheet(context);
    if (result != null) {
      setState(() => _reminders.add(result));
    }
  }

  // ─── 目标模式切换 ───

  Widget _buildModeToggle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment<bool>(
              value: true,
              label: Text(context.l10n.adoptionUnlimitedMode),
              icon: const Icon(Icons.all_inclusive),
            ),
            ButtonSegment<bool>(
              value: false,
              label: Text(context.l10n.adoptionMilestoneMode),
              icon: const Icon(Icons.flag_outlined),
            ),
          ],
          selected: {_isUnlimitedMode},
          onSelectionChanged: (modes) => setState(() {
            _isUnlimitedMode = modes.first;
            if (!_isUnlimitedMode) _targetHours ??= 100;
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _isUnlimitedMode
              ? context.l10n.adoptionUnlimitedDesc
              : context.l10n.adoptionMilestoneDesc,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ─── 截止日期选择器 ───

  Widget _buildDeadlinePicker(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Row(
      children: [
        Icon(
          Icons.event,
          size: 20,
          color: colorScheme.onSurfaceVariant,
          semanticLabel: 'Deadline',
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(l10n.adoptionDeadlineLabel, style: textTheme.labelLarge),
        const Spacer(),
        if (_deadlineDate != null) ...[
          Text(
            _formatDate(_deadlineDate!),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => _deadlineDate = null),
            tooltip: 'Clear deadline',
            visualDensity: VisualDensity.compact,
          ),
        ] else
          TextButton(
            onPressed: _pickDeadlineDate,
            child: Text(l10n.adoptionDeadlineNone),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDeadlineDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (date != null) {
      setState(() => _deadlineDate = date);
    }
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
            suffixText: context.l10n.unitMinShort,
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
            suffixText: context.l10n.unitHourShort,
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
                  borderRadius: AppShape.borderLarge,
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
                child: Semantics(
                  button: true,
                  label: isSelected
                      ? '${previewCat.name}, selected'
                      : '${previewCat.name}, tap to select',
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCatIndex = index),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedContainer(
                          duration: AppMotion.durationShort4,
                          width: 80,
                          height: 96,
                          padding: AppSpacing.paddingXs,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: AppShape.borderMedium,
                            border: isSelected
                                ? Border.all(
                                    color: colorScheme.primary,
                                    width: 2,
                                  )
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
                          child: Semantics(
                            button: true,
                            label: 'Regenerate ${previewCat.name}',
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
                        ),
                      ],
                    ),
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
            _isUnlimitedMode
                ? context.l10n.adoptionGrowthHint
                : context.l10n.adoptionGrowthTarget(
                    _nameController.text.trim(),
                    _targetHours ?? 100,
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
