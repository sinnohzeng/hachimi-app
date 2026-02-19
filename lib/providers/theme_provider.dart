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
// - ThemeNotifier：StateNotifier，管理主题状态 + 持久化；
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

  const ThemeSettings({
    this.mode = ThemeMode.system,
    this.seedColor = const Color(0xFF4285F4),
  });

  ThemeSettings copyWith({ThemeMode? mode, Color? seedColor}) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

/// Theme notifier — manages theme mode + seed color with SharedPreferences persistence.
class ThemeNotifier extends StateNotifier<ThemeSettings> {
  static const _keyThemeMode = 'theme_mode';
  static const _keySeedColor = 'theme_seed_color';

  ThemeNotifier() : super(const ThemeSettings()) {
    _load();
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

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, state.mode.index);
    await prefs.setInt(_keySeedColor, state.seedColor.toARGB32());
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_keyThemeMode);
    final colorValue = prefs.getInt(_keySeedColor);

    state = ThemeSettings(
      mode: modeIndex != null ? ThemeMode.values[modeIndex] : ThemeMode.system,
      seedColor: colorValue != null
          ? Color(colorValue)
          : AppTheme.defaultSeedColor,
    );
  }
}

/// Theme settings provider — SSOT for app theme mode + seed color.
final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeSettings>((ref) {
  return ThemeNotifier();
});
