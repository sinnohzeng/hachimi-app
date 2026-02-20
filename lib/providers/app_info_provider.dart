// ---
// 📘 文件说明：
// appInfoProvider — 从系统读取应用版本信息，消除硬编码版本号。
//
// 🧩 文件结构：
// - appInfoProvider：FutureProvider，异步获取 PackageInfo；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// appInfoProvider — reads version info from the system at runtime.
///
/// Usage:
/// ```dart
/// final info = ref.watch(appInfoProvider);
/// info.when(
///   data: (pkg) => Text(pkg.version),
///   loading: () => Text('...'),
///   error: (e, _) => Text('?'),
/// );
/// ```
final appInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});
