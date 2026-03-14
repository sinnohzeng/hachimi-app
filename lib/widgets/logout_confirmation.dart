import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

/// 退出确认 — 带 loading 状态的确认 dialog。
///
/// 确认后禁用按钮并显示进度指示器，防止重复点击。
/// 登出完成后 AuthGate 的 popUntil 自动关闭 dialog。
Future<void> showLogoutConfirmation(BuildContext context, WidgetRef ref) {
  final l10n = context.l10n;
  final notifier = ref.read(userProfileNotifierProvider.notifier);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) =>
        _LogoutDialog(l10n: l10n, onConfirm: notifier.logout),
  );
}

class _LogoutDialog extends StatefulWidget {
  final S l10n;
  final Future<void> Function() onConfirm;

  const _LogoutDialog({required this.l10n, required this.onConfirm});

  @override
  State<_LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<_LogoutDialog> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    await widget.onConfirm();
    // AuthGate 的 popUntil 会自动关闭此 dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.logoutTitle),
      content: Text(widget.l10n.logoutMessage),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(widget.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _handleLogout,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.l10n.commonLogOut),
        ),
      ],
    );
  }
}
