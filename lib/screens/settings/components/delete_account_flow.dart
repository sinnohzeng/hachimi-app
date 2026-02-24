import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/account_deletion_service.dart'
    show AccountDeletionService;

/// 多步账号删除流程编排器。
/// Step 1: 数据摘要警告
/// Step 2: 输入 "DELETE" 确认
/// Step 3: Google 重新认证
/// Step 4: 进度弹窗（不可关闭）
class DeleteAccountFlow {
  final BuildContext context;
  final WidgetRef ref;

  DeleteAccountFlow({required this.context, required this.ref});

  AccountDeletionService get _deletionService =>
      ref.read(accountDeletionServiceProvider);

  Future<void> start() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    // Step 1: 数据摘要
    final proceed = await _showDataSummaryDialog(uid);
    if (proceed != true || !context.mounted) return;

    // Step 2: 输入 DELETE
    final confirmed = await _showDeleteConfirmDialog();
    if (confirmed != true || !context.mounted) return;

    // Step 3: 重新认证
    final authed = await _reauthenticate();
    if (authed != true || !context.mounted) return;

    // Step 4: 执行删除
    await _executeDelete(uid);
  }

  /// Step 1: 数据摘要警告
  Future<bool?> _showDataSummaryDialog(String uid) async {
    final l10n = context.l10n;

    // 获取数据摘要
    final ledger = ref.read(ledgerServiceProvider);
    final summary = await _deletionService.getUserDataSummary(
      uid,
      ledger: ledger,
    );
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
  Future<bool?> _showDeleteConfirmDialog() {
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

  /// Step 3: Google 重新认证
  Future<bool?> _reauthenticate() async {
    final l10n = context.l10n;

    try {
      final success = await _deletionService.reauthenticateWithGoogle();
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountAuthCancelled),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return success;
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountAuthFailed(e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  /// Step 4: 执行删除（不可关闭的进度弹窗）
  Future<void> _executeDelete(String uid) async {
    final l10n = context.l10n;
    String statusText = '';
    double progress = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (ctx, setState) {
            // 在外部更新进度时刷新（加 mounted 守卫防止 dispose 后调用）
            _onProgress = (p, step) {
              if (ctx.mounted) {
                setState(() {
                  progress = p;
                  statusText = step;
                });
              }
            };

            return AlertDialog(
              title: Text(l10n.deleteAccountProgress),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: AppSpacing.md),
                  Text(statusText),
                ],
              ),
            );
          },
        ),
      ),
    );

    try {
      await _deletionService.deleteEverything(
        uid,
        onProgress: (p, step) => _onProgress?.call(p, step),
      );

      if (context.mounted) {
        // 关闭进度弹窗
        Navigator.of(context).pop();
        // 显示成功提示（AuthGate 会自动跳转到 LoginScreen）
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountSuccess),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void Function(double, String)? _onProgress;
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
