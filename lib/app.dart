import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/constants/sync_constants.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/utils/deferred_init.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart'; // re-exports service_providers
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/celebration/achievement_celebration_layer.dart';
import 'package:hachimi_app/providers/locale_provider.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/onboarding/onboarding_screen.dart';
// NotificationService accessed via notificationServiceProvider (re-exported from auth_provider)
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';
import 'package:hachimi_app/services/achievement_evaluator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HachimiApp extends ConsumerWidget {
  final Stopwatch? startupStopwatch;
  const HachimiApp({super.key, this.startupStopwatch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsService = ref.read(analyticsServiceProvider);
    final themeSettings = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Use system dynamic color when available and enabled by user
        final useDynamic =
            themeSettings.useDynamicColor && lightDynamic != null;

        return MaterialApp(
          title: 'Hachimi',
          debugShowCheckedModeBanner: false,
          theme: useDynamic
              ? AppTheme.lightThemeFromScheme(lightDynamic)
              : AppTheme.lightTheme(themeSettings.seedColor),
          darkTheme: useDynamic
              ? AppTheme.lightThemeFromScheme(darkDynamic ?? lightDynamic)
              : AppTheme.darkTheme(themeSettings.seedColor),
          themeMode: themeSettings.mode,
          locale: locale,
          // i18n support
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          home: AuthGate(startupStopwatch: startupStopwatch),
          onGenerateRoute: AppRouter.onGenerateRoute,
          navigatorObservers: [analyticsService.observer],
        );
      },
    );
  }
}

/// AuthGate — reactively switches between OnboardingScreen, LoginScreen,
/// and HomeScreen based on onboarding state + Firebase Auth state.
/// This is the SSOT for auth-based routing.
///
/// [A4] 乐观认证：cached UID 存在时直接渲染 HomeScreen，无需等待 Auth stream。
class AuthGate extends ConsumerStatefulWidget {
  final Stopwatch? startupStopwatch;
  const AuthGate({super.key, this.startupStopwatch});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _appOpenLogged = false;
  bool _isAutoSigningIn = false;
  bool _isPendingDeletionRetry = false;
  Timer? _pendingDeletionTimer;
  ProviderSubscription<bool>? _onboardingListener;

  @override
  void initState() {
    super.initState();

    _onboardingListener = ref.listenManual<bool>(onboardingCompleteProvider, (
      previous,
      next,
    ) {
      if (previous == true && next == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final navigator = Navigator.maybeOf(context);
          navigator?.popUntil((route) => route.isFirst);
        });
      }
    });

    // Google Sign-In 延迟初始化（从 DeferredInit 迁移至此，通过 Provider 获取 AuthBackend）
    Future.microtask(() async {
      try {
        await ref.read(authBackendProvider).initializeSocialLogin();
      } catch (e) {
        debugPrint('[APP] GoogleSignIn init failed: $e');
      }
    });

    _resumePendingDeletion();
    _pendingDeletionTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _resumePendingDeletion(),
    );
  }

  @override
  void dispose() {
    _pendingDeletionTimer?.cancel();
    _onboardingListener?.close();
    super.dispose();
  }

  void _onOnboardingComplete() {
    _ensureLocalUid();
    ref.read(onboardingCompleteProvider.notifier).complete();
  }

  /// 同步生成本地访客 UID — 零网络依赖，保证引导完成后立即进入主页。
  void _ensureLocalUid() {
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs.getString(AppPrefsKeys.cachedUid) != null) return;
    final guestUid = 'guest_${const Uuid().v4()}';
    prefs.setString(AppPrefsKeys.localGuestUid, guestUid);
    prefs.setString(AppPrefsKeys.cachedUid, guestUid);
  }

  /// 后台匿名登录 — 失败不影响 UI，下次联网再试。
  Future<void> _autoSignInAnonymously() async {
    if (_isAutoSigningIn) return;
    _isAutoSigningIn = true;
    try {
      await ref.read(authBackendProvider).signInAnonymously();
      debugPrint('[APP] background sign-in complete');
    } catch (e) {
      debugPrint('[APP] background sign-in failed: $e');
    } finally {
      _isAutoSigningIn = false;
    }
  }

  Future<void> _resumePendingDeletion() async {
    if (_isPendingDeletionRetry) return;
    _isPendingDeletionRetry = true;
    try {
      final changed = await ref
          .read(accountDeletionOrchestratorProvider)
          .resumePendingDeletion();
      if (changed && mounted) setState(() {});
    } finally {
      _isPendingDeletionRetry = false;
    }
  }

  Future<void> _abandonPendingDeletion() async {
    await ref
        .read(accountDeletionOrchestratorProvider)
        .abandonPendingDeletion();
    await ref.read(userProfileNotifierProvider.notifier).logout();
  }

  /// 认证用户就绪后：缓存 UID、设置 Crashlytics。
  void _handleAuthUser(AuthUser user, SharedPreferences prefs) {
    prefs.setString(AppPrefsKeys.cachedUid, user.uid);
    _applyUidObservability(user.uid);
    ErrorHandler.breadcrumb('auth_state: ${ObservabilityRuntime.uidHash}');
  }

  void _applyUidObservability(String uid) {
    ObservabilityRuntime.setUidHashFromUid(uid);
    FirebaseCrashlytics.instance.setUserIdentifier(
      ObservabilityRuntime.uidHash,
    );
  }

  /// Log app_opened analytics event with days_since_last and consecutive_days.
  /// [R3] 使用 sharedPreferencesProvider 替代独立的 SharedPreferences.getInstance()
  void _logAppOpened() {
    if (_appOpenLogged) return;
    _appOpenLogged = true;

    final prefs = ref.read(sharedPreferencesProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int daysSinceLast = 0;
    int consecutiveDays = 1;

    final lastOpenStr = prefs.getString(AppPrefsKeys.lastAppOpen);
    if (lastOpenStr != null) {
      final lastOpen = DateTime.tryParse(lastOpenStr);
      if (lastOpen != null) {
        final lastDate = DateTime(lastOpen.year, lastOpen.month, lastOpen.day);
        daysSinceLast = today.difference(lastDate).inDays;

        final savedConsecutive =
            prefs.getInt(AppPrefsKeys.consecutiveDays) ?? 1;
        if (daysSinceLast == 1) {
          consecutiveDays = savedConsecutive + 1;
        } else if (daysSinceLast == 0) {
          consecutiveDays = savedConsecutive;
        } else {
          consecutiveDays = 1;
        }
      }
    }

    prefs.setString(AppPrefsKeys.lastAppOpen, today.toIso8601String());
    prefs.setInt(AppPrefsKeys.consecutiveDays, consecutiveDays);

    ref
        .read(analyticsServiceProvider)
        .logAppOpened(
          daysSinceLast: daysSinceLast,
          consecutiveDays: consecutiveDays,
        );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingComplete = ref.watch(onboardingCompleteProvider);
    if (!onboardingComplete) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    final prefs = ref.read(sharedPreferencesProvider);
    final authState = ref.watch(authStateProvider);

    if (_hasPendingDeletion(prefs)) {
      return _PendingDeletionScreen(onAbandon: _abandonPendingDeletion);
    }

    // 已认证 → 使用认证 UID
    final AuthUser? authUser = authState.whenOrNull(data: (u) => u);
    if (authUser != null) {
      _handleAuthUser(authUser, prefs);
      _logAppOpened();
      return _FirstHabitGate(
        uid: authUser.uid,
        startupStopwatch: widget.startupStopwatch,
      );
    }

    // Firebase 未就绪 → 使用缓存 UID（_ensureLocalUid 已保证存在）
    final cachedUid = prefs.getString(AppPrefsKeys.cachedUid);
    if (cachedUid != null) {
      _applyUidObservability(cachedUid);
      _autoSignInAnonymously();
      _logAppOpened();
      return _FirstHabitGate(
        uid: cachedUid,
        startupStopwatch: widget.startupStopwatch,
      );
    }

    ObservabilityRuntime.clearUidHash();
    FirebaseCrashlytics.instance.setUserIdentifier('');

    // 无认证 + 无缓存 = 已登出，等 onboardingCompleteProvider reset 触发重建
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  bool _hasPendingDeletion(SharedPreferences prefs) {
    final tombstone = prefs.getBool(AppPrefsKeys.deletionTombstone) ?? false;
    final pending = prefs.getString(AppPrefsKeys.pendingDeletionJob);
    return tombstone || (pending != null && pending.isNotEmpty);
  }
}

class _PendingDeletionScreen extends ConsumerWidget {
  final VoidCallback onAbandon;
  const _PendingDeletionScreen({required this.onAbandon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final retryCount =
        ref
            .read(sharedPreferencesProvider)
            .getInt(AppPrefsKeys.deletionRetryCount) ??
        0;
    final showEscape = retryCount >= SyncConstants.deletionEscapeRetryThreshold;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.deleteAccountPending, textAlign: TextAlign.center),
              if (showEscape) ...[
                const SizedBox(height: AppSpacing.xl),
                TextButton(
                  onPressed: onAbandon,
                  child: Text(l10n.deleteAccountAbandon),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// _FirstHabitGate — shows HomeScreen immediately, but if the user has
/// zero habits, auto-navigates to the adoption flow with first-time messaging.
class _FirstHabitGate extends ConsumerStatefulWidget {
  final String uid;
  final Stopwatch? startupStopwatch;
  const _FirstHabitGate({required this.uid, this.startupStopwatch});

  @override
  ConsumerState<_FirstHabitGate> createState() => _FirstHabitGateState();
}

class _FirstHabitGateState extends ConsumerState<_FirstHabitGate> {
  bool _checkedFirstHabit = false;
  bool _remindersScheduled = false;
  bool _deferredInitTriggered = false;
  AchievementEvaluator? _evaluator;
  int _engineRunId = 0;

  @override
  void initState() {
    super.initState();
    _checkInterruptedSession();
    _startBackgroundEngines();

    // [A2] 延迟初始化：首帧后执行非关键任务
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_deferredInitTriggered) {
        _deferredInitTriggered = true;
        DeferredInit.run();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _FirstHabitGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      _onUidChanged();
    }
  }

  @override
  void dispose() {
    _engineRunId++;
    _evaluator?.stop();
    super.dispose();
  }

  void _onUidChanged() {
    _evaluator?.stop();
    _checkedFirstHabit = false;
    _remindersScheduled = false;
    _startBackgroundEngines();
  }

  /// 启动后台引擎：孤立数据恢复 + 数据水化 + 同步引擎 + 成就评估器。
  /// guest_ UID 跳过 Firestore 水化/同步（纯本地模式）。
  Future<void> _startBackgroundEngines() async {
    final runId = ++_engineRunId;
    final uid = widget.uid;
    final syncEngine = ref.read(syncEngineProvider);

    try {
      // Saga 补偿：检测未完成的访客迁移并恢复
      await _recoverOrphanedGuestData(uid);
      if (!mounted || runId != _engineRunId) return;

      // 先停旧引擎，避免旧 UID 同步链路残留。
      syncEngine.stop();

      if (!uid.startsWith('guest_')) {
        // 数据水化 — 首次从 Firestore 拉取已有数据到 SQLite
        await syncEngine.hydrateFromFirestore(uid);
        if (!mounted || runId != _engineRunId) return;
        syncEngine.start(uid);
      }

      // 成就评估器 — 纯本地，不需要网络
      final ledger = ref.read(ledgerServiceProvider);
      final evaluator = AchievementEvaluator(
        ledger: ledger,
        onUnlocked: (ids) {
          ref.read(newlyUnlockedProvider.notifier).addAll(ids);
        },
      );
      if (!mounted || runId != _engineRunId) return;
      _evaluator?.stop();
      _evaluator = evaluator;
      evaluator.start(uid);
    } on Exception catch (e, stack) {
      await ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'FirstHabitGate',
        operation: 'startBackgroundEngines',
        errorCode: 'background_engine_start_failed',
      );
    }
  }

  /// 检测 localGuestUid 与当前 UID 不一致 → 补偿迁移。
  /// 幂等：migrateUid 对已迁移数据是 no-op（UPDATE WHERE uid=oldUid 匹配 0 行）。
  Future<void> _recoverOrphanedGuestData(String currentUid) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final guestUid = prefs.getString(AppPrefsKeys.localGuestUid);
    if (guestUid == null || guestUid == currentUid) return;

    try {
      final ledger = ref.read(ledgerServiceProvider);
      await ledger.migrateUid(guestUid, currentUid);
      await prefs.remove(AppPrefsKeys.localGuestUid);
      await prefs.setBool(AppPrefsKeys.dataHydrated, true);
      ledger.notifyChange(const LedgerChange(type: 'hydrate'));
      debugPrint(
        '[RECOVERY] migrated orphaned guest data: $guestUid -> $currentUid',
      );
    } on Exception catch (e) {
      ErrorHandler.recordOperation(
        e,
        feature: 'FirstHabitGate',
        operation: 'recoverOrphanedGuestData',
        errorCode: 'guest_recovery_failed',
      );
    }
  }

  Future<void> _checkInterruptedSession() async {
    final hasSession = await FocusTimerNotifier.hasInterruptedSession();
    if (!mounted) return;

    if (hasSession) {
      final info = await FocusTimerNotifier.getSavedSessionInfo();
      if (!mounted || info == null) return;

      final habitName = info['habitName'] as String;
      final elapsed = info['wallClockElapsed'] as int;
      final habitId = info['habitId'] as String;
      final mins = elapsed ~/ 60;
      final secs = elapsed % 60;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final l10n = context.l10n;
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.sessionResumeTitle),
            content: Text(
              l10n.sessionResumeMessage(habitName, '${mins}m ${secs}s'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.sessionDiscard),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.sessionResumeButton),
              ),
            ],
          ),
        ).then((resume) async {
          if (!mounted) return;
          if (resume == true) {
            await ref.read(focusTimerProvider.notifier).restoreSession();
            if (mounted && habitId.isNotEmpty) {
              Navigator.of(
                context,
              ).pushNamed(AppRouter.timer, arguments: habitId);
            }
          } else {
            await FocusTimerNotifier.clearSavedState();
          }
        });
      });
    }

    // Session check complete — no state tracking needed
  }

  /// 重新调度所有有提醒的 habit 的通知。
  /// 仅在通知权限已授予时执行。
  /// [R1] 等待 DeferredInit 完成以确保 NotificationService 已初始化。
  Future<void> _rescheduleReminders(List<Habit> habits) async {
    // 在 async gap 之前缓存 context 引用
    final l10n = context.l10n;
    final fallbackCatName = l10n.focusCompleteYourCat;

    await DeferredInit.run(); // 幂等，确保通知插件已初始化
    final notifService = ref.read(notificationServiceProvider);
    final hasPermission = await notifService.isPermissionGranted();
    if (!hasPermission) return;

    final catsAsync = ref.read(catsProvider);
    final cats = catsAsync.value ?? [];

    for (final habit in habits) {
      if (habit.isActive && habit.hasReminders) {
        try {
          final cat = habit.catId != null
              ? cats.where((c) => c.id == habit.catId).firstOrNull
              : null;
          final catName = cat?.name ?? fallbackCatName;

          await notifService.scheduleReminders(
            habitId: habit.id,
            habitName: habit.name,
            catName: catName,
            reminders: habit.reminders,
            title: l10n.reminderNotificationTitle(catName),
            body: l10n.reminderNotificationBody(habit.name),
          );
        } on Exception catch (e) {
          debugPrint('[REMINDER] Failed to schedule for ${habit.id}: $e');
        }
      }
    }
  }

  /// 非访客用户是否仍在等待水化完成。
  bool get _isAwaitingHydration =>
      !widget.uid.startsWith('guest_') &&
      !(ref
              .read(sharedPreferencesProvider)
              .getBool(AppPrefsKeys.dataHydrated) ??
          false);

  /// 首次 build 时输出冷启动耗时。
  void _logStartupMetric() {
    final sw = widget.startupStopwatch;
    if (sw != null && sw.isRunning) {
      debugPrint(
        '[STARTUP] cold start to FirstHabitGate: ${sw.elapsedMilliseconds}ms',
      );
      sw.stop();
    }
  }

  /// 习惯数据就绪后判断是否为首次用户，触发领养引导或调度提醒。
  void _onHabitsLoaded(List<Habit> habits) {
    _checkedFirstHabit = true;
    if (habits.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushNamed(
            AppRouter.adoption,
            arguments: true, // isFirstHabit = true
          );
        }
      });
    } else if (!_remindersScheduled) {
      _remindersScheduled = true;
      _rescheduleReminders(habits);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logStartupMetric();

    if (!_checkedFirstHabit) {
      if (_isAwaitingHydration) {
        return const AchievementCelebrationLayer(child: HomeScreen());
      }
      ref.watch(habitsProvider).whenData(_onHabitsLoaded);
    }

    return const AchievementCelebrationLayer(child: HomeScreen());
  }
}
