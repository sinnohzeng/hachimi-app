import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风矩形开关 — 替代 M3 圆形 Switch。
///
/// M3 的 Switch 有圆形 thumb 和圆角 track，无法通过主题级联改为矩形。
/// 此组件使用 CustomPaint 绘制方形 thumb 在方形 track 中滑动的效果。
class PixelSwitch extends StatelessWidget {
  const PixelSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// 激活态颜色 — 默认 pixelSuccess
  final Color? activeColor;

  /// 未激活态颜色 — 默认 xpBarTrack
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final scheme = Theme.of(context).colorScheme;
    final active = activeColor ?? pixel.pixelSuccess;
    final inactive = inactiveColor ?? pixel.xpBarTrack;
    final border = pixel.pixelBorder;

    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
          width: 44,
          height: 24,
          decoration: BoxDecoration(
            color: value ? active : inactive,
            border: Border.all(color: border, width: 2),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.all(1),
              // thumb 色需在 pixelSuccess track 上保持高对比度
              // 亮色：onSurface（深色）在浅绿上 ≥ 7:1
              // 暗色：retroBackground（#1A1A2E）在亮绿上 ≥ 7:1
              color: value ? pixel.retroBackground : border,
            ),
          ),
        ),
      ),
    );
  }
}
