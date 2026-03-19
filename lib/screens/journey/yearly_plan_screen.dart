import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/lumi_constants.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/models/yearly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/journey_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

/// 年计划全页编辑器 — 年度寄语 (7 字段) + 成长计划 (8 维度)。
class YearlyPlanScreen extends ConsumerStatefulWidget {
  const YearlyPlanScreen({super.key});

  @override
  ConsumerState<YearlyPlanScreen> createState() => _YearlyPlanScreenState();
}

class _YearlyPlanScreenState extends ConsumerState<YearlyPlanScreen> {
  // 年度寄语 7 字段
  late final List<TextEditingController> _messageControllers;
  // 成长维度 8 字段
  final _dimControllers = <String, TextEditingController>{};

  bool _loaded = false;
  bool _isSaving = false;

  static const _prompts = [
    '这一年我希望自己成为......',
    '达成目标',
    '突破性完成',
    '不做（说不，也是在为重要的事腾位置）',
    '年度关键词（例：专注/勇敢/耐心/温柔）',
    '给亲爱的未来的我',
    '我的座右铭',
  ];

  static const _dimIcons = <String, IconData>{
    'health': Icons.favorite_outline,
    'emotion': Icons.psychology_outlined,
    'relationship': Icons.people_outline,
    'career': Icons.work_outline,
    'finance': Icons.account_balance_wallet_outlined,
    'learning': Icons.school_outlined,
    'creativity': Icons.palette_outlined,
    'spirituality': Icons.self_improvement_outlined,
  };

  @override
  void initState() {
    super.initState();
    _messageControllers = List.generate(
      _prompts.length,
      (_) => TextEditingController(),
    );
    for (final key in LumiConstants.growthDimensions.keys) {
      _dimControllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _messageControllers) {
      c.dispose();
    }
    for (final c in _dimControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadFromPlan(YearlyPlan plan) {
    if (_loaded) return;
    _loaded = true;
    _messageControllers[0].text = plan.becomePerson ?? '';
    _messageControllers[1].text = plan.achieveGoals ?? '';
    _messageControllers[2].text = plan.breakthrough ?? '';
    _messageControllers[3].text = plan.dontDo ?? '';
    _messageControllers[4].text = plan.yearKeyword ?? '';
    _messageControllers[5].text = plan.futureMessage ?? '';
    _messageControllers[6].text = plan.motto ?? '';

    final dims = plan.growthDimensions ?? {};
    for (final entry in dims.entries) {
      _dimControllers[entry.key]?.text = entry.value;
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      String? trimOrNull(TextEditingController c) {
        final t = c.text.trim();
        return t.isEmpty ? null : t;
      }

      final dims = <String, String>{};
      for (final entry in _dimControllers.entries) {
        final text = entry.value.text.trim();
        if (text.isNotEmpty) dims[entry.key] = text;
      }

      final year = DateTime.now().year;
      final existing = ref.read(currentYearPlanProvider).value;
      final now = DateTime.now();

      final plan = YearlyPlan(
        id: existing?.id ?? const Uuid().v4(),
        year: year,
        becomePerson: trimOrNull(_messageControllers[0]),
        achieveGoals: trimOrNull(_messageControllers[1]),
        breakthrough: trimOrNull(_messageControllers[2]),
        dontDo: trimOrNull(_messageControllers[3]),
        yearKeyword: trimOrNull(_messageControllers[4]),
        futureMessage: trimOrNull(_messageControllers[5]),
        motto: trimOrNull(_messageControllers[6]),
        growthDimensions: dims.isEmpty ? null : dims,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      await ref.read(planRepositoryProvider).saveYearlyPlan(uid, plan);

      if (mounted) {
        AppFeedback.success(context, '已保存');
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[YearlyPlanScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(currentYearPlanProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    planAsync.whenData((plan) {
      if (plan != null) _loadFromPlan(plan);
      if (!_loaded) _loaded = true;
    });

    final dimEntries = LumiConstants.growthDimensions.entries.toList();

    return AppScaffold(
      appBar: AppBar(title: Text('${DateTime.now().year} 年度计划')),
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
            // 年度寄语
            _sectionTitle(textTheme, colorScheme, Icons.edit_note, '年度寄语'),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(
              _prompts.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TextField(
                  controller: _messageControllers[i],
                  maxLines: i == 5 ? 4 : 2,
                  decoration: InputDecoration(
                    labelText: _prompts[i],
                    border: OutlineInputBorder(
                      borderRadius: AppShape.borderSmall,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 成长计划
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.rocket_launch_outlined,
              '成长计划',
            ),
            const SizedBox(height: AppSpacing.md),
            ...dimEntries.map((entry) {
              final icon = _dimIcons[entry.key] ?? Icons.circle_outlined;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TextField(
                  controller: _dimControllers[entry.key],
                  maxLines: 2,
                  decoration: InputDecoration(
                    icon: Icon(icon, size: 20, color: colorScheme.primary),
                    labelText: entry.value,
                    border: OutlineInputBorder(
                      borderRadius: AppShape.borderSmall,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              );
            }),

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
        Text(title, style: textTheme.titleMedium),
      ],
    );
  }
}
