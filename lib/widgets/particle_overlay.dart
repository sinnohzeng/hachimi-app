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
class ParticleOverlay extends ConsumerWidget {
  final ParticleMode mode;
  final Widget? child;

  const ParticleOverlay({super.key, required this.mode, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationEnabled = ref.watch(
      themeProvider.select((s) => s.enableBackgroundAnimation),
    );
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (!animationEnabled || disableAnimations) {
      return child ?? const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final particleColor = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.5);

    switch (mode) {
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
          child: child ?? const SizedBox.expand(),
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
          child: child ?? const SizedBox.expand(),
        );
    }
  }
}
