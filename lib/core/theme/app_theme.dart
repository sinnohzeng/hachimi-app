import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
