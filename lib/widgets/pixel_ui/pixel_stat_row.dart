import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 复古游戏风格的统计行 — 图标 + 标签 + 数值。
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
