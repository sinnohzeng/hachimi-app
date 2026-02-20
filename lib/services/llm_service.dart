// ---
// 📘 文件说明：
// LLM 推理服务 — 封装 llama_cpp_dart 的 Isolate 推理引擎。
// 推理在独立 Isolate 运行（dart:ffi），不阻塞 Dart UI 线程。
//
// 📋 程序整体伪代码（中文）：
// 1. 使用 LlamaParent 创建独立 Isolate 加载 GGUF 模型；
// 2. 暴露 generate() 用于一次性文本生成（日记）；
// 3. 暴露 generateStream() 用于流式 token 输出（聊天）；
// 4. 管理模型加载/卸载生命周期；
// 5. Isolate 崩溃时自动重置状态，允许重新加载；
//
// 🧩 文件结构：
// - LlmService：推理引擎封装；
// - LlmEngineStatus：引擎状态枚举；
//
// 🕒 创建时间：2026-02-19
// ---

import 'dart:async';
import 'dart:io' show Platform;

import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';

/// LLM 引擎状态。
enum LlmEngineStatus {
  unloaded,
  loading,
  ready,
  generating,
  error,
}

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

    _status = LlmEngineStatus.loading;
    _lastError = null;

    try {
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
        verbose: false,
      );

      _parent = LlamaParent(loadCommand);
      await _parent!.init();
      _status = LlmEngineStatus.ready;
    } catch (e) {
      _status = LlmEngineStatus.error;
      _lastError = e.toString();
      _parent = null;
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
      final buffer = StringBuffer();
      StreamSubscription<String>? streamSub;

      final completer = Completer<String>();

      streamSub = parent.stream.listen(
        (token) {
          buffer.write(token);
        },
        onError: (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
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

      _status = LlmEngineStatus.ready;
      return _cleanResponse(result);
    } catch (e) {
      _resetOnError(e);
      rethrow;
    }
  }

  /// 流式文本生成（用于聊天）。
  /// 返回 token stream，每个事件是一个 token。
  /// 调用方需自行收集 token 拼接完整回复。
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
      (token) {
        controller.add(token);
      },
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
    } catch (_) {
      // ignore stop errors
    }
    if (_status == LlmEngineStatus.generating) {
      _status = LlmEngineStatus.ready;
    }
  }

  /// 卸载模型，释放内存。
  Future<void> unloadModel() async {
    try {
      await _parent?.dispose();
    } catch (_) {
      // ignore dispose errors
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
  String _cleanResponse(String text) {
    return text
        .replaceAll('<|im_end|>', '')
        .replaceAll('<|im_start|>', '')
        .replaceAll('<|endoftext|>', '')
        .trim();
  }
}
