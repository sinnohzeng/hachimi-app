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

/// Gemini 大模型提供商实现。
///
/// 使用 Google Generative Language API，支持 Gemini 3 Flash 模型。
class GeminiProvider implements AiProvider {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const _model = 'gemini-3-flash-preview';
  static const _connectTimeout = Duration(seconds: 30);
  static const _streamIdleTimeout = Duration(seconds: 120);

  /// 编译时注入的 API Key。
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  final HttpClient _client = HttpClient();
  HttpClientRequest? _activeRequest;

  GeminiProvider() {
    _client.connectionTimeout = _connectTimeout;
    _client.idleTimeout = _streamIdleTimeout;
  }

  @override
  String get id => 'gemini';

  @override
  String get displayName => 'Gemini';

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  Future<AiResponse> generate(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async {
    _ensureConfigured();
    final body = _buildRequestBody(messages, config);
    const url = '$_baseUrl/$_model:generateContent';

    try {
      final response = await _sendRequest(url, body);
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
    final body = _buildRequestBody(messages, config);
    const url = '$_baseUrl/$_model:streamGenerateContent?alt=sse';

    HttpClientResponse response;
    try {
      response = await _sendRequest(url, body);
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
    AiRequestConfig config,
  ) {
    final body = <String, dynamic>{
      'contents': _buildContents(messages),
      'generationConfig': _buildGenerationConfig(config),
    };
    final systemText = _extractSystemText(messages);
    if (systemText != null) {
      body['system_instruction'] = {
        'parts': [
          {'text': systemText},
        ],
      };
    }
    return body;
  }

  /// 提取 system 消息文本（Gemini 使用独立字段，不在 contents 中）。
  String? _extractSystemText(List<AiMessage> messages) {
    final systemMsgs = messages.where((m) => m.role == AiRole.system);
    if (systemMsgs.isEmpty) return null;
    return systemMsgs.map((m) => m.content).join('\n');
  }

  /// 将非 system 消息转换为 Gemini contents 格式。
  List<Map<String, dynamic>> _buildContents(List<AiMessage> messages) {
    return messages
        .where((m) => m.role != AiRole.system)
        .map(
          (m) => {
            'role': m.role == AiRole.assistant ? 'model' : 'user',
            'parts': [
              {'text': m.content},
            ],
          },
        )
        .toList();
  }

  Map<String, dynamic> _buildGenerationConfig(AiRequestConfig config) {
    return {
      'maxOutputTokens': config.maxTokens,
      'temperature': config.temperature,
      'topP': config.topP,
      'thinkingConfig': {'thinkingLevel': 'low'},
    };
  }

  Future<HttpClientResponse> _sendRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    final request = await _client.postUrl(Uri.parse(url));
    _activeRequest = request;
    request.headers.set('x-goog-api-key', _apiKey);
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
    _checkError(json);
    final text = _extractText(json);
    final usage = _parseUsage(json);
    return AiResponse(content: text, usage: usage);
  }

  void _checkError(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>?;
    if (error == null) return;
    final code = error['code'] as int? ?? 0;
    final msg = error['message'] as String? ?? 'Unknown error';
    throw _mapGeminiError(code, msg);
  }

  AiException _mapGeminiError(int code, String msg) {
    return switch (code) {
      400 => AiException(AiErrorType.serverError, msg),
      401 || 403 => AiException(AiErrorType.authFailure, msg),
      429 => AiException(AiErrorType.rateLimited, msg),
      _ => AiException(AiErrorType.serverError, msg),
    };
  }

  /// 从非流式响应中提取文本。
  String _extractText(Map<String, dynamic> json) {
    final candidates = json['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return '';
    final first = candidates[0] as Map<String, dynamic>;
    final content = first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) return '';
    final firstPart = parts[0] as Map<String, dynamic>;
    return firstPart['text'] as String? ?? '';
  }

  AiUsage? _parseUsage(Map<String, dynamic> json) {
    final meta = json['usageMetadata'] as Map<String, dynamic>?;
    if (meta == null) return null;
    return AiUsage(
      promptTokens: meta['promptTokenCount'] as int? ?? 0,
      completionTokens: meta['candidatesTokenCount'] as int? ?? 0,
    );
  }

  /// Gemini SSE token 提取器。
  ///
  /// 路径：`candidates[0].content.parts[0].text`
  static String? _geminiExtractor(Map<String, dynamic> data) {
    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return null;
    final first = candidates[0] as Map<String, dynamic>;
    final content = first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) return null;
    final firstPart = parts[0] as Map<String, dynamic>;
    return firstPart['text'] as String?;
  }

  Stream<String> _parseStreamResponse(HttpClientResponse response) {
    final lines = response
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    return SseParser.parse(lines, extractToken: _geminiExtractor);
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
    debugPrint('[GeminiProvider] $operation failed: $e');
    ErrorHandler.record(
      e,
      stackTrace: stack,
      source: 'GeminiProvider',
      operation: operation,
    );
  }
}
