import 'package:flutter/material.dart';

import '../pixel_theme_extension.dart';

/// 主题皮肤策略接口 — 定义 Material 组件主题的构建契约。
///
/// [MaterialSkin] 和 [RetroPixelSkin] 分别实现此接口，
/// [AppTheme._buildTheme] 通过策略委托来构建 ThemeData，
/// 无需任何条件分支。
///
/// 添加第三种皮肤只需创建新的实现类，遵循开闭原则。
abstract class ThemeSkin {
  /// 是否为复古像素模式 — 供 PixelThemeExtension.isRetro 使用
  bool get isRetro;

  /// 构建配色方案 — 可在 M3 基础上覆盖语义色槽
  ColorScheme buildColorScheme(Color seedColor, Brightness brightness);

  /// 构建文字排版 — 可替换字体族
  TextTheme buildTextTheme(TextTheme base, ColorScheme scheme);

  /// 以下每个方法对应一个 Material 组件主题
  AppBarTheme appBarTheme(ColorScheme scheme, PixelThemeExtension ext);
  CardThemeData cardTheme(ColorScheme scheme, PixelThemeExtension ext);
  DialogThemeData dialogTheme(ColorScheme scheme, PixelThemeExtension ext);
  BottomSheetThemeData bottomSheetTheme(ColorScheme scheme);
  InputDecorationTheme inputDecoration(ColorScheme scheme);
  NavigationBarThemeData navigationBarTheme(ColorScheme scheme);
  NavigationRailThemeData navigationRailTheme(ColorScheme scheme);
  FloatingActionButtonThemeData fabTheme(ColorScheme scheme);
  FilledButtonThemeData filledButtonTheme(ColorScheme scheme);
  OutlinedButtonThemeData outlinedButtonTheme(ColorScheme scheme);
  TextButtonThemeData textButtonTheme();
  IconButtonThemeData iconButtonTheme();
  ChipThemeData chipTheme(ColorScheme scheme);
  SnackBarThemeData snackBarTheme(ColorScheme scheme);
  ListTileThemeData listTileTheme(ColorScheme scheme);
  SwitchThemeData switchTheme(ColorScheme scheme);
  PopupMenuThemeData popupMenuTheme(ColorScheme scheme);
  TooltipThemeData tooltipTheme(ColorScheme scheme, TextTheme textTheme);
}
