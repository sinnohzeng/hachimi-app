import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_exception.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/core/ai/ai_provider.dart';

/// AI 门面服务 — 路由到当前活跃的 [AiProvider] 并提供并发控制。
///
/// [ChatService] 和 [DiaryService] 通过此服务调用 AI，
/// 不直接接触具体的 Provider 实现。
///
/// 断路器回调在此层统一接入 — AiService 是所有 AI 调用的唯一入口，
/// 一处接入即可保护所有消费方。
class AiService {
  final AiProvider _provider;
  final void Function()? onSuccess;
  final void Function()? onFailure;
  Completer<void>? _inflight;

  AiService({required AiProvider provider, this.onSuccess, this.onFailure})
    : _provider = provider;

  /// 当前提供商标识。
  String get providerId => _provider.id;

  /// 当前提供商显示名称。
  String get providerName => _provider.displayName;

  /// 是否已配置（API Key 等）。
  bool get isConfigured => _provider.isConfigured;

  /// 是否有请求正在执行。
  bool get isGenerating => _inflight != null;

  /// 一次性生成 — 带并发控制与断路器回调。
  Future<AiResponse> generate(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async {
    _guardConcurrency();
    _inflight = Completer<void>();
    try {
      final response = await _provider.generate(messages, config);
      _logUsage('generate', response.usage);
      onSuccess?.call();
      return response;
    } catch (e) {
      _notifyFailureIfApplicable(e);
      rethrow;
    } finally {
      _inflight?.complete();
      _inflight = null;
    }
  }

  /// 流式生成 — 带并发控制与断路器回调。
  ///
  /// 流正常完成时通知 [onSuccess]，
  /// 异常（非 busy/cancelled）时通知 [onFailure]。
  Stream<String> generateStream(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async* {
    _guardConcurrency();
    _inflight = Completer<void>();
    try {
      yield* _provider.generateStream(messages, config);
      onSuccess?.call();
    } catch (e) {
      _notifyFailureIfApplicable(e);
      rethrow;
    } finally {
      _inflight?.complete();
      _inflight = null;
    }
  }

  /// 取消当前请求。
  Future<void> cancel() async {
    await _provider.cancel();
    _inflight?.complete();
    _inflight = null;
  }

  /// 验证连接。
  Future<bool> validateConnection() => _provider.validateConnection();

  // ─── Private ───

  void _guardConcurrency() {
    if (_inflight != null) {
      throw const AiException(
        AiErrorType.busy,
        'A generation is already in progress',
      );
    }
  }

  /// 仅对真正的 AI 故障通知断路器，忽略本地冲突和用户取消。
  void _notifyFailureIfApplicable(Object error) {
    if (error is AiException &&
        (error.type == AiErrorType.busy ||
            error.type == AiErrorType.cancelled)) {
      return;
    }
    onFailure?.call();
  }

  void _logUsage(String operation, AiUsage? usage) {
    if (usage == null) return;
    debugPrint(
      '[AiService] $operation usage: '
      '${usage.promptTokens}p + ${usage.completionTokens}c '
      '= ${usage.totalTokens} tokens',
    );
  }
}
