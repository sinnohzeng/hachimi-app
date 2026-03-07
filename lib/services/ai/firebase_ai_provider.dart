import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_exception.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/core/ai/ai_provider.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// Firebase AI Logic provider implementation (Vertex backend).
class FirebaseAiProvider implements AiProvider {
  static const _modelName = 'gemini-2.5-flash';
  bool _cancelRequested = false;

  @override
  String get id => 'firebase_gemini';

  @override
  String get displayName => 'Firebase Gemini';

  @override
  bool get isConfigured => true;

  @override
  Future<AiResponse> generate(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async {
    _cancelRequested = false;
    try {
      final model = _createModel(messages, config);
      final response = await model
          .generateContent(_toPrompt(messages))
          .timeout(
            config.timeout,
            onTimeout: () {
              throw const AiException(
                AiErrorType.networkError,
                'Request timed out',
              );
            },
          );
      if (_cancelRequested) {
        throw const AiException(AiErrorType.cancelled, 'Cancelled by user');
      }
      return AiResponse(
        content: response.text ?? '',
        usage: _parseUsage(response.usageMetadata),
      );
    } catch (e, stack) {
      if (e is AiException) rethrow;
      _recordError(e, stack, 'generate');
      throw _mapException(e);
    }
  }

  @override
  Stream<String> generateStream(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) async* {
    _cancelRequested = false;
    try {
      final model = _createModel(messages, config);
      final stream = model.generateContentStream(_toPrompt(messages));
      var lastTokenTime = DateTime.now();
      const idleTimeout = Duration(seconds: 10);
      await for (final event in stream) {
        if (_cancelRequested) {
          throw const AiException(AiErrorType.cancelled, 'Cancelled by user');
        }
        if (DateTime.now().difference(lastTokenTime) > idleTimeout) {
          throw const AiException(
            AiErrorType.networkError,
            'Stream idle timeout',
          );
        }
        final token = event.text;
        if (token == null || token.isEmpty) continue;
        lastTokenTime = DateTime.now();
        yield token;
      }
    } catch (e, stack) {
      if (e is AiException && e.type == AiErrorType.cancelled) rethrow;
      _recordError(e, stack, 'generateStream');
      throw _mapException(e);
    }
  }

  @override
  Future<void> cancel() async {
    _cancelRequested = true;
  }

  @override
  Future<bool> validateConnection() async {
    try {
      final response = await generate(const [
        AiMessage.user('ping'),
      ], AiRequestConfig.validation);
      return response.content.isNotEmpty;
    } on AiException {
      return false;
    }
  }

  GenerativeModel _createModel(
    List<AiMessage> messages,
    AiRequestConfig config,
  ) {
    final systemInstruction = _extractSystemInstruction(messages);
    return FirebaseAI.vertexAI(auth: FirebaseAuth.instance).generativeModel(
      model: _modelName,
      generationConfig: GenerationConfig(
        maxOutputTokens: config.maxTokens,
        temperature: config.temperature,
        topP: config.topP,
      ),
      systemInstruction: systemInstruction == null
          ? null
          : Content.system(systemInstruction),
    );
  }

  String? _extractSystemInstruction(List<AiMessage> messages) {
    final systemMessages = messages.where((m) => m.role == AiRole.system);
    if (systemMessages.isEmpty) return null;
    return systemMessages.map((m) => m.content).join('\n');
  }

  List<Content> _toPrompt(List<AiMessage> messages) {
    return messages.where((m) => m.role != AiRole.system).map((m) {
      return switch (m.role) {
        AiRole.user => Content.text(m.content),
        AiRole.assistant => Content.model([TextPart(m.content)]),
        AiRole.system => Content.system(m.content),
      };
    }).toList();
  }

  AiUsage? _parseUsage(UsageMetadata? usage) {
    if (usage == null) return null;
    return AiUsage(
      promptTokens: usage.promptTokenCount ?? 0,
      completionTokens: usage.candidatesTokenCount ?? 0,
    );
  }

  AiException _mapException(Object error) {
    if (error is FirebaseAIException) {
      final message = error.message;
      if (error is QuotaExceeded) {
        return AiException(AiErrorType.rateLimited, message);
      }
      if (error is ServiceApiNotEnabled || error is UnsupportedUserLocation) {
        return AiException(AiErrorType.unconfigured, message);
      }
      if (error is InvalidApiKey) {
        return AiException(AiErrorType.authFailure, message);
      }
      if (error is ServerException) {
        return AiException(AiErrorType.serverError, message);
      }
      return AiException(AiErrorType.serverError, message);
    }
    if (error is TimeoutException) {
      return const AiException(AiErrorType.networkError, 'Request timed out');
    }
    return AiException(AiErrorType.serverError, error.toString());
  }

  void _recordError(Object e, StackTrace stack, String operation) {
    debugPrint('[FirebaseAiProvider] $operation failed: $e');
    ErrorHandler.recordOperation(
      e,
      stackTrace: stack,
      feature: 'FirebaseAiProvider',
      operation: operation,
    );
  }
}
