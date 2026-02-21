import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/constants/analytics_events.dart';

/// ErrorHandler — centralized error reporting bridge.
///
/// Sends errors to:
/// 1. `debugPrint` (always, for local dev)
/// 2. `FirebaseCrashlytics.recordError` (release builds only)
/// 3. GA4 `app_error` event (for analytics dashboards)
class ErrorHandler {
  ErrorHandler._();

  /// Record a caught error with structured metadata.
  ///
  /// [source] — class or module name, e.g. `'CoinService'`
  /// [operation] — method name, e.g. `'checkIn'`
  /// [fatal] — set true only for unrecoverable errors
  static Future<void> record(
    Object error, {
    StackTrace? stackTrace,
    required String source,
    required String operation,
    bool fatal = false,
    Map<String, String>? extras,
  }) async {
    final trace = stackTrace ?? StackTrace.current;
    debugPrint('[$source] $operation failed: $error');

    try {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCustomKey('error_source', source);
      await crashlytics.setCustomKey('error_operation', operation);
      if (extras != null) {
        for (final entry in extras.entries) {
          await crashlytics.setCustomKey(entry.key, entry.value);
        }
      }
      await crashlytics.recordError(
        error,
        trace,
        reason: '$source.$operation',
        fatal: fatal,
      );
    } catch (_) {
      // Crashlytics itself failed — swallow to avoid cascading errors.
    }

    // Log to GA4 for analytics dashboards
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: AnalyticsEvents.appError,
        parameters: {
          AnalyticsEvents.paramErrorType: error.runtimeType.toString(),
          AnalyticsEvents.paramErrorSource: source,
          AnalyticsEvents.paramErrorOperation: operation,
        },
      );
    } catch (_) {}
  }

  /// Append a breadcrumb log to Crashlytics for debugging context.
  static void breadcrumb(String message) {
    try {
      FirebaseCrashlytics.instance.log(message);
    } catch (_) {}
  }
}
