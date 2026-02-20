// ---
// 📘 文件说明：
// 主题设置 Provider — 管理深色/浅色模式和种子色切换。
// 使用 SharedPreferences 持久化用户偏好。
//
// 📋 程序整体伪代码（中文）：
// 1. 从 SharedPreferences 加载已保存的主题设置；
// 2. 暴露 ThemeSettings（ThemeMode + seedColor）供 MaterialApp 使用；
// 3. 提供 toggleMode / setSeedColor 方法修改并持久化偏好；
//
// 🧩 文件结构：
// - ThemeSettings：主题设置值对象；
// - ThemeNotifier：Notifier，管理主题状态 + 持久化；
// - themeProvider：全局 Provider 定义；
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';

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
    _load();
    return const ThemeSettings();
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

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, state.mode.index);
    await prefs.setInt(_keySeedColor, state.seedColor.toARGB32());
    await prefs.setBool(_keyDynamicColor, state.useDynamicColor);
    await prefs.setBool(_keyBgAnimation, state.enableBackgroundAnimation);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_keyThemeMode);
    final colorValue = prefs.getInt(_keySeedColor);
    final dynamicColor = prefs.getBool(_keyDynamicColor);
    final bgAnimation = prefs.getBool(_keyBgAnimation);

    state = ThemeSettings(
      mode: modeIndex != null ? ThemeMode.values[modeIndex] : ThemeMode.system,
      seedColor: colorValue != null
          ? Color(colorValue)
          : AppTheme.defaultSeedColor,
      useDynamicColor: dynamicColor ?? true,
      enableBackgroundAnimation: bgAnimation ?? true,
    );
  }
}

/// Theme settings provider — SSOT for app theme mode + seed color.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeSettings>(
  ThemeNotifier.new,
);
