import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/ai/firebase_ai_provider.dart';
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
    AiProviderId.firebaseGemini => FirebaseAiProvider(),
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
enum AiProviderId { firebaseGemini }

extension AiProviderIdWire on AiProviderId {
  String get wireValue => switch (this) {
    AiProviderId.firebaseGemini => 'firebase_gemini',
  };

  static AiProviderId fromWireValue(String? value) {
    return switch (value) {
      'firebase_gemini' => AiProviderId.firebaseGemini,
      _ => AiProviderId.firebaseGemini,
    };
  }
}

/// AI 提供商选择 — 持久化到 SharedPreferences。
class AiProviderSelectionNotifier extends Notifier<AiProviderId> {
  @override
  AiProviderId build() {
    _load();
    return AiProviderId.firebaseGemini;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AiConstants.prefAiProvider);
    final parsed = AiProviderIdWire.fromWireValue(saved);
    state = parsed;
    await prefs.setString(AiConstants.prefAiProvider, parsed.wireValue);
  }

  Future<void> select(AiProviderId id) async {
    state = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AiConstants.prefAiProvider, id.wireValue);
  }
}

final aiProviderSelectionProvider =
    NotifierProvider<AiProviderSelectionNotifier, AiProviderId>(
      AiProviderSelectionNotifier.new,
    );

// ─── AI Availability ───

/// AI 可用性状态（2 态：always-on 架构）。
enum AiAvailability {
  /// 云端 AI 已就绪。
  ready,

  /// 配置或连接异常。
  error,
}

/// AI 可用性状态机 — 懒验证 + 断路器。
///
/// - 乐观策略：`build()` 返回 `ready`，后台异步验证连接。
/// - 断路器：连续 3 次失败 → 5 分钟回退期，不再重试。
/// - 回退到期后自动进入 half-open 状态（下次请求探测）。
class AiAvailabilityNotifier extends Notifier<AiAvailability> {
  bool _validated = false;
  int _consecutiveFailures = 0;
  DateTime? _backoffUntil;

  static const _maxFailures = 3;
  static const _backoffDuration = Duration(minutes: 5);

  @override
  AiAvailability build() {
    final aiService = ref.read(aiServiceProvider);
    if (!aiService.isConfigured) return AiAvailability.error;
    if (!_validated) _lazyValidate();
    return AiAvailability.ready; // 乐观返回
  }

  /// 后台异步验证连接。
  Future<void> _lazyValidate() async {
    if (_isInBackoff) return;
    try {
      final ok = await ref.read(aiServiceProvider).validateConnection();
      _validated = true;
      if (ok) {
        _consecutiveFailures = 0;
        state = AiAvailability.ready;
      } else {
        _consecutiveFailures++;
        state = AiAvailability.error;
        _applyBackoff();
      }
    } catch (e, stack) {
      _validated = true;
      _consecutiveFailures++;
      state = AiAvailability.error;
      _applyBackoff();
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AiAvailabilityNotifier',
        operation: 'lazyValidate',
      );
    }
  }

  /// 重新检查可用性（重置断路器）。
  void refresh() {
    _validated = false;
    _consecutiveFailures = 0;
    _backoffUntil = null;
    final aiService = ref.read(aiServiceProvider);
    if (!aiService.isConfigured) {
      state = AiAvailability.error;
      return;
    }
    state = AiAvailability.ready;
    _lazyValidate();
  }

  /// 验证云端连接。
  Future<bool> validateConnection() async {
    try {
      final ok = await ref.read(aiServiceProvider).validateConnection();
      if (ok) {
        _consecutiveFailures = 0;
        _backoffUntil = null;
      } else {
        _consecutiveFailures++;
        _applyBackoff();
      }
      state = ok ? AiAvailability.ready : AiAvailability.error;
      return ok;
    } catch (e, stack) {
      _consecutiveFailures++;
      _applyBackoff();
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AiAvailabilityNotifier',
        operation: 'validateConnection',
      );
      state = AiAvailability.error;
      return false;
    }
  }

  /// 记录外部失败（如 DiaryService / ChatService 调用失败）。
  void recordFailure() {
    _consecutiveFailures++;
    _applyBackoff();
    if (_consecutiveFailures >= _maxFailures) {
      state = AiAvailability.error;
    }
  }

  /// 记录外部成功（重置断路器）。
  void recordSuccess() {
    _consecutiveFailures = 0;
    _backoffUntil = null;
    state = AiAvailability.ready;
  }

  void setError() => state = AiAvailability.error;

  bool get _isInBackoff =>
      _backoffUntil != null && DateTime.now().isBefore(_backoffUntil!);

  void _applyBackoff() {
    if (_consecutiveFailures >= _maxFailures) {
      _backoffUntil = DateTime.now().add(_backoffDuration);
      debugPrint(
        '[AiAvailability] Circuit breaker open — '
        'backoff until $_backoffUntil',
      );
    }
  }
}

final aiAvailabilityProvider =
    NotifierProvider<AiAvailabilityNotifier, AiAvailability>(
      AiAvailabilityNotifier.new,
    );
