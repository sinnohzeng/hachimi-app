import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

/// 退出确认 — 单 Dialog 就地变形模式。
///
/// 确认前：标题 + 正文 + 取消/退出按钮
/// 确认后：CircularProgressIndicator + 文案，按钮消失，不可关闭
/// 完成后：AuthGate 的 popUntil 自动关闭 Dialog
Future<void> showLogoutConfirmation(BuildContext context, WidgetRef ref) {
  final l10n = context.l10n;

  // async gap 之前捕获 notifier 引用，避免 widget dispose 后 ref 失效
  final notifier = ref.read(userProfileNotifierProvider.notifier);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      var isLoading = false;

      return StatefulBuilder(
        builder: (ctx, setState) => PopScope(
          canPop: !isLoading,
          child: AlertDialog(
            title: isLoading ? null : Text(l10n.logoutTitle),
            content: isLoading
                ? Row(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      Text(l10n.loggingOut),
                    ],
                  )
                : Text(l10n.logoutMessage),
            actions: isLoading
                ? null
                : [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(l10n.commonCancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        setState(() => isLoading = true);
                        notifier.logout();
                        // logout() 触发 reset() → AuthGate popUntil → Dialog 自动关闭
                      },
                      child: Text(l10n.commonLogOut),
                    ),
                  ],
          ),
        ),
      );
    },
  );
}
