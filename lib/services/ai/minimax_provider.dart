import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_exception.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/core/ai/ai_provider.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/ai/sse_parser.dart';

/// MiniMax 大模型提供商实现。
///
/// 使用 MiniMax 官方 API（api.minimax.io），兼容 OpenAI Chat Completions 格式。
class MiniMaxProvider implements AiProvider {
  static const _endpoint = 'https://api.minimax.io/v1/text/chatcompletion_v2';
  static const _model = 'MiniMax-M2.5';
  static const _connectTimeout = Duration(seconds: 30);
  static const _streamIdleTimeout = Duration(seconds: 120);

  /// 编译时注入的 API Key。
  static const _apiKey = String.fromEnvironment('MINIMAX_API_KEY');

  final HttpClient _client = HttpClient();
  HttpClientRequest? _activeRequest;

  MiniMaxProvider() {
    _client.connectionTimeout = _connectTimeout;
    _client.idleTimeout = _streamIdleTimeout;
  }

  @override
  String get id => 'minimax';

  @override
  String get displayName => 'MiniMax';

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  Future<AiResponse> generate(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async {
    _ensureConfigured();
    final body = _buildRequestBody(messages, config, stream: false);

    try {
      final response = await _sendRequest(body);
      final json = await _readResponseJson(response);
      return _parseResponse(json);
    } on AiException {
      rethrow;
    } catch (e, stack) {
      _recordError(e, stack, 'generate');
      throw _wrapException(e);
    }
  }

  @override
  Stream<String> generateStream(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async* {
    _ensureConfigured();
    final body = _buildRequestBody(messages, config, stream: true);

    HttpClientResponse response;
    try {
      response = await _sendRequest(body);
      _checkResponseStatus(response);
    } on AiException {
      rethrow;
    } catch (e, stack) {
      _recordError(e, stack, 'generateStream');
      throw _wrapException(e);
    }

    yield* _parseStreamResponse(response);
  }

  @override
  Future<void> cancel() async {
    _activeRequest?.abort();
    _activeRequest = null;
  }

  @override
  Future<bool> validateConnection() async {
    if (!isConfigured) return false;
    try {
      final messages = [const AiMessage.user('Hi')];
      await generate(messages, AiRequestConfig.validation);
      return true;
    } on AiException {
      return false;
    }
  }

  // ─── Private Helpers ───

  void _ensureConfigured() {
    if (!isConfigured) {
      throw const AiException(AiErrorType.unconfigured, 'API Key not set');
    }
  }

  Map<String, dynamic> _buildRequestBody(
    List<AiMessage> messages,
    AiRequestConfig config, {
    required bool stream,
  }) {
    return {
      'model': _model,
      'messages': messages.map((m) => m.toJson()).toList(),
      'max_tokens': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'stream': stream,
    };
  }

  Future<HttpClientResponse> _sendRequest(Map<String, dynamic> body) async {
    final request = await _client.postUrl(Uri.parse(_endpoint));
    _activeRequest = request;
    request.headers.set('Authorization', 'Bearer $_apiKey');
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode(body));
    return request.close();
  }

  Future<Map<String, dynamic>> _readResponseJson(
    HttpClientResponse response,
  ) async {
    _checkResponseStatus(response);
    final raw = await response.transform(utf8.decoder).join();
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  void _checkResponseStatus(HttpClientResponse response) {
    final status = response.statusCode;
    if (status == 401 || status == 403) {
      throw const AiException(AiErrorType.authFailure, 'Invalid API key');
    }
    if (status == 429) {
      throw const AiException(AiErrorType.rateLimited, 'Rate limited');
    }
    if (status >= 500) {
      throw AiException(AiErrorType.serverError, 'Server error: $status');
    }
  }

  AiResponse _parseResponse(Map<String, dynamic> json) {
    _checkBaseResp(json);
    final choices = json['choices'] as List<dynamic>?;
    final first = choices?.firstOrNull as Map<String, dynamic>?;
    final message = first?['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String? ?? '';
    final usage = _parseUsage(json);
    return AiResponse(content: content, usage: usage);
  }

  void _checkBaseResp(Map<String, dynamic> json) {
    final baseResp = json['base_resp'] as Map<String, dynamic>?;
    if (baseResp == null) return;
    final code = baseResp['status_code'] as int? ?? 0;
    if (code == 0) return;
    final msg = baseResp['status_msg'] as String? ?? 'Unknown error';
    throw _mapMiniMaxError(code, msg);
  }

  AiException _mapMiniMaxError(int code, String msg) {
    return switch (code) {
      1002 => AiException(AiErrorType.rateLimited, msg),
      1004 => AiException(AiErrorType.authFailure, msg),
      1008 => AiException(AiErrorType.insufficientBalance, msg),
      _ => AiException(AiErrorType.serverError, msg),
    };
  }

  AiUsage? _parseUsage(Map<String, dynamic> json) {
    final usage = json['usage'] as Map<String, dynamic>?;
    if (usage == null) return null;
    return AiUsage(
      promptTokens: usage['prompt_tokens'] as int? ?? 0,
      completionTokens: usage['completion_tokens'] as int? ?? 0,
    );
  }

  Stream<String> _parseStreamResponse(HttpClientResponse response) {
    final lines = response
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    return SseParser.parse(lines);
  }

  AiException _wrapException(Object error) {
    if (error is SocketException) {
      return AiException(AiErrorType.networkError, error.message);
    }
    if (error is HttpException) {
      return AiException(AiErrorType.networkError, error.message);
    }
    if (error is TimeoutException) {
      return const AiException(AiErrorType.networkError, 'Request timed out');
    }
    return AiException(AiErrorType.serverError, error.toString());
  }

  void _recordError(Object e, StackTrace stack, String operation) {
    debugPrint('[MiniMaxProvider] $operation failed: $e');
    ErrorHandler.record(
      e,
      stackTrace: stack,
      source: 'MiniMaxProvider',
      operation: operation,
    );
  }
}
