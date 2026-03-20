import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/yearly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/journey_providers.dart';
import 'package:uuid/uuid.dart';

/// 年度寄语卡片 — 7 个提示字段，保存到 YearlyPlan。
class YearlyMessagesCard extends ConsumerStatefulWidget {
  const YearlyMessagesCard({super.key});

  @override
  ConsumerState<YearlyMessagesCard> createState() => _YearlyMessagesCardState();
}

class _YearlyMessagesCardState extends ConsumerState<YearlyMessagesCard> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  String? _loadedPlanId;
  Timer? _saveTimer;

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

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_promptCount, (_) => TextEditingController());
    _focusNodes = List.generate(_promptCount, (_) {
      final node = FocusNode();
      node.addListener(() {
        if (!node.hasFocus) _save();
      });
      return node;
    });
    for (final controller in _controllers) {
      controller.addListener(_scheduleSave);
    }
  }

  @override
  void dispose() {
    // 离开页面时立即保存未提交的内容
    _saveTimer?.cancel();
    _save();
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), _save);
  }

  void _loadFromPlan(YearlyPlan plan) {
    if (_loadedPlanId == plan.id) return;
    _loadedPlanId = plan.id;
    _controllers[0].text = plan.becomePerson ?? '';
    _controllers[1].text = plan.achieveGoals ?? '';
    _controllers[2].text = plan.breakthrough ?? '';
    _controllers[3].text = plan.dontDo ?? '';
    _controllers[4].text = plan.yearKeyword ?? '';
    _controllers[5].text = plan.futureMessage ?? '';
    _controllers[6].text = plan.motto ?? '';
  }

  Future<void> _save() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final year = DateTime.now().year;
    final existing = ref.read(currentYearPlanProvider).value;
    final now = DateTime.now();

    String? trimOrNull(String text) {
      final trimmed = text.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final plan =
        (existing ??
                YearlyPlan(
                  id: const Uuid().v4(),
                  year: year,
                  createdAt: now,
                  updatedAt: now,
                ))
            .copyWith(
              becomePerson: trimOrNull(_controllers[0].text),
              clearBecomePerson: _controllers[0].text.trim().isEmpty,
              achieveGoals: trimOrNull(_controllers[1].text),
              clearAchieveGoals: _controllers[1].text.trim().isEmpty,
              breakthrough: trimOrNull(_controllers[2].text),
              clearBreakthrough: _controllers[2].text.trim().isEmpty,
              dontDo: trimOrNull(_controllers[3].text),
              clearDontDo: _controllers[3].text.trim().isEmpty,
              yearKeyword: trimOrNull(_controllers[4].text),
              clearYearKeyword: _controllers[4].text.trim().isEmpty,
              futureMessage: trimOrNull(_controllers[5].text),
              clearFutureMessage: _controllers[5].text.trim().isEmpty,
              motto: trimOrNull(_controllers[6].text),
              clearMotto: _controllers[6].text.trim().isEmpty,
              updatedAt: now,
            );

    try {
      await ref.read(planRepositoryProvider).saveYearlyPlan(uid, plan);
    } on Exception catch (e) {
      debugPrint('[YearlyMessagesCard] Save error: $e');
      if (mounted) AppFeedback.error(context, context.l10n.commonSaveError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(currentYearPlanProvider);
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
                Icon(Icons.edit_note, size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n.yearlyMessagesTitle,
                  style: textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(_promptCount, (i) {
              final prompts = _prompts(context);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  maxLines: i == 5 ? 3 : 1, // "给未来的我" 多行
                  decoration: InputDecoration(
                    labelText: prompts[i],
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
