import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/observability/correlation_id_factory.dart';
import 'package:hachimi_app/core/observability/error_context.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';
import 'package:hachimi_app/core/observability/uid_hasher.dart';

void main() {
  test('correlation id has expected prefix', () {
    final id = CorrelationIdFactory.newId();
    expect(id, startsWith('corr_'));
    expect(id.length, greaterThan(10));
  });

  test('uid hash is deterministic', () {
    final hashA = UidHasher.hash('user_1');
    final hashB = UidHasher.hash('user_1');
    final hashC = UidHasher.hash('user_2');

    expect(hashA, equals(hashB));
    expect(hashA, isNot(equals(hashC)));
    expect(hashA.length, equals(64));
  });

  test('operation context serializes and deserializes', () {
    const context = OperationContext(
      correlationId: 'corr_abc',
      uidHash: 'hash_abc',
      operationStage: 'account_deletion',
      retryCount: 3,
    );

    final json = context.toJson();
    final restored = OperationContext.fromJson(Map<String, dynamic>.from(json));

    expect(restored.correlationId, equals('corr_abc'));
    expect(restored.uidHash, equals('hash_abc'));
    expect(restored.operationStage, equals('account_deletion'));
    expect(restored.retryCount, equals(3));
  });

  test('error context tags contain mandatory keys', () {
    final context = ErrorContext.capture(
      feature: 'SyncEngine',
      operation: 'pushPending',
      operationStage: 'sync',
      correlationId: 'corr_x',
      uidHash: 'hash_x',
      networkState: 'wifi',
      retryCount: 1,
      errorCode: 'sync_failed',
      extras: {'provider': 'firestore'},
    );

    final tags = context.toTags();
    expect(tags['feature'], equals('SyncEngine'));
    expect(tags['operation'], equals('pushPending'));
    expect(tags['correlation_id'], equals('corr_x'));
    expect(tags['uid_hash'], equals('hash_x'));
    expect(tags['provider'], equals('firestore'));
  });
}
