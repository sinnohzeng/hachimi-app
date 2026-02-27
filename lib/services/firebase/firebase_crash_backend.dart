import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hachimi_app/core/backend/crash_backend.dart';

/// Firebase Crashlytics 后端实现。
class FirebaseCrashBackend implements CrashBackend {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  String get id => 'firebase';

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> setCustomKey(String key, String value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  @override
  void log(String message) {
    _crashlytics.log(message);
  }
}
