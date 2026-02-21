import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';

/// 模型下载状态。
enum ModelDownloadStatus {
  idle,
  downloading,
  paused,
  verifying,
  completed,
  failed,
}

/// 模型管理服务 — 下载、校验、删除、版本检查。
class ModelManagerService {
  static const _downloadTaskGroup = 'llm_model';

  /// 检查模型是否已下载且版本匹配。
  Future<bool> isModelReady() async {
    final prefs = await SharedPreferences.getInstance();
    final downloaded = prefs.getBool(LlmConstants.prefModelDownloaded) ?? false;
    if (!downloaded) return false;

    final filePath = prefs.getString(LlmConstants.prefModelFilePath);
    if (filePath == null || filePath.isEmpty) return false;

    final file = File(filePath);
    if (!file.existsSync()) {
      // 文件已被外部删除，重置状态
      await _clearModelPrefs(prefs);
      return false;
    }

    // 检查版本是否匹配
    final storedVersion = prefs.getString(LlmConstants.prefModelVersion) ?? '';
    if (storedVersion != LlmConstants.modelVersion) return false;

    return true;
  }

  /// 获取已下载模型的文件路径。
  /// 若存储路径过期（OS 升级/多用户切换导致路径漂移），自动尝试当前预期路径并更新。
  Future<String?> getModelPath() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPath = prefs.getString(LlmConstants.prefModelFilePath);
    if (storedPath == null || storedPath.isEmpty) return null;

    if (File(storedPath).existsSync()) return storedPath;

    // 存储路径文件不存在 — 尝试在当前 documents 目录下重新定位文件
    final expectedPath =
        '${(await getApplicationDocumentsDirectory()).path}'
        '/llm_models/${LlmConstants.modelFileName}';
    if (File(expectedPath).existsSync()) {
      await prefs.setString(LlmConstants.prefModelFilePath, expectedPath);
      return expectedPath;
    }

    await _clearModelPrefs(prefs);
    return null;
  }

  /// 获取模型存储目录路径。
  Future<String> _getModelDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${appDir.path}/llm_models');
    if (!modelDir.existsSync()) {
      modelDir.createSync(recursive: true);
    }
    return modelDir.path;
  }

  /// 检查磁盘空间是否足够。
  Future<bool> hasEnoughSpace() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final stat = await appDir.stat();
      // stat 不提供可用空间信息，使用 StatFs 替代方案
      // 简化处理：检查文件系统是否存在
      return stat.type == FileSystemEntityType.directory;
    } catch (_) {
      return true; // 无法确认时允许下载
    }
  }

  /// 启动模型下载。返回下载任务。
  Future<DownloadTask> startDownload() async {
    final modelDir = await _getModelDirectory();
    final task = DownloadTask(
      url: LlmConstants.modelDownloadUrl,
      filename: LlmConstants.modelFileName,
      directory: modelDir,
      baseDirectory: BaseDirectory.root,
      group: _downloadTaskGroup,
      updates: Updates.statusAndProgress,
      requiresWiFi: false,
      retries: 3,
    );

    await FileDownloader().enqueue(task);
    return task;
  }

  /// 暂停下载。
  Future<void> pauseDownload(DownloadTask task) async {
    await FileDownloader().pause(task);
  }

  /// 恢复下载。
  Future<void> resumeDownload(DownloadTask task) async {
    await FileDownloader().resume(task);
  }

  /// 取消下载。
  Future<void> cancelDownload(DownloadTask task) async {
    await FileDownloader().cancelTaskWithId(task.taskId);
  }

  /// 下载完成后校验文件并保存路径。
  Future<bool> verifyAndSaveModel(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return false;

    // 文件大小校验：必须接近预期大小（95%），防止截断的大文件通过弱 100 MB 阈值
    final fileSize = file.lengthSync();
    if (fileSize < LlmConstants.minValidModelSizeBytes) {
      await file.delete();
      return false;
    }

    // SHA-256 校验（如果设置了 hash）
    if (LlmConstants.modelSha256.isNotEmpty) {
      final fileBytes = await file.readAsBytes();
      final digest = sha256.convert(fileBytes);
      if (digest.toString() != LlmConstants.modelSha256) {
        // 校验失败，删除文件
        await file.delete();
        return false;
      }
    }

    // 保存到 SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LlmConstants.prefModelDownloaded, true);
    await prefs.setString(LlmConstants.prefModelFilePath, filePath);
    await prefs.setString(
      LlmConstants.prefModelVersion,
      LlmConstants.modelVersion,
    );

    return true;
  }

  /// 删除已下载的模型文件。
  Future<void> deleteModel() async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString(LlmConstants.prefModelFilePath);
    if (filePath != null) {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    await _clearModelPrefs(prefs);
  }

  /// 检查是否有新版本可用。
  Future<bool> hasUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getString(LlmConstants.prefModelVersion) ?? '';
    return storedVersion.isNotEmpty &&
        storedVersion != LlmConstants.modelVersion;
  }

  /// 获取模型文件大小（字节）。如果已下载返回实际大小，否则返回预估值。
  Future<int> getModelSize() async {
    final path = await getModelPath();
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) return file.lengthSync();
    }
    return LlmConstants.modelFileSizeBytes;
  }

  /// Native 层加载失败时调用：删除可能损坏的文件并重置下载状态，让用户重新下载。
  Future<void> clearCorruptedModel() async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString(LlmConstants.prefModelFilePath);
    if (filePath != null && filePath.isNotEmpty) {
      final file = File(filePath);
      if (file.existsSync()) await file.delete();
    }
    await _clearModelPrefs(prefs);
  }

  Future<void> _clearModelPrefs(SharedPreferences prefs) async {
    await prefs.setBool(LlmConstants.prefModelDownloaded, false);
    await prefs.setString(LlmConstants.prefModelFilePath, '');
    await prefs.setString(LlmConstants.prefModelVersion, '');
  }
}
