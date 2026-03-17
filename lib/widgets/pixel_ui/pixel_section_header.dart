import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 区块标题 — 自适应双模式渲染。
///
/// - MD3：简洁分隔线 + titleSmall 标题
/// - Retro：像素虚线 "━━━ Title ━━━"
///
/// 用于 CatDetailScreen 各卡片的区块标题。
class PixelSectionHeader extends StatelessWidget {
  const PixelSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  final String title;
  final IconData? icon;

  /// 右侧可选控件（如展开箭头、按钮等）
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    if (!pixel.isRetro) return _buildMaterial(context);
    return _buildRetro(context, pixel);
  }

  Widget _buildMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lineColor = scheme.outlineVariant.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 左分隔线
          Expanded(child: Divider(color: lineColor)),
          const SizedBox(width: 8),
          if (icon != null) ...[
            Icon(icon, size: 16, color: scheme.primary),
            const SizedBox(width: 6),
          ],
          Text(title, style: theme.textTheme.titleSmall),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
          const SizedBox(width: 8),
          // 右分隔线
          Expanded(child: Divider(color: lineColor)),
        ],
      ),
    );
  }

  Widget _buildRetro(BuildContext context, PixelThemeExtension pixel) {
    final lineColor = pixel.pixelBorder.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 左装饰线
          Flexible(child: _PixelDivider(color: lineColor)),
          const SizedBox(width: 8),
          if (icon != null) ...[
            Icon(icon, size: 16, color: pixel.pixelAccentWarm),
            const SizedBox(width: 6),
          ],
          Text(title, style: pixel.pixelHeading),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
          const SizedBox(width: 8),
          // 右装饰线
          Flexible(child: _PixelDivider(color: lineColor)),
        ],
      ),
    );
  }
}

/// 像素风分隔线 — 用虚线矩形模拟像素点阵。
class _PixelDivider extends StatelessWidget {
  const _PixelDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 2),
      painter: _DashedLinePainter(color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const gap = 3.0;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;

    var x = 0.0;
    while (x < size.width) {
      canvas.drawRect(Rect.fromLTWH(x, 0, dashWidth, 2), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
