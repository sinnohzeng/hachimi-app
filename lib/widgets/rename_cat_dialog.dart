import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 共享猫咪重命名对话框 — CatDetailScreen 和 CatRoomScreen 统一调用。
Future<void> showRenameCatDialog(
  BuildContext context,
  WidgetRef ref,
  Cat cat,
) async {
  final controller = TextEditingController(text: cat.name);
  final l10n = context.l10n;

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.catDetailRenameTitle),
      content: TextField(
        controller: controller,
        maxLength: Cat.maxNameLength,
        decoration: InputDecoration(
          labelText: l10n.catDetailNewName,
          prefixIcon: const Icon(Icons.pets),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => _performRename(ctx, ref, cat, controller.text),
          child: Text(l10n.catDetailRename),
        ),
      ],
    ),
  );
}

Future<void> _performRename(
  BuildContext dialogCtx,
  WidgetRef ref,
  Cat cat,
  String rawName,
) async {
  final newName = rawName.trim();
  if (newName.isEmpty) return;
  final uid = ref.read(currentUidProvider);
  if (uid == null) return;

  try {
    HapticFeedback.mediumImpact();
    final renamedCat = cat.copyWith(name: newName);
    await ref.read(localCatRepositoryProvider).update(uid, renamedCat);
    ref
        .read(ledgerServiceProvider)
        .notifyChange(const LedgerChange(type: 'cat_update'));
  } catch (e) {
    if (dialogCtx.mounted) {
      AppFeedback.error(dialogCtx, dialogCtx.l10n.catRoomRenameError);
    }
    return;
  }

  if (dialogCtx.mounted) {
    Navigator.of(dialogCtx).pop();
    AppFeedback.success(dialogCtx, dialogCtx.l10n.catDetailRenamed);
  }
}
