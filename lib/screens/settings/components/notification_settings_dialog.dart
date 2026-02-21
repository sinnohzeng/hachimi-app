import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/services/notification_service.dart';

/// Notification settings dialog with focus reminders toggle.
class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  State<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  static const _key = 'notifications_enabled';
  bool _enabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.getBool(_key) ?? true;
      _loaded = true;
    });
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);

    if (!value) {
      await NotificationService().cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsNotifications),
      content: _loaded
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text(l10n.settingsNotificationFocusReminders),
                  subtitle: Text(l10n.settingsNotificationSubtitle),
                  value: _enabled,
                  onChanged: _toggle,
                ),
              ],
            )
          : const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator()),
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
