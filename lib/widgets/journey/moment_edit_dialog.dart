import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:uuid/uuid.dart';

/// 时刻编辑 BottomSheet — 新建或编辑幸福/高光时刻。
///
/// 返回编辑后的 [HighlightEntry]，调用方负责保存。
Future<HighlightEntry?> showMomentEditSheet(
  BuildContext context, {
  required HighlightType type,
  HighlightEntry? existing,
}) {
  return showModalBottomSheet<HighlightEntry>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _MomentEditSheet(type: type, existing: existing),
  );
}

class _MomentEditSheet extends StatefulWidget {
  final HighlightType type;
  final HighlightEntry? existing;

  const _MomentEditSheet({required this.type, this.existing});

  @override
  State<_MomentEditSheet> createState() => _MomentEditSheetState();
}

class _MomentEditSheetState extends State<_MomentEditSheet> {
  late final TextEditingController _descController;
  late final TextEditingController _companionController;
  late final TextEditingController _feelingController;
  late final TextEditingController _dateController;
  int _rating = 3;

  bool get _isHappy => widget.type == HighlightType.happy;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _descController = TextEditingController(text: e?.description ?? '');
    _companionController = TextEditingController(text: e?.companion ?? '');
    _feelingController = TextEditingController(text: e?.feeling ?? '');
    _dateController = TextEditingController(text: e?.date ?? _todayString());
    _rating = e?.rating ?? 3;
  }

  @override
  void dispose() {
    _descController.dispose();
    _companionController.dispose();
    _feelingController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _submit() {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      AppFeedback.info(context, context.l10n.momentDescRequired);
      return;
    }

    final now = DateTime.now();
    final entry = HighlightEntry(
      id: widget.existing?.id ?? const Uuid().v4(),
      year: now.year,
      type: widget.type,
      description: desc,
      companion: _trimOrNull(_companionController.text),
      feeling: _trimOrNull(_feelingController.text),
      date: _dateController.text.trim().isEmpty
          ? _todayString()
          : _dateController.text.trim(),
      rating: _rating,
      createdAt: widget.existing?.createdAt ?? now,
      updatedAt: now,
    );

    Navigator.of(context).pop(entry);
  }

  String? _trimOrNull(String text) {
    final t = text.trim();
    return t.isEmpty ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 拖拽手柄
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppShape.borderFull,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              widget.existing != null
                  ? context.l10n.momentEditTitle
                  : (_isHappy
                        ? context.l10n.momentNewHappy
                        : context.l10n.momentNewHighlight),
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: _isHappy
                    ? context.l10n.momentDescHappy
                    : context.l10n.momentDescHighlight,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _companionController,
              decoration: InputDecoration(
                labelText: _isHappy
                    ? context.l10n.momentCompanionHappy
                    : context.l10n.momentCompanionHighlight,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _feelingController,
              decoration: InputDecoration(
                labelText: context.l10n.momentFeeling,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: context.l10n.momentDate,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 评分
            Row(
              children: [
                Text(context.l10n.momentRating, style: textTheme.bodyMedium),
                const SizedBox(width: AppSpacing.md),
                ...List.generate(5, (i) {
                  final filled = i < _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        filled ? Icons.star : Icons.star_border,
                        size: 28,
                        color: filled
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: Text(context.l10n.commonSave),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
