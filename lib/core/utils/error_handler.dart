import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/backend/analytics_backend.dart';
import 'package:hachimi_app/core/backend/crash_backend.dart';
import 'package:hachimi_app/core/constants/analytics_events.dart';
import 'package:hachimi_app/core/observability/error_context.dart';
import 'package:hachimi_app/core/observability/network_state_resolver.dart';
import 'package:hachimi_app/core/observability/observability_tags.dart';

/// ErrorHandler — centralized error reporting bridge.
///
/// Sends errors to:
/// 1. `debugPrint` (always, for local dev)
/// 2. [CrashBackend.recordError] (release builds only)
/// 3. [AnalyticsBackend.logEvent] `app_error` event (for analytics dashboards)
///
/// Call [init] once at startup to inject backend implementations.
class ErrorHandler {
  ErrorHandler._();

  static CrashBackend? _crash;
  static AnalyticsBackend? _analytics;
  static bool _initialized = false;

  /// 注入后端实现。在 main() 初始化 Firebase 后调用一次。
  static void init(CrashBackend crash, AnalyticsBackend analytics) {
    _crash = crash;
    _analytics = analytics;
    _initialized = true;
  }

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

    if (!_initialized) return;

    try {
      final crash = _crash!;
      final tags = _sanitizeTags(effectiveContext.toTags());
      for (final entry in tags.entries) {
        await crash.setCustomKey(entry.key, entry.value);
      }
      await crash.recordError(
        error,
        trace,
        reason: '${effectiveContext.feature}.${effectiveContext.operation}',
        fatal: fatal,
      );
    } catch (e) {
      // Crash backend itself failed — swallow to avoid cascading errors.
      debugPrint('[ErrorHandler] secondary error (Crash): $e');
    }

    // Log to analytics for dashboards
    try {
      await _analytics!.logEvent(
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
    } catch (e) {
      debugPrint('[ErrorHandler] secondary error (Analytics): $e');
    }
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

  /// Append a breadcrumb log for debugging context.
  static void breadcrumb(String message) {
    if (!_initialized) return;
    try {
      _crash!.log(message);
    } catch (e) {
      debugPrint('[ErrorHandler] secondary error (breadcrumb): $e');
    }
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
