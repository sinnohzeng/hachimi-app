import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/service_providers.dart';

/// Locale notifier — manages app locale with SharedPreferences persistence.
/// State is `null` when following system locale.
class LocaleNotifier extends Notifier<Locale?> {
  static const _keyLocale = 'app_locale';

  @override
  Locale? build() {
    ref.keepAlive();
    final prefs = ref.read(sharedPreferencesProvider);
    final code = prefs.getString(_keyLocale);
    if (code != null) {
      return _parseLocale(code);
    }
    return null;
  }

  /// Set locale. Pass null to follow system.
  void setLocale(Locale? locale) {
    state = locale;
    _persist();
  }

  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state == null) {
      prefs.remove(_keyLocale);
    } else {
      // 存储格式：languageCode 或 languageCode_scriptCode（如 zh_Hant）
      final code = state!.scriptCode != null
          ? '${state!.languageCode}_${state!.scriptCode}'
          : state!.languageCode;
      prefs.setString(_keyLocale, code);
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
