import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';

/// 时钟函数 — 默认 DateTime.now，测试时可替换为可控时钟。
typedef Clock = DateTime Function();

/// TimerPersistence — SharedPreferences 持久化 + 壁钟计算。
///
/// 职责：
/// 1. 将 FocusTimerState 序列化/反序列化到 SharedPreferences（崩溃恢复）
/// 2. 提供壁钟锚点计算（wall-clock elapsed = now - startedAt - paused）
///
/// 所有 DateTime.now() 调用通过 [_clock] 注入，使核心路径可测试。
class TimerPersistence {
  final Clock _clock;

  TimerPersistence({Clock? clock}) : _clock = clock ?? DateTime.now;

  // ─── SharedPreferences key 定义 ───

  static const _prefix = 'focus_timer_';
  static const _keyHabitId = '${_prefix}habitId';
  static const _keyCatId = '${_prefix}catId';
  static const _keyCatName = '${_prefix}catName';
  static const _keyHabitName = '${_prefix}habitName';
  static const _keyTotalSeconds = '${_prefix}totalSeconds';
  static const _keyElapsedSeconds = '${_prefix}elapsedSeconds';
  static const _keyMode = '${_prefix}mode';
  static const _keyStartedAt = '${_prefix}startedAt';
  static const _keyTotalPausedSeconds = '${_prefix}totalPausedSeconds';
  static const _keyPausedAt = '${_prefix}pausedAt';

  /// 所有持久化 key — 用于批量清除，防止新增 key 时遗忘。
  static const _allKeys = [
    _keyHabitId,
    _keyCatId,
    _keyCatName,
    _keyHabitName,
    _keyTotalSeconds,
    _keyElapsedSeconds,
    _keyMode,
    _keyStartedAt,
    _keyTotalPausedSeconds,
    _keyPausedAt,
  ];

  static const _defaultDurationSeconds = 1500; // 25 分钟

  // ─── 壁钟计算 ───

  /// 根据壁钟锚点计算有效专注秒数 = (now - startedAt) - totalPausedSeconds。
  int computeWallClockElapsed(DateTime startedAt, int totalPausedSeconds) {
    final wallTotal = _clock().difference(startedAt).inSeconds;
    return (wallTotal - totalPausedSeconds).clamp(0, wallTotal);
  }

  /// 解析未结算的暂停时长（app 被杀时正处于暂停/后台）。
  int computePendingPauseDelta(String? pausedAtStr) {
    if (pausedAtStr == null) return 0;
    final pausedAt = DateTime.tryParse(pausedAtStr);
    return pausedAt != null ? _clock().difference(pausedAt).inSeconds : 0;
  }

  /// 获取当前时间（通过注入的时钟）。
  DateTime now() => _clock();

  // ─── 崩溃恢复：读取 ───

  /// 是否存在中断的会话。
  Future<bool> hasInterruptedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyStartedAt);
  }

  /// 获取已保存会话的摘要信息（用于恢复对话框）。
  Future<Map<String, dynamic>?> getSavedSessionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final startedAtStr = prefs.getString(_keyStartedAt);
    if (startedAtStr == null) return null;

    final startedAt = DateTime.tryParse(startedAtStr);
    if (startedAt == null) return null;

    final totalPausedSeconds =
        (prefs.getInt(_keyTotalPausedSeconds) ?? 0) +
        computePendingPauseDelta(prefs.getString(_keyPausedAt));
    final effectiveElapsed = computeWallClockElapsed(
      startedAt,
      totalPausedSeconds,
    );

    return {
      'habitId': prefs.getString(_keyHabitId) ?? '',
      'habitName': prefs.getString(_keyHabitName) ?? 'Focus',
      'wallClockElapsed': effectiveElapsed,
      'totalSeconds': prefs.getInt(_keyTotalSeconds) ?? 0,
      'mode': TimerMode.values[prefs.getInt(_keyMode) ?? 0],
    };
  }

  /// 从 SharedPreferences 恢复完整会话状态。
  Future<FocusTimerState?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final startedAtStr = prefs.getString(_keyStartedAt);
    if (startedAtStr == null) return null;

    final startedAt = DateTime.tryParse(startedAtStr);
    if (startedAt == null) return null;

    final habitId = prefs.getString(_keyHabitId) ?? '';
    final catId = prefs.getString(_keyCatId) ?? '';
    final catName = prefs.getString(_keyCatName) ?? '';
    final habitName = prefs.getString(_keyHabitName) ?? '';
    final totalSeconds =
        prefs.getInt(_keyTotalSeconds) ?? _defaultDurationSeconds;
    final modeIndex = prefs.getInt(_keyMode) ?? 0;
    final mode = TimerMode.values[modeIndex];

    final totalPausedSeconds =
        (prefs.getInt(_keyTotalPausedSeconds) ?? 0) +
        computePendingPauseDelta(prefs.getString(_keyPausedAt));
    final elapsed = computeWallClockElapsed(startedAt, totalPausedSeconds);

    // 倒计时模式：检查是否已自然完成
    final terminalStatus =
        (mode == TimerMode.countdown && elapsed >= totalSeconds)
        ? TimerStatus.completed
        : TimerStatus.paused;

    return FocusTimerState(
      habitId: habitId,
      catId: catId,
      catName: catName,
      habitName: habitName,
      totalSeconds: totalSeconds,
      elapsedSeconds: terminalStatus == TimerStatus.completed
          ? totalSeconds
          : elapsed,
      totalPausedSeconds: totalPausedSeconds,
      status: terminalStatus,
      mode: mode,
      startedAt: startedAt,
      pausedAt: terminalStatus == TimerStatus.paused ? _clock() : null,
    );
  }

  // ─── 崩溃恢复：写入 ───

  /// 持久化当前计时器状态。外包 try/catch，调用方无需处理异常。
  Future<void> saveState(FocusTimerState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _serialize(state);
      for (final entry in data.entries) {
        final value = entry.value;
        if (value is String) {
          await prefs.setString(entry.key, value);
        } else if (value is int) {
          await prefs.setInt(entry.key, value);
        }
      }
      // pausedAt 为 null 时需主动移除旧值
      if (state.pausedAt == null) {
        await prefs.remove(_keyPausedAt);
      }
    } catch (e) {
      debugPrint('[TimerPersistence] save error: $e');
    }
  }

  /// 清除所有已保存的会话数据。
  Future<void> clearSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait(_allKeys.map((k) => prefs.remove(k)));
    } catch (e) {
      debugPrint('[TimerPersistence] clear error: $e');
    }
  }

  // ─── 内部序列化 ───

  Map<String, Object> _serialize(FocusTimerState state) {
    return {
      _keyHabitId: state.habitId,
      _keyCatId: state.catId,
      _keyCatName: state.catName,
      _keyHabitName: state.habitName,
      _keyTotalSeconds: state.totalSeconds,
      _keyElapsedSeconds: state.elapsedSeconds,
      _keyTotalPausedSeconds: state.totalPausedSeconds,
      _keyMode: state.mode.index,
      if (state.startedAt != null)
        _keyStartedAt: state.startedAt!.toIso8601String(),
      if (state.pausedAt != null)
        _keyPausedAt: state.pausedAt!.toIso8601String(),
    };
  }
}

/// TimerPersistence provider — 可通过 override 注入测试时钟。
final timerPersistenceProvider = Provider<TimerPersistence>(
  (ref) => TimerPersistence(),
);
