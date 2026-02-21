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
      withValues(
          alpha: brightness == Brightness.dark ? darkAlpha : lightAlpha);
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
