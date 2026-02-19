// ---
// 📘 文件说明：
// AccessoryInfo 轻量数据类 — 饰品商店和装备 UI 使用。
// 整合饰品 ID、显示名、价格、分类、拥有/装备状态。
//
// 🕒 创建时间：2026-02-18
// ---

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
