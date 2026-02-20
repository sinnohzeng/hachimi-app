// ---
// 📘 文件说明：
// 动态 mesh 渐变背景组件 — 封装 AnimatedMeshGradient，支持动画开关。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 4 色列表 + speed + child；
// 2. 检查 themeProvider.enableBackgroundAnimation 和系统无障碍设置；
// 3. 启用时渲染 AnimatedMeshGradient；
// 4. 禁用时 fallback 为静态 LinearGradient；
//
// 🧩 文件结构：
// - AnimatedMeshBackground：可复用 ConsumerWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:hachimi_app/providers/theme_provider.dart';

/// 可复用的动态 mesh 渐变背景。
///
/// 当动画被禁用时（用户设置或系统无障碍），自动 fallback 为静态 LinearGradient。
class AnimatedMeshBackground extends ConsumerWidget {
  /// 恰好 4 种颜色，对应 mesh 四角。
  final List<Color> colors;

  /// 动画速度（默认 1.0，计时页建议 0.3）。
  final double speed;

  /// 渲染在渐变之上的子组件。
  final Widget? child;

  const AnimatedMeshBackground({
    super.key,
    required this.colors,
    this.speed = 1.0,
    this.child,
  }) : assert(
         colors.length == 4,
         'AnimatedMeshBackground requires exactly 4 colors',
       );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(colors.length == 4);

    final animationEnabled = ref.watch(
      themeProvider.select((s) => s.enableBackgroundAnimation),
    );
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (!animationEnabled || disableAnimations) {
      return _StaticFallback(colors: colors, child: child);
    }

    return AnimatedMeshGradient(
      colors: colors,
      options: AnimatedMeshGradientOptions(
        speed: speed,
        grain: 0.0,
        frequency: 3,
        amplitude: 20,
      ),
      child: child ?? const SizedBox.expand(),
    );
  }
}

/// 动画禁用时的静态渐变 fallback。
class _StaticFallback extends StatelessWidget {
  final List<Color> colors;
  final Widget? child;

  const _StaticFallback({required this.colors, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
