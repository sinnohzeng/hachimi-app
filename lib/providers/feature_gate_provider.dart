import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/lumi_feature.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';

/// 功能解锁状态 — 基于累计记录天数判断各功能是否解锁。
///
/// 依赖 [awarenessStatsProvider] 的 totalLightDays。
/// 返回 `Map<LumiFeature, bool>`，true 表示已解锁。
final featureGateProvider = Provider<Map<LumiFeature, bool>>((ref) {
  final statsAsync = ref.watch(awarenessStatsProvider);
  final totalDays = statsAsync.whenData((s) => s['totalLightDays'] ?? 0);
  final days = totalDays.value ?? 0;

  return {
    for (final feature in LumiFeature.values)
      feature: days >= feature.requiredDays,
  };
});
