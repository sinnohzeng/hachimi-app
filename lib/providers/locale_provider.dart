// ---
// 📘 文件说明：
// 语言设置 Provider — 管理应用语言区域设置。
// null 表示跟随系统，否则为用户手动选择的 Locale。
//
// 📋 程序整体伪代码（中文）：
// 1. 从 SharedPreferences 加载已保存的语言偏好；
// 2. 暴露 Locale? 供 MaterialApp.locale 使用；
// 3. 提供 setLocale 方法修改并持久化偏好；
//
// 🧩 文件结构：
// - LocaleNotifier：Notifier，管理 Locale 状态 + 持久化；
// - localeProvider：全局 Provider 定义；
// ---

import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale notifier — manages app locale with SharedPreferences persistence.
/// State is `null` when following system locale.
class LocaleNotifier extends Notifier<Locale?> {
  static const _keyLocale = 'app_locale';

  @override
  Locale? build() {
    ref.keepAlive();
    _load();
    return null;
  }

  /// Set locale. Pass null to follow system.
  void setLocale(Locale? locale) {
    state = locale;
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == null) {
      await prefs.remove(_keyLocale);
    } else {
      // 存储格式：languageCode 或 languageCode_scriptCode（如 zh_Hant）
      final code = state!.scriptCode != null
          ? '${state!.languageCode}_${state!.scriptCode}'
          : state!.languageCode;
      await prefs.setString(_keyLocale, code);
    }
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale);
    if (code != null) {
      state = _parseLocale(code);
    }
  }

  /// 解析存储的 locale 字符串，支持 "zh_Hant" 等带 script 的格式。
  static Locale _parseLocale(String code) {
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
    }
    return Locale(code);
  }
}

/// Locale provider — SSOT for app language setting.
/// null = follow system; Locale('en'), Locale('zh'), Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
/// Locale('ja'), Locale('ko') = user override.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
