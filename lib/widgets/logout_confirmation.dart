import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

/// 退出确认 — 纯确认 dialog，无 loading 状态。
///
/// Navigation-First 保证 logout() 瞬间完成导航，
/// dialog 被 AuthGate 的 popUntil 自动关闭。
Future<void> showLogoutConfirmation(BuildContext context, WidgetRef ref) {
  final l10n = context.l10n;
  final notifier = ref.read(userProfileNotifierProvider.notifier);

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.logoutTitle),
      content: Text(l10n.logoutMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: notifier.logout,
          child: Text(l10n.commonLogOut),
        ),
      ],
    ),
  );
}
