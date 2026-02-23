import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 显示名称编辑对话框（MD3 AlertDialog）。
///
/// 保存时同时更新 Firebase Auth displayName 和 Firestore users/{uid}.displayName。
Future<void> showEditNameDialog(BuildContext context, WidgetRef ref) {
  final user = ref.read(authStateProvider).value;
  final currentName = user?.displayName ?? user?.email?.split('@').first ?? '';
  final controller = TextEditingController(text: currentName);
  final l10n = context.l10n;

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
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
          onPressed: () async {
            final newName = controller.text.trim();
            if (newName.isEmpty) return;

            final uid = ref.read(currentUidProvider);
            if (uid == null) return;

            HapticFeedback.mediumImpact();

            // 同时更新 Firebase Auth + Firestore
            await Future.wait([
              ref.read(authServiceProvider).updateDisplayName(newName),
              ref
                  .read(firestoreServiceProvider)
                  .updateUserProfile(uid: uid, displayName: newName),
            ]);

            if (ctx.mounted) {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(l10n.profileSaved),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
}
