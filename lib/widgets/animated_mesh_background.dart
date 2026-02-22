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
  ///
  /// 子组件会接收到 tight constraints（等于父级可用空间），
  /// 无需在调用方额外包裹 [SizedBox.expand]。
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

    // SizedBox.expand 将 loose constraints 转为 tight constraints，
    // 确保子组件在 FlexibleSpaceBar.background 等场景下也能正确填满。
    if (!animationEnabled || disableAnimations) {
      return SizedBox.expand(
        child: _StaticFallback(colors: colors, child: child),
      );
    }

    return SizedBox.expand(
      child: AnimatedMeshGradient(
        colors: colors,
        options: AnimatedMeshGradientOptions(
          speed: speed,
          grain: 0.0,
          frequency: 3,
          amplitude: 20,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
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
