import 'package:hachimi_app/core/observability/correlation_id_factory.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';

class OperationContext {
  final String correlationId;
  final String uidHash;
  final String operationStage;
  final int retryCount;

  const OperationContext({
    required this.correlationId,
    required this.uidHash,
    required this.operationStage,
    required this.retryCount,
  });

  factory OperationContext.capture({
    String operationStage = 'runtime',
    int retryCount = 0,
    String? correlationId,
    String? uidHash,
  }) {
    return OperationContext(
      correlationId: correlationId ?? CorrelationIdFactory.newId(),
      uidHash: uidHash ?? ObservabilityRuntime.uidHash,
      operationStage: operationStage,
      retryCount: retryCount,
    );
  }

  Map<String, Object> toJson() {
    return {
      'correlation_id': correlationId,
      'uid_hash': uidHash,
      'operation_stage': operationStage,
      'retry_count': retryCount,
    };
  }

  factory OperationContext.fromJson(Map<String, dynamic> json) {
    return OperationContext(
      correlationId:
          (json['correlation_id'] as String?) ?? CorrelationIdFactory.newId(),
      uidHash: (json['uid_hash'] as String?) ?? 'anonymous',
      operationStage: (json['operation_stage'] as String?) ?? 'runtime',
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
    );
  }
}
