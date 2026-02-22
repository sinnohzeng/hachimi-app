import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Notification settings dialog with focus reminders toggle.
class NotificationSettingsDialog extends ConsumerStatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  ConsumerState<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends ConsumerState<NotificationSettingsDialog> {
  static const _key = 'notifications_enabled';
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    _enabled = prefs.getBool(_key) ?? true;
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_key, value);

    if (!value) {
      await ref.read(notificationServiceProvider).cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsNotifications),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text(l10n.settingsNotificationFocusReminders),
            subtitle: Text(l10n.settingsNotificationSubtitle),
            value: _enabled,
            onChanged: _toggle,
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonDone),
        ),
      ],
    );
  }
}
