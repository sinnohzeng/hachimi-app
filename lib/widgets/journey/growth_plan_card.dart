import 'dart:async';

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
import 'package:uuid/uuid.dart';

/// 年度成长计划卡片 — 8 维度网格，每个维度可填写笔记。
class GrowthPlanCard extends ConsumerStatefulWidget {
  const GrowthPlanCard({super.key});

  @override
  ConsumerState<GrowthPlanCard> createState() => _GrowthPlanCardState();
}

class _GrowthPlanCardState extends ConsumerState<GrowthPlanCard> {
  final _controllers = <String, TextEditingController>{};
  final _focusNodes = <String, FocusNode>{};
  String? _loadedPlanId;
  Timer? _saveTimer;

  static const _icons = <String, IconData>{
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
    for (final key in LumiConstants.growthDimensions.keys) {
      final controller = TextEditingController();
      controller.addListener(_scheduleSave);
      _controllers[key] = controller;

      final focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) _save();
      });
      _focusNodes[key] = focusNode;
    }
  }

  @override
  void dispose() {
    // 离开页面时立即保存未提交的内容
    _saveTimer?.cancel();
    _save();
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    for (final c in _controllers.values) {
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
    final dims = plan.growthDimensions ?? {};
    for (final key in _controllers.keys) {
      _controllers[key]?.text = dims[key] ?? '';
    }
  }

  Future<void> _save() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final dims = <String, String>{};
    for (final entry in _controllers.entries) {
      final text = entry.value.text.trim();
      if (text.isNotEmpty) dims[entry.key] = text;
    }

    final year = DateTime.now().year;
    final existing = ref.read(currentYearPlanProvider).value;
    final now = DateTime.now();

    final plan =
        (existing ??
                YearlyPlan(
                  id: const Uuid().v4(),
                  year: year,
                  createdAt: now,
                  updatedAt: now,
                ))
            .copyWith(
              growthDimensions: dims.isEmpty ? null : dims,
              clearGrowthDimensions: dims.isEmpty,
              updatedAt: now,
            );

    try {
      await ref.read(planRepositoryProvider).saveYearlyPlan(uid, plan);
    } on Exception catch (e) {
      debugPrint('[GrowthPlanCard] Save error: $e');
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

    final entries = LumiConstants.growthDimensions.entries.toList();

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rocket_launch_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(context.l10n.growthPlanTitle, style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.3,
              ),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final key = entries[i].key;
                final label = entries[i].value;
                final icon = _icons[key] ?? Icons.circle_outlined;

                return Container(
                  padding: AppSpacing.paddingSm,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: AppShape.borderSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 16, color: colorScheme.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              label,
                              style: textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Expanded(
                        child: TextField(
                          controller: _controllers[key],
                          focusNode: _focusNodes[key],
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: context.l10n.growthPlanHint,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
