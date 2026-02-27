import 'package:flutter/material.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 聊天入口卡片 — 在 Diary Preview 下方，提升聊天功能可发现性。
class ChatEntryCard extends StatelessWidget {
  final String catId;
  final String catName;

  const ChatEntryCard({super.key, required this.catId, required this.catName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRouter.catChat, arguments: catId);
        },
        borderRadius: AppShape.borderMedium,
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Row(
            children: [
              const ExcludeSemantics(
                child: Text('\u{1F4AC}', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.catDetailChatWith(catName),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.catDetailChatSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                semanticLabel: context.l10n.catDetailChatWith(catName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
