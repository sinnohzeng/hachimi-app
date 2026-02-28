import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 多步账号删除流程编排器（纯静态方法）。
///
/// Step 1: 数据摘要警告 + 保留数据合规说明
/// Step 2: 输入 "DELETE" 确认
/// Step 3: 多 Provider 重新认证（Google / Email / 匿名跳过）
/// Step 4: 进度弹窗（不可关闭）
class DeleteAccountFlow {
  DeleteAccountFlow._();

  /// 启动删除流程入口。
  static Future<void> start(BuildContext context, WidgetRef ref) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    // 记录删除流程开始
    ref.read(analyticsServiceProvider).logAccountDeletionStarted();

    // Step 1: 数据摘要
    final proceed = await _showDataSummaryDialog(context, ref, uid);
    if (proceed != true || !context.mounted) return;

    // Step 2: 输入 DELETE
    final confirmed = await _showDeleteConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    // Step 3: 重新认证
    final authed = await _reauthenticate(context, ref);
    if (authed != true || !context.mounted) return;

    // Step 4: 执行删除
    await _executeDelete(context, ref, uid);
  }

  /// Step 1: 数据摘要警告 + 保留数据合规说明
  static Future<bool?> _showDataSummaryDialog(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final l10n = context.l10n;
    final service = ref.read(accountDeletionServiceProvider);

    final summary = await service.getUserDataSummary(uid);
    if (!context.mounted) return false;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteAccountDataWarning),
            const SizedBox(height: AppSpacing.md),
            _DataRow(
              icon: Icons.flag_outlined,
              label: l10n.deleteAccountQuests,
              value: '${summary.questCount}',
            ),
            _DataRow(
              icon: Icons.pets,
              label: l10n.deleteAccountCats,
              value: '${summary.catCount}',
            ),
            _DataRow(
              icon: Icons.timer,
              label: l10n.deleteAccountHours,
              value: '${summary.totalHours}h',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.deleteAccountIrreversible,
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // 保留数据合规说明
            Text(
              l10n.deleteAccountRetainedData,
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                color: Theme.of(ctx).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.deleteAccountContinue),
          ),
        ],
      ),
    );
  }

  /// Step 2: 输入 "DELETE" 确认
  static Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    final l10n = context.l10n;
    final controller = TextEditingController();

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final isValid = controller.text.trim().toUpperCase() == 'DELETE';
          return AlertDialog(
            title: Text(l10n.deleteAccountConfirmTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.deleteAccountTypeDelete),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'DELETE'),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: isValid ? () => Navigator.of(ctx).pop(true) : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error,
                ),
                child: Text(l10n.commonDeleteAccount),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Step 3: 多 Provider 重新认证。
  ///
  /// Google → reauthenticateWithGoogle()
  /// Email  → 弹出密码输入框 + reauthenticateWithEmail()
  /// 匿名   → 跳过
  static Future<bool?> _reauthenticate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = context.l10n;
    final backend = ref.read(authBackendProvider);
    final providers = backend.providerIds;

    try {
      if (providers.contains('google.com')) {
        return await backend.reauthenticateWithGoogle();
      }
      if (providers.contains('password')) {
        return await _showEmailReauthDialog(context, ref);
      }
      // 匿名用户跳过重认证
      return true;
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_mapDeletionError(e, l10n)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  /// Email 重认证对话框
  static Future<bool?> _showEmailReauthDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final controller = TextEditingController();

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccountReauthEmail),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.deleteAccountReauthPasswordHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              final password = controller.text;
              if (password.isEmpty) return;

              try {
                final backend = ref.read(authBackendProvider);
                await backend.reauthenticateWithEmail(
                  email: backend.currentEmail ?? '',
                  password: password,
                );
                if (ctx.mounted) Navigator.of(ctx).pop(true);
              } on Exception catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(_mapDeletionError(e, l10n)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.deleteAccountContinue),
          ),
        ],
      ),
    );
  }

  /// Step 4: 执行删除（不可关闭的进度弹窗）
  static Future<void> _executeDelete(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final l10n = context.l10n;
    final progress = ValueNotifier<(double, String)>((0.0, ''));

    // 显示进度弹窗
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: ValueListenableBuilder<(double, String)>(
          valueListenable: progress,
          builder: (ctx, value, _) => AlertDialog(
            title: Text(l10n.deleteAccountProgress),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: value.$1),
                const SizedBox(height: AppSpacing.md),
                Text(value.$2),
              ],
            ),
          ),
        ),
      ),
    );

    // 先停 SyncEngine 防竞态
    ref.read(syncEngineProvider).stop();

    try {
      await ref
          .read(accountDeletionServiceProvider)
          .deleteEverything(
            uid,
            onProgress: (p, step) => progress.value = (p, step),
          );

      // Auth 删除 + Google 登出
      await ref.read(authBackendProvider).deleteAccount();

      // 记录删除成功
      ref.read(analyticsServiceProvider).logAccountDeletionCompleted();

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountSuccess),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on Exception catch (e) {
      // 记录删除失败
      final errorCode = e is FirebaseException
          ? e.code
          : e.runtimeType.toString();
      ref
          .read(analyticsServiceProvider)
          .logAccountDeletionFailed(errorCode: errorCode);

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_mapDeletionError(e, l10n)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      progress.dispose();
    }
  }

  /// 将删除错误映射为用户可读的本地化消息。
  static String _mapDeletionError(Object error, S l10n) {
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return l10n.deleteAccountPermissionError;
      }
    }
    if (error is SocketException) return l10n.deleteAccountNetworkError;
    return l10n.deleteAccountError;
  }
}

/// 数据行组件（数据摘要弹窗内用）
class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
