import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/awareness_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/widgets/awareness/tag_selector.dart';

/// HappyMomentCard — 幸福时刻输入卡片。
///
/// 包含编号标题、文本输入区和标签选择器，
/// 用于记录每日最多 3 个幸福时刻。
class HappyMomentCard extends StatefulWidget {
  /// 幸福时刻序号（1-3）。
  final int momentNumber;

  /// 当前文本内容。
  final String? text;

  /// 当前选中标签。
  final Set<String> tags;

  /// 文本变更回调。
  final ValueChanged<String> onTextChanged;

  /// 标签变更回调。
  final ValueChanged<Set<String>> onTagsChanged;

  const HappyMomentCard({
    super.key,
    required this.momentNumber,
    this.text,
    this.tags = const {},
    required this.onTextChanged,
    required this.onTagsChanged,
  });

  @override
  State<HappyMomentCard> createState() => _HappyMomentCardState();
}

class _HappyMomentCardState extends State<HappyMomentCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(HappyMomentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当父组件传入的 text 变化时（非用户输入导致），同步到 controller。
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.text = widget.text ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    widget.onTextChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(textTheme, colorScheme),
            const SizedBox(height: AppSpacing.sm),
            _buildTextField(textTheme, colorScheme),
            const SizedBox(height: AppSpacing.sm),
            TagSelector(
              presetTags: AwarenessConstants.presetTags,
              selectedTags: widget.tags,
              onTagsChanged: widget.onTagsChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Text(
      '幸福时刻 #${widget.momentNumber}',
      style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
    );
  }

  Widget _buildTextField(TextTheme textTheme, ColorScheme colorScheme) {
    return TextField(
      controller: _controller,
      minLines: 2,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: '记录这个幸福瞬间...',
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        border: InputBorder.none,
      ),
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
    );
  }
}
