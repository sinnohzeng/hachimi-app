import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:hachimi_app/providers/theme_provider.dart';

/// 可复用的动态 mesh 渐变背景。
///
/// 当动画被禁用时（用户设置或系统无障碍），自动 fallback 为静态 LinearGradient。
/// 支持 [fadeIn] 模式：等路由转场完成后再渐入显示，避免 Hero 转场期间的视觉断裂。
class AnimatedMeshBackground extends ConsumerStatefulWidget {
  /// 恰好 4 种颜色，对应 mesh 四角。
  final List<Color> colors;

  /// 动画速度（默认 1.0，计时页建议 0.3）。
  final double speed;

  /// 渲染在渐变之上的子组件。
  final Widget? child;

  /// 是否启用渐入效果（默认 false）。
  ///
  /// 启用后，组件在路由转场完成后才开始渐入显示，
  /// 避免 GPU shader 编译首帧造成的静态到动态闪烁。
  final bool fadeIn;

  /// 渐入动画时长（默认 600ms）。
  final Duration fadeInDuration;

  const AnimatedMeshBackground({
    super.key,
    required this.colors,
    this.speed = 1.0,
    this.child,
    this.fadeIn = false,
    this.fadeInDuration = const Duration(milliseconds: 600),
  }) : assert(
         colors.length == 4,
         'AnimatedMeshBackground requires exactly 4 colors',
       );

  @override
  ConsumerState<AnimatedMeshBackground> createState() =>
      _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends ConsumerState<AnimatedMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;

  /// 多态 opacity 驱动：默认使用 _fadeCtrl，路由转场中使用 CurvedAnimation。
  late Animation<double> _opacity;

  /// 标记是否已解析过路由动画，避免 didChangeDependencies 重复执行。
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: widget.fadeInDuration,
      value: widget.fadeIn ? 0.0 : 1.0,
    );
    _opacity = _fadeCtrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.fadeIn || _resolved) return;
    _resolved = true;

    final route = ModalRoute.of(context);
    if (route == null) {
      // 无路由上下文（如嵌套在非路由 widget 中），直接显示
      _fadeCtrl.value = 1.0;
      return;
    }

    final animation = route.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      // 转场已完成（如从后台恢复或热重载），渐入显示
      _fadeCtrl.forward();
    } else {
      // 路由转场进行中 — 同步 opacity 与转场进度。
      // Interval(0.3, 1.0)：前 30% 保持不可见（shader 预热缓冲），
      // 剩余 70% 随页面入场渐入。
      _opacity = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      );
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.colors.length == 4);

    final animationEnabled = ref.watch(
      themeProvider.select((s) => s.enableBackgroundAnimation),
    );
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    // 动画禁用时跳过 fade，直接显示静态 fallback
    if (!animationEnabled || disableAnimations) {
      return SizedBox.expand(
        child: _StaticFallback(colors: widget.colors, child: widget.child),
      );
    }

    return RepaintBoundary(
      child: FadeTransition(
        opacity: _opacity,
        child: SizedBox.expand(
          child: AnimatedMeshGradient(
            colors: widget.colors,
            options: AnimatedMeshGradientOptions(
              speed: widget.speed,
              grain: 0.0,
              frequency: 3,
              amplitude: 20,
            ),
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
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
