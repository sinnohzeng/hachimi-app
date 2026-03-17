import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// TagSelector — 多选标签 + 可选自定义输入。
///
/// 预设标签使用 [FilterChip]，自定义标签通过
/// 内联 TextField 输入后添加到选中列表。
class TagSelector extends StatefulWidget {
  /// 预设标签列表。
  final List<String> presetTags;

  /// 当前选中的标签集合。
  final Set<String> selectedTags;

  /// 标签变更回调。
  final ValueChanged<Set<String>> onTagsChanged;

  /// 是否允许自定义标签输入。
  final bool allowCustom;

  const TagSelector({
    super.key,
    required this.presetTags,
    required this.selectedTags,
    required this.onTagsChanged,
    this.allowCustom = true,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  bool _showCustomInput = false;
  late final TextEditingController _customController;
  late final FocusNode _customFocus;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
    _customFocus = FocusNode();
  }

  @override
  void dispose() {
    _customController.dispose();
    _customFocus.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    final updated = Set<String>.from(widget.selectedTags);
    if (updated.contains(tag)) {
      updated.remove(tag);
    } else {
      updated.add(tag);
    }
    widget.onTagsChanged(updated);
  }

  void _submitCustomTag() {
    final text = _customController.text.trim();
    if (text.isEmpty) {
      setState(() => _showCustomInput = false);
      return;
    }
    final updated = Set<String>.from(widget.selectedTags)..add(text);
    widget.onTagsChanged(updated);
    _customController.clear();
    setState(() => _showCustomInput = false);
  }

  void _openCustomInput() {
    setState(() => _showCustomInput = true);
    // 延迟请求焦点，等待 TextField 构建完成。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _customFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        ...widget.presetTags.map(_buildPresetChip),
        ..._buildCustomChips(),
        if (widget.allowCustom) _buildCustomAction(),
      ],
    );
  }

  Widget _buildPresetChip(String tag) {
    return FilterChip(
      label: Text(tag),
      selected: widget.selectedTags.contains(tag),
      onSelected: (_) => _toggleTag(tag),
    );
  }

  /// 已添加的自定义标签（不在预设列表中的）。
  Iterable<Widget> _buildCustomChips() {
    final customTags = widget.selectedTags.where(
      (t) => !widget.presetTags.contains(t),
    );
    return customTags.map(
      (tag) => FilterChip(
        label: Text(tag),
        selected: true,
        onSelected: (_) => _toggleTag(tag),
      ),
    );
  }

  Widget _buildCustomAction() {
    if (_showCustomInput) {
      return SizedBox(
        width: 100,
        child: TextField(
          controller: _customController,
          focusNode: _customFocus,
          style: Theme.of(context).textTheme.labelLarge,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
          ),
          onSubmitted: (_) => _submitCustomTag(),
          onTapOutside: (_) => _submitCustomTag(),
        ),
      );
    }
    // TODO(l10n): 将 '+自定义' 替换为 l10n key（待添加 tagAddCustom）。
    return ActionChip(label: const Text('+自定义'), onPressed: _openCustomInput);
  }
}
