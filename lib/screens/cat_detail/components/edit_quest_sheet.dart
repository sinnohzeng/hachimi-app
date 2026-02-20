// ---
// 📘 文件说明：
// Edit Quest Sheet — 编辑任务 BottomSheet 组件。
// 支持修改任务的名称、每日目标和总目标。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 Habit 数据，初始化表单状态；
// 2. 渲染名称输入框；
// 3. 渲染每日目标和总目标 ChoiceChip 组；
// 4. 保存时调用 Firestore 更新任务；
//
// 🧩 文件结构：
// - EditQuestSheet：编辑任务 BottomSheet ConsumerStatefulWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Modal bottom sheet for editing quest: name, goal, target.
class EditQuestSheet extends ConsumerStatefulWidget {
  final Habit habit;

  const EditQuestSheet({super.key, required this.habit});

  @override
  ConsumerState<EditQuestSheet> createState() => _EditQuestSheetState();
}

class _EditQuestSheetState extends ConsumerState<EditQuestSheet> {
  late final TextEditingController _nameController;
  late int _selectedGoal;
  late int _selectedTarget;
  bool _isSaving = false;

  static const _defaultGoalOptions = [15, 25, 40, 60];
  static const _defaultTargetOptions = [50, 100, 200, 500];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _selectedGoal = widget.habit.goalMinutes;
    _selectedTarget = widget.habit.targetHours;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Include current value in chips if non-standard
    final goalChips = _buildChipValues(_defaultGoalOptions, _selectedGoal);
    final targetChips = _buildChipValues(_defaultTargetOptions, _selectedTarget);

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

            // Daily goal chips
            Text(context.l10n.catDetailDailyGoalMinutes, style: textTheme.labelLarge),
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

            // Target hours chips
            Text(context.l10n.catDetailTargetTotalHours, style: textTheme.labelLarge),
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
            const SizedBox(height: AppSpacing.xl),

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

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    HapticFeedback.mediumImpact();
    await ref.read(firestoreServiceProvider).updateHabit(
          uid: uid,
          habitId: widget.habit.id,
          name: name != widget.habit.name ? name : null,
          goalMinutes: _selectedGoal != widget.habit.goalMinutes
              ? _selectedGoal
              : null,
          targetHours: _selectedTarget != widget.habit.targetHours
              ? _selectedTarget
              : null,
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
