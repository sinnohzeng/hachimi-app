/// 饰品信息数据类 — 用于商店展示和装备管理。
class AccessoryInfo {
  final String id;
  final String displayName;
  final int price;
  final String category; // 'plant' / 'wild' / 'collar'
  final bool isOwned;
  final bool isEquipped;

  const AccessoryInfo({
    required this.id,
    required this.displayName,
    required this.price,
    required this.category,
    this.isOwned = false,
    this.isEquipped = false,
  });
}
