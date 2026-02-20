// ---
// 📘 文件说明：
// 浮动粒子覆盖层 — 封装 AtmosphericParticles，提供 firefly/dust 两种预设。
//
// 📋 程序整体伪代码（中文）：
// 1. 根据 ParticleMode 选择粒子数量、速度、大小等参数；
// 2. 检查动画开关，禁用时不渲染任何粒子；
// 3. 渲染 AtmosphericParticles 覆盖在 child 上方；
//
// 🧩 文件结构：
// - ParticleMode 枚举：firefly / dust；
// - ParticleOverlay：可复用 ConsumerWidget；
//
// 🕒 创建时间：2026-02-19
// ---

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
