import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';
import '_md3_helpers.dart';

/// 金币显示 — 自适应双模式渲染。
///
/// - MD3：Material monetization_on 图标 + labelLarge 计数
/// - Retro：16×16 像素金币 CustomPaint + Silkscreen 计数
///
/// 数值变化时数字向上滚动（里程表效果）。
class PixelCoinDisplay extends StatelessWidget {
  const PixelCoinDisplay({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    if (!pixel.isRetro) return _buildMaterial(context);
    return _buildRetro(context, pixel);
  }

  Widget _buildMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.monetization_on, size: 18, color: scheme.tertiary),
        const SizedBox(width: 4),
        md3AnimatedCounter(
          amount: amount,
          style: theme.textTheme.labelLarge?.copyWith(
            color: scheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRetro(BuildContext context, PixelThemeExtension pixel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 像素金币图标
        CustomPaint(
          size: const Size(16, 16),
          painter: _CoinPainter(
            color: pixel.xpBarFill,
            // 金币 "C" 字色：深棕在金色 (#FFD700) 上对比度 7.5:1（亮/暗色通用）
            letterColor: const Color(0xFF3E2723),
          ),
        ),
        const SizedBox(width: 4),
        md3AnimatedCounter(
          amount: amount,
          style: pixel.pixelLabel.copyWith(
            color: pixel.xpBarFill,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// 绘制 16×16 像素金币 — 圆形底色 + "C" 标记。
class _CoinPainter extends CustomPainter {
  _CoinPainter({required this.color, required this.letterColor});

  final Color color;
  final Color letterColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 外圈
    canvas.drawCircle(
      center,
      size.width / 2,
      Paint()
        ..color = color
        ..isAntiAlias = false,
    );

    // 内圈高光
    canvas.drawCircle(
      center,
      size.width / 2 - 2,
      Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..isAntiAlias = false,
    );

    // "C" 标记
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'C',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: letterColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_CoinPainter oldDelegate) =>
      color != oldDelegate.color || letterColor != oldDelegate.letterColor;
}
