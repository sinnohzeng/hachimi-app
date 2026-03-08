import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

/// 退出确认 — 单 Dialog 就地变形模式。
///
/// 确认前：标题 + 正文 + 取消/退出按钮
/// 确认后：CircularProgressIndicator + 文案，按钮消失，不可关闭
/// 完成后：AuthGate 的 popUntil 自动关闭 Dialog
Future<void> showLogoutConfirmation(BuildContext context, WidgetRef ref) {
  // async gap 之前捕获引用，避免 widget dispose 后 ref 失效
  final l10n = context.l10n;
  final notifier = ref.read(userProfileNotifierProvider.notifier);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _LogoutDialog(l10n: l10n, notifier: notifier),
  );
}

class _LogoutDialog extends StatefulWidget {
  final S l10n;
  final UserProfileNotifier notifier;
  const _LogoutDialog({required this.l10n, required this.notifier});

  @override
  State<_LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<_LogoutDialog> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: AlertDialog(
        title: _isLoading ? null : Text(widget.l10n.logoutTitle),
        content: _isLoading ? _buildLoading() : Text(widget.l10n.logoutMessage),
        actions: _isLoading ? null : _buildActions(),
      ),
    );
  }

  Widget _buildLoading() {
    return Row(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(width: 16),
        Text(widget.l10n.loggingOut),
      ],
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(widget.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () {
          setState(() => _isLoading = true);
          widget.notifier.logout();
          // logout() 触发 reset() → AuthGate popUntil → Dialog 自动关闭
        },
        child: Text(widget.l10n.commonLogOut),
      ),
    ];
  }
}
