import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// LightInputCard — 今日一光文本输入卡片。
///
/// 提供多行输入区域，最多 [maxLength] 字符，
/// 右下角显示字符计数。
class LightInputCard extends StatefulWidget {
  /// 初始文本。
  final String? initialText;

  /// 文本变更回调。
  final ValueChanged<String> onTextChanged;

  /// 最大字符数。
  final int maxLength;

  const LightInputCard({
    super.key,
    this.initialText,
    required this.onTextChanged,
    this.maxLength = 500,
  });

  @override
  State<LightInputCard> createState() => _LightInputCardState();
}

class _LightInputCardState extends State<LightInputCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    widget.onTextChanged(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 6,
              maxLength: widget.maxLength,
              buildCounter: _buildCounter,
              decoration: InputDecoration(
                hintText: context.l10n.awarenessLightPlaceholder,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 自定义字符计数器 — 显示 "N/500" 格式。
  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      '$currentLength/${maxLength ?? widget.maxLength}',
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
