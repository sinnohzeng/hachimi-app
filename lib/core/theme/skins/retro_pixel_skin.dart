import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_breakpoints.dart';
import '../app_spacing.dart';
import '../pixel_border_shape.dart';
import '../pixel_theme_extension.dart';
import 'theme_skin.dart';

/// 复古像素皮肤 — 星露谷物语风格的暖色调像素 UI。
///
/// 核心设计决策：
/// 1. 将复古色映射到 [ColorScheme] 语义槽，使所有 Material 组件自动适配
/// 2. 所有组件主题使用 [PixelBorderShape] 替代圆角
/// 3. 标题/标签使用 Silkscreen 像素字体，正文保留 Roboto 确保可读性
class RetroPixelSkin implements ThemeSkin {
  const RetroPixelSkin();

  @override
  bool get isRetro => true;

  // --- 复古色板 ---
  // 基础色引用 PixelThemeExtension SSOT 静态常量，避免重复定义
  static const _lightBackground = PixelThemeExtension.lightBackground;
  static const _lightSurface = PixelThemeExtension.lightSurface;
  static const _lightBorder = PixelThemeExtension.lightBorder;
  static const _darkBackground = PixelThemeExtension.darkBackground;
  static const _darkSurface = PixelThemeExtension.darkSurface;
  static const _darkBorder = PixelThemeExtension.darkBorder;

  // 皮肤专用色（不在 PixelThemeExtension 中）
  static const _lightSurfaceHigh = Color(0xFFF5E6B8); // 加深米色
  static const _lightError = Color(0xFFC41E3A); // 复古红
  static const _darkSurfaceHigh = Color(0xFF2F2F5A); // 加深紫灰
  static const _darkError = Color(0xFFFF6B6B); // 亮红

  /// 像素边框宽度（全局统一）
  static const double _borderWidth = 2.0;

  PixelBorderShape _pixelShape(Color borderColor) {
    return PixelBorderShape(
      borderWidth: _borderWidth,
      borderColor: borderColor,
    );
  }

  @override
  ColorScheme buildColorScheme(Color seedColor, Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    // 将复古色映射到 M3 语义色槽，保留 primary/secondary 系列
    if (brightness == Brightness.light) {
      return base.copyWith(
        surface: _lightBackground,
        surfaceContainerLowest: _lightBackground,
        surfaceContainerLow: _lightSurface,
        surfaceContainer: _lightSurface,
        surfaceContainerHigh: _lightSurfaceHigh,
        surfaceContainerHighest: _lightSurfaceHigh,
        outline: _lightBorder,
        outlineVariant: _lightBorder.withValues(alpha: 0.5),
        error: _lightError,
      );
    }
    return base.copyWith(
      surface: _darkBackground,
      surfaceContainerLowest: _darkBackground,
      surfaceContainerLow: _darkSurface,
      surfaceContainer: _darkSurface,
      surfaceContainerHigh: _darkSurfaceHigh,
      surfaceContainerHighest: _darkSurfaceHigh,
      outline: _darkBorder,
      outlineVariant: _darkBorder.withValues(alpha: 0.5),
      error: _darkError,
    );
  }

  @override
  TextTheme buildTextTheme(TextTheme base, ColorScheme scheme) {
    // 标题使用 Silkscreen 像素字体，正文保留 Roboto 确保可读性
    final pixelDisplay = GoogleFonts.silkscreen(
      fontWeight: FontWeight.bold,
      color: scheme.onSurface,
    );
    final pixelHeadline = GoogleFonts.silkscreen(color: scheme.onSurface);

    return base.copyWith(
      displayLarge: pixelDisplay.copyWith(fontSize: 28),
      displayMedium: pixelDisplay.copyWith(fontSize: 24),
      displaySmall: pixelDisplay.copyWith(fontSize: 20),
      headlineLarge: pixelHeadline.copyWith(fontSize: 18),
      headlineMedium: pixelHeadline.copyWith(fontSize: 16),
      headlineSmall: pixelHeadline.copyWith(fontSize: 14),
      // titleLarge 以下保留 Roboto — 确保正文可读性
      titleLarge: base.titleLarge?.copyWith(letterSpacing: -0.25),
    );
  }

  @override
  AppBarTheme appBarTheme(ColorScheme scheme, PixelThemeExtension ext) {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      titleTextStyle: GoogleFonts.silkscreen(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
    );
  }

  @override
  CardThemeData cardTheme(ColorScheme scheme, PixelThemeExtension ext) {
    return CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: _pixelShape(scheme.outline),
    );
  }

  @override
  DialogThemeData dialogTheme(ColorScheme scheme, PixelThemeExtension ext) {
    return DialogThemeData(
      elevation: 0,
      backgroundColor: scheme.surfaceContainerLow,
      shape: _pixelShape(scheme.outline),
    );
  }

  @override
  BottomSheetThemeData bottomSheetTheme(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(), // 方角
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
    );
  }

  @override
  InputDecorationTheme inputDecoration(ColorScheme scheme) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: scheme.outline, width: _borderWidth),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: scheme.outline, width: _borderWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: scheme.primary, width: _borderWidth),
      ),
      filled: false,
    );
  }

  @override
  NavigationBarThemeData navigationBarTheme(ColorScheme scheme) {
    return NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer.withValues(alpha: 0.5),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  @override
  NavigationRailThemeData navigationRailTheme(ColorScheme scheme) {
    return NavigationRailThemeData(
      indicatorColor: scheme.primaryContainer.withValues(alpha: 0.5),
      selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      labelType: NavigationRailLabelType.all,
      backgroundColor: scheme.surface,
    );
  }

  @override
  FloatingActionButtonThemeData fabTheme(ColorScheme scheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      shape: _pixelShape(scheme.outline),
      elevation: 0,
    );
  }

  @override
  FilledButtonThemeData filledButtonTheme(ColorScheme scheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: _pixelShape(scheme.outline),
        elevation: 0,
      ),
    );
  }

  @override
  OutlinedButtonThemeData outlinedButtonTheme(ColorScheme scheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: _pixelShape(scheme.outline),
        side: BorderSide(color: scheme.outline, width: _borderWidth),
      ),
    );
  }

  @override
  TextButtonThemeData textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: const RoundedRectangleBorder(), // 方角
      ),
    );
  }

  @override
  IconButtonThemeData iconButtonTheme() {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: const RoundedRectangleBorder(), // 方角
      ),
    );
  }

  @override
  ChipThemeData chipTheme(ColorScheme scheme) {
    return ChipThemeData(
      shape: _pixelShape(scheme.outline),
      side: BorderSide.none, // PixelBorderShape 已绘制边框
    );
  }

  @override
  SnackBarThemeData snackBarTheme(ColorScheme scheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: _pixelShape(scheme.outline),
    );
  }

  @override
  ListTileThemeData listTileTheme(ColorScheme scheme) {
    return const ListTileThemeData(
      shape: RoundedRectangleBorder(), // 方角
      contentPadding: AppSpacing.paddingHBase,
    );
  }

  @override
  SwitchThemeData switchTheme(ColorScheme scheme) {
    // 保留 M3 Switch 外观 — 自定义 PixelSwitch 组件处理复古样式
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? scheme.onPrimary : null,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? scheme.primary : null,
      ),
    );
  }

  @override
  PopupMenuThemeData popupMenuTheme(ColorScheme scheme) {
    return PopupMenuThemeData(
      shape: _pixelShape(scheme.outline),
      elevation: 0,
      color: scheme.surfaceContainerLow,
    );
  }

  @override
  TooltipThemeData tooltipTheme(ColorScheme scheme, TextTheme textTheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        border: Border.all(color: scheme.outline, width: _borderWidth),
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
    );
  }
}
