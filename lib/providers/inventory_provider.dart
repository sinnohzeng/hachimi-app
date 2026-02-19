// ---
// 📘 文件说明：
// 道具箱 Provider — 实时监听用户 inventory 字段。
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 实时道具箱内容（未装备的配饰 ID 列表）。
final inventoryProvider = StreamProvider<List<String>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(inventoryServiceProvider).watchInventory(uid);
});
