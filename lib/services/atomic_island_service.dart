// ---
// 📘 文件说明：
// 原子岛通知服务 — 通过 MethodChannel 调用原生 Kotlin 富通知构建器，
// 触发 vivo 原子岛展示和 Android 16 ProgressStyle 锁屏。
//
// 📋 程序整体伪代码（中文）：
// 1. updateNotification() 发送计时器元数据到原生层；
// 2. cancel() 取消富通知；
// 3. 所有调用静默失败 — flutter_foreground_task 基础通知作为 fallback；
//
// 🧩 文件结构：
// - AtomicIslandService：静态方法类，平台通道封装；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/services.dart';

/// AtomicIslandService — platform channel wrapper for vivo Atomic Island
/// rich notification. Silently falls back to flutter_foreground_task's
/// basic notification if the native call fails.
class AtomicIslandService {
  static const _channel = MethodChannel('com.hachimi.notification');

  /// Update the rich timer notification for Atomic Island display.
  static Future<void> updateNotification({
    required String title,
    required String text,
    required bool isCountdown,
    required bool isPaused,
    int? endTimeMs,
    int? startTimeMs,
  }) async {
    try {
      await _channel.invokeMethod('updateTimerNotification', {
        'title': title,
        'text': text,
        'subText': 'Hachimi',
        'isCountdown': isCountdown,
        'isPaused': isPaused,
        'endTimeMs': endTimeMs,
        'startTimeMs': startTimeMs,
      });
    } catch (_) {
      // 静默失败 — flutter_foreground_task 的基础通知仍作为 fallback
    }
  }

  /// Cancel the rich timer notification.
  static Future<void> cancel() async {
    try {
      await _channel.invokeMethod('cancelTimerNotification');
    } catch (_) {
      // 静默失败
    }
  }
}
