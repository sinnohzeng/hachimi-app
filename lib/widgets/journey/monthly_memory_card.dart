import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/journey_providers.dart';
import 'package:uuid/uuid.dart';

/// 本月记忆与成就卡片 — 两个文本字段，保存到 MonthlyPlan。
class MonthlyMemoryCard extends ConsumerStatefulWidget {
  const MonthlyMemoryCard({super.key});

  @override
  ConsumerState<MonthlyMemoryCard> createState() => _MonthlyMemoryCardState();
}

class _MonthlyMemoryCardState extends ConsumerState<MonthlyMemoryCard> {
  final _memoryController = TextEditingController();
  final _achievementController = TextEditingController();
  String? _loadedPlanId;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _memoryController.addListener(_scheduleSave);
    _achievementController.addListener(_scheduleSave);
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _memoryController.dispose();
    _achievementController.dispose();
    super.dispose();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), _save);
  }

  void _loadFromPlan(MonthlyPlan plan) {
    if (_loadedPlanId == plan.id) return;
    _loadedPlanId = plan.id;
    _memoryController.text = plan.memory ?? '';
    _achievementController.text = plan.achievement ?? '';
  }

  Future<void> _save() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

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
            .copyWith(
              memory: _memoryController.text.trim().isEmpty
                  ? null
                  : _memoryController.text.trim(),
              clearMemory: _memoryController.text.trim().isEmpty,
              achievement: _achievementController.text.trim().isEmpty
                  ? null
                  : _achievementController.text.trim(),
              clearAchievement: _achievementController.text.trim().isEmpty,
              updatedAt: now,
            );

    try {
      await ref.read(planRepositoryProvider).saveMonthlyPlan(uid, plan);
    } on Exception catch (e) {
      debugPrint('[MonthlyMemoryCard] Save error: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(currentMonthPlanProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                Icon(
                  Icons.auto_stories_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('本月记忆', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _memoryController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '这个月最美好的记忆是...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.star_outline, size: 20, color: colorScheme.tertiary),
                const SizedBox(width: AppSpacing.sm),
                Text('本月成就', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _achievementController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '这个月我最骄傲的成就是...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
