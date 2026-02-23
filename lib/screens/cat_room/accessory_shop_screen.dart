import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/accessory_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/coin_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/widgets/accessory_card.dart';

/// 饰品商店 — 3 标签分类展示 + 购买流程。
class AccessoryShopScreen extends ConsumerWidget {
  const AccessoryShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balance = ref.watch(coinBalanceProvider).value ?? 0;
    final cats = ref.watch(catsProvider).value ?? [];
    final inventory = ref.watch(inventoryProvider).value ?? [];

    // owned = inventory + 各猫已装备的
    final ownedSet = <String>{...inventory};
    for (final cat in cats) {
      if (cat.equippedAccessory != null) {
        ownedSet.add(cat.equippedAccessory!);
      }
    }

    final prices = accessoryPriceMap;

    // 构建 3 类饰品列表
    final plantItems = plantAccessories
        .map(
          (id) => AccessoryInfo(
            id: id,
            displayName: accessoryDisplayName(id),
            price: prices[id] ?? 150,
            category: 'plant',
            isOwned: ownedSet.contains(id),
          ),
        )
        .toList();

    final wildItems = wildAccessories
        .map(
          (id) => AccessoryInfo(
            id: id,
            displayName: accessoryDisplayName(id),
            price: prices[id] ?? 250,
            category: 'wild',
            isOwned: ownedSet.contains(id),
          ),
        )
        .toList();

    final collarItems = <AccessoryInfo>[];
    for (final style in collarStyles) {
      for (final color in collarColors) {
        final id = '$color$style';
        collarItems.add(
          AccessoryInfo(
            id: id,
            displayName: accessoryDisplayName(id),
            price: prices[id] ?? 100,
            category: 'collar',
            isOwned: ownedSet.contains(id),
          ),
        );
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.shopTitle),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Chip(
                avatar: Icon(
                  Icons.monetization_on,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  '$balance',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.shopTabPlants(plantItems.length)),
              Tab(text: context.l10n.shopTabWild(wildItems.length)),
              Tab(text: context.l10n.shopTabCollars(collarItems.length)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AccessoryGrid(items: plantItems, balance: balance),
            _AccessoryGrid(items: wildItems, balance: balance),
            _AccessoryGrid(items: collarItems, balance: balance),
          ],
        ),
      ),
    );
  }
}

/// 饰品网格 — 3 列 GridView。
class _AccessoryGrid extends ConsumerWidget {
  final List<AccessoryInfo> items;
  final int balance;

  const _AccessoryGrid({required this.items, required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(child: Text(context.l10n.shopNoAccessories));
    }

    return GridView.builder(
      padding: AppSpacing.paddingSm,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AccessoryCard(
          info: item,
          onTap: item.isOwned
              ? null
              : () => _showPurchaseDialog(context, ref, item),
        );
      },
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    WidgetRef ref,
    AccessoryInfo item,
  ) {
    HapticFeedback.mediumImpact();

    final canAfford = balance >= item.price;

    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = ctx.l10n;
        return AlertDialog(
          title: Text(l10n.shopBuyConfirm(item.displayName)),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on,
                size: 18,
                color: Theme.of(ctx).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(l10n.shopPrice(item.price)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: canAfford ? () => _purchase(ctx, ref, item) : null,
              child: Text(
                canAfford
                    ? l10n.shopPurchaseButton
                    : l10n.shopNotEnoughCoinsButton,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _purchase(
    BuildContext context,
    WidgetRef ref,
    AccessoryInfo item,
  ) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    Navigator.of(context).pop();

    final success = await ref
        .read(coinServiceProvider)
        .purchaseAccessory(uid: uid, accessoryId: item.id, price: item.price);

    if (!context.mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      ref
          .read(analyticsServiceProvider)
          .logAccessoryPurchased(accessoryId: item.id, price: item.price);
      ref
          .read(analyticsServiceProvider)
          .logCoinsSpent(amount: item.price, accessoryId: item.id);
    }

    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (success)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
                semanticLabel: 'Success',
              ),
            if (success) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                success
                    ? l10n.shopPurchaseSuccess(item.displayName)
                    : l10n.shopPurchaseFailed(item.price),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
