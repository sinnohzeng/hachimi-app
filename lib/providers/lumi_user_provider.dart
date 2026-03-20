import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/providers/service_providers.dart';

/// LUMI 用户名 — 响应式 Notifier，引导页写入后 TodayScreen 立即更新。
class LumiUserNameNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(AppPrefsKeys.lumiUserName) ?? '';
  }

  void update(String name) {
    state = name;
  }
}

final lumiUserNameProvider = NotifierProvider<LumiUserNameNotifier, String>(
  LumiUserNameNotifier.new,
);
