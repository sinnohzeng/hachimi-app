// ---
// 📘 文件说明：
// LLM 推理服务 — 封装 flutter_llama 的推理引擎。
// 推理在 native 单线程 executor 运行，不阻塞 Dart UI 线程。
//
// 📋 程序整体伪代码（中文）：
// 1. 使用 FlutterLlama.instance 单例加载 GGUF 模型；
// 2. 暴露 generate() 用于一次性文本生成（日记）；
// 3. 暴露 generateStream() 用于流式 token 输出（聊天）；
// 4. 管理模型加载/卸载生命周期；
//
// 🧩 文件结构：
// - LlmService：推理引擎封装；
// - LlmEngineStatus：引擎状态枚举；
//
// 🕒 创建时间：2026-02-19
// ---

import 'dart:async';

import 'package:flutter_llama/flutter_llama.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';

/// LLM 引擎状态。
enum LlmEngineStatus {
  unloaded,
  loading,
  ready,
  generating,
  error,
}

/// LLM 推理服务 — native 层单线程推理，不阻塞 UI。
class LlmService {
  final FlutterLlama _llama = FlutterLlama.instance;
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

    _status = LlmEngineStatus.loading;
    _lastError = null;

    try {
      final config = LlamaConfig(
        modelPath: modelPath,
        nThreads: 4,
        nGpuLayers: 0, // CPU only — 安全兼容所有设备
        contextSize: LlmConstants.contextSize,
        batchSize: 512,
        useGpu: false,
        verbose: false,
      );

      final success = await _llama.loadModel(config);
      if (success) {
        _status = LlmEngineStatus.ready;
      } else {
        _status = LlmEngineStatus.error;
        _lastError = 'Failed to load model';
      }
    } catch (e) {
      _status = LlmEngineStatus.error;
      _lastError = e.toString();
      rethrow;
    }
  }

  /// 一次性文本生成（用于日记）。
  /// 返回完整生成文本。
  Future<String> generate(String prompt) async {
    if (!_llama.isModelLoaded || _status != LlmEngineStatus.ready) {
      throw StateError('LLM engine not ready. Current status: $_status');
    }

    _status = LlmEngineStatus.generating;
    try {
      final params = GenerationParams(
        prompt: prompt,
        temperature: LlmConstants.temperature,
        topP: LlmConstants.topP,
        maxTokens: LlmConstants.diaryMaxTokens,
        repeatPenalty: LlmConstants.repeatPenalty,
        stopSequences: const ['<|im_end|>', '<|endoftext|>'],
      );

      final response = await _llama.generate(params);
      _status = LlmEngineStatus.ready;
      return _cleanResponse(response.text);
    } catch (e) {
      _status = LlmEngineStatus.ready;
      _lastError = e.toString();
      rethrow;
    }
  }

  /// 流式文本生成（用于聊天）。
  /// 返回 token stream，每个事件是一个 token。
  /// 调用方需自行收集 token 拼接完整回复。
  Stream<String> generateStream(String prompt) {
    if (!_llama.isModelLoaded || _status != LlmEngineStatus.ready) {
      return Stream.error(
        StateError('LLM engine not ready. Current status: $_status'),
      );
    }

    _status = LlmEngineStatus.generating;

    final params = GenerationParams(
      prompt: prompt,
      temperature: LlmConstants.temperature,
      topP: LlmConstants.topP,
      maxTokens: LlmConstants.chatMaxTokens,
      repeatPenalty: LlmConstants.repeatPenalty,
      stopSequences: const ['<|im_end|>', '<|endoftext|>'],
    );

    // 将原始 stream 包装以管理状态
    final controller = StreamController<String>();
    _llama.generateStream(params).listen(
      (token) {
        controller.add(token);
      },
      onError: (e) {
        _status = LlmEngineStatus.ready;
        _lastError = e.toString();
        controller.addError(e);
      },
      onDone: () {
        _status = LlmEngineStatus.ready;
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 停止当前推理。
  Future<void> stopGeneration() async {
    try {
      await _llama.stopGeneration();
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
      await _llama.unloadModel();
    } catch (_) {
      // ignore unload errors
    }
    _status = LlmEngineStatus.unloaded;
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
