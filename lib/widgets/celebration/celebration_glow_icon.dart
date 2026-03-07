import 'package:flutter/material.dart';
import 'package:hachimi_app/widgets/celebration/celebration_tier.dart';

/// 成就图标 + 辐射光环效果 — 按层级区分视觉表现。
class CelebrationGlowIcon extends StatelessWidget {
  final IconData icon;
  final CelebrationTier tier;
  final Animation<double> burstAnimation;
  final double size;

  const CelebrationGlowIcon({
    super.key,
    required this.icon,
    required this.tier,
    required this.burstAnimation,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 2,
      height: size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 辐射光环（Notable / Epic）
          if (tier != CelebrationTier.standard)
            AnimatedBuilder(
              animation: burstAnimation,
              builder: (context, _) {
                final burstRadius = size * (1.0 + burstAnimation.value);
                final burstOpacity = (1.0 - burstAnimation.value).clamp(
                  0.0,
                  1.0,
                );
                return Container(
                  width: burstRadius,
                  height: burstRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4 * burstOpacity),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

          // 图标容器
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.2),
                  blurRadius: tier == CelebrationTier.epic ? 24 : 16,
                  spreadRadius: tier == CelebrationTier.epic ? 6 : 3,
                ),
              ],
            ),
            child: Icon(icon, size: size * 0.5, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
