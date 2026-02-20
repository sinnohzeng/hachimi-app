// ---
// 📘 文件说明：
// LLM Provider 单元测试 — 验证 ModelDownloadState copyWith 和 LlmAvailability 枚举。
//
// 🧩 文件结构：
// - LlmAvailability 枚举值
// - ModelDownloadState 默认值、copyWith
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/providers/llm_provider.dart';

void main() {
  group('LlmAvailability — enum', () {
    test('has all expected values', () {
      expect(LlmAvailability.values.length, equals(5));
      expect(LlmAvailability.values, contains(LlmAvailability.featureDisabled));
      expect(
        LlmAvailability.values,
        contains(LlmAvailability.modelNotDownloaded),
      );
      expect(LlmAvailability.values, contains(LlmAvailability.modelLoading));
      expect(LlmAvailability.values, contains(LlmAvailability.ready));
      expect(LlmAvailability.values, contains(LlmAvailability.error));
    });
  });

  group('ModelDownloadState — defaults', () {
    test('default state is not downloading', () {
      const s = ModelDownloadState();
      expect(s.isDownloading, isFalse);
      expect(s.isPaused, isFalse);
      expect(s.progress, equals(0.0));
      expect(s.downloadedBytes, equals(0));
      expect(s.totalBytes, equals(0));
      expect(s.error, isNull);
      expect(s.task, isNull);
    });
  });

  group('ModelDownloadState — copyWith', () {
    test('updates isDownloading only', () {
      const s = ModelDownloadState();
      final s2 = s.copyWith(isDownloading: true);
      expect(s2.isDownloading, isTrue);
      expect(s2.isPaused, isFalse);
      expect(s2.progress, equals(0.0));
    });

    test('updates progress and bytes', () {
      const s = ModelDownloadState(isDownloading: true);
      final s2 = s.copyWith(
        progress: 0.5,
        downloadedBytes: 500,
        totalBytes: 1000,
      );
      expect(s2.progress, closeTo(0.5, 0.001));
      expect(s2.downloadedBytes, equals(500));
      expect(s2.totalBytes, equals(1000));
      expect(s2.isDownloading, isTrue); // preserved
    });

    test('error clears on new copyWith without error', () {
      final s = const ModelDownloadState().copyWith(error: 'Download failed');
      expect(s.error, equals('Download failed'));

      // copyWith without error → error becomes null
      final s2 = s.copyWith(isDownloading: false);
      expect(s2.error, isNull);
    });

    test('isPaused toggle', () {
      const s = ModelDownloadState(isDownloading: true, isPaused: false);
      final s2 = s.copyWith(isPaused: true);
      expect(s2.isPaused, isTrue);
      expect(s2.isDownloading, isTrue);
    });
  });
}
