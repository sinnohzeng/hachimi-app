import 'package:flutter/material.dart';
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

    return Semantics(
      label:
          '${info.displayName} accessory, ${info.isEquipped
              ? "equipped"
              : info.isOwned
              ? "owned"
              : "${info.price} coins"}',
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
                  style: const TextStyle(fontSize: 28),
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
                      borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
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
                        color: _priceColor(
                          info.price,
                          colorScheme,
                          theme.brightness,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${info.price}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _priceColor(
                            info.price,
                            colorScheme,
                            theme.brightness,
                          ),
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

  String _categoryEmoji(String category) {
    switch (category) {
      case 'plant':
        return '🌿';
      case 'wild':
        return '🪶';
      case 'collar':
        return '📿';
      default:
        return '✨';
    }
  }

  Color _priceColor(int price, ColorScheme colorScheme, Brightness brightness) {
    if (price >= 350)
      return brightness == Brightness.dark
          ? Colors.amber.shade400
          : Colors.amber.shade700;
    if (price >= 250)
      return brightness == Brightness.dark
          ? Colors.purple.shade300
          : Colors.purple.shade400;
    if (price >= 150) return colorScheme.primary;
    return colorScheme.onSurfaceVariant;
  }
}
