import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pixel_theme_extension.dart';
import 'skins/material_skin.dart';
import 'skins/retro_pixel_skin.dart';
import 'skins/theme_skin.dart';

/// UI 风格枚举 — 用户可在设置中切换。
enum AppUiStyle { material, retroPixel }

/// App Theme — Single Source of Truth for all UI styling.
///
/// 通过 [ThemeSkin] 策略模式构建 ThemeData：
/// - [MaterialSkin]: Material Design 3 默认样式
/// - [RetroPixelSkin]: 复古像素风（星露谷物语风格）
///
/// 所有屏幕和组件必须通过 Theme.of(context) 访问颜色和文字样式。
class AppTheme {
  AppTheme._();

  static const Color defaultSeedColor = Color(0xFF4285F4); // Google Blue

  /// 预设色板 — 8 种 Material Design 3 推荐种子色。
  static const List<Color> presetColors = [
    Color(0xFF4285F4), // Google Blue (default)
    Color(0xFF009688), // Teal
    Color(0xFF7C4DFF), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFFFF9800), // Orange
    Color(0xFF4CAF50), // Green
    Color(0xFFF44336), // Red
    Color(0xFF3F51B5), // Indigo
  ];

  static ThemeSkin _skinFor(AppUiStyle style) {
    return switch (style) {
      AppUiStyle.material => const MaterialSkin(),
      AppUiStyle.retroPixel => const RetroPixelSkin(),
    };
  }

  static ThemeData lightTheme([
    Color? seed,
    AppUiStyle style = AppUiStyle.material,
  ]) {
    final seedColor = seed ?? defaultSeedColor;
    final skin = _skinFor(style);
    final baseText = GoogleFonts.robotoTextTheme();
    return _buildTheme(seedColor, Brightness.light, baseText, skin);
  }

  /// 从系统动态色方案构建主题（Material You 壁纸取色）。
  static ThemeData lightThemeFromScheme(
    ColorScheme scheme, [
    AppUiStyle style = AppUiStyle.material,
  ]) {
    final skin = _skinFor(style);
    final baseText = GoogleFonts.robotoTextTheme(
      scheme.brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );
    // 动态色方案：skin 可在 buildColorScheme 中覆盖语义槽
    return _buildThemeFromScheme(scheme, baseText, skin);
  }

  static ThemeData darkTheme([
    Color? seed,
    AppUiStyle style = AppUiStyle.material,
  ]) {
    final seedColor = seed ?? defaultSeedColor;
    final skin = _skinFor(style);
    final baseText = GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme);
    return _buildTheme(seedColor, Brightness.dark, baseText, skin);
  }

  /// 从种子色构建 — 皮肤负责 ColorScheme 定制。
  static ThemeData _buildTheme(
    Color seedColor,
    Brightness brightness,
    TextTheme baseText,
    ThemeSkin skin,
  ) {
    final colorScheme = skin.buildColorScheme(seedColor, brightness);
    return _assemble(colorScheme, baseText, skin);
  }

  /// 从动态色方案构建 — 用于 Material You。
  static ThemeData _buildThemeFromScheme(
    ColorScheme scheme,
    TextTheme baseText,
    ThemeSkin skin,
  ) {
    // Retro 模式忽略动态色方案，从种子色重建复古色板
    final colorScheme = skin.isRetro
        ? skin.buildColorScheme(scheme.primary, scheme.brightness)
        : scheme;
    return _assemble(colorScheme, baseText, skin);
  }

  /// 页面过渡 — 平台行为，与皮肤无关，全局统一。
  static const _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  /// 组装最终 ThemeData — 全部委托给皮肤，零分支。
  static ThemeData _assemble(
    ColorScheme colorScheme,
    TextTheme baseText,
    ThemeSkin skin,
  ) {
    final pixelExt = colorScheme.brightness == Brightness.dark
        ? PixelThemeExtension.dark(colorScheme).copyWith(isRetro: skin.isRetro)
        : PixelThemeExtension.light(
            colorScheme,
          ).copyWith(isRetro: skin.isRetro);

    final textTheme = skin.buildTextTheme(baseText, colorScheme);

    return ThemeData(
      useMaterial3: true,
      extensions: [pixelExt],
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      pageTransitionsTheme: _pageTransitions,
      appBarTheme: skin
          .appBarTheme(colorScheme, pixelExt)
          .copyWith(systemOverlayStyle: _systemOverlay(colorScheme)),
      cardTheme: skin.cardTheme(colorScheme, pixelExt),
      dialogTheme: skin.dialogTheme(colorScheme, pixelExt),
      bottomSheetTheme: skin.bottomSheetTheme(colorScheme),
      inputDecorationTheme: skin.inputDecoration(colorScheme),
      navigationBarTheme: skin.navigationBarTheme(colorScheme),
      navigationRailTheme: skin.navigationRailTheme(colorScheme),
      floatingActionButtonTheme: skin.fabTheme(colorScheme),
      filledButtonTheme: skin.filledButtonTheme(colorScheme),
      outlinedButtonTheme: skin.outlinedButtonTheme(colorScheme),
      textButtonTheme: skin.textButtonTheme(),
      iconButtonTheme: skin.iconButtonTheme(),
      chipTheme: skin.chipTheme(colorScheme),
      snackBarTheme: skin.snackBarTheme(colorScheme),
      listTileTheme: skin.listTileTheme(colorScheme),
      switchTheme: skin.switchTheme(colorScheme),
      popupMenuTheme: skin.popupMenuTheme(colorScheme),
      tooltipTheme: skin.tooltipTheme(colorScheme, textTheme),
    );
  }

  /// 系统状态栏 / 导航栏样式 — 两种皮肤共用。
  static SystemUiOverlayStyle _systemOverlay(ColorScheme scheme) {
    final isLight = scheme.brightness == Brightness.light;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: scheme.brightness,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: isLight
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }
}
