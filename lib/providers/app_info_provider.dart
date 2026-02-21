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
