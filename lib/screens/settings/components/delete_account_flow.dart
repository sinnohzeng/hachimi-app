import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/account_deletion_result.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

/// 三段式账号删除流程：
/// 1) 数据摘要确认
/// 2) 输入 DELETE 二次确认
/// 3) 立即本地删除 + 云端硬删（在线立即执行，离线排队）
class DeleteAccountFlow {
  DeleteAccountFlow._();

  static Future<void> start(BuildContext context, WidgetRef ref) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    ref.read(analyticsServiceProvider).logAccountDeletionStarted();

    final proceed = await _showDataSummaryDialog(context, ref, uid);
    if (proceed != true || !context.mounted) return;

    final confirmed = await _showDeleteConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    await _executeDelete(context, ref, uid);
  }

  static Future<bool?> _showDataSummaryDialog(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final l10n = context.l10n;
    final summaryFuture = ref
        .read(accountDeletionServiceProvider)
        .getUserDataSummary(uid);

    return showDialog<bool>(
      context: context,
      builder: (ctx) => FutureBuilder(
        future: summaryFuture,
        builder: (ctx, snapshot) {
          final isLoading = !snapshot.hasData && !snapshot.hasError;
          return AlertDialog(
            title: Text(l10n.deleteAccountTitle),
            content: isLoading
                ? const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.deleteAccountDataWarning),
                      const SizedBox(height: AppSpacing.md),
                      if (snapshot.hasData) ...[
                        _DataRow(
                          icon: Icons.flag_outlined,
                          label: l10n.deleteAccountQuests,
                          value: '${snapshot.data!.questCount}',
                        ),
                        _DataRow(
                          icon: Icons.pets,
                          label: l10n.deleteAccountCats,
                          value: '${snapshot.data!.catCount}',
                        ),
                        _DataRow(
                          icon: Icons.timer,
                          label: l10n.deleteAccountHours,
                          value: '${snapshot.data!.totalHours}h',
                        ),
                      ],
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
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: isLoading ? null : () => Navigator.of(ctx).pop(true),
                child: Text(l10n.deleteAccountContinue),
              ),
            ],
          );
        },
      ),
    );
  }

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

  static Future<void> _executeDelete(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final l10n = context.l10n;
    final progress = ValueNotifier<String>(l10n.deleteAccountStepLocal);
    _showProgressDialog(context, l10n, progress);
    ref.read(syncEngineProvider).stop();

    bool localDataDestroyed = false;
    bool navigatedAway = false;
    try {
      progress.value = l10n.deleteAccountStepCloud;
      final result = await ref
          .read(accountDeletionOrchestratorProvider)
          .deleteAccount(uid: uid);
      localDataDestroyed = result.localDeleted;
      if (!context.mounted) return;
      navigatedAway = await _handleDeletionResult(context, ref, result, l10n);
    } catch (e, stack) {
      localDataDestroyed = true;
      await ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'DeleteAccountFlow',
        operation: 'executeDelete',
        operationStage: 'account_deletion',
        errorCode: 'delete_account_execute_failed',
      );
      await ref
          .read(analyticsServiceProvider)
          .logAccountDeletionFailed(errorCode: 'delete_account_execute_failed');
      if (context.mounted) {
        Navigator.of(context).pop();
        AppFeedback.error(context, l10n.deleteAccountError);
      }
    } finally {
      progress.dispose();
      // 结构性不变量：本地数据已销毁且尚未导航 → 必须签出 + 重置引导
      // 不能让用户留在"认证有效但数据为空"的僵尸态
      if (localDataDestroyed && !navigatedAway && context.mounted) {
        await ref.read(userProfileNotifierProvider.notifier).logout();
      }
    }
  }

  static void _showProgressDialog(
    BuildContext context,
    S l10n,
    ValueNotifier<String> progress,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: ValueListenableBuilder<String>(
          valueListenable: progress,
          builder: (ctx, message, _) => AlertDialog(
            title: Text(l10n.deleteAccountProgress),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LinearProgressIndicator(),
                const SizedBox(height: AppSpacing.md),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 处理删除结果 — 返回是否已导航离开。
  static Future<bool> _handleDeletionResult(
    BuildContext context,
    WidgetRef ref,
    AccountDeletionResult result,
    S l10n,
  ) async {
    if (result.remoteDeleted) {
      // 删号 = 全新开始，清除 hasOnboardedBefore 让用户看到完整引导教程。
      ref
          .read(sharedPreferencesProvider)
          .remove(AppPrefsKeys.hasOnboardedBefore);
      ref.read(onboardingCompleteProvider.notifier).reset();
      await ref.read(analyticsServiceProvider).logAccountDeletionCompleted();
      if (!context.mounted) return true;
      Navigator.of(context).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);
      AppFeedback.success(context, l10n.deleteAccountSuccess);
      return true;
    }

    if (result.queued) {
      await ref
          .read(analyticsServiceProvider)
          .logAccountDeletionFailed(
            errorCode: result.errorCode ?? 'delete_account_queued',
          );
      if (!context.mounted) return true;
      // 不 reset onboarding — AuthGate 的 _hasPendingDeletion 接管
      Navigator.of(context).popUntil((route) => route.isFirst);
      AppFeedback.info(context, l10n.deleteAccountQueued);
      return true;
    }

    await ref
        .read(analyticsServiceProvider)
        .logAccountDeletionFailed(
          errorCode: result.errorCode ?? 'delete_account_remote_failed',
        );
    if (!context.mounted) return false;
    Navigator.of(context).pop();
    AppFeedback.error(context, l10n.deleteAccountError);
    return false;
  }
}

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
