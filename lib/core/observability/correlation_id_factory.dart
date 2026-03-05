import 'package:uuid/uuid.dart';

/// Generates stable-format correlation ids for cross-system tracing.
class CorrelationIdFactory {
  CorrelationIdFactory._();

  static const _uuid = Uuid();

  static String newId() => 'corr_${_uuid.v4()}';
}
