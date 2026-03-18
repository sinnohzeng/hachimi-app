import 'package:firebase_performance/firebase_performance.dart';

/// AppTraces — wraps Firebase Performance custom traces for key operations.
///
/// Usage:
/// ```dart
/// final result = await AppTraces.trace('llm_generate', () => llmService.generate(prompt));
/// ```
class AppTraces {
  AppTraces._();

  /// Execute [fn] wrapped in a Firebase Performance custom trace.
  /// Automatically sets `status` attribute to `success` or `error`.
  static Future<T> trace<T>(String name, Future<T> Function() fn) async {
    final trace = FirebasePerformance.instance.newTrace(name);
    await trace.start();
    try {
      final result = await fn();
      trace.putAttribute('status', 'success');
      return result;
    } catch (e) {
      trace.putAttribute('status', 'error');
      rethrow;
    } finally {
      await trace.stop();
    }
  }
}
