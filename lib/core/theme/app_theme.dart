import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_breakpoints.dart';
import 'app_elevation.dart';
import 'app_shape.dart';
import 'app_spacing.dart';

/// App Theme — Single Source of Truth for all UI styling.
/// All screens and widgets MUST use Theme.of(context) to access colors and text styles.
/// No hardcoded colors, fonts, or spacing values anywhere else.
class AppTheme {
  AppTheme._();

  static const Color defaultSeedColor = Color(0xFF4285F4); // Google Blue

  /// Preset color palette — 8 Material Design 3 recommended seed colors.
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

  static ThemeData lightTheme([Color? seed]) {
    final seedColor = seed ?? defaultSeedColor;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    final textTheme = GoogleFonts.robotoTextTheme();

    return _buildTheme(colorScheme, textTheme);
  }

  /// Build theme from a pre-built ColorScheme (used for dynamic color).
  static ThemeData lightThemeFromScheme(ColorScheme scheme) {
    final textTheme = GoogleFonts.robotoTextTheme(
      scheme.brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );
    return _buildTheme(scheme, textTheme);
  }

  static ThemeData darkTheme([Color? seed]) {
    final seedColor = seed ?? defaultSeedColor;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    final textTheme = GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme);

    return _buildTheme(colorScheme, textTheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, TextTheme textTheme) {
    // M3 Typography 微调 — Display/Headline 级别收紧字间距。
    final refinedTextTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(letterSpacing: -0.25),
      displayMedium: textTheme.displayMedium?.copyWith(letterSpacing: -0.25),
      headlineLarge: textTheme.headlineLarge?.copyWith(letterSpacing: -0.25),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: refinedTextTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppElevation.level0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: colorScheme.brightness,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: colorScheme.brightness == Brightness.dark
            ? AppElevation.level0
            : AppElevation.level1,
        color: colorScheme.brightness == Brightness.dark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppShape.borderMedium,
          side: colorScheme.brightness == Brightness.dark
              ? BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                )
              : BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      navigationRailTheme: NavigationRailThemeData(
        indicatorColor: colorScheme.secondaryContainer,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        labelType: NavigationRailLabelType.all,
        backgroundColor: colorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: colorScheme.brightness == Brightness.dark ? 0.6 : 0.3,
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: AppElevation.level5,
        shape: AppShape.shapeExtraLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderSmall),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppShape.extraLarge),
          ),
        ),
        showDragHandle: true,
        constraints: BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderSmall),
        elevation: AppElevation.level2,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: AppShape.borderExtraSmall,
        ),
        textStyle: refinedTextTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderSmall),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderMedium),
        contentPadding: AppSpacing.paddingHBase,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : null,
        ),
      ),
    );
  }
}
