import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/motivation_quotes.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:hachimi_app/widgets/chip_selector_row.dart';
import 'package:hachimi_app/widgets/growth_path_card.dart';
import 'package:hachimi_app/widgets/quest_form_dialogs.dart';
import 'package:hachimi_app/widgets/reminder_picker_sheet.dart';

/// Step 1: 定义习惯 — 名称、备忘、目标模式、提醒。
///
/// 自身管理表单状态（goalMinutes、targetHours 等），
/// 父级通过 [GlobalKey<AdoptionStep1FormState>] 读取最终值。
class AdoptionStep1Form extends StatefulWidget {
  final bool isFirstHabit;
  final TextEditingController nameController;
  final TextEditingController motivationController;

  static const List<int> goalOptions = [15, 25, 40, 60];
  static const List<int> targetHourOptions = [50, 100, 200, 500];

  const AdoptionStep1Form({
    super.key,
    required this.isFirstHabit,
    required this.nameController,
    required this.motivationController,
  });

  @override
  State<AdoptionStep1Form> createState() => AdoptionStep1FormState();
}

/// 对外暴露表单数据，父级通过 GlobalKey 读取。
class AdoptionStep1FormState extends State<AdoptionStep1Form>
    with AutomaticKeepAliveClientMixin {
  int goalMinutes = 25;
  int? targetHours = 100;
  bool isUnlimitedMode = false;
  final List<ReminderConfig> reminders = [];
  DateTime? deadlineDate;

  bool _isCustomGoal = false;
  bool _isCustomTarget = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: AppSpacing.paddingBase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isFirstHabit) _buildWelcomeHeader(theme),
          _buildNameFields(theme),
          const SizedBox(height: AppSpacing.lg),
          _buildGoalSectionHeader(theme),
          const SizedBox(height: AppSpacing.md),
          _buildModeToggle(theme),
          const SizedBox(height: AppSpacing.md),
          if (!isUnlimitedMode) ...[
            _buildTargetHoursChips(theme),
            const SizedBox(height: AppSpacing.md),
            _buildDeadlinePicker(theme),
            const SizedBox(height: AppSpacing.md),
          ],
          _buildDailyGoalChips(theme),
          const SizedBox(height: AppSpacing.lg),
          _buildReminderSection(theme),
          const SizedBox(height: AppSpacing.lg),
          const GrowthPathCard(),
        ],
      ),
    );
  }

  // ─── 子组件构建 ───

  Widget _buildWelcomeHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adoptionQuestPrompt,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.l10n.adoptionKittenHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildNameFields(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.nameController,
          decoration: InputDecoration(
            labelText: context.l10n.adoptionQuestName,
            hintText: context.l10n.adoptionQuestHint,
          ),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: widget.motivationController,
          maxLength: 240,
          maxLines: 4,
          minLines: 2,
          decoration: InputDecoration(
            labelText: context.l10n.adoptionMotivationLabel,
            hintText: context.l10n.adoptionMotivationHint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: context.l10n.adoptionMotivationSwap,
              onPressed: _swapMotivation,
            ),
          ),
        ),
      ],
    );
  }

  void _swapMotivation() {
    final current = widget.motivationController.text;
    final locale = Localizations.localeOf(context);
    widget.motivationController.text = randomMotivationQuote(
      locale,
      exclude: current,
    );
  }

  Widget _buildGoalSectionHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adoptionGoals,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.l10n.adoptionGrowthHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildModeToggle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment<bool>(
              value: false,
              label: Text(context.l10n.adoptionMilestoneMode),
              icon: const Icon(Icons.flag_outlined),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text(context.l10n.adoptionUnlimitedMode),
              icon: const Icon(Icons.all_inclusive),
            ),
          ],
          selected: {isUnlimitedMode},
          onSelectionChanged: (modes) => setState(() {
            isUnlimitedMode = modes.first;
            if (!isUnlimitedMode) targetHours ??= 100;
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          isUnlimitedMode
              ? context.l10n.adoptionUnlimitedDesc
              : context.l10n.adoptionMilestoneDesc,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetHoursChips(ThemeData theme) {
    return ChipSelectorRow(
      label: context.l10n.adoptionTotalTarget,
      options: AdoptionStep1Form.targetHourOptions,
      selected: targetHours,
      isCustom: _isCustomTarget,
      labelBuilder: (v) => '${v}h',
      customLabel: context.l10n.adoptionCustom,
      onSelected: (v) => setState(() {
        targetHours = v;
        _isCustomTarget = false;
      }),
      onCustom: _showCustomTargetDialog,
    );
  }

  Widget _buildDailyGoalChips(ThemeData theme) {
    return ChipSelectorRow(
      label: context.l10n.adoptionDailyGoalLabel,
      options: AdoptionStep1Form.goalOptions,
      selected: goalMinutes,
      isCustom: _isCustomGoal,
      labelBuilder: (v) => '${v}min',
      customLabel: context.l10n.adoptionCustom,
      onSelected: (v) => setState(() {
        goalMinutes = v;
        _isCustomGoal = false;
      }),
      onCustom: _showCustomGoalDialog,
    );
  }

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
        if (deadlineDate != null) ...[
          Text(
            _formatDate(deadlineDate!),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => deadlineDate = null),
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

  Widget _buildReminderSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adoptionReminderSection,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildReminderList(theme),
      ],
    );
  }

  Widget _buildReminderList(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < reminders.length; i++) _buildReminderItem(theme, i),
        if (reminders.length < 5)
          TextButton.icon(
            onPressed: _addReminder,
            icon: const Icon(Icons.add_alarm, size: 18),
            label: Text(context.l10n.reminderAddMore),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              context.l10n.reminderMaxReached,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReminderItem(ThemeData theme, int index) {
    final colorScheme = theme.colorScheme;

    return Padding(
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
              reminders[index].localizedDescription(context.l10n),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: colorScheme.error),
            onPressed: () => setState(() => reminders.removeAt(index)),
            tooltip: context.l10n.catDetailRemoveReminder,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  // ─── 对话框与交互 ───

  Future<void> _addReminder() async {
    final result = await showReminderPickerSheet(context);
    if (result != null) {
      setState(() => reminders.add(result));
    }
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
      setState(() => deadlineDate = date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';
  }

  void _showCustomGoalDialog() {
    showCustomGoalDialog(
      context,
      currentValue: goalMinutes,
      isCustom: _isCustomGoal,
      onConfirm: (value) => setState(() {
        goalMinutes = value;
        _isCustomGoal = true;
      }),
    );
  }

  void _showCustomTargetDialog() {
    showCustomTargetDialog(
      context,
      currentValue: targetHours,
      isCustom: _isCustomTarget,
      onConfirm: (value) => setState(() {
        targetHours = value;
        _isCustomTarget = true;
      }),
    );
  }
}
