import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hachimi_app/core/backend/analytics_backend.dart';

/// Firebase Analytics 后端实现。
class FirebaseAnalyticsBackend implements AnalyticsBackend {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  String get id => 'firebase';

  /// 提供 NavigatorObserver 用于路由追踪。
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    // Firebase Analytics 要求非空值 — 过滤掉 null entries。
    Map<String, Object>? filtered;
    if (parameters != null) {
      filtered = Map.fromEntries(
        parameters.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
    }
    await _analytics.logEvent(name: name, parameters: filtered);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logLogin({String? method}) async {
    await _analytics.logLogin(loginMethod: method);
  }

  @override
  Future<void> logSignUp({String? method}) async {
    await _analytics.logSignUp(signUpMethod: method ?? 'email');
  }
}
