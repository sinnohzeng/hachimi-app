import 'package:flutter/material.dart';

import '../app_breakpoints.dart';
import '../app_elevation.dart';
import '../app_shape.dart';
import '../app_spacing.dart';
import '../pixel_theme_extension.dart';
import 'theme_skin.dart';

/// Material Design 3 默认皮肤 — 从原 AppTheme._buildTheme() 提取，零行为变更。
class MaterialSkin implements ThemeSkin {
  const MaterialSkin();

  @override
  bool get isRetro => false;

  @override
  ColorScheme buildColorScheme(Color seedColor, Brightness brightness) {
    return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  }

  @override
  TextTheme buildTextTheme(TextTheme base, ColorScheme scheme) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(letterSpacing: -0.25),
      displayMedium: base.displayMedium?.copyWith(letterSpacing: -0.25),
      headlineLarge: base.headlineLarge?.copyWith(letterSpacing: -0.25),
    );
  }

  @override
  AppBarTheme appBarTheme(ColorScheme scheme, PixelThemeExtension ext) {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: AppElevation.level0,
    );
  }

  @override
  CardThemeData cardTheme(ColorScheme scheme, PixelThemeExtension ext) {
    final isDark = scheme.brightness == Brightness.dark;
    return CardThemeData(
      elevation: isDark ? AppElevation.level0 : AppElevation.level1,
      color: isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: AppShape.borderMedium,
        side: isDark
            ? BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3))
            : BorderSide.none,
      ),
    );
  }

  @override
  DialogThemeData dialogTheme(ColorScheme scheme, PixelThemeExtension ext) {
    return DialogThemeData(
      elevation: AppElevation.level5,
      shape: AppShape.shapeExtraLarge,
    );
  }

  @override
  BottomSheetThemeData bottomSheetTheme(ColorScheme scheme) {
    return const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppShape.extraLarge),
        ),
      ),
      showDragHandle: true,
      constraints: BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
    );
  }

  @override
  InputDecorationTheme inputDecoration(ColorScheme scheme) {
    return InputDecorationTheme(
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(
        alpha: scheme.brightness == Brightness.dark ? 0.6 : 0.3,
      ),
    );
  }

  @override
  NavigationBarThemeData navigationBarTheme(ColorScheme scheme) {
    return NavigationBarThemeData(
      indicatorColor: scheme.secondaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  @override
  NavigationRailThemeData navigationRailTheme(ColorScheme scheme) {
    return NavigationRailThemeData(
      indicatorColor: scheme.secondaryContainer,
      selectedIconTheme: IconThemeData(color: scheme.onSecondaryContainer),
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
    );
  }

  @override
  FilledButtonThemeData filledButtonTheme(ColorScheme scheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  @override
  OutlinedButtonThemeData outlinedButtonTheme(ColorScheme scheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: scheme.outline),
      ),
    );
  }

  @override
  TextButtonThemeData textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  IconButtonThemeData iconButtonTheme() {
    return IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    );
  }

  @override
  ChipThemeData chipTheme(ColorScheme scheme) {
    return ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppShape.borderSmall),
    );
  }

  @override
  SnackBarThemeData snackBarTheme(ColorScheme scheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppShape.borderSmall),
    );
  }

  @override
  ListTileThemeData listTileTheme(ColorScheme scheme) {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppShape.borderMedium),
      contentPadding: AppSpacing.paddingHBase,
    );
  }

  @override
  SwitchThemeData switchTheme(ColorScheme scheme) {
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
      shape: RoundedRectangleBorder(borderRadius: AppShape.borderSmall),
      elevation: AppElevation.level2,
    );
  }

  @override
  TooltipThemeData tooltipTheme(ColorScheme scheme, TextTheme textTheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: AppShape.borderExtraSmall,
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
    );
  }
}
