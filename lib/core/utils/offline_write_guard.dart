import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// OfflineWriteGuard — protects critical Firestore writes from offline failures.
///
/// When a Firestore write fails (e.g. network timeout), the payload is saved to
/// SharedPreferences as a pending operation. On the next app launch, pending
/// operations are retried automatically.
///
/// This is a last-resort safety net — Firestore's built-in offline persistence
/// handles most cases. This guard covers edge cases like app crashes during writes.
class OfflineWriteGuard {
  OfflineWriteGuard._();

  static const String _pendingKey = 'offline_pending_writes';

  /// Execute a Firestore write with offline fallback.
  ///
  /// [operationName] — identifies the write type for retry routing.
  /// [payload] — serializable data needed to reconstruct the write.
  /// [writeFn] — the actual Firestore write function.
  ///
  /// If [writeFn] succeeds, returns normally.
  /// If it fails, stores payload for later retry and rethrows.
  static Future<void> guard({
    required String operationName,
    required Map<String, dynamic> payload,
    required Future<void> Function() writeFn,
  }) async {
    try {
      await writeFn();
    } catch (e, stack) {
      debugPrint(
        '[OfflineWriteGuard] $operationName failed, queuing for retry',
      );
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'OfflineWriteGuard',
        operation: operationName,
      );
      await _enqueue(operationName, payload);
      rethrow;
    }
  }

  /// Enqueue a pending write operation.
  static Future<void> _enqueue(
    String operationName,
    Map<String, dynamic> payload,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pending = prefs.getStringList(_pendingKey) ?? [];
      final entry = json.encode({
        'op': operationName,
        'payload': payload,
        'timestamp': DateTime.now().toIso8601String(),
      });
      pending.add(entry);
      await prefs.setStringList(_pendingKey, pending);
    } catch (e) {
      debugPrint('[OfflineWriteGuard] Failed to enqueue: $e');
    }
  }

  /// Retry all pending writes. Call on app startup after auth.
  ///
  /// [retryHandler] — maps operation name → retry function.
  /// Successfully retried operations are removed from the queue.
  static Future<void> retryPending(
    Map<String, Future<void> Function(Map<String, dynamic> payload)>
    retryHandler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pending = prefs.getStringList(_pendingKey) ?? [];
      if (pending.isEmpty) return;

      debugPrint(
        '[OfflineWriteGuard] Retrying ${pending.length} pending writes',
      );
      final remaining = <String>[];

      for (final entryJson in pending) {
        try {
          final entry = json.decode(entryJson) as Map<String, dynamic>;
          final op = entry['op'] as String;
          final payload = entry['payload'] as Map<String, dynamic>;

          final handler = retryHandler[op];
          if (handler != null) {
            await handler(payload);
            debugPrint('[OfflineWriteGuard] Retried $op successfully');
          } else {
            debugPrint('[OfflineWriteGuard] No handler for $op, discarding');
          }
        } catch (e) {
          // Keep failed entries for next retry
          remaining.add(entryJson);
          debugPrint('[OfflineWriteGuard] Retry failed, keeping in queue: $e');
        }
      }

      await prefs.setStringList(_pendingKey, remaining);
    } catch (e) {
      debugPrint('[OfflineWriteGuard] retryPending failed: $e');
    }
  }

  /// Check if there are pending writes.
  static Future<int> pendingCount() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_pendingKey) ?? []).length;
  }
}
