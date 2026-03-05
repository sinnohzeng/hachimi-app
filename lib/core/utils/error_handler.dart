import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/constants/analytics_events.dart';
import 'package:hachimi_app/core/observability/error_context.dart';
import 'package:hachimi_app/core/observability/network_state_resolver.dart';
import 'package:hachimi_app/core/observability/observability_tags.dart';

/// ErrorHandler — centralized error reporting bridge.
///
/// Sends errors to:
/// 1. `debugPrint` (always, for local dev)
/// 2. `FirebaseCrashlytics.recordError` (release builds only)
/// 3. GA4 `app_error` event (for analytics dashboards)
class ErrorHandler {
  ErrorHandler._();

  /// Record a caught error with structured metadata.
  static Future<void> record(
    Object error, {
    StackTrace? stackTrace,
    required ErrorContext context,
    bool fatal = false,
  }) async {
    final trace = stackTrace ?? StackTrace.current;
    final effectiveContext = await _enrichContext(context);
    debugPrint(
      '[${effectiveContext.feature}] ${effectiveContext.operation} failed: $error',
    );

    try {
      final crashlytics = FirebaseCrashlytics.instance;
      final tags = _sanitizeTags(effectiveContext.toTags());
      for (final entry in tags.entries) {
        await crashlytics.setCustomKey(entry.key, entry.value);
      }
      await crashlytics.recordError(
        error,
        trace,
        reason: '${effectiveContext.feature}.${effectiveContext.operation}',
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
          AnalyticsEvents.paramErrorSource: effectiveContext.feature,
          AnalyticsEvents.paramErrorOperation: effectiveContext.operation,
          'correlation_id': effectiveContext.correlationId,
          'operation_stage': effectiveContext.operationStage,
          'error_code': effectiveContext.errorCode,
        },
      );
    } catch (_) {}
  }

  static Future<void> recordOperation(
    Object error, {
    StackTrace? stackTrace,
    required String feature,
    required String operation,
    String operationStage = 'runtime',
    int retryCount = 0,
    String errorCode = 'unknown_error',
    String? correlationId,
    bool fatal = false,
    Map<String, String> extras = const {},
  }) async {
    return record(
      error,
      stackTrace: stackTrace,
      context: ErrorContext.capture(
        feature: feature,
        operation: operation,
        operationStage: operationStage,
        retryCount: retryCount,
        errorCode: errorCode,
        correlationId: correlationId,
        extras: extras,
      ),
      fatal: fatal,
    );
  }

  /// Append a breadcrumb log to Crashlytics for debugging context.
  static void breadcrumb(String message) {
    try {
      FirebaseCrashlytics.instance.log(message);
    } catch (_) {}
  }

  static Future<ErrorContext> _enrichContext(ErrorContext context) async {
    if (context.networkState != 'unknown') return context;
    final networkState = await NetworkStateResolver.resolve();
    return context.copyWith(networkState: networkState);
  }

  static Map<String, String> _sanitizeTags(Map<String, String> tags) {
    final sanitized = <String, String>{};
    for (final entry in tags.entries) {
      final key = entry.key;
      if (ObservabilityTags.isPiiKey(key)) continue;
      if (!ObservabilityTags.isAllowedKey(key)) continue;
      sanitized[key] = entry.value;
    }
    return sanitized;
  }
}
