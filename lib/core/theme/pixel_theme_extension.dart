import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 像素风 UI 设计令牌 — 为猫咪屏幕提供复古游戏视觉层。
///
/// 通过 `Theme.of(context).extension<PixelThemeExtension>()` 访问。
/// 仅在猫咪相关屏幕使用，不影响其他 Material 3 界面。
class PixelThemeExtension extends ThemeExtension<PixelThemeExtension> {
  const PixelThemeExtension({
    required this.retroBackground,
    required this.retroSurface,
    required this.pixelBorder,
    required this.xpBarFill,
    required this.xpBarTrack,
    required this.pixelAccentWarm,
    required this.pixelAccentCool,
    required this.pixelTitle,
    required this.pixelHeading,
    required this.pixelLabel,
    required this.pixelName,
  });

  // --- 复古配色 ---

  /// 画面底色 — 羊皮纸暖色 (light) / 深靛蓝 (dark)
  final Color retroBackground;

  /// 卡片填充色 — 柔和米色 (light) / 哑光紫灰 (dark)
  final Color retroSurface;

  /// 像素阶梯边框色 — 温暖棕色
  final Color pixelBorder;

  /// 经验条填充色 — 金色
  final Color xpBarFill;

  /// 经验条轨道色 — 浅棕 (light) / 深紫灰 (dark)
  final Color xpBarTrack;

  /// 暖色调点缀 — 蜜桃色
  final Color pixelAccentWarm;

  /// 冷色调点缀 — 天蓝色
  final Color pixelAccentCool;

  // --- 像素字体样式 ---

  /// 屏幕标题 — Silkscreen 16px bold
  final TextStyle pixelTitle;

  /// 卡片区块标题 — Silkscreen 14px
  final TextStyle pixelHeading;

  /// 徽章、标签 — Silkscreen 12px
  final TextStyle pixelLabel;

  /// 猫咪名称（详情页英雄区）— Silkscreen 20px bold
  final TextStyle pixelName;

  /// 明亮主题
  factory PixelThemeExtension.light(ColorScheme scheme) {
    return PixelThemeExtension(
      retroBackground: const Color(0xFFFFF8E7),
      retroSurface: const Color(0xFFFEF3D0),
      pixelBorder: const Color(0xFF5C3A1E),
      xpBarFill: const Color(0xFFFFD700),
      xpBarTrack: const Color(0xFFD4C5A0),
      pixelAccentWarm: const Color(0xFFE8A87C),
      pixelAccentCool: const Color(0xFF7EC8E3),
      pixelTitle: _pixelFont(16, FontWeight.bold, scheme.onSurface),
      pixelHeading: _pixelFont(14, FontWeight.normal, scheme.onSurface),
      pixelLabel: _pixelFont(12, FontWeight.normal, scheme.onSurfaceVariant),
      pixelName: _pixelFont(20, FontWeight.bold, scheme.onSurface),
    );
  }

  /// 暗色主题
  factory PixelThemeExtension.dark(ColorScheme scheme) {
    return PixelThemeExtension(
      retroBackground: const Color(0xFF1A1A2E),
      retroSurface: const Color(0xFF252547),
      pixelBorder: const Color(0xFF8B7355),
      xpBarFill: const Color(0xFFFFD700),
      xpBarTrack: const Color(0xFF3A3A5C),
      pixelAccentWarm: const Color(0xFFE8A87C),
      pixelAccentCool: const Color(0xFF7EC8E3),
      pixelTitle: _pixelFont(16, FontWeight.bold, scheme.onSurface),
      pixelHeading: _pixelFont(14, FontWeight.normal, scheme.onSurface),
      pixelLabel: _pixelFont(12, FontWeight.normal, scheme.onSurfaceVariant),
      pixelName: _pixelFont(20, FontWeight.bold, scheme.onSurface),
    );
  }

  /// 测试用回退值
  factory PixelThemeExtension.fallback() {
    return PixelThemeExtension(
      retroBackground: const Color(0xFFFFF8E7),
      retroSurface: const Color(0xFFFEF3D0),
      pixelBorder: const Color(0xFF5C3A1E),
      xpBarFill: const Color(0xFFFFD700),
      xpBarTrack: const Color(0xFFD4C5A0),
      pixelAccentWarm: const Color(0xFFE8A87C),
      pixelAccentCool: const Color(0xFF7EC8E3),
      pixelTitle: _pixelFont(16, FontWeight.bold, Colors.black),
      pixelHeading: _pixelFont(14, FontWeight.normal, Colors.black),
      pixelLabel: _pixelFont(12, FontWeight.normal, Colors.grey),
      pixelName: _pixelFont(20, FontWeight.bold, Colors.black),
    );
  }

  static TextStyle _pixelFont(double size, FontWeight weight, Color color) {
    return GoogleFonts.silkscreen(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  @override
  PixelThemeExtension copyWith({
    Color? retroBackground,
    Color? retroSurface,
    Color? pixelBorder,
    Color? xpBarFill,
    Color? xpBarTrack,
    Color? pixelAccentWarm,
    Color? pixelAccentCool,
    TextStyle? pixelTitle,
    TextStyle? pixelHeading,
    TextStyle? pixelLabel,
    TextStyle? pixelName,
  }) {
    return PixelThemeExtension(
      retroBackground: retroBackground ?? this.retroBackground,
      retroSurface: retroSurface ?? this.retroSurface,
      pixelBorder: pixelBorder ?? this.pixelBorder,
      xpBarFill: xpBarFill ?? this.xpBarFill,
      xpBarTrack: xpBarTrack ?? this.xpBarTrack,
      pixelAccentWarm: pixelAccentWarm ?? this.pixelAccentWarm,
      pixelAccentCool: pixelAccentCool ?? this.pixelAccentCool,
      pixelTitle: pixelTitle ?? this.pixelTitle,
      pixelHeading: pixelHeading ?? this.pixelHeading,
      pixelLabel: pixelLabel ?? this.pixelLabel,
      pixelName: pixelName ?? this.pixelName,
    );
  }

  @override
  PixelThemeExtension lerp(covariant PixelThemeExtension? other, double t) {
    if (other == null) return this;
    return PixelThemeExtension(
      retroBackground: Color.lerp(retroBackground, other.retroBackground, t)!,
      retroSurface: Color.lerp(retroSurface, other.retroSurface, t)!,
      pixelBorder: Color.lerp(pixelBorder, other.pixelBorder, t)!,
      xpBarFill: Color.lerp(xpBarFill, other.xpBarFill, t)!,
      xpBarTrack: Color.lerp(xpBarTrack, other.xpBarTrack, t)!,
      pixelAccentWarm: Color.lerp(pixelAccentWarm, other.pixelAccentWarm, t)!,
      pixelAccentCool: Color.lerp(pixelAccentCool, other.pixelAccentCool, t)!,
      pixelTitle: TextStyle.lerp(pixelTitle, other.pixelTitle, t)!,
      pixelHeading: TextStyle.lerp(pixelHeading, other.pixelHeading, t)!,
      pixelLabel: TextStyle.lerp(pixelLabel, other.pixelLabel, t)!,
      pixelName: TextStyle.lerp(pixelName, other.pixelName, t)!,
    );
  }
}

/// 便捷访问 — 避免每次写 `Theme.of(context).extension<...>()`。
extension PixelThemeContext on BuildContext {
  PixelThemeExtension get pixel =>
      Theme.of(this).extension<PixelThemeExtension>() ??
      PixelThemeExtension.fallback();
}
