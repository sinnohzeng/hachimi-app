import 'package:flutter/material.dart';

/// 亮度感知透明度工具 — 根据当前亮度模式返回不同的 alpha 值。
extension BrightnessAlpha on Color {
  /// 根据亮度模式返回不同透明度的颜色。
  /// [lightAlpha] 用于亮色模式，[darkAlpha] 用于深色模式。
  Color withBrightnessAlpha(
    Brightness brightness, {
    required double lightAlpha,
    required double darkAlpha,
  }) =>
      withValues(alpha: brightness == Brightness.dark ? darkAlpha : lightAlpha);
}

/// 语义化状态颜色 — 提供亮度感知的成功/错误状态色。
class StatusColors {
  StatusColors._();

  static const Color success = Color(0xFF4CAF50);

  /// 成功状态容器背景色（深色模式下提高透明度以增强对比度）。
  static Color successContainer(Brightness b) =>
      success.withValues(alpha: b == Brightness.dark ? 0.25 : 0.12);

  /// 成功状态前景色（深色模式下使用较浅的绿色以增强可读性）。
  static Color onSuccess(Brightness b) =>
      b == Brightness.dark ? const Color(0xFF81C784) : success;
}

/// 品牌与功能色常量 — 避免在 Widget 中硬编码颜色值。
class BrandColors {
  BrandColors._();

  /// Google 品牌色（用于登录按钮渐变等）。
  static const List<Color> google = [
    Color(0xFF4285F4), // Blue
    Color(0xFF34A853), // Green
    Color(0xFFFBBC05), // Yellow
    Color(0xFFEA4335), // Red
    Color(0xFF4285F4), // Blue（闭合渐变）
  ];

  /// 奖励金色 — 签到、成就等奖励场景。
  static const Color rewardGold = Color(0xFFFFD700);

  /// 成就星星色 — 成就详情页星标。
  static const Color achievementStar = Color(0xFFFF8F00); // amber.shade700

  /// 从 ColorScheme 派生的 confetti 颜色。
  static List<Color> confetti(ColorScheme cs) => [
        cs.primary,
        cs.tertiary,
        cs.secondary,
        Colors.amber,
        Colors.pink,
      ];
}
