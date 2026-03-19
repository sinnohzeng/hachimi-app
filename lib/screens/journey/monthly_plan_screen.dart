import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/journey_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

/// 月计划全页编辑器 — 月目标、小赢挑战、自我关怀、本月记忆/成就。
class MonthlyPlanScreen extends ConsumerStatefulWidget {
  const MonthlyPlanScreen({super.key});

  @override
  ConsumerState<MonthlyPlanScreen> createState() => _MonthlyPlanScreenState();
}

class _MonthlyPlanScreenState extends ConsumerState<MonthlyPlanScreen> {
  static const _maxGoals = 5;

  final _goalControllers = List.generate(
    _maxGoals,
    (_) => TextEditingController(),
  );
  final _goalCompleted = List.filled(_maxGoals, false);
  final _challengeNameController = TextEditingController();
  final _challengeRewardController = TextEditingController();
  final _memoryController = TextEditingController();
  final _achievementController = TextEditingController();
  final _selfCareControllers = List.generate(3, (_) => TextEditingController());

  bool _loaded = false;
  bool _isSaving = false;

  @override
  void dispose() {
    for (final c in _goalControllers) {
      c.dispose();
    }
    _challengeNameController.dispose();
    _challengeRewardController.dispose();
    _memoryController.dispose();
    _achievementController.dispose();
    for (final c in _selfCareControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadFromPlan(MonthlyPlan plan) {
    if (_loaded) return;
    _loaded = true;

    for (var i = 0; i < plan.goals.length && i < _maxGoals; i++) {
      _goalControllers[i].text = plan.goals[i].text;
      _goalCompleted[i] = plan.goals[i].completed;
    }
    _challengeNameController.text = plan.challengeHabitName ?? '';
    _challengeRewardController.text = plan.challengeReward ?? '';
    _memoryController.text = plan.memory ?? '';
    _achievementController.text = plan.achievement ?? '';
    for (var i = 0; i < plan.selfCareActivities.length && i < 3; i++) {
      _selfCareControllers[i].text = plan.selfCareActivities[i];
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final goals = <MonthlyGoal>[];
      for (var i = 0; i < _maxGoals; i++) {
        final text = _goalControllers[i].text.trim();
        if (text.isNotEmpty) {
          goals.add(MonthlyGoal(text: text, completed: _goalCompleted[i]));
        }
      }

      final selfCare = _selfCareControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final existing = ref.read(currentMonthPlanProvider).value;
      final now = DateTime.now();

      String? trimOrNull(TextEditingController c) {
        final t = c.text.trim();
        return t.isEmpty ? null : t;
      }

      final plan = MonthlyPlan(
        id: existing?.id ?? const Uuid().v4(),
        monthId: AppDateUtils.currentMonth(),
        goals: goals,
        challengeHabitName: trimOrNull(_challengeNameController),
        challengeReward: trimOrNull(_challengeRewardController),
        selfCareActivities: selfCare,
        memory: trimOrNull(_memoryController),
        achievement: trimOrNull(_achievementController),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      await ref.read(planRepositoryProvider).saveMonthlyPlan(uid, plan);

      if (mounted) {
        AppFeedback.success(context, '已保存');
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[MonthlyPlanScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plan = ref.read(currentMonthPlanProvider).value;
      if (plan != null) _loadFromPlan(plan);
      if (!_loaded) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 触发 provider 订阅，保持数据刷新
    ref.watch(currentMonthPlanProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('月计划')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: const Text('保存'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 月目标
            _sectionTitle(textTheme, colorScheme, Icons.flag_outlined, '月目标'),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(
              _maxGoals,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Checkbox(
                        value: _goalCompleted[i],
                        onChanged: (v) =>
                            setState(() => _goalCompleted[i] = v ?? false),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _goalControllers[i],
                        decoration: InputDecoration(
                          hintText: '目标 ${i + 1}',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          decoration: _goalCompleted[i]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 小赢挑战
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.emoji_events_outlined,
              '小赢挑战',
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _challengeNameController,
              decoration: InputDecoration(
                labelText: '挑战习惯名称',
                hintText: '例：每天跑步 10 分钟',
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _challengeRewardController,
              decoration: InputDecoration(
                labelText: '完成后的奖励',
                hintText: '例：买一本想看的书',
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 爱自己活动
            _sectionTitle(textTheme, colorScheme, Icons.spa_outlined, '爱自己活动'),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: TextField(
                  controller: _selfCareControllers[i],
                  decoration: InputDecoration(
                    hintText: '活动 ${i + 1}',
                    border: OutlineInputBorder(
                      borderRadius: AppShape.borderSmall,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 本月记忆
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.auto_stories_outlined,
              '本月记忆',
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _memoryController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '这个月最美好的记忆是...',
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 本月成就
            _sectionTitle(textTheme, colorScheme, Icons.star_outline, '本月成就'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _achievementController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '这个月我最骄傲的成就是...',
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),

            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: textTheme.titleSmall),
      ],
    );
  }
}
