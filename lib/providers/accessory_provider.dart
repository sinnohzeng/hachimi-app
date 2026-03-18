/// 饰品分类。
enum AccessoryCategory {
  plant('plant'),
  wild('wild'),
  collar('collar');

  const AccessoryCategory(this.value);
  final String value;

  static AccessoryCategory fromValue(String value) {
    return AccessoryCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AccessoryCategory.plant, // 安全回退
    );
  }
}

/// 饰品信息数据类 — 用于商店展示和装备管理。
class AccessoryInfo {
  final String id;
  final String displayName;
  final int price;
  final AccessoryCategory category;
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
