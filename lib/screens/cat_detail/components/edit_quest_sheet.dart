import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/motivation_quotes.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Modal bottom sheet for editing quest: name, goal, target, motivation.
class EditQuestSheet extends ConsumerStatefulWidget {
  final Habit habit;

  const EditQuestSheet({super.key, required this.habit});

  @override
  ConsumerState<EditQuestSheet> createState() => _EditQuestSheetState();
}

class _EditQuestSheetState extends ConsumerState<EditQuestSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _motivationController;
  late int _selectedGoal;
  late int? _selectedTarget;
  late bool _isUnlimitedMode;
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

    // Include current value in chips if non-standard
    final goalChips = _buildChipValues(_defaultGoalOptions, _selectedGoal);
    final targetChips = _selectedTarget != null
        ? _buildChipValues(_defaultTargetOptions, _selectedTarget!)
        : _defaultTargetOptions;
    final isTargetCompleted = widget.habit.targetCompleted;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            Text(
              context.l10n.catDetailEditQuestTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Name field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.l10n.catDetailQuestName,
                prefixIcon: const Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 目标模式切换
            Text(context.l10n.adoptionGoals, style: textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: true,
                  label: Text(context.l10n.adoptionUnlimitedMode),
                  icon: const Icon(Icons.all_inclusive, size: 18),
                ),
                ButtonSegment(
                  value: false,
                  label: Text(context.l10n.adoptionMilestoneMode),
                  icon: const Icon(Icons.flag_outlined, size: 18),
                  enabled: !isTargetCompleted,
                ),
              ],
              selected: {_isUnlimitedMode},
              onSelectionChanged: isTargetCompleted
                  ? null
                  : (selected) => setState(() {
                      _isUnlimitedMode = selected.first;
                      if (!_isUnlimitedMode) {
                        _selectedTarget ??= 100;
                      }
                    }),
            ),
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
            const SizedBox(height: AppSpacing.lg),

            // 里程碑模式：目标小时数 + 截止日期
            if (!_isUnlimitedMode) ...[
              Text(
                context.l10n.catDetailTargetTotalHours,
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                children: targetChips.map((hrs) {
                  return ChoiceChip(
                    label: Text('$hrs'),
                    selected: _selectedTarget == hrs,
                    onSelected: (_) => setState(() => _selectedTarget = hrs),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),

              // 截止日期
              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    context.l10n.adoptionDeadlineLabel,
                    style: textTheme.labelLarge,
                  ),
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
                      visualDensity: VisualDensity.compact,
                    ),
                  ] else
                    TextButton(
                      onPressed: _pickDeadlineDate,
                      child: Text(context.l10n.adoptionDeadlineNone),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Daily goal chips
            Text(
              context.l10n.catDetailDailyGoalMinutes,
              style: textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: goalChips.map((mins) {
                return ChoiceChip(
                  label: Text('$mins'),
                  selected: _selectedGoal == mins,
                  onSelected: (_) => setState(() => _selectedGoal = mins),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Motivation field
            TextField(
              controller: _motivationController,
              maxLength: 40,
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
                      exclude: current.isNotEmpty ? current : null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.commonSave),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _buildChipValues(List<int> defaults, int current) {
    final chips = [...defaults];
    if (!chips.contains(current)) {
      chips.add(current);
      chips.sort();
    }
    return chips;
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
    if (date != null) {
      setState(() => _deadlineDate = date);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    // 判断激励语是否变化
    final newMotivation = _motivationController.text.trim();
    final oldMotivation = widget.habit.motivationText ?? '';
    final motivationChanged = newMotivation != oldMotivation;

    // 判断目标模式是否变化
    final wasUnlimited = widget.habit.isUnlimited;
    final switchedToUnlimited = !wasUnlimited && _isUnlimitedMode;
    final switchedToMilestone = wasUnlimited && !_isUnlimitedMode;

    // 判断截止日期是否变化
    final oldDeadline = widget.habit.deadlineDate;
    final deadlineChanged = _deadlineDate != oldDeadline;
    final deadlineCleared = deadlineChanged && _deadlineDate == null;

    HapticFeedback.mediumImpact();
    await ref
        .read(firestoreServiceProvider)
        .updateHabit(
          uid: uid,
          habitId: widget.habit.id,
          name: name != widget.habit.name ? name : null,
          goalMinutes: _selectedGoal != widget.habit.goalMinutes
              ? _selectedGoal
              : null,
          targetHours:
              switchedToMilestone ||
                  (!_isUnlimitedMode &&
                      _selectedTarget != widget.habit.targetHours)
              ? _selectedTarget
              : null,
          clearTargetHours: switchedToUnlimited,
          deadlineDate: !_isUnlimitedMode && deadlineChanged && !deadlineCleared
              ? _deadlineDate
              : null,
          clearDeadlineDate: _isUnlimitedMode || deadlineCleared,
          motivationText: motivationChanged && newMotivation.isNotEmpty
              ? newMotivation
              : null,
          clearMotivation:
              motivationChanged &&
              newMotivation.isEmpty &&
              oldMotivation.isNotEmpty,
        );

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
}
