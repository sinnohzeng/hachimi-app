import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/accessory_provider.dart';

/// 饰品卡片 — 商店网格中的单个饰品展示。
class AccessoryCard extends StatelessWidget {
  final AccessoryInfo info;
  final VoidCallback? onTap;

  const AccessoryCard({super.key, required this.info, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final l10n = context.l10n;
    final status = info.isEquipped
        ? l10n.accessoryEquipped
        : info.isOwned
        ? l10n.accessoryOwned
        : l10n.coinBalance(info.price);

    return Semantics(
      label: '${info.displayName}, $status',
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppSpacing.paddingSm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 饰品图标（类别对应 emoji）
                Text(
                  _categoryEmoji(info.category),
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xs),

                // 饰品名称
                Text(
                  info.displayName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),

                // 价格标签 / 已拥有徽章 / 已装备徽章
                if (info.isEquipped)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: AppShape.borderSmall,
                    ),
                    child: Text(
                      context.l10n.accessoryEquipped,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 10,
                      ),
                    ),
                  )
                else if (info.isOwned)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: AppShape.borderSmall,
                    ),
                    child: Text(
                      context.l10n.accessoryOwned,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontSize: 10,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 14,
                        color: _priceColor(info.price, colorScheme),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${info.price}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _priceColor(info.price, colorScheme),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _categoryEmoji(AccessoryCategory category) => switch (category) {
    AccessoryCategory.plant => '🌿',
    AccessoryCategory.wild => '🪶',
    AccessoryCategory.collar => '📿',
  };

  Color _priceColor(int price, ColorScheme colorScheme) {
    if (price >= 350) {
      return colorScheme.tertiary;
    }
    if (price >= 250) {
      return colorScheme.secondary;
    }
    if (price >= 150) return colorScheme.primary;
    return colorScheme.onSurfaceVariant;
  }
}
