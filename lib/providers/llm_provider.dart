import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart' show LlamaException;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/llm_service.dart';
import 'package:hachimi_app/services/model_manager_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';
import 'package:hachimi_app/services/diary_service.dart';
import 'package:hachimi_app/services/chat_service.dart';

// ─── Service Providers ───

final modelManagerProvider = Provider<ModelManagerService>(
  (ref) => ModelManagerService(),
);

final localDatabaseProvider = Provider<LocalDatabaseService>(
  (ref) => LocalDatabaseService(),
);

final llmServiceInstanceProvider = Provider<LlmService>((ref) => LlmService());

final diaryServiceProvider = Provider<DiaryService>((ref) {
  return DiaryService(
    llmService: ref.watch(llmServiceInstanceProvider),
    dbService: ref.watch(localDatabaseProvider),
  );
});

final chatServiceProvider = Provider<ChatService>((ref) {
  final service = ChatService(
    llmService: ref.watch(llmServiceInstanceProvider),
    dbService: ref.watch(localDatabaseProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

// ─── AI Feature Toggle ───

/// AI 功能总开关 — 持久化到 SharedPreferences。
class AiFeatureNotifier extends StateNotifier<bool> {
  AiFeatureNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(LlmConstants.prefAiEnabled) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LlmConstants.prefAiEnabled, state);
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LlmConstants.prefAiEnabled, value);
  }
}

final aiFeatureEnabledProvider = StateNotifierProvider<AiFeatureNotifier, bool>(
  (ref) => AiFeatureNotifier(),
);

// ─── LLM Availability ───

/// LLM 可用性状态。
enum LlmAvailability {
  featureDisabled,
  modelNotDownloaded,
  modelLoading,
  ready,
  error,
}

/// LLM 可用性状态机。
class LlmAvailabilityNotifier extends StateNotifier<LlmAvailability> {
  final Ref _ref;

  LlmAvailabilityNotifier(this._ref) : super(LlmAvailability.featureDisabled) {
    _check();
  }

  Future<void> _check() async {
    final enabled = _ref.read(aiFeatureEnabledProvider);
    if (!enabled) {
      state = LlmAvailability.featureDisabled;
      return;
    }

    final manager = _ref.read(modelManagerProvider);
    final ready = await manager.isModelReady();
    if (!ready) {
      state = LlmAvailability.modelNotDownloaded;
      return;
    }

    state = LlmAvailability.ready;
  }

  /// 重新检查可用性状态。
  Future<void> refresh() async {
    await _check();
  }

  /// 加载模型到内存。
  /// 若 native 层返回"Could not load model"，说明文件已损坏，自动清理并重置为待下载状态。
  Future<void> loadModel() async {
    state = LlmAvailability.modelLoading;
    try {
      final manager = _ref.read(modelManagerProvider);
      final modelPath = await manager.getModelPath();
      if (modelPath == null) {
        state = LlmAvailability.modelNotDownloaded;
        return;
      }

      final llmService = _ref.read(llmServiceInstanceProvider);
      await llmService.loadModel(modelPath);
      ErrorHandler.breadcrumb('llm_model_loaded: $modelPath');
      state = LlmAvailability.ready;
    } on LlamaException catch (e) {
      final msg = e.toString();
      // native 加载失败或文件不完整 → 文件已损坏，清理后让用户重新下载
      if (msg.contains('Could not load model') || msg.contains('incomplete')) {
        await _ref.read(modelManagerProvider).clearCorruptedModel();
        state = LlmAvailability.modelNotDownloaded;
      } else {
        state = LlmAvailability.error;
      }
      rethrow;
    } catch (e) {
      state = LlmAvailability.error;
      rethrow;
    }
  }

  /// 卸载模型。
  Future<void> unloadModel() async {
    final llmService = _ref.read(llmServiceInstanceProvider);
    await llmService.unloadModel();
    state = LlmAvailability.modelNotDownloaded;
  }

  void setError() => state = LlmAvailability.error;
  void setDisabled() => state = LlmAvailability.featureDisabled;
}

final llmAvailabilityProvider =
    StateNotifierProvider<LlmAvailabilityNotifier, LlmAvailability>(
      LlmAvailabilityNotifier.new,
    );

// ─── Model Download Progress ───

/// 模型下载进度状态。
class ModelDownloadState {
  final bool isDownloading;
  final bool isPaused;
  final double progress; // 0.0 - 1.0
  final int downloadedBytes;
  final int totalBytes;
  final String? error;
  final DownloadTask? task;

  const ModelDownloadState({
    this.isDownloading = false,
    this.isPaused = false,
    this.progress = 0.0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.error,
    this.task,
  });

  ModelDownloadState copyWith({
    bool? isDownloading,
    bool? isPaused,
    double? progress,
    int? downloadedBytes,
    int? totalBytes,
    String? error,
    DownloadTask? task,
  }) {
    return ModelDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      isPaused: isPaused ?? this.isPaused,
      progress: progress ?? this.progress,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      error: error,
      task: task ?? this.task,
    );
  }
}

/// 模型下载控制器。
class ModelDownloadNotifier extends StateNotifier<ModelDownloadState> {
  final Ref _ref;
  StreamSubscription<TaskUpdate>? _updatesSub;

  ModelDownloadNotifier(this._ref) : super(const ModelDownloadState());

  /// 开始下载模型。
  Future<void> startDownload() async {
    if (state.isDownloading) return;

    final manager = _ref.read(modelManagerProvider);

    try {
      final task = await manager.startDownload();

      state = state.copyWith(
        isDownloading: true,
        isPaused: false,
        progress: 0.0,
        error: null,
        task: task,
      );

      // 监听下载进度（取消旧订阅，避免泄漏）
      await _updatesSub?.cancel();
      _updatesSub = FileDownloader().updates.listen((update) {
        if (update is TaskStatusUpdate) {
          _handleStatusUpdate(update);
        } else if (update is TaskProgressUpdate) {
          _handleProgressUpdate(update);
        }
      });
    } catch (e) {
      state = state.copyWith(isDownloading: false, error: e.toString());
    }
  }

  void _handleStatusUpdate(TaskStatusUpdate update) {
    switch (update.status) {
      case TaskStatus.complete:
        _onDownloadComplete(update.task as DownloadTask);
      case TaskStatus.failed:
        state = state.copyWith(isDownloading: false, error: 'Download failed');
      case TaskStatus.canceled:
        state = const ModelDownloadState();
      case TaskStatus.paused:
        state = state.copyWith(isPaused: true);
      case TaskStatus.running:
        state = state.copyWith(isPaused: false, isDownloading: true);
      default:
        break;
    }
  }

  void _handleProgressUpdate(TaskProgressUpdate update) {
    final expectedSize = update.expectedFileSize;
    final downloaded = expectedSize > 0
        ? (update.progress * expectedSize).round()
        : 0;

    state = state.copyWith(
      progress: update.progress.clamp(0.0, 1.0),
      downloadedBytes: downloaded,
      totalBytes: expectedSize > 0
          ? expectedSize
          : LlmConstants.modelFileSizeBytes,
    );
  }

  Future<void> _onDownloadComplete(DownloadTask task) async {
    final manager = _ref.read(modelManagerProvider);
    final filePath = await task.filePath();

    final verified = await manager.verifyAndSaveModel(filePath);
    if (verified) {
      state = state.copyWith(isDownloading: false, progress: 1.0);
      // 刷新 LLM 可用性
      _ref.read(llmAvailabilityProvider.notifier).refresh();
    } else {
      state = state.copyWith(
        isDownloading: false,
        error: 'Model verification failed',
      );
    }
  }

  /// 暂停下载。
  Future<void> pause() async {
    final task = state.task;
    if (task == null) return;
    await _ref.read(modelManagerProvider).pauseDownload(task);
  }

  /// 恢复下载。
  Future<void> resume() async {
    final task = state.task;
    if (task == null) return;
    await _ref.read(modelManagerProvider).resumeDownload(task);
  }

  /// 取消下载。
  Future<void> cancel() async {
    final task = state.task;
    if (task == null) return;
    await _ref.read(modelManagerProvider).cancelDownload(task);
    state = const ModelDownloadState();
  }

  @override
  void dispose() {
    _updatesSub?.cancel();
    super.dispose();
  }
}

final modelDownloadProvider =
    StateNotifierProvider<ModelDownloadNotifier, ModelDownloadState>(
      ModelDownloadNotifier.new,
    );
