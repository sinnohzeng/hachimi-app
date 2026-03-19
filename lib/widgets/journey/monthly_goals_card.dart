import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/journey_providers.dart';
import 'package:uuid/uuid.dart';

/// 本月目标卡片 — 5 个带勾选的目标条目，支持内联编辑。
class MonthlyGoalsCard extends ConsumerStatefulWidget {
  const MonthlyGoalsCard({super.key});

  @override
  ConsumerState<MonthlyGoalsCard> createState() => _MonthlyGoalsCardState();
}

class _MonthlyGoalsCardState extends ConsumerState<MonthlyGoalsCard> {
  static const _maxGoals = 5;
  final _controllers = List.generate(_maxGoals, (_) => TextEditingController());
  final _completed = List.filled(_maxGoals, false);
  String? _loadedPlanId;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadFromPlan(MonthlyPlan plan) {
    if (_loadedPlanId == plan.id) return;
    _loadedPlanId = plan.id;
    for (var i = 0; i < _maxGoals; i++) {
      if (i < plan.goals.length) {
        _controllers[i].text = plan.goals[i].text;
        _completed[i] = plan.goals[i].completed;
      } else {
        _controllers[i].text = '';
        _completed[i] = false;
      }
    }
  }

  Future<void> _save() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final goals = <MonthlyGoal>[];
    for (var i = 0; i < _maxGoals; i++) {
      final text = _controllers[i].text.trim();
      if (text.isNotEmpty) {
        goals.add(MonthlyGoal(text: text, completed: _completed[i]));
      }
    }

    final existing = ref.read(currentMonthPlanProvider).value;
    final now = DateTime.now();
    final plan =
        (existing ??
                MonthlyPlan(
                  id: const Uuid().v4(),
                  monthId: AppDateUtils.currentMonth(),
                  createdAt: now,
                  updatedAt: now,
                ))
            .copyWith(goals: goals, updatedAt: now);

    try {
      await ref.read(planRepositoryProvider).saveMonthlyPlan(uid, plan);
    } on Exception catch (e) {
      debugPrint('[MonthlyGoalsCard] Save error: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(currentMonthPlanProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    planAsync.whenData((plan) {
      if (plan != null) _loadFromPlan(plan);
    });

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag_outlined, size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('本月目标', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(
              _maxGoals,
              (i) => _GoalRow(
                controller: _controllers[i],
                completed: _completed[i],
                hint: '目标 ${i + 1}',
                onCompletedChanged: (v) {
                  setState(() => _completed[i] = v);
                  _save();
                },
                onEditingComplete: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final TextEditingController controller;
  final bool completed;
  final String hint;
  final ValueChanged<bool> onCompletedChanged;
  final VoidCallback onEditingComplete;

  const _GoalRow({
    required this.controller,
    required this.completed,
    required this.hint,
    required this.onCompletedChanged,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Checkbox(
            value: completed,
            onChanged: (v) => onCompletedChanged(v ?? false),
            visualDensity: VisualDensity.compact,
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
              ),
            ),
            style: textTheme.bodyMedium?.copyWith(
              decoration: completed ? TextDecoration.lineThrough : null,
            ),
            onEditingComplete: onEditingComplete,
          ),
        ),
      ],
    );
  }
}
