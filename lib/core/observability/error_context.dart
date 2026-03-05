import 'package:hachimi_app/core/observability/correlation_id_factory.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';

class ErrorContext {
  final String feature;
  final String operation;
  final String operationStage;
  final String correlationId;
  final String uidHash;
  final String appVersion;
  final String buildNumber;
  final String networkState;
  final int retryCount;
  final String errorCode;
  final Map<String, String> extras;

  const ErrorContext({
    required this.feature,
    required this.operation,
    required this.operationStage,
    required this.correlationId,
    required this.uidHash,
    required this.appVersion,
    required this.buildNumber,
    required this.networkState,
    required this.retryCount,
    required this.errorCode,
    this.extras = const {},
  });

  factory ErrorContext.capture({
    required String feature,
    required String operation,
    String operationStage = 'runtime',
    String? correlationId,
    String? uidHash,
    String networkState = 'unknown',
    int retryCount = 0,
    String errorCode = 'unknown_error',
    Map<String, String> extras = const {},
  }) {
    return ErrorContext(
      feature: feature,
      operation: operation,
      operationStage: operationStage,
      correlationId: correlationId ?? CorrelationIdFactory.newId(),
      uidHash: uidHash ?? ObservabilityRuntime.uidHash,
      appVersion: ObservabilityRuntime.appVersion,
      buildNumber: ObservabilityRuntime.buildNumber,
      networkState: networkState,
      retryCount: retryCount,
      errorCode: errorCode,
      extras: extras,
    );
  }

  ErrorContext copyWith({
    String? feature,
    String? operation,
    String? operationStage,
    String? correlationId,
    String? uidHash,
    String? appVersion,
    String? buildNumber,
    String? networkState,
    int? retryCount,
    String? errorCode,
    Map<String, String>? extras,
  }) {
    return ErrorContext(
      feature: feature ?? this.feature,
      operation: operation ?? this.operation,
      operationStage: operationStage ?? this.operationStage,
      correlationId: correlationId ?? this.correlationId,
      uidHash: uidHash ?? this.uidHash,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      networkState: networkState ?? this.networkState,
      retryCount: retryCount ?? this.retryCount,
      errorCode: errorCode ?? this.errorCode,
      extras: extras ?? this.extras,
    );
  }

  Map<String, String> toTags() {
    return {
      'feature': feature,
      'operation': operation,
      'operation_stage': operationStage,
      'correlation_id': correlationId,
      'uid_hash': uidHash,
      'app_version': appVersion,
      'build_number': buildNumber,
      'network_state': networkState,
      'retry_count': '$retryCount',
      'error_code': errorCode,
      ...extras,
    };
  }
}
