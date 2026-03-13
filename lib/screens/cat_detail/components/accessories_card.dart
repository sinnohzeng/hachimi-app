import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show accessoryDisplayName;
import 'package:hachimi_app/widgets/pixel_ui/pixel_badge.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_card.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_section_header.dart';

/// 饰品装备/卸下卡片 — 数据来源为 inventoryProvider。
class AccessoriesCard extends ConsumerWidget {
  final Cat cat;

  const AccessoriesCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasEquipped =
        cat.equippedAccessory != null && cat.equippedAccessory!.isNotEmpty;
    final inventory = ref.watch(inventoryProvider).value ?? [];

    return PixelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PixelSectionHeader(
            title: context.l10n.catDetailAccessoriesTitle,
            icon: Icons.diamond_outlined,
          ),

          // 当前装备
          Row(
            children: [
              Text(
                context.l10n.catDetailEquipped,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (hasEquipped)
                Expanded(
                  child: Row(
                    children: [
                      PixelBadge(
                        text: accessoryDisplayName(cat.equippedAccessory!),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: () => _unequip(context, ref),
                        icon: const Icon(Icons.remove_circle_outline, size: 16),
                        label: Text(context.l10n.catDetailUnequip),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  context.l10n.catDetailNone,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),

          // 道具箱中可装备的饰品
          if (inventory.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.catDetailFromInventory(inventory.length),
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: inventory.map((id) {
                return ActionChip(
                  key: ValueKey(id),
                  label: Text(
                    accessoryDisplayName(id),
                    style: textTheme.labelSmall,
                  ),
                  onPressed: () => _equip(context, ref, id),
                );
              }).toList(),
            ),
          ] else if (!hasEquipped)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                context.l10n.catDetailNoAccessories,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _equip(BuildContext context, WidgetRef ref, String accessoryId) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    HapticFeedback.selectionClick();
    ref
        .read(inventoryServiceProvider)
        .equipAccessory(uid: uid, catId: cat.id, accessoryId: accessoryId);
    AppFeedback.success(
      context,
      context.l10n.catDetailEquippedItem(accessoryDisplayName(accessoryId)),
    );
  }

  void _unequip(BuildContext context, WidgetRef ref) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    HapticFeedback.selectionClick();
    ref
        .read(inventoryServiceProvider)
        .unequipAccessory(uid: uid, catId: cat.id);
    AppFeedback.info(context, context.l10n.catDetailUnequipped);
  }
}
