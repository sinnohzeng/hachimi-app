import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/weekly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/journey_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

/// 周计划编辑页 — 一句话 + 四象限任务列表。
class WeeklyPlanScreen extends ConsumerStatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  ConsumerState<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends ConsumerState<WeeklyPlanScreen> {
  final _oneLineController = TextEditingController();
  final _urgentImportant = <String>[];
  final _importantNotUrgent = <String>[];
  final _urgentNotImportant = <String>[];
  final _wantToDo = <String>[];
  bool _loaded = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _oneLineController.dispose();
    super.dispose();
  }

  void _loadFromPlan(WeeklyPlan plan) {
    if (_loaded) return;
    _loaded = true;
    _oneLineController.text = plan.oneLineForSelf ?? '';
    _urgentImportant.addAll(plan.urgentImportant);
    _importantNotUrgent.addAll(plan.importantNotUrgent);
    _urgentNotImportant.addAll(plan.urgentNotImportant);
    _wantToDo.addAll(plan.wantToDo);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final weekId = AppDateUtils.currentWeekId();
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));

      final existingPlan = ref.read(currentWeekPlanProvider).value;

      final plan = WeeklyPlan(
        id: existingPlan?.id ?? const Uuid().v4(),
        weekId: weekId,
        weekStartDate: AppDateUtils.formatDay(monday),
        weekEndDate: AppDateUtils.formatDay(sunday),
        oneLineForSelf: _oneLineController.text.trim().isEmpty
            ? null
            : _oneLineController.text.trim(),
        urgentImportant: _urgentImportant,
        importantNotUrgent: _importantNotUrgent,
        urgentNotImportant: _urgentNotImportant,
        wantToDo: _wantToDo,
        createdAt: existingPlan?.createdAt ?? now,
        updatedAt: now,
      );

      await ref.read(planRepositoryProvider).saveWeeklyPlan(uid, plan);

      if (mounted) {
        AppFeedback.success(context, '已保存'); // TODO: l10n
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[WeeklyPlan] Save failed: $e');
      if (mounted) {
        AppFeedback.error(context, '保存失败'); // TODO: l10n
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plan = ref.read(currentWeekPlanProvider).value;
      if (plan != null) _loadFromPlan(plan);
      if (!_loaded) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 触发 provider 订阅，保持数据刷新
    ref.watch(currentWeekPlanProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('本周计划'), // TODO: l10n
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: const Text('保存'), // TODO: l10n
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 一句话
            Text(
              '写一句话给这周的自己', // TODO: l10n
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _oneLineController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '这周我想...', // TODO: l10n
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // 四象限
            _QuadrantSection(
              title: '必须做',
              subtitle: '紧急且重要', // TODO: l10n
              color: colorScheme.error,
              items: _urgentImportant,
              onAdd: (text) => setState(() => _urgentImportant.add(text)),
              onRemove: (i) => setState(() => _urgentImportant.removeAt(i)),
            ),
            const SizedBox(height: AppSpacing.md),
            _QuadrantSection(
              title: '要做',
              subtitle: '重要不紧急', // TODO: l10n
              color: colorScheme.primary,
              items: _importantNotUrgent,
              onAdd: (text) => setState(() => _importantNotUrgent.add(text)),
              onRemove: (i) => setState(() => _importantNotUrgent.removeAt(i)),
            ),
            const SizedBox(height: AppSpacing.md),
            _QuadrantSection(
              title: '该做',
              subtitle: '紧急不重要', // TODO: l10n
              color: colorScheme.tertiary,
              items: _urgentNotImportant,
              onAdd: (text) => setState(() => _urgentNotImportant.add(text)),
              onRemove: (i) => setState(() => _urgentNotImportant.removeAt(i)),
            ),
            const SizedBox(height: AppSpacing.md),
            _QuadrantSection(
              title: '想做',
              subtitle: '不紧急不重要', // TODO: l10n
              color: colorScheme.secondary,
              items: _wantToDo,
              onAdd: (text) => setState(() => _wantToDo.add(text)),
              onRemove: (i) => setState(() => _wantToDo.removeAt(i)),
            ),
            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }
}

/// 四象限条目区域 — 标题 + 列表 + 添加按钮。
class _QuadrantSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color color;
  final List<String> items;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  const _QuadrantSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<_QuadrantSection> createState() => _QuadrantSectionState();
}

class _QuadrantSectionState extends State<_QuadrantSection> {
  final _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _addController.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(text);
    _addController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: widget.color.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: AppShape.borderMedium,
        side: BorderSide(color: widget.color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  widget.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  widget.subtitle,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // 已有条目
            ...widget.items.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: Text(entry.value, style: textTheme.bodyMedium),
                    ),
                    IconButton(
                      onPressed: () => widget.onRemove(entry.key),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              );
            }),
            // 添加输入
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    decoration: InputDecoration(
                      hintText: '添加...', // TODO: l10n
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.base,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    onSubmitted: (_) => _addItem(),
                    style: textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: _addItem,
                  icon: Icon(Icons.add_circle_outline, color: widget.color),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
