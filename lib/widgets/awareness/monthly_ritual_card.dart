import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';

/// 月初仪式卡片 — 在觉知 Tab「今天」子标签中展示。
///
/// 每月第一次显示时展示设定提示，设定后显示 30 天进度网格。
/// 数据存储在 materialized_state 表中（key-value 对）。
class MonthlyRitualCard extends ConsumerWidget {
  const MonthlyRitualCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();

    final ritualAsync = ref.watch(_monthlyRitualProvider(uid));

    return ritualAsync.when(
      data: (ritual) {
        if (ritual == null) return _SetupPromptCard(uid: uid);
        return _ProgressCard(ritual: ritual, uid: uid);
      },
      loading: () => const SizedBox.shrink(),
      error: (e, stack) {
        // 生产环境可见性：装饰性卡片静默降级
        debugPrint('[MonthlyRitual] Load failed: $e');
        return const SizedBox.shrink();
      },
    );
  }
}

// ─── 数据模型 ───

class _MonthlyRitual {
  final String habitId;
  final String habitName;
  final String month;
  final int targetDays;
  final String rewardText;
  final Set<String> completedDays;

  const _MonthlyRitual({
    required this.habitId,
    required this.habitName,
    required this.month,
    required this.targetDays,
    required this.rewardText,
    required this.completedDays,
  });
}

// ─── Provider ───

/// 当前月的月度仪式数据 — 从 materialized_state 读取。
final _monthlyRitualProvider = FutureProvider.family<_MonthlyRitual?, String>((
  ref,
  uid,
) async {
  final ledger = ref.watch(ledgerServiceProvider);
  final currentMonth = _currentMonthString();

  final ritualMonth = await ledger.getMaterialized(uid, 'monthly_ritual_month');
  if (ritualMonth != currentMonth) return null;

  final habitId =
      await ledger.getMaterialized(uid, 'monthly_ritual_habit_id') ?? '';
  final targetStr =
      await ledger.getMaterialized(uid, 'monthly_ritual_target_days') ?? '20';
  final rewardText =
      await ledger.getMaterialized(uid, 'monthly_ritual_reward_text') ?? '';
  final completedJson = await ledger.getMaterialized(
    uid,
    'monthly_ritual_completed_days',
  );

  // 从习惯 ID 获取习惯名称
  final habits = ref.read(habitsProvider).value ?? [];
  final habit = habits.where((h) => h.id == habitId).firstOrNull;
  final habitName = habit?.name ?? '';

  Set<String> completedDays = {};
  if (completedJson != null) {
    try {
      final decoded = jsonDecode(completedJson);
      if (decoded is List) {
        completedDays = decoded.whereType<String>().toSet();
      }
    } on FormatException catch (e) {
      debugPrint('[MonthlyRitual] JSON parse failed: $e');
    }
  }

  return _MonthlyRitual(
    habitId: habitId,
    habitName: habitName,
    month: currentMonth,
    targetDays: int.tryParse(targetStr) ?? 20,
    rewardText: rewardText,
    completedDays: completedDays,
  );
});

String _currentMonthString() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

// ─── 设定提示卡 ───

class _SetupPromptCard extends ConsumerWidget {
  final String uid;

  const _SetupPromptCard({required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.monthlyRitualSetupTitle,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.monthlyRitualSetupDesc,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: () => _showSetupDialog(context, ref),
                child: Text(l10n.monthlyRitualSetupButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSetupDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<_SetupResult>(
      context: context,
      builder: (ctx) => _SetupDialog(uid: uid),
    );
    if (result == null) return;

    try {
      final ledger = ref.read(ledgerServiceProvider);
      final month = _currentMonthString();
      await ledger.setMaterialized(
        uid,
        'monthly_ritual_habit_id',
        result.habitId,
      );
      await ledger.setMaterialized(uid, 'monthly_ritual_month', month);
      await ledger.setMaterialized(
        uid,
        'monthly_ritual_target_days',
        result.targetDays.toString(),
      );
      await ledger.setMaterialized(
        uid,
        'monthly_ritual_reward_text',
        result.rewardText,
      );
      await ledger.setMaterialized(uid, 'monthly_ritual_completed_days', '[]');
      if (!context.mounted) return;
      // 刷新 Provider
      ref.invalidate(_monthlyRitualProvider(uid));
    } catch (e) {
      debugPrint('[MonthlyRitual] Save failed: $e');
      if (context.mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    }
  }
}

// ─── 设定对话框 ───

class _SetupResult {
  final String habitId;
  final int targetDays;
  final String rewardText;

  const _SetupResult({
    required this.habitId,
    required this.targetDays,
    required this.rewardText,
  });
}

class _SetupDialog extends ConsumerStatefulWidget {
  final String uid;

  const _SetupDialog({required this.uid});

  @override
  ConsumerState<_SetupDialog> createState() => _SetupDialogState();
}

class _SetupDialogState extends ConsumerState<_SetupDialog> {
  String? _selectedHabitId;
  double _targetDays = 20;
  final _rewardController = TextEditingController();

  @override
  void dispose() {
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final habits = ref.watch(habitsProvider).value ?? [];

    return AlertDialog(
      title: Text(l10n.monthlyRitualDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 习惯选择
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: l10n.monthlyRitualHabitLabel,
              ),
              initialValue: _selectedHabitId,
              items: habits
                  .map(
                    (h) => DropdownMenuItem(value: h.id, child: Text(h.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedHabitId = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            // 目标天数
            Text(l10n.monthlyRitualTargetLabel),
            Slider(
              value: _targetDays,
              min: 10,
              max: 30,
              divisions: 20,
              label: l10n.monthlyRitualTargetValue(_targetDays.round()),
              onChanged: (v) => setState(() => _targetDays = v),
            ),
            Text(
              l10n.monthlyRitualTargetValue(_targetDays.round()),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            // 奖励文本
            TextField(
              controller: _rewardController,
              decoration: InputDecoration(
                labelText: l10n.monthlyRitualRewardLabel,
                hintText: l10n.monthlyRitualRewardHint,
              ),
              maxLength: 50,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.awarenessBridgeSkip),
        ),
        FilledButton(
          onPressed: _selectedHabitId == null
              ? null
              : () => Navigator.of(context).pop(
                  _SetupResult(
                    habitId: _selectedHabitId!,
                    targetDays: _targetDays.round(),
                    rewardText: _rewardController.text.trim(),
                  ),
                ),
          child: Text(l10n.monthlyRitualSetupButton),
        ),
      ],
    );
  }
}

// ─── 进度卡 ───

class _ProgressCard extends StatelessWidget {
  final _MonthlyRitual ritual;
  final String uid;

  const _ProgressCard({required this.ritual, required this.uid});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final completedCount = ritual.completedDays.length;
    final achieved = completedCount >= ritual.targetDays;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Text(
              ritual.habitName,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (ritual.rewardText.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                ritual.rewardText,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            // 30 天网格
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List.generate(daysInMonth, (index) {
                final day = index + 1;
                final dateStr =
                    '${now.year}-'
                    '${now.month.toString().padLeft(2, '0')}-'
                    '${day.toString().padLeft(2, '0')}';
                final isCompleted = ritual.completedDays.contains(dateStr);
                final isToday = day == now.day;
                final isFuture = day > now.day;

                return _DayDot(
                  day: day,
                  isCompleted: isCompleted,
                  isToday: isToday,
                  isFuture: isFuture,
                );
              }),
            ),
            const SizedBox(height: AppSpacing.md),
            // 进度文案
            Text(
              achieved
                  ? l10n.monthlyRitualAchieved
                  : l10n.monthlyRitualProgress(
                      completedCount,
                      ritual.targetDays,
                    ),
              style: textTheme.bodyMedium?.copyWith(
                color: achieved ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: achieved ? FontWeight.bold : null,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.monthlyRitualEncouragement,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 日期圆点 ───

class _DayDot extends StatelessWidget {
  final int day;
  final bool isCompleted;
  final bool isToday;
  final bool isFuture;

  const _DayDot({
    required this.day,
    required this.isCompleted,
    required this.isToday,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color bgColor;
    Color textColor;
    if (isCompleted) {
      bgColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
    } else if (isToday) {
      bgColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
    } else if (isFuture) {
      bgColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
      textColor = colorScheme.onSurface.withValues(alpha: 0.38);
    } else {
      bgColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Text(
        '$day',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: isToday ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
