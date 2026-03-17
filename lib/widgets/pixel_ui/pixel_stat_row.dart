import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 统计行 — 自适应双模式渲染。
///
/// - MD3：标准 bodyMedium 文字 + primary 图标
/// - Retro：Silkscreen 像素标签 + pixelAccentWarm 图标
///
/// 用于 FocusStatsCard 中替代普通 Table 行。
class PixelStatRow extends StatelessWidget {
  const PixelStatRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  /// 统计标签（如 "Daily goal"）
  final String label;

  /// 统计值（如 "25 min"）
  final String value;

  /// 可选图标
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    if (!pixel.isRetro) return _buildMaterial(context);
    return _buildRetro(context, pixel);
  }

  Widget _buildMaterial(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: scheme.primary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRetro(BuildContext context, PixelThemeExtension pixel) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: pixel.pixelAccentWarm),
            const SizedBox(width: 6),
          ],
          Text(label, style: pixel.pixelLabel),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
