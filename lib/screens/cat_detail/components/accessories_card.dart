// ---
// 📘 文件说明：
// Accessories Card — 饰品装备/卸下卡片组件。
// 展示当前装备、道具箱中可装备的饰品，支持装备和卸下操作。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 Cat 数据；
// 2. 监听 inventoryProvider 获取道具箱列表；
// 3. 渲染当前装备（有则显示名称 + 卸下按钮）；
// 4. 渲染道具箱中的饰品 ActionChip 列表；
// 5. 装备/卸下操作调用 inventoryServiceProvider；
//
// 🧩 文件结构：
// - AccessoriesCard：饰品装备卡片 ConsumerWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show accessoryDisplayName;

/// 饰品装备/卸下卡片 — 数据来源为 inventoryProvider。
class AccessoriesCard extends ConsumerWidget {
  final Cat cat;

  const AccessoriesCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasEquipped = cat.equippedAccessory != null &&
        cat.equippedAccessory!.isNotEmpty;
    final inventory = ref.watch(inventoryProvider).value ?? [];

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.catDetailAccessoriesTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

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
                        Text(
                          accessoryDisplayName(cat.equippedAccessory!),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: () => _unequip(context, ref),
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 16),
                          label: Text(context.l10n.catDetailUnequip),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
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
      ),
    );
  }

  void _equip(BuildContext context, WidgetRef ref, String accessoryId) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    HapticFeedback.selectionClick();
    ref.read(inventoryServiceProvider).equipAccessory(
          uid: uid,
          catId: cat.id,
          accessoryId: accessoryId,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.catDetailEquippedItem(accessoryDisplayName(accessoryId))),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _unequip(BuildContext context, WidgetRef ref) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    HapticFeedback.selectionClick();
    ref.read(inventoryServiceProvider).unequipAccessory(
          uid: uid,
          catId: cat.id,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.catDetailUnequipped),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
