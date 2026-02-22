import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/reminder_config.dart';

/// 三列 CupertinoPicker 底部弹窗，用于选择提醒模式和时间。
/// 返回 ReminderConfig?（null = 取消）。
Future<ReminderConfig?> showReminderPickerSheet(
  BuildContext context, {
  ReminderConfig? initial,
}) {
  return showModalBottomSheet<ReminderConfig>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _ReminderPickerSheet(initial: initial),
  );
}

class _ReminderPickerSheet extends StatefulWidget {
  final ReminderConfig? initial;
  const _ReminderPickerSheet({this.initial});

  @override
  State<_ReminderPickerSheet> createState() => _ReminderPickerSheetState();
}

class _ReminderPickerSheetState extends State<_ReminderPickerSheet> {
  late FixedExtentScrollController _modeController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  late int _selectedModeIndex;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _selectedModeIndex = initial != null
        ? ReminderConfig.validModes.indexOf(initial.mode).clamp(0, 8)
        : 0;
    _selectedHour = initial?.hour ?? 8;
    _selectedMinute = initial?.minute ?? 0;

    _modeController = FixedExtentScrollController(
      initialItem: _selectedModeIndex,
    );
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
  }

  @override
  void dispose() {
    _modeController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  /// 获取模式的本地化名称。
  String _modeName(String mode) =>
      ReminderConfig.localizedModeName(mode, context.l10n);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 标题
            Text(
              l10n.reminderPickerTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            // 三列滚轮
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // 模式列
                  Expanded(
                    flex: 3,
                    child: CupertinoPicker(
                      scrollController: _modeController,
                      itemExtent: 36,
                      onSelectedItemChanged: (index) {
                        _selectedModeIndex = index;
                      },
                      children: ReminderConfig.validModes.map((mode) {
                        return Center(
                          child: Text(
                            _modeName(mode),
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // 小时列
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      scrollController: _hourController,
                      itemExtent: 36,
                      onSelectedItemChanged: (index) {
                        _selectedHour = index;
                      },
                      children: List.generate(24, (i) {
                        return Center(
                          child: Text(
                            '$i ${l10n.reminderHourUnit}',
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }),
                    ),
                  ),

                  // 分钟列
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      scrollController: _minuteController,
                      itemExtent: 36,
                      onSelectedItemChanged: (index) {
                        _selectedMinute = index;
                      },
                      children: List.generate(60, (i) {
                        return Center(
                          child: Text(
                            '$i ${l10n.reminderMinuteUnit}',
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            // 确认按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  final mode = ReminderConfig.validModes[_selectedModeIndex];
                  Navigator.of(context).pop(
                    ReminderConfig(
                      mode: mode,
                      hour: _selectedHour,
                      minute: _selectedMinute,
                    ),
                  );
                },
                child: Text(l10n.reminderConfirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
