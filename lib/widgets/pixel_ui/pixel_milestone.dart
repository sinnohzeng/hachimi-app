import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风里程碑 — 星形标记（填充/空心）+ 虚线连接。
///
/// 自适应双模式：
/// - MD3：圆形指示器 + 实线连接
/// - Retro Pixel：像素星形 + 虚线连接
///
/// 取代 StageMilestone，用于成长阶段可视化。
class PixelMilestone extends StatelessWidget {
  const PixelMilestone({
    super.key,
    required this.stages,
    required this.currentIndex,
    this.stageColors,
  });

  /// 阶段名称列表（如 ["Kitten", "Adolescent", "Adult", "Senior"]）
  final List<String> stages;

  /// 当前已达阶段索引（0-based）
  final int currentIndex;

  /// 各阶段对应颜色 — 默认使用 xpBarFill (retro) / scheme.primary (MD3)
  final List<Color>? stageColors;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    if (!pixel.isRetro) return _buildMaterial(context);
    return _buildRetro(context, pixel);
  }

  // ---------------------------------------------------------------------------
  // MD3 模式
  // ---------------------------------------------------------------------------

  Widget _buildMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        for (var i = 0; i < stages.length; i++) ...[
          if (i > 0) _MaterialLine(color: scheme.outlineVariant),
          _CircleMarker(
            label: stages[i],
            filled: i <= currentIndex,
            color: stageColors?.elementAtOrNull(i) ?? scheme.primary,
            outlineColor: scheme.outlineVariant,
            labelStyle: theme.textTheme.labelSmall!,
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Retro Pixel 模式
  // ---------------------------------------------------------------------------

  Widget _buildRetro(BuildContext context, PixelThemeExtension pixel) {
    return Row(
      children: [
        for (var i = 0; i < stages.length; i++) ...[
          if (i > 0) _DottedLine(color: pixel.pixelBorder),
          _StarMarker(
            label: stages[i],
            filled: i <= currentIndex,
            color: stageColors?.elementAtOrNull(i) ?? pixel.xpBarFill,
            borderColor: pixel.pixelBorder,
            labelStyle: pixel.pixelLabel,
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// MD3 组件
// =============================================================================

class _CircleMarker extends StatelessWidget {
  const _CircleMarker({
    required this.label,
    required this.filled,
    required this.color,
    required this.outlineColor,
    required this.labelStyle,
  });

  final String label;
  final bool filled;
  final Color color;
  final Color outlineColor;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? color : Colors.transparent,
            border: Border.all(color: filled ? color : outlineColor, width: 2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: labelStyle.copyWith(fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MaterialLine extends StatelessWidget {
  const _MaterialLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(height: 2, color: color.withValues(alpha: 0.3)),
      ),
    );
  }
}

// =============================================================================
// Retro Pixel 组件
// =============================================================================

class _StarMarker extends StatelessWidget {
  const _StarMarker({
    required this.label,
    required this.filled,
    required this.color,
    required this.borderColor,
    required this.labelStyle,
  });

  final String label;
  final bool filled;
  final Color color;
  final Color borderColor;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(18, 18),
          painter: _PixelStarPainter(
            filled: filled,
            color: color,
            borderColor: borderColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: labelStyle.copyWith(fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// 虚线连接两颗星。
class _DottedLine extends StatelessWidget {
  const _DottedLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CustomPaint(
          size: const Size(double.infinity, 2),
          painter: _DottedLinePainter(color: color),
        ),
      ),
    );
  }
}

/// 像素星形 — 用简化的十字 + 对角组合近似星形。
class _PixelStarPainter extends CustomPainter {
  _PixelStarPainter({
    required this.filled,
    required this.color,
    required this.borderColor,
  });

  final bool filled;
  final Color color;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // 简化像素星：用菱形近似
    final path = Path()
      ..moveTo(cx, 0) // 上
      ..lineTo(cx + r * 0.35, cy - r * 0.35)
      ..lineTo(r * 2, cy) // 右
      ..lineTo(cx + r * 0.35, cy + r * 0.35)
      ..lineTo(cx, r * 2) // 下
      ..lineTo(cx - r * 0.35, cy + r * 0.35)
      ..lineTo(0, cy) // 左
      ..lineTo(cx - r * 0.35, cy - r * 0.35)
      ..close();

    if (filled) {
      canvas.drawPath(path, paint..color = color);
    }
    canvas.drawPath(
      path,
      paint
        ..color = filled ? borderColor : borderColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_PixelStarPainter oldDelegate) {
    return filled != oldDelegate.filled || color != oldDelegate.color;
  }
}

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..isAntiAlias = false;
    const dash = 3.0;
    const gap = 3.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawRect(Rect.fromLTWH(x, 0, dash, 2), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
