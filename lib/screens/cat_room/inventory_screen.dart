// ---
// 📘 文件说明：
// InventoryScreen — 道具箱页面。
// 分「箱中」和「已装备在猫上」两区展示配饰。
//
// 📋 程序整体伪代码：
// 1. 从 inventoryProvider 读取箱中道具；
// 2. 从 catsProvider 收集各猫的 equippedAccessory；
// 3. 点击箱中道具 → 选猫弹窗 → 装备；
// 4. 点击已装备道具 → 卸下确认；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// 道具箱页面 — 管理用户所有配饰的装备/卸下。
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final inventory = ref.watch(inventoryProvider).value ?? [];
    final cats = ref.watch(catsProvider).value ?? [];

    // 收集已装备的配饰
    final equippedItems = <_EquippedItem>[];
    for (final cat in cats) {
      if (cat.equippedAccessory != null && cat.equippedAccessory!.isNotEmpty) {
        equippedItems.add(
          _EquippedItem(accessoryId: cat.equippedAccessory!, cat: cat),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryTitle)),
      body: ListView(
        padding: AppSpacing.paddingBase,
        children: [
          // 箱中道具
          Text(
            context.l10n.inventoryInBox(inventory.length),
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (inventory.isEmpty)
            Padding(
              padding: AppSpacing.paddingVLg,
              child: Center(
                child: Text(
                  context.l10n.inventoryEmpty,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: inventory.map((id) {
                return ActionChip(
                  label: Text(accessoryDisplayName(id)),
                  onPressed: () => _showEquipDialog(context, ref, id, cats),
                );
              }).toList(),
            ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.base),

          // 已装备在猫上
          Text(
            context.l10n.inventoryEquippedOnCats(equippedItems.length),
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (equippedItems.isEmpty)
            Padding(
              padding: AppSpacing.paddingVLg,
              child: Center(
                child: Text(
                  context.l10n.inventoryNoEquipped,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...equippedItems.map((item) {
              return Card(
                child: ListTile(
                  leading: PixelCatSprite.fromCat(cat: item.cat, size: 40),
                  title: Text(accessoryDisplayName(item.accessoryId)),
                  subtitle: Text(item.cat.name),
                  trailing: TextButton(
                    onPressed: () => _unequip(context, ref, item.cat),
                    child: Text(context.l10n.inventoryUnequip),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showEquipDialog(
    BuildContext context,
    WidgetRef ref,
    String accessoryId,
    List<Cat> cats,
  ) {
    HapticFeedback.mediumImpact();

    if (cats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.inventoryNoActiveCats)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.inventoryEquipTo(
                  accessoryDisplayName(accessoryId),
                ),
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cats.length,
                  itemBuilder: (_, index) {
                    final cat = cats[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _equip(context, ref, cat.id, accessoryId);
                      },
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(ctx).colorScheme.surfaceContainerLow,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PixelCatSprite.fromCat(cat: cat, size: 48),
                            const SizedBox(height: 2),
                            Text(
                              cat.name,
                              style: Theme.of(ctx).textTheme.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _equip(
    BuildContext context,
    WidgetRef ref,
    String catId,
    String accessoryId,
  ) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    ref
        .read(inventoryServiceProvider)
        .equipAccessory(uid: uid, catId: catId, accessoryId: accessoryId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.inventoryEquipSuccess(accessoryDisplayName(accessoryId)),
        ),
      ),
    );
  }

  void _unequip(BuildContext context, WidgetRef ref, Cat cat) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    ref
        .read(inventoryServiceProvider)
        .unequipAccessory(uid: uid, catId: cat.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.inventoryUnequipSuccess(cat.name))),
    );
  }
}

class _EquippedItem {
  final String accessoryId;
  final Cat cat;

  const _EquippedItem({required this.accessoryId, required this.cat});
}
