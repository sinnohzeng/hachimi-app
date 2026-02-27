import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 自定义每日目标对话框（共用于创建和编辑 Quest）。
void showCustomGoalDialog(
  BuildContext context, {
  required int currentValue,
  required bool isCustom,
  required void Function(int value) onConfirm,
}) {
  final controller = TextEditingController(
    text: isCustom ? '$currentValue' : '',
  );
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(context.l10n.adoptionCustomGoalTitle),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.l10n.adoptionMinutesPerDay,
          hintText: context.l10n.adoptionMinutesHint,
          suffixText: context.l10n.unitMinShort,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            final value = int.tryParse(controller.text.trim());
            if (value == null || value < 5 || value > 180) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.adoptionValidMinutes)),
              );
              return;
            }
            onConfirm(value);
            Navigator.of(ctx).pop();
          },
          child: Text(context.l10n.adoptionSet),
        ),
      ],
    ),
  );
}

/// 自定义总目标对话框（共用于创建和编辑 Quest）。
void showCustomTargetDialog(
  BuildContext context, {
  required int? currentValue,
  required bool isCustom,
  required void Function(int value) onConfirm,
}) {
  final controller = TextEditingController(
    text: isCustom ? '$currentValue' : '',
  );
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(context.l10n.adoptionCustomTargetTitle),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.l10n.adoptionTotalHours,
          hintText: context.l10n.adoptionHoursHint,
          suffixText: context.l10n.unitHourShort,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            final value = int.tryParse(controller.text.trim());
            if (value == null || value < 10 || value > 2000) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.adoptionValidHours)),
              );
              return;
            }
            onConfirm(value);
            Navigator.of(ctx).pop();
          },
          child: Text(context.l10n.adoptionSet),
        ),
      ],
    ),
  );
}
