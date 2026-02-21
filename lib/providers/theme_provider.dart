import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/providers/service_providers.dart';

/// Theme settings value object.
class ThemeSettings {
  final ThemeMode mode;
  final Color seedColor;
  final bool useDynamicColor;
  final bool enableBackgroundAnimation;

  const ThemeSettings({
    this.mode = ThemeMode.system,
    this.seedColor = const Color(0xFF4285F4),
    this.useDynamicColor = true,
    this.enableBackgroundAnimation = true,
  });

  ThemeSettings copyWith({
    ThemeMode? mode,
    Color? seedColor,
    bool? useDynamicColor,
    bool? enableBackgroundAnimation,
  }) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      enableBackgroundAnimation:
          enableBackgroundAnimation ?? this.enableBackgroundAnimation,
    );
  }
}

/// Theme notifier — manages theme mode + seed color with SharedPreferences persistence.
class ThemeNotifier extends Notifier<ThemeSettings> {
  static const _keyThemeMode = 'theme_mode';
  static const _keySeedColor = 'theme_seed_color';
  static const _keyDynamicColor = 'theme_dynamic_color';
  static const _keyBgAnimation = 'theme_bg_animation';

  @override
  ThemeSettings build() {
    ref.keepAlive();
    final prefs = ref.read(sharedPreferencesProvider);
    final modeIndex = prefs.getInt(_keyThemeMode);
    final colorValue = prefs.getInt(_keySeedColor);
    final dynamicColor = prefs.getBool(_keyDynamicColor);
    final bgAnimation = prefs.getBool(_keyBgAnimation);

    return ThemeSettings(
      mode: modeIndex != null ? ThemeMode.values[modeIndex] : ThemeMode.system,
      seedColor: colorValue != null
          ? Color(colorValue)
          : AppTheme.defaultSeedColor,
      useDynamicColor: dynamicColor ?? true,
      enableBackgroundAnimation: bgAnimation ?? true,
    );
  }

  /// Switch theme mode (system / light / dark).
  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
    _persist();
  }

  /// Set seed color from the preset palette.
  void setSeedColor(Color color) {
    state = state.copyWith(seedColor: color);
    _persist();
  }

  /// Toggle dynamic color (Material You wallpaper-based theming).
  void setDynamicColor(bool enabled) {
    state = state.copyWith(useDynamicColor: enabled);
    _persist();
  }

  /// Toggle animated backgrounds (mesh gradient + floating particles).
  void setBackgroundAnimation(bool enabled) {
    state = state.copyWith(enableBackgroundAnimation: enabled);
    _persist();
  }

  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt(_keyThemeMode, state.mode.index);
    prefs.setInt(_keySeedColor, state.seedColor.toARGB32());
    prefs.setBool(_keyDynamicColor, state.useDynamicColor);
    prefs.setBool(_keyBgAnimation, state.enableBackgroundAnimation);
  }
}

/// Theme settings provider — SSOT for app theme mode + seed color.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeSettings>(
  ThemeNotifier.new,
);
