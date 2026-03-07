// AI Provider unit tests — AiAvailability enum, AiException, AiRequestConfig.
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_exception.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';
import 'package:hachimi_app/providers/ai_provider.dart';

void main() {
  group('AiProviderId — enum', () {
    test('has 1 value', () {
      expect(AiProviderId.values.length, equals(1));
      expect(AiProviderId.values, contains(AiProviderId.firebaseGemini));
    });

    test('wire value serializes correctly', () {
      expect(AiProviderId.firebaseGemini.wireValue, equals('firebase_gemini'));
    });
  });

  group('AiAvailability — enum', () {
    test('has 2 values (always-on architecture)', () {
      expect(AiAvailability.values.length, equals(2));
      expect(AiAvailability.values, contains(AiAvailability.ready));
      expect(AiAvailability.values, contains(AiAvailability.error));
    });
  });

  group('AiErrorType — enum', () {
    test('has all expected values', () {
      expect(AiErrorType.values.length, equals(7));
      expect(AiErrorType.values, contains(AiErrorType.networkError));
      expect(AiErrorType.values, contains(AiErrorType.authFailure));
      expect(AiErrorType.values, contains(AiErrorType.rateLimited));
      expect(AiErrorType.values, contains(AiErrorType.insufficientBalance));
      expect(AiErrorType.values, contains(AiErrorType.serverError));
      expect(AiErrorType.values, contains(AiErrorType.cancelled));
      expect(AiErrorType.values, contains(AiErrorType.unconfigured));
    });
  });

  group('AiException', () {
    test('carries type and message', () {
      const e = AiException(AiErrorType.authFailure, 'Invalid API key');
      expect(e.type, equals(AiErrorType.authFailure));
      expect(e.message, equals('Invalid API key'));
      expect(e.toString(), contains('Invalid API key'));
    });
  });

  group('AiMessage', () {
    test('system constructor', () {
      const msg = AiMessage.system('You are a cat.');
      expect(msg.role, equals(AiRole.system));
      expect(msg.content, equals('You are a cat.'));
    });

    test('user constructor', () {
      const msg = AiMessage.user('Hello!');
      expect(msg.role, equals(AiRole.user));
      expect(msg.content, equals('Hello!'));
    });

    test('assistant constructor', () {
      const msg = AiMessage.assistant('Meow~');
      expect(msg.role, equals(AiRole.assistant));
      expect(msg.content, equals('Meow~'));
    });

    test('toJson serializes correctly', () {
      const msg = AiMessage(role: AiRole.user, content: 'Hi');
      final json = msg.toJson();
      expect(json['role'], equals('user'));
      expect(json['content'], equals('Hi'));
    });
  });

  group('AiRequestConfig — presets', () {
    test('chat preset', () {
      expect(AiRequestConfig.chat.maxTokens, equals(150));
      expect(AiRequestConfig.chat.temperature, closeTo(0.7, 0.01));
      expect(AiRequestConfig.chat.timeout, equals(const Duration(seconds: 15)));
    });

    test('diary preset', () {
      expect(AiRequestConfig.diary.maxTokens, equals(200));
      expect(
        AiRequestConfig.diary.timeout,
        equals(const Duration(seconds: 20)),
      );
    });

    test('validation preset uses minimal tokens and short timeout', () {
      expect(AiRequestConfig.validation.maxTokens, equals(1));
      expect(AiRequestConfig.validation.temperature, equals(0.0));
      expect(
        AiRequestConfig.validation.timeout,
        equals(const Duration(seconds: 5)),
      );
    });
  });

  group('AiResponse', () {
    test('content and usage', () {
      const usage = AiUsage(promptTokens: 10, completionTokens: 20);
      const response = AiResponse(content: 'Hello', usage: usage);
      expect(response.content, equals('Hello'));
      expect(response.usage?.totalTokens, equals(30));
    });

    test('usage can be null', () {
      const response = AiResponse(content: 'Hello');
      expect(response.usage, isNull);
    });
  });
}
