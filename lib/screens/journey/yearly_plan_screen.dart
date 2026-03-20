import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/lumi_constants.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
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

  static const _promptCount = 7;

  List<String> _prompts(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.yearlyMessageBecome,
      l10n.yearlyMessageGoals,
      l10n.yearlyMessageBreakthrough,
      l10n.yearlyMessageDontDo,
      l10n.yearlyMessageKeyword,
      l10n.yearlyMessageFutureSelf,
      l10n.yearlyMessageMotto,
    ];
  }

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
      _promptCount,
      (_) => TextEditingController(),
    );
    for (final key in LumiConstants.growthDimensions.keys) {
      _dimControllers[key] = TextEditingController();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(currentYearPlanProvider, (prev, next) {
        next.whenData((plan) {
          if (plan != null && !_loaded) {
            _loadFromPlan(plan);
            setState(() {});
          }
        });
      }, fireImmediately: true);
    });
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
        AppFeedback.success(context, context.l10n.commonSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[YearlyPlanScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, context.l10n.commonSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 触发 provider 订阅，保持数据刷新
    ref.watch(currentYearPlanProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final dimEntries = LumiConstants.growthDimensions.entries.toList();

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n.yearlyPlanScreenTitle(DateTime.now().year)),
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
        label: Text(context.l10n.commonSave),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 年度寄语
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.edit_note,
              context.l10n.yearlyPlanMessagesSection,
            ),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(_promptCount, (i) {
              final prompts = _prompts(context);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TextField(
                  controller: _messageControllers[i],
                  maxLines: i == 5 ? 4 : 2,
                  decoration: InputDecoration(
                    labelText: prompts[i],
                    border: OutlineInputBorder(
                      borderRadius: AppShape.borderSmall,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              );
            }),

            const SizedBox(height: AppSpacing.lg),

            // 成长计划
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.rocket_launch_outlined,
              context.l10n.yearlyPlanGrowthSection,
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
