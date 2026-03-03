import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

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
    final summary = await ref
        .read(accountDeletionServiceProvider)
        .getUserDataSummary(uid);
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
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteAccountContinue),
          ),
        ],
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

    ref.read(syncEngineProvider).stop();

    try {
      await ref
          .read(accountDeletionOrchestratorProvider)
          .deleteAccount(uid: uid);
      progress.value = l10n.deleteAccountStepCloud;

      final pending = ref
          .read(sharedPreferencesProvider)
          .getString(AppPrefsKeys.pendingDeletionJob);
      final queued = pending != null && pending.isNotEmpty;

      ref.read(onboardingCompleteProvider.notifier).reset();
      ref.read(analyticsServiceProvider).logAccountDeletionCompleted();

      if (!context.mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            queued ? l10n.deleteAccountQueued : l10n.deleteAccountSuccess,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Exception catch (e) {
      if (!uid.startsWith('guest_')) {
        ref.read(syncEngineProvider).start(uid);
      }
      ref
          .read(analyticsServiceProvider)
          .logAccountDeletionFailed(errorCode: e.runtimeType.toString());

      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.deleteAccountError),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      progress.dispose();
    }
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
