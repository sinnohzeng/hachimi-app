import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

/// 显示名称编辑对话框（MD3 AlertDialog）。
///
/// 保存时同时更新 Auth displayName 和 Firestore users/{uid}.displayName。
Future<void> showEditNameDialog(BuildContext context, WidgetRef ref) {
  final AuthUser? user = ref.read(authStateProvider).value;
  final currentName = user?.displayName ?? user?.email?.split('@').first ?? '';
  final controller = TextEditingController(text: currentName);
  final l10n = context.l10n;

  return showDialog(
    context: context,
    builder: (ctx) => _buildEditNameDialog(ctx, ref, controller, l10n),
  );
}

AlertDialog _buildEditNameDialog(
  BuildContext ctx,
  WidgetRef ref,
  TextEditingController controller,
  S l10n,
) {
  return AlertDialog(
    title: Text(l10n.profileEditName),
    content: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.profileDisplayName,
        counterText: '',
      ),
      maxLength: 30,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(ctx).pop(),
        child: Text(l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () => _saveName(ctx, ref, controller, l10n),
        child: Text(l10n.commonSave),
      ),
    ],
  );
}

Future<void> _saveName(
  BuildContext ctx,
  WidgetRef ref,
  TextEditingController controller,
  S l10n,
) async {
  final newName = controller.text.trim();
  if (newName.isEmpty) return;

  HapticFeedback.mediumImpact();

  try {
    await ref
        .read(userProfileNotifierProvider.notifier)
        .updateDisplayName(newName);

    if (ctx.mounted) {
      Navigator.of(ctx).pop();
      AppFeedback.success(ctx, l10n.profileSaved);
    }
  } catch (_) {
    if (ctx.mounted) {
      AppFeedback.error(ctx, l10n.commonError);
    }
  }
}
