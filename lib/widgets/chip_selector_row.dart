import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// 通用 Chip 选择行 — 固定选项 + 可选自定义按钮。
///
/// 消除 EditQuestSheet 和 AdoptionStep1Form 中各 ~40 行的重复代码。
class ChipSelectorRow extends StatelessWidget {
  /// 标题文案。
  final String label;

  /// 可选值列表。
  final List<int> options;

  /// 当前选中值。
  final int? selected;

  /// 是否为自定义值（custom chip 高亮）。
  final bool isCustom;

  /// 选项标签构建器，如 `(v) => '${v}h'`。
  final String Function(int value) labelBuilder;

  /// 选中回调。
  final ValueChanged<int> onSelected;

  /// 自定义按钮点击回调。
  final VoidCallback? onCustom;

  /// 自定义按钮文案。
  final String customLabel;

  const ChipSelectorRow({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.isCustom,
    required this.labelBuilder,
    required this.onSelected,
    this.onCustom,
    this.customLabel = 'Custom',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          children: [
            ...options.map(_buildOptionChip),
            if (onCustom != null) _buildCustomChip(),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionChip(int value) {
    final active = !isCustom && selected == value;
    return ChoiceChip(
      label: Text(labelBuilder(value)),
      selected: active,
      onSelected: (_) => onSelected(value),
    );
  }

  Widget _buildCustomChip() {
    if (isCustom && selected != null) {
      return ChoiceChip(
        label: Text(labelBuilder(selected!)),
        selected: true,
        onSelected: (_) => onCustom!(),
      );
    }
    return ActionChip(
      label: Text(customLabel),
      avatar: const Icon(Icons.tune, size: 18),
      onPressed: onCustom,
    );
  }
}
