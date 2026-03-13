import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/account_data_snapshot.dart';

Future<ArchiveConflictChoice?> showArchiveConflictDialog({
  required BuildContext context,
  required AccountDataSnapshot local,
  required AccountDataSnapshot cloud,
}) {
  final l10n = context.l10n;
  return showDialog<ArchiveConflictChoice>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.archiveConflictTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.archiveConflictMessage),
            const SizedBox(height: AppSpacing.md),
            _SnapshotCard(
              title: l10n.archiveConflictLocal,
              snapshot: local,
              highlighted: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            _SnapshotCard(title: l10n.archiveConflictCloud, snapshot: cloud),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(ArchiveConflictChoice.keepCloud),
            child: Text(l10n.archiveConflictKeepCloud),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(ctx).pop(ArchiveConflictChoice.keepLocal),
            child: Text(l10n.archiveConflictKeepLocal),
          ),
        ],
      );
    },
  );
}

class _SnapshotCard extends StatelessWidget {
  final String title;
  final AccountDataSnapshot snapshot;
  final bool highlighted;

  const _SnapshotCard({
    required this.title,
    required this.snapshot,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleSmall;
    final bodyStyle = Theme.of(context).textTheme.bodySmall;

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingBase,
      decoration: BoxDecoration(
        color: highlighted ? colors.primaryContainer : colors.surfaceContainer,
        borderRadius: AppShape.borderMedium,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${l10n.deleteAccountHours}: ${snapshot.focusHours}h',
            style: bodyStyle,
          ),
          Text(
            '${l10n.achievementTitle}: ${snapshot.achievements}',
            style: bodyStyle,
          ),
          Text('${l10n.deleteAccountCats}: ${snapshot.cats}', style: bodyStyle),
          Text(
            '${l10n.deleteAccountQuests}: ${snapshot.habits}',
            style: bodyStyle,
          ),
          Text(l10n.coinBalance(snapshot.coins), style: bodyStyle),
        ],
      ),
    );
  }
}
