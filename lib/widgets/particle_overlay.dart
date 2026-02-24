import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmospheric_particles/atmospheric_particles.dart';
import 'package:hachimi_app/providers/theme_provider.dart';

/// 粒子模式预设。
enum ParticleMode {
  /// 猫猫页用 — 40 个粒子，较活泼，暖白色。
  firefly,

  /// 计时页用 — 15 个粒子，极缓慢，不分散注意力。
  dust,
}

/// 浮动粒子覆盖层。
///
/// 动画禁用时返回空 SizedBox。
/// [fadeIn] 为 true 时等待路由转场完成后渐入，避免与 Hero 动画重叠。
class ParticleOverlay extends ConsumerStatefulWidget {
  final ParticleMode mode;
  final Widget? child;

  /// 是否启用渐入效果（默认 false，向后兼容）。
  final bool fadeIn;

  /// 渐入动画时长（默认 400ms）。
  final Duration fadeInDuration;

  const ParticleOverlay({
    super.key,
    required this.mode,
    this.child,
    this.fadeIn = false,
    this.fadeInDuration = const Duration(milliseconds: 400),
  });

  @override
  ConsumerState<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends ConsumerState<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;

  /// 缓存路由动画引用，确保 dispose 时移除的是同一个对象。
  Animation<double>? _routeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: widget.fadeInDuration,
      value: widget.fadeIn ? 0.0 : 1.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.fadeIn || _routeAnimation != null) return;

    final route = ModalRoute.of(context);
    if (route == null) {
      _fadeCtrl.value = 1.0;
      return;
    }

    final animation = route.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      _fadeCtrl.forward();
    } else {
      _routeAnimation = animation;
      animation.addStatusListener(_onRouteAnimationStatus);
    }
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _fadeCtrl.forward();
    }
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationEnabled = ref.watch(
      themeProvider.select((s) => s.enableBackgroundAnimation),
    );
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (!animationEnabled || disableAnimations) {
      return widget.child ?? const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final particleColor = isDark
        ? onSurface.withValues(alpha: 0.25)
        : onSurface.withValues(alpha: 0.5);

    final particles = _buildParticles(particleColor);

    if (!widget.fadeIn) return particles;

    return FadeTransition(opacity: _fadeCtrl, child: particles);
  }

  Widget _buildParticles(Color particleColor) {
    final child = widget.child ?? const SizedBox.expand();
    switch (widget.mode) {
      case ParticleMode.firefly:
        return AtmosphericParticles(
          particleCount: 40,
          particleColor: particleColor,
          minParticleRadius: 1.5,
          maxParticleRadius: 3.0,
          minVerticalVelocity: -25,
          maxVerticalVelocity: -5,
          minHorizontalVelocity: -8,
          maxHorizontalVelocity: 8,
          trailLength: 0,
          fadeDirection: FadeDirection.bottom,
          child: child,
        );
      case ParticleMode.dust:
        return AtmosphericParticles(
          particleCount: 15,
          particleColor: particleColor,
          minParticleRadius: 1.0,
          maxParticleRadius: 2.0,
          minVerticalVelocity: -10,
          maxVerticalVelocity: -2,
          minHorizontalVelocity: -3,
          maxHorizontalVelocity: 3,
          trailLength: 0,
          fadeDirection: FadeDirection.bottom,
          child: child,
        );
    }
  }
}
