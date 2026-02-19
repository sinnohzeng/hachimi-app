// ---
// 📘 文件说明：
// AccessoryShopScreen — 饰品商店全页界面。
// TabBar 3 标签（Plants / Wild / Collars），3 列网格展示。
// 购买流程：点击 → BottomSheet 选猫 → 确认购买。
//
// 📋 程序整体伪代码：
// 1. 从 Provider 读取金币余额和所有猫咪数据；
// 2. 构建 3 标签页（植物/野生/项圈），填充饰品网格；
// 3. 点击未拥有饰品 → BottomSheet：选猫 + 购买确认；
// 4. 调用 CoinService.purchaseAccessory()；
// 5. 反馈结果（SnackBar）；
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/accessory_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/coin_provider.dart';
import 'package:hachimi_app/widgets/accessory_card.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// 饰品商店 — 3 标签分类展示 + 购买流程。
class AccessoryShopScreen extends ConsumerWidget {
  const AccessoryShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balance = ref.watch(coinBalanceProvider).value ?? 0;
    final cats = ref.watch(catsProvider).value ?? [];

    // 构建所有饰品的 owned 集合（任一猫拥有即视为已购买）
    final ownedSet = <String>{};
    for (final cat in cats) {
      ownedSet.addAll(cat.accessories);
    }

    final prices = accessoryPriceMap;

    // 构建 3 类饰品列表
    final plantItems = plantAccessories.map((id) => AccessoryInfo(
          id: id,
          displayName: accessoryDisplayName(id),
          price: prices[id] ?? 150,
          category: 'plant',
          isOwned: ownedSet.contains(id),
        )).toList();

    final wildItems = wildAccessories.map((id) => AccessoryInfo(
          id: id,
          displayName: accessoryDisplayName(id),
          price: prices[id] ?? 250,
          category: 'wild',
          isOwned: ownedSet.contains(id),
        )).toList();

    final collarItems = <AccessoryInfo>[];
    for (final style in collarStyles) {
      for (final color in collarColors) {
        final id = '$color$style';
        collarItems.add(AccessoryInfo(
          id: id,
          displayName: accessoryDisplayName(id),
          price: prices[id] ?? 100,
          category: 'collar',
          isOwned: ownedSet.contains(id),
        ));
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accessory Shop'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
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
              Tab(text: 'Plants (${plantItems.length})'),
              Tab(text: 'Wild (${wildItems.length})'),
              Tab(text: 'Collars (${collarItems.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AccessoryGrid(
              items: plantItems,
              cats: cats,
              balance: balance,
            ),
            _AccessoryGrid(
              items: wildItems,
              cats: cats,
              balance: balance,
            ),
            _AccessoryGrid(
              items: collarItems,
              cats: cats,
              balance: balance,
            ),
          ],
        ),
      ),
    );
  }
}

/// 饰品网格 — 3 列 GridView。
class _AccessoryGrid extends ConsumerWidget {
  final List<AccessoryInfo> items;
  final List<Cat> cats;
  final int balance;

  const _AccessoryGrid({
    required this.items,
    required this.cats,
    required this.balance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(child: Text('No accessories available'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
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
              : () => _showPurchaseSheet(context, ref, item),
        );
      },
    );
  }

  void _showPurchaseSheet(
      BuildContext context, WidgetRef ref, AccessoryInfo item) {
    HapticFeedback.mediumImpact();

    if (cats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active cats to receive accessories')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => _PurchaseSheet(
        item: item,
        cats: cats,
        balance: balance,
      ),
    );
  }
}

/// 购买 BottomSheet — 选猫 + 确认购买。
class _PurchaseSheet extends ConsumerStatefulWidget {
  final AccessoryInfo item;
  final List<Cat> cats;
  final int balance;

  const _PurchaseSheet({
    required this.item,
    required this.cats,
    required this.balance,
  });

  @override
  ConsumerState<_PurchaseSheet> createState() => _PurchaseSheetState();
}

class _PurchaseSheetState extends ConsumerState<_PurchaseSheet> {
  int _selectedCatIndex = 0;
  bool _purchasing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canAfford = widget.balance >= widget.item.price;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 饰品名称和价格
            Text(
              'Buy ${widget.item.displayName}?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on, size: 18, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  '${widget.item.price} coins',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 猫咪选择器
            Text(
              'Choose a cat:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.cats.length,
                itemBuilder: (context, index) {
                  final cat = widget.cats[index];
                  final isSelected = index == _selectedCatIndex;
                  final alreadyOwns = cat.accessories.contains(widget.item.id);
                  return GestureDetector(
                    onTap: alreadyOwns
                        ? null
                        : () => setState(() => _selectedCatIndex = index),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected && !alreadyOwns
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                        color: alreadyOwns
                            ? colorScheme.surfaceContainerHighest
                            : isSelected
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerLow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PixelCatSprite.fromCat(cat: cat, size: 48),
                          const SizedBox(height: 2),
                          Text(
                            alreadyOwns ? 'Has it' : cat.name,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: alreadyOwns
                                  ? colorScheme.onSurfaceVariant
                                  : null,
                            ),
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
            const SizedBox(height: 16),

            // 购买按钮
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canAfford && !_purchasing
                    ? () => _purchase(context)
                    : null,
                child: _purchasing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(canAfford
                        ? 'Purchase'
                        : 'Not enough coins (need ${widget.item.price})'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchase(BuildContext context) async {
    setState(() => _purchasing = true);

    final cat = widget.cats[_selectedCatIndex];
    final uid = ref.read(currentUidProvider);
    if (uid == null) {
      setState(() => _purchasing = false);
      return;
    }

    final success = await ref.read(coinServiceProvider).purchaseAccessory(
          uid: uid,
          catId: cat.id,
          accessoryId: widget.item.id,
          price: widget.item.price,
        );

    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Purchased! ${widget.item.displayName} added to ${cat.name}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Not enough coins (need ${widget.item.price}, have ${widget.balance})'),
        ),
      );
    }
  }
}
