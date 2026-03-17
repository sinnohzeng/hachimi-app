import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 像素风 UI 设计令牌 — 为全应用提供复古游戏视觉层。
///
/// 通过 `Theme.of(context).extension<PixelThemeExtension>()` 访问，
/// 或使用便捷扩展 `context.pixel`。
///
/// 在 Retro Pixel 模式下，语义色已映射到 [ColorScheme]（由 [RetroPixelSkin] 处理），
/// 本扩展仅承载「无 ColorScheme 对应项」的像素专用令牌：
/// - 经验条/金币色（xpBarFill, xpBarTrack）
/// - 暖冷色点缀（pixelAccentWarm, pixelAccentCool）
/// - 状态色（pixelSuccess, pixelWarning）
/// - 像素字体样式（Silkscreen 系列）
class PixelThemeExtension extends ThemeExtension<PixelThemeExtension> {
  // --- 复古色板 SSOT — 工厂构造函数和外部预览组件共用 ---
  static const Color lightBackground = Color(0xFFFFF8E7);
  static const Color lightSurface = Color(0xFFFEF3D0);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF252547);
  static const Color lightBorder = Color(0xFF5C3A1E);
  static const Color darkBorder = Color(0xFFA08B6D);

  const PixelThemeExtension({
    required this.isRetro,
    required this.retroBackground,
    required this.retroSurface,
    required this.pixelBorder,
    required this.xpBarFill,
    required this.xpBarTrack,
    required this.pixelAccentWarm,
    required this.pixelAccentCool,
    required this.pixelSuccess,
    required this.pixelWarning,
    required this.pixelTitle,
    required this.pixelHeading,
    required this.pixelBody,
    required this.pixelLabel,
    required this.pixelName,
  });

  /// 当前是否处于复古像素模式 — SectionHeader 等组件据此切换样式。
  final bool isRetro;

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

  /// 正向反馈色 — 复古绿
  final Color pixelSuccess;

  /// 警告色 — 琥珀色
  final Color pixelWarning;

  // --- 像素字体样式 ---

  /// 屏幕标题 — Silkscreen 16px bold
  final TextStyle pixelTitle;

  /// 卡片区块标题 — Silkscreen 14px
  final TextStyle pixelHeading;

  /// 正文 — Silkscreen 14px（最小可读尺寸）
  final TextStyle pixelBody;

  /// 徽章、标签 — Silkscreen 14px（从 12px 提升，确保无障碍访问）
  final TextStyle pixelLabel;

  /// 猫咪名称（详情页英雄区）— Silkscreen 20px bold
  final TextStyle pixelName;

  /// 明亮主题
  factory PixelThemeExtension.light(ColorScheme scheme) {
    return PixelThemeExtension(
      isRetro: true,
      retroBackground: lightBackground,
      retroSurface: lightSurface,
      pixelBorder: lightBorder,
      xpBarFill: const Color(0xFFFFD700),
      xpBarTrack: const Color(0xFFD4C5A0),
      pixelAccentWarm: const Color(0xFFE8A87C),
      pixelAccentCool: const Color(0xFF7EC8E3),
      pixelSuccess: const Color(0xFF2E8B57),
      pixelWarning: const Color(0xFFDAA520),
      pixelTitle: _pixelFont(16, FontWeight.bold, scheme.onSurface),
      pixelHeading: _pixelFont(14, FontWeight.normal, scheme.onSurface),
      pixelBody: _pixelFont(14, FontWeight.normal, scheme.onSurface),
      pixelLabel: _pixelFont(14, FontWeight.normal, scheme.onSurfaceVariant),
      pixelName: _pixelFont(20, FontWeight.bold, scheme.onSurface),
    );
  }

  /// 暗色主题（边框色已提亮至 #A08B6D，在 #1A1A2E 上达到 4.6:1 对比度）
  factory PixelThemeExtension.dark(ColorScheme scheme) {
    return PixelThemeExtension(
      isRetro: true,
      retroBackground: darkBackground,
      retroSurface: darkSurface,
      pixelBorder: darkBorder,
      xpBarFill: const Color(0xFFFFD700),
      xpBarTrack: const Color(0xFF3A3A5C),
      pixelAccentWarm: const Color(0xFFE8A87C),
      pixelAccentCool: const Color(0xFF7EC8E3),
      pixelSuccess: const Color(0xFF5CDB95),
      pixelWarning: const Color(0xFFFFD700),
      pixelTitle: _pixelFont(16, FontWeight.bold, scheme.onSurface),
      pixelHeading: _pixelFont(14, FontWeight.normal, scheme.onSurface),
      pixelBody: _pixelFont(14, FontWeight.normal, scheme.onSurface),
      pixelLabel: _pixelFont(14, FontWeight.normal, scheme.onSurfaceVariant),
      pixelName: _pixelFont(20, FontWeight.bold, scheme.onSurface),
    );
  }

  /// 测试用回退值
  factory PixelThemeExtension.fallback() {
    return PixelThemeExtension(
      isRetro: false,
      retroBackground: lightBackground,
      retroSurface: lightSurface,
      pixelBorder: lightBorder,
      xpBarFill: const Color(0xFFFFD700),
      xpBarTrack: const Color(0xFFD4C5A0),
      pixelAccentWarm: const Color(0xFFE8A87C),
      pixelAccentCool: const Color(0xFF7EC8E3),
      pixelSuccess: const Color(0xFF2E8B57),
      pixelWarning: const Color(0xFFDAA520),
      pixelTitle: _pixelFont(16, FontWeight.bold, const Color(0xFF1C1B1F)),
      pixelHeading: _pixelFont(14, FontWeight.normal, const Color(0xFF1C1B1F)),
      pixelBody: _pixelFont(14, FontWeight.normal, const Color(0xFF1C1B1F)),
      pixelLabel: _pixelFont(14, FontWeight.normal, const Color(0xFF49454F)),
      pixelName: _pixelFont(20, FontWeight.bold, const Color(0xFF1C1B1F)),
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
    bool? isRetro,
    Color? retroBackground,
    Color? retroSurface,
    Color? pixelBorder,
    Color? xpBarFill,
    Color? xpBarTrack,
    Color? pixelAccentWarm,
    Color? pixelAccentCool,
    Color? pixelSuccess,
    Color? pixelWarning,
    TextStyle? pixelTitle,
    TextStyle? pixelHeading,
    TextStyle? pixelBody,
    TextStyle? pixelLabel,
    TextStyle? pixelName,
  }) {
    return PixelThemeExtension(
      isRetro: isRetro ?? this.isRetro,
      retroBackground: retroBackground ?? this.retroBackground,
      retroSurface: retroSurface ?? this.retroSurface,
      pixelBorder: pixelBorder ?? this.pixelBorder,
      xpBarFill: xpBarFill ?? this.xpBarFill,
      xpBarTrack: xpBarTrack ?? this.xpBarTrack,
      pixelAccentWarm: pixelAccentWarm ?? this.pixelAccentWarm,
      pixelAccentCool: pixelAccentCool ?? this.pixelAccentCool,
      pixelSuccess: pixelSuccess ?? this.pixelSuccess,
      pixelWarning: pixelWarning ?? this.pixelWarning,
      pixelTitle: pixelTitle ?? this.pixelTitle,
      pixelHeading: pixelHeading ?? this.pixelHeading,
      pixelBody: pixelBody ?? this.pixelBody,
      pixelLabel: pixelLabel ?? this.pixelLabel,
      pixelName: pixelName ?? this.pixelName,
    );
  }

  @override
  PixelThemeExtension lerp(covariant PixelThemeExtension? other, double t) {
    if (other == null) return this;
    // 所有字段均为 non-nullable，Color.lerp / TextStyle.lerp 在双参非空时保证返回非空
    return PixelThemeExtension(
      isRetro: t < 0.5 ? isRetro : other.isRetro,
      retroBackground: Color.lerp(retroBackground, other.retroBackground, t)!,
      retroSurface: Color.lerp(retroSurface, other.retroSurface, t)!,
      pixelBorder: Color.lerp(pixelBorder, other.pixelBorder, t)!,
      xpBarFill: Color.lerp(xpBarFill, other.xpBarFill, t)!,
      xpBarTrack: Color.lerp(xpBarTrack, other.xpBarTrack, t)!,
      pixelAccentWarm: Color.lerp(pixelAccentWarm, other.pixelAccentWarm, t)!,
      pixelAccentCool: Color.lerp(pixelAccentCool, other.pixelAccentCool, t)!,
      pixelSuccess: Color.lerp(pixelSuccess, other.pixelSuccess, t)!,
      pixelWarning: Color.lerp(pixelWarning, other.pixelWarning, t)!,
      pixelTitle: TextStyle.lerp(pixelTitle, other.pixelTitle, t)!,
      pixelHeading: TextStyle.lerp(pixelHeading, other.pixelHeading, t)!,
      pixelBody: TextStyle.lerp(pixelBody, other.pixelBody, t)!,
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
