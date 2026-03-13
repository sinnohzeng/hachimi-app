import 'package:flutter/material.dart';

/// 像素风页面转场 — 阶梯式交叉淡入（0 → 0.33 → 0.66 → 1.0）。
///
/// 代替 M3 平滑 300ms Material 滑入动画，
/// 用 120ms 内 3-4 帧离散透明度切换模拟 8-bit 屏幕切换。
///
/// 通过 [RetroPixelSkin.pageTransitions] 注入 ThemeData，
/// 无需屏幕代码改动。
class PixelPageTransitionsBuilder extends PageTransitionsBuilder {
  const PixelPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: _SteppedOpacity(parent: animation),
      child: child,
    );
  }
}

/// 将连续的 0.0~1.0 动画离散化为 4 级透明度阶梯。
///
/// 使用 [FadeTransition] 而非 [Opacity] widget，
/// 避免创建额外的合成层，在 RenderObject 层直接设置透明度。
class _SteppedOpacity extends Animation<double>
    with AnimationWithParentMixin<double> {
  _SteppedOpacity({required this.parent});

  @override
  final Animation<double> parent;

  @override
  double get value {
    // clamp 防御弹性曲线/物理模拟的越界值
    final t = parent.value.clamp(0.0, 1.0);
    if (t < 0.25) return 0.0;
    if (t < 0.5) return 0.33;
    if (t < 0.75) return 0.66;
    return 1.0;
  }
}
