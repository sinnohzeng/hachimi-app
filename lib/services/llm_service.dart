import 'dart:async';
import 'dart:io' show File, Platform;

import 'package:flutter/foundation.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/performance_traces.dart';

/// LLM 引擎状态。
enum LlmEngineStatus { unloaded, loading, ready, generating, error }

/// LLM 推理服务 — Isolate 隔离推理，不阻塞 UI。
class LlmService {
  LlamaParent? _parent;
  LlmEngineStatus _status = LlmEngineStatus.unloaded;
  String? _lastError;

  /// 当前引擎状态。
  LlmEngineStatus get status => _status;

  /// 最近的错误信息。
  String? get lastError => _lastError;

  /// 模型是否已加载且就绪。
  bool get isReady => _status == LlmEngineStatus.ready;

  /// 是否正在生成中。
  bool get isGenerating => _status == LlmEngineStatus.generating;

  /// 加载模型到内存。
  Future<void> loadModel(String modelPath) async {
    if (_status == LlmEngineStatus.loading) return;
    if (_status == LlmEngineStatus.ready) return;

    // iOS 暂不支持（llama_cpp_dart 无预编译 xcframework）
    if (Platform.isIOS) {
      _status = LlmEngineStatus.error;
      _lastError = 'AI features coming soon on iOS';
      return;
    }

    // 前置校验：在调用 native 层前先在 Dart 侧检查文件有效性
    final modelFile = File(modelPath);
    if (!modelFile.existsSync()) {
      _status = LlmEngineStatus.error;
      _lastError = 'Model file not found: $modelPath';
      throw LlamaException(_lastError!);
    }
    final fileSize = modelFile.lengthSync();
    final actualMb = (fileSize / 1024 / 1024).toStringAsFixed(1);
    debugPrint('[LlmService] Loading model: $modelPath ($actualMb MB)');
    if (fileSize < LlmConstants.minValidModelSizeBytes) {
      final expectedMb = (LlmConstants.modelFileSizeBytes / 1024 / 1024)
          .toStringAsFixed(0);
      _status = LlmEngineStatus.error;
      _lastError =
          'Model file is incomplete ($actualMb MB, expected ~$expectedMb MB). '
          'Please re-download.';
      throw LlamaException(_lastError!);
    }

    _status = LlmEngineStatus.loading;
    _lastError = null;

    try {
      await AppTraces.trace('llm_load_model', () async {
        final loadCommand = LlamaLoad(
          path: modelPath,
          modelParams: ModelParams()..nGpuLayers = 0, // CPU only
          contextParams: ContextParams()
            ..nCtx = LlmConstants.contextSize
            ..nBatch = 512
            ..nThreads = 4
            ..nPredict = LlmConstants.diaryMaxTokens,
          samplingParams: SamplerParams()
            ..temp = LlmConstants.temperature
            ..topP = LlmConstants.topP
            ..penaltyRepeat = LlmConstants.repeatPenalty,
          verbose: true,
        );

        _parent = LlamaParent(loadCommand);
        await _parent!.init();
      });
      _status = LlmEngineStatus.ready;
      debugPrint('[LlmService] Model loaded successfully');
    } catch (e, stack) {
      _status = LlmEngineStatus.error;
      _lastError = e.toString();
      _parent = null;
      ErrorHandler.record(e, stackTrace: stack, source: 'LlmService', operation: 'loadModel');
      rethrow;
    }
  }

  /// 一次性文本生成（用于日记）。
  /// 返回完整生成文本。
  Future<String> generate(String prompt) async {
    final parent = _parent;
    if (parent == null || _status != LlmEngineStatus.ready) {
      throw StateError('LLM engine not ready. Current status: $_status');
    }

    _status = LlmEngineStatus.generating;
    try {
      final text = await AppTraces.trace('llm_generate', () async {
        final buffer = StringBuffer();
        StreamSubscription<String>? streamSub;

        final completer = Completer<String>();

        streamSub = parent.stream.listen(
          buffer.write,
          onError: (e) {
            if (!completer.isCompleted) {
              completer.completeError(e);
            }
          },
          onDone: () {
            // stream 意外关闭（Isolate 崩溃等），防止 completer 悬空
            if (!completer.isCompleted) {
              completer.complete(buffer.toString());
            }
          },
        );

        // 监听完成事件
        StreamSubscription<CompletionEvent>? completionSub;
        completionSub = parent.completions.listen((event) {
          if (!completer.isCompleted) {
            completer.complete(buffer.toString());
          }
          completionSub?.cancel();
        });

        await parent.sendPrompt(prompt);

        final result = await completer.future;
        await streamSub.cancel();
        await completionSub.cancel();
        return result;
      });

      _status = LlmEngineStatus.ready;
      return cleanResponse(text);
    } catch (e, stack) {
      _resetOnError(e);
      ErrorHandler.record(e, stackTrace: stack, source: 'LlmService', operation: 'generate');
      rethrow;
    }
  }

  /// 流式文本生成（用于聊天）。
  /// 返回 token stream，每个事件是一个 token。
  /// 调用方需自行收集 token 拼接完整回复，并调用 [cleanResponse] 清理特殊 token。
  Stream<String> generateStream(String prompt) {
    final parent = _parent;
    if (parent == null || _status != LlmEngineStatus.ready) {
      return Stream.error(
        StateError('LLM engine not ready. Current status: $_status'),
      );
    }

    _status = LlmEngineStatus.generating;

    final controller = StreamController<String>();

    // 监听 token stream
    StreamSubscription<String>? streamSub;
    StreamSubscription<CompletionEvent>? completionSub;

    streamSub = parent.stream.listen(
      controller.add,
      onError: (e) {
        _resetOnError(e);
        controller.addError(e);
      },
    );

    completionSub = parent.completions.listen((event) {
      _status = LlmEngineStatus.ready;
      streamSub?.cancel();
      completionSub?.cancel();
      controller.close();
    });

    // 发送 prompt
    parent.sendPrompt(prompt).catchError((Object e) {
      _resetOnError(e);
      controller.addError(e);
      streamSub?.cancel();
      completionSub?.cancel();
      controller.close();
      return ''; // satisfy return type
    });

    controller.onCancel = () {
      streamSub?.cancel();
      completionSub?.cancel();
    };

    return controller.stream;
  }

  /// 停止当前推理。
  Future<void> stopGeneration() async {
    try {
      await _parent?.stop();
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'LlmService', operation: 'stopGeneration');
    }
    if (_status == LlmEngineStatus.generating) {
      _status = LlmEngineStatus.ready;
    }
  }

  /// 卸载模型，释放内存。
  Future<void> unloadModel() async {
    try {
      await _parent?.dispose();
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'LlmService', operation: 'unloadModel');
    }
    _parent = null;
    _status = LlmEngineStatus.unloaded;
  }

  /// Isolate 崩溃或异常时重置状态，允许重新 loadModel()。
  void _resetOnError(Object e) {
    _status = LlmEngineStatus.error;
    _lastError = e.toString();
    // Isolate 可能已死，置空允许重新加载
    _parent = null;
  }

  /// 清理生成文本中的特殊 token 标记。
  String cleanResponse(String text) {
    return text
        .replaceAll('<|im_end|>', '')
        .replaceAll('<|im_start|>', '')
        .replaceAll('<|endoftext|>', '')
        .trim();
  }
}
