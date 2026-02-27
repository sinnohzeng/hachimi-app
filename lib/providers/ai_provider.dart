import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/ai/gemini_provider.dart';
import 'package:hachimi_app/services/ai/minimax_provider.dart';
import 'package:hachimi_app/services/ai_service.dart';
import 'package:hachimi_app/services/chat_service.dart';
import 'package:hachimi_app/services/diary_service.dart';
import 'package:hachimi_app/services/local_database_service.dart';

// ─── Service Providers ───

final localDatabaseProvider = Provider<LocalDatabaseService>(
  (ref) => LocalDatabaseService(),
);

/// AI 门面服务 — 根据用户选择的提供商动态实例化。
final aiServiceProvider = Provider<AiService>((ref) {
  final selected = ref.watch(aiProviderSelectionProvider);
  final provider = switch (selected) {
    AiProviderId.minimax => MiniMaxProvider(),
    AiProviderId.gemini => GeminiProvider(),
  };
  return AiService(provider: provider);
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

// ─── AI Provider Selection ───

/// 可选的 AI 提供商标识。
enum AiProviderId { minimax, gemini }

/// AI 提供商选择 — 持久化到 SharedPreferences。
class AiProviderSelectionNotifier extends Notifier<AiProviderId> {
  @override
  AiProviderId build() {
    _load();
    return AiProviderId.minimax;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AiConstants.prefAiProvider);
    if (saved == AiProviderId.gemini.name) {
      state = AiProviderId.gemini;
    }
  }

  Future<void> select(AiProviderId id) async {
    state = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AiConstants.prefAiProvider, id.name);
  }
}

final aiProviderSelectionProvider =
    NotifierProvider<AiProviderSelectionNotifier, AiProviderId>(
      AiProviderSelectionNotifier.new,
    );

// ─── AI Feature Toggle ───

/// AI 功能总开关 — 持久化到 SharedPreferences。
class AiFeatureNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
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

final aiFeatureEnabledProvider = NotifierProvider<AiFeatureNotifier, bool>(
  AiFeatureNotifier.new,
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
class AiAvailabilityNotifier extends Notifier<AiAvailability> {
  @override
  AiAvailability build() {
    final enabled = ref.read(aiFeatureEnabledProvider);
    if (!enabled) return AiAvailability.disabled;
    final aiService = ref.read(aiServiceProvider);
    return aiService.isConfigured ? AiAvailability.ready : AiAvailability.error;
  }

  /// 重新检查可用性。
  void refresh() {
    final enabled = ref.read(aiFeatureEnabledProvider);
    if (!enabled) {
      state = AiAvailability.disabled;
      return;
    }
    final aiService = ref.read(aiServiceProvider);
    state = aiService.isConfigured
        ? AiAvailability.ready
        : AiAvailability.error;
  }

  /// 验证云端连接。
  Future<bool> validateConnection() async {
    final aiService = ref.read(aiServiceProvider);
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
    NotifierProvider<AiAvailabilityNotifier, AiAvailability>(
      AiAvailabilityNotifier.new,
    );
