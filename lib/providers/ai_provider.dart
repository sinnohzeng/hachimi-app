import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/ai/minimax_provider.dart';
import 'package:hachimi_app/services/ai_service.dart';
import 'package:hachimi_app/services/chat_service.dart';
import 'package:hachimi_app/services/diary_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';

// ─── Service Providers ───

final localDatabaseProvider = Provider<LocalDatabaseService>(
  (ref) => LocalDatabaseService(),
);

/// AI 门面服务 — 持有当前活跃的 AiProvider 实例。
final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(provider: MiniMaxProvider());
});

final diaryServiceProvider = Provider<DiaryService>((ref) {
  return DiaryService(
    aiService: ref.watch(aiServiceProvider),
    dbService: ref.watch(localDatabaseProvider),
  );
});

final chatServiceProvider = Provider<ChatService>((ref) {
  final service = ChatService(
    aiService: ref.watch(aiServiceProvider),
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
    state = prefs.getBool(AiConstants.prefAiEnabled) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AiConstants.prefAiEnabled, state);
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AiConstants.prefAiEnabled, value);
  }
}

final aiFeatureEnabledProvider = StateNotifierProvider<AiFeatureNotifier, bool>(
  (ref) => AiFeatureNotifier(),
);

// ─── AI Availability ───

/// AI 可用性状态（3 态）。
enum AiAvailability {
  /// AI 功能已停用。
  disabled,

  /// 云端 AI 已就绪。
  ready,

  /// 配置或连接异常。
  error,
}

/// AI 可用性状态机。
class AiAvailabilityNotifier extends StateNotifier<AiAvailability> {
  final Ref _ref;

  AiAvailabilityNotifier(this._ref) : super(AiAvailability.disabled) {
    _check();
  }

  void _check() {
    final enabled = _ref.read(aiFeatureEnabledProvider);
    if (!enabled) {
      state = AiAvailability.disabled;
      return;
    }

    final aiService = _ref.read(aiServiceProvider);
    state = aiService.isConfigured
        ? AiAvailability.ready
        : AiAvailability.error;
  }

  /// 重新检查可用性。
  void refresh() => _check();

  /// 验证云端连接。
  Future<bool> validateConnection() async {
    final aiService = _ref.read(aiServiceProvider);
    try {
      final ok = await aiService.validateConnection();
      state = ok ? AiAvailability.ready : AiAvailability.error;
      return ok;
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AiAvailabilityNotifier',
        operation: 'validateConnection',
      );
      state = AiAvailability.error;
      return false;
    }
  }

  void setError() => state = AiAvailability.error;
  void setDisabled() => state = AiAvailability.disabled;
}

final aiAvailabilityProvider =
    StateNotifierProvider<AiAvailabilityNotifier, AiAvailability>(
      AiAvailabilityNotifier.new,
    );
