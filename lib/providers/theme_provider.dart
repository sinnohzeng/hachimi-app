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
  final AppUiStyle uiStyle;

  const ThemeSettings({
    this.mode = ThemeMode.system,
    this.seedColor = const Color(0xFF4285F4),
    this.useDynamicColor = true,
    this.enableBackgroundAnimation = true,
    this.uiStyle = AppUiStyle.retroPixel,
  });

  /// Retro Pixel 模式下强制禁用动态色 — 复古色板即品牌标识。
  bool get effectiveDynamicColor =>
      uiStyle == AppUiStyle.retroPixel ? false : useDynamicColor;

  ThemeSettings copyWith({
    ThemeMode? mode,
    Color? seedColor,
    bool? useDynamicColor,
    bool? enableBackgroundAnimation,
    AppUiStyle? uiStyle,
  }) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      enableBackgroundAnimation:
          enableBackgroundAnimation ?? this.enableBackgroundAnimation,
      uiStyle: uiStyle ?? this.uiStyle,
    );
  }
}

/// Theme notifier — manages theme mode + seed color with SharedPreferences persistence.
class ThemeNotifier extends Notifier<ThemeSettings> {
  static const _keyThemeMode = 'theme_mode';
  static const _keySeedColor = 'theme_seed_color';
  static const _keyDynamicColor = 'theme_dynamic_color';
  static const _keyBgAnimation = 'theme_bg_animation';
  static const _keyUiStyle = 'theme_ui_style';

  @override
  ThemeSettings build() {
    ref.keepAlive();
    final prefs = ref.read(sharedPreferencesProvider);
    final modeIndex = prefs.getInt(_keyThemeMode);
    final colorValue = prefs.getInt(_keySeedColor);
    final dynamicColor = prefs.getBool(_keyDynamicColor);
    final bgAnimation = prefs.getBool(_keyBgAnimation);
    final styleIndex = prefs.getInt(_keyUiStyle);

    return ThemeSettings(
      mode: modeIndex != null && modeIndex < ThemeMode.values.length
          ? ThemeMode.values[modeIndex]
          : ThemeMode.system,
      seedColor: colorValue != null
          ? Color(colorValue)
          : AppTheme.defaultSeedColor,
      useDynamicColor: dynamicColor ?? true,
      enableBackgroundAnimation: bgAnimation ?? true,
      uiStyle: styleIndex != null && styleIndex < AppUiStyle.values.length
          ? AppUiStyle.values[styleIndex]
          : AppUiStyle.retroPixel,
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

  /// 切换 UI 风格 — Material 3 / Retro Pixel。
  void setUiStyle(AppUiStyle style) {
    state = state.copyWith(uiStyle: style);
    _persist();
  }

  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt(_keyThemeMode, state.mode.index);
    prefs.setInt(_keySeedColor, state.seedColor.toARGB32());
    prefs.setBool(_keyDynamicColor, state.useDynamicColor);
    prefs.setBool(_keyBgAnimation, state.enableBackgroundAnimation);
    prefs.setInt(_keyUiStyle, state.uiStyle.index);
  }
}

/// Theme settings provider — SSOT for app theme mode + seed color + UI style.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeSettings>(
  ThemeNotifier.new,
);
