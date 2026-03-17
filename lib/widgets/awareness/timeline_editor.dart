import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// TimelineEditor — 垂直时间轴编辑器，允许记录当天关键事件（最多 5 条）。
class TimelineEditor extends StatefulWidget {
  /// 初始事件列表（编辑已有记录时传入）。
  final List<String>? initialEvents;

  /// 事件列表变更回调。
  final ValueChanged<List<String>> onEventsChanged;

  const TimelineEditor({
    super.key,
    this.initialEvents,
    required this.onEventsChanged,
  });

  @override
  State<TimelineEditor> createState() => _TimelineEditorState();
}

class _TimelineEditorState extends State<TimelineEditor> {
  late List<TextEditingController> _controllers;

  static const _maxEvents = 5;

  @override
  void initState() {
    super.initState();
    _controllers = (widget.initialEvents ?? [])
        .map((e) => TextEditingController(text: e))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addEvent(int insertIndex) {
    if (_controllers.length >= _maxEvents) return;
    setState(() {
      _controllers.insert(insertIndex, TextEditingController());
    });
    _notifyChange();
  }

  void _removeEvent(int index) {
    if (index < 0 || index >= _controllers.length) return;
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notifyChange();
  }

  void _notifyChange() {
    widget.onEventsChanged(
      _controllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < _controllers.length; i++) ...[
          _EventRow(
            controller: _controllers[i],
            index: i,
            isLast: i == _controllers.length - 1,
            onRemove: () => _removeEvent(i),
            onChanged: (_) => _notifyChange(),
          ),
          if (_controllers.length < _maxEvents)
            _AddButton(onTap: () => _addEvent(i + 1)),
        ],
        if (_controllers.isEmpty) _AddButton(onTap: () => _addEvent(0)),
      ],
    );
  }
}

// ─── 事件行 ───

class _EventRow extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final bool isLast;
  final VoidCallback onRemove;
  final ValueChanged<String> onChanged;

  const _EventRow({
    required this.controller,
    required this.index,
    required this.isLast,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: l10n.timelineEventHint,
                counterText: '',
                isDense: true,
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: colorScheme.outline),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

// ─── 添加按钮 ───

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Expanded(
                  child: Container(width: 2, color: colorScheme.outlineVariant),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: Icon(Icons.add, size: 8, color: colorScheme.outline),
                  ),
                ),
                Expanded(
                  child: Container(width: 2, color: colorScheme.outlineVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
