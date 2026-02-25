import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/motivation_quotes.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/growth_path_card.dart';
import 'package:hachimi_app/widgets/reminder_picker_sheet.dart';

/// 全屏编辑 Quest 页面 — 字段顺序与创建流程一致。
class EditQuestSheet extends ConsumerStatefulWidget {
  final Habit habit;
  final Cat cat;

  const EditQuestSheet({super.key, required this.habit, required this.cat});

  @override
  ConsumerState<EditQuestSheet> createState() => _EditQuestSheetState();
}

class _EditQuestSheetState extends ConsumerState<EditQuestSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _motivationController;
  late int _selectedGoal;
  late int? _selectedTarget;
  late bool _isUnlimitedMode;
  late bool _isCustomGoal;
  late bool _isCustomTarget;
  late List<ReminderConfig> _reminders;
  DateTime? _deadlineDate;
  bool _isSaving = false;

  static const _defaultGoalOptions = [15, 25, 40, 60];
  static const _defaultTargetOptions = [50, 100, 200, 500];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _motivationController = TextEditingController(
      text: widget.habit.motivationText ?? '',
    );
    _selectedGoal = widget.habit.goalMinutes;
    _selectedTarget = widget.habit.targetHours;
    _isUnlimitedMode = widget.habit.isUnlimited;
    _deadlineDate = widget.habit.deadlineDate;
    _reminders = [...widget.habit.reminders];

    _isCustomGoal = !_defaultGoalOptions.contains(_selectedGoal);
    _isCustomTarget =
        _selectedTarget != null &&
        !_defaultTargetOptions.contains(_selectedTarget);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isTargetCompleted = widget.habit.targetCompleted;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.catDetailEditQuestTitle)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingBase,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.adoptionQuestName,
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
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: context.l10n.adoptionMotivationSwap,
                        onPressed: () {
                          final current = _motivationController.text;
                          final locale = Localizations.localeOf(context);
                          _motivationController.text = randomMotivationQuote(
                            locale,
                            exclude: current.isNotEmpty ? current : null,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── 目标设置 ──
                  Text(
                    context.l10n.adoptionGoals,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                  _buildModeToggle(theme, isTargetCompleted),
                  if (isTargetCompleted) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.catDetailTargetCompletedHint,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),

                  // 里程碑模式：目标小时数 + 截止日期
                  if (!_isUnlimitedMode) ...[
                    Text(
                      context.l10n.adoptionTotalTarget,
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      children: [
                        ..._defaultTargetOptions.map((hours) {
                          final isSelected =
                              !_isCustomTarget && _selectedTarget == hours;
                          return ChoiceChip(
                            label: Text('${hours}h'),
                            selected: isSelected,
                            onSelected: (_) => setState(() {
                              _selectedTarget = hours;
                              _isCustomTarget = false;
                            }),
                          );
                        }),
                        if (_isCustomTarget)
                          ChoiceChip(
                            label: Text('${_selectedTarget}h'),
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

                    // 截止日期
                    _buildDeadlinePicker(theme),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // 每日目标
                  Text(
                    context.l10n.adoptionDailyGoalLabel,
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    children: [
                      ..._defaultGoalOptions.map((minutes) {
                        final isSelected =
                            !_isCustomGoal && _selectedGoal == minutes;
                        return ChoiceChip(
                          label: Text('${minutes}min'),
                          selected: isSelected,
                          onSelected: (_) => setState(() {
                            _selectedGoal = minutes;
                            _isCustomGoal = false;
                          }),
                        );
                      }),
                      if (_isCustomGoal)
                        ChoiceChip(
                          label: Text('${_selectedGoal}min'),
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
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildReminderList(theme),
                  const SizedBox(height: AppSpacing.lg),

                  // ── 成长之路 ──
                  const GrowthPathCard(),
                ],
              ),
            ),
          ),

          // 底部保存按钮
          SafeArea(
            child: Padding(
              padding: AppSpacing.paddingBase,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          context.l10n.commonSave,
                          style: textTheme.titleMedium?.copyWith(
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

  // ─── 目标模式切换（与创建界面一致的 _ModeOption 卡片） ───

  Widget _buildModeToggle(ThemeData theme, bool isTargetCompleted) {
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
          selected: {_isUnlimitedMode},
          onSelectionChanged: isTargetCompleted
              ? null
              : (modes) => setState(() {
                  _isUnlimitedMode = modes.first;
                  if (!_isUnlimitedMode) _selectedTarget ??= 100;
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

  // ─── 提醒列表 ───

  Widget _buildReminderList(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _reminders.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _reminders[i].localizedDescription(l10n),
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

  Future<void> _addReminder() async {
    final result = await showReminderPickerSheet(context);
    if (result != null) {
      setState(() => _reminders.add(result));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDeadlineDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _deadlineDate ?? now.add(const Duration(days: 30)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (date != null && mounted) {
      setState(() => _deadlineDate = date);
    }
  }

  void _showCustomGoalDialog() {
    final controller = TextEditingController(
      text: _isCustomGoal ? '$_selectedGoal' : '',
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
                _selectedGoal = value;
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
      text: _isCustomTarget ? '$_selectedTarget' : '',
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
                _selectedTarget = value;
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

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final newMotivation = _motivationController.text.trim();

    // 判断提醒是否变化
    final oldReminders = widget.habit.reminders;
    final remindersChanged = !_remindersEqual(oldReminders, _reminders);

    HapticFeedback.mediumImpact();

    // 构建完整的更新后 Habit — 直接用构造器确保所有字段正确
    final updatedHabit = Habit(
      id: widget.habit.id,
      name: name,
      targetHours: _isUnlimitedMode ? null : _selectedTarget,
      goalMinutes: _selectedGoal,
      reminders: _reminders,
      motivationText: newMotivation.isNotEmpty ? newMotivation : null,
      catId: widget.habit.catId,
      isActive: widget.habit.isActive,
      totalMinutes: widget.habit.totalMinutes,
      lastCheckInDate: widget.habit.lastCheckInDate,
      totalCheckInDays: widget.habit.totalCheckInDays,
      deadlineDate: _isUnlimitedMode ? null : _deadlineDate,
      targetCompleted: widget.habit.targetCompleted,
      createdAt: widget.habit.createdAt,
    );
    await ref.read(localHabitRepositoryProvider).update(uid, updatedHabit);

    // 提醒变更时重新调度通知
    if (remindersChanged && mounted) {
      final notifService = ref.read(notificationServiceProvider);
      if (_reminders.isEmpty) {
        await notifService.cancelAllRemindersForHabit(widget.habit.id);
      } else {
        final l10n = context.l10n;
        await notifService.scheduleReminders(
          habitId: widget.habit.id,
          habitName: name,
          catName: widget.cat.name,
          reminders: _reminders,
          title: l10n.reminderNotificationTitle(widget.cat.name),
          body: l10n.reminderNotificationBody(name),
        );
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.catDetailQuestUpdated),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// 比较两个提醒列表是否相同
  bool _remindersEqual(List<ReminderConfig> a, List<ReminderConfig> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].toMap().toString() != b[i].toMap().toString()) return false;
    }
    return true;
  }
}
