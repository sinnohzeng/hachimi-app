import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/utils/deferred_init.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart'; // re-exports service_providers
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/achievement_celebration_overlay.dart';
import 'package:hachimi_app/providers/locale_provider.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/onboarding/onboarding_screen.dart';
// NotificationService accessed via notificationServiceProvider (re-exported from auth_provider)
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/services/achievement_evaluator.dart';

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
          builder: (context, child) {
            return AchievementCelebrationLayer(child: child!);
          },
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
  late final bool _onboardingComplete;
  bool _appOpenLogged = false;

  static const _kLastOpenKey = 'last_app_open';
  static const _kConsecutiveDaysKey = 'consecutive_days';
  static const _kCachedUidKey = 'cached_uid';

  @override
  void initState() {
    super.initState();
    // [A1] 同步读取 onboarding 状态，不再 async
    final prefs = ref.read(sharedPreferencesProvider);
    _onboardingComplete = prefs.getBool(kOnboardingCompleteKey) ?? false;
  }

  bool _isAutoSigningIn = false;

  void _onOnboardingComplete() {
    setState(() => _onboardingComplete = true);
  }

  /// 自动匿名登录 — 无需用户操作即可使用应用核心功能。
  Future<void> _autoSignInAnonymously() async {
    if (_isAutoSigningIn) return;
    _isAutoSigningIn = true;
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously();
      debugPrint('[APP] auto anonymous sign-in complete');
    } catch (e) {
      debugPrint('[APP] auto anonymous sign-in failed: $e');
    } finally {
      _isAutoSigningIn = false;
    }
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

    final lastOpenStr = prefs.getString(_kLastOpenKey);
    if (lastOpenStr != null) {
      final lastOpen = DateTime.tryParse(lastOpenStr);
      if (lastOpen != null) {
        final lastDate = DateTime(lastOpen.year, lastOpen.month, lastOpen.day);
        daysSinceLast = today.difference(lastDate).inDays;

        final savedConsecutive = prefs.getInt(_kConsecutiveDaysKey) ?? 1;
        if (daysSinceLast == 1) {
          consecutiveDays = savedConsecutive + 1;
        } else if (daysSinceLast == 0) {
          consecutiveDays = savedConsecutive;
        } else {
          consecutiveDays = 1;
        }
      }
    }

    prefs.setString(_kLastOpenKey, today.toIso8601String());
    prefs.setInt(_kConsecutiveDaysKey, consecutiveDays);

    ref
        .read(analyticsServiceProvider)
        .logAppOpened(
          daysSinceLast: daysSinceLast,
          consecutiveDays: consecutiveDays,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Show onboarding if not completed
    if (!_onboardingComplete) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    // Onboarding done — check auth state
    final authState = ref.watch(authStateProvider);
    final prefs = ref.read(sharedPreferencesProvider);

    return authState.when(
      data: (user) {
        debugPrint('[APP] authState: data, user=${user?.uid}');
        if (user == null) {
          // 无用户 — 自动匿名登录（访客模式）
          prefs.remove(_kCachedUidKey);
          _autoSignInAnonymously();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // [A4] 缓存 UID 以供下次冷启动乐观认证
        prefs.setString(_kCachedUidKey, user.uid);
        FirebaseCrashlytics.instance.setUserIdentifier(user.uid);
        ErrorHandler.breadcrumb('auth_state: ${user.uid}');
        _logAppOpened();
        return _VersionGate(
          uid: user.uid,
          startupStopwatch: widget.startupStopwatch,
        );
      },
      loading: () {
        debugPrint('[APP] authState: loading');
        // [A4] 乐观认证：cached UID 存在时直接渲染，无需等待 Auth stream
        final cachedUid = prefs.getString(_kCachedUidKey);
        if (cachedUid != null) {
          debugPrint('[APP] using cached UID for optimistic auth: $cachedUid');
          _logAppOpened();
          return _VersionGate(
            uid: cachedUid,
            startupStopwatch: widget.startupStopwatch,
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (e, _) {
        debugPrint('[APP] authState: error=$e');
        // 网络错误时也尝试匿名登录
        _autoSignInAnonymously();
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

/// _VersionGate — detects old data schema and prompts data reset.
/// Inserted between AuthGate and _FirstHabitGate.
///
/// [A3] 迁移检查缓存化：已检查过则直接跳过，不阻塞首屏。
class _VersionGate extends ConsumerStatefulWidget {
  final String uid;
  final Stopwatch? startupStopwatch;
  const _VersionGate({required this.uid, this.startupStopwatch});

  @override
  ConsumerState<_VersionGate> createState() => _VersionGateState();
}

class _VersionGateState extends ConsumerState<_VersionGate> {
  bool _needsMigration = false;
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    _checkMigration();
  }

  Future<void> _checkMigration() async {
    try {
      final migrationService = ref.read(migrationServiceProvider);
      final needs = await migrationService.checkNeedsMigration(widget.uid);

      // Lazy migrate per-cat accessories to user-level inventory
      await migrationService.migrateAccessoriesToInventory(widget.uid);

      if (mounted && needs) {
        setState(() {
          _needsMigration = true;
        });
      }
    } catch (e) {
      debugPrint('[VersionGate] migration check failed: $e');
      // 迁移检查失败时跳过，允许用户正常使用
    }
  }

  Future<void> _clearData() async {
    setState(() => _clearing = true);
    final migrationService = ref.read(migrationServiceProvider);
    await migrationService.clearAllUserData(widget.uid);
    if (mounted) {
      setState(() {
        _needsMigration = false;
        _clearing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // [A3] 默认直接渲染 _FirstHabitGate，仅在检测到需迁移时才阻塞
    if (_needsMigration) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: AppSpacing.paddingXl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🐱', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.migrationTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  context.l10n.migrationMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (_clearing)
                  const CircularProgressIndicator()
                else
                  FilledButton.icon(
                    onPressed: _clearData,
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.migrationResetButton),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return _FirstHabitGate(
      uid: widget.uid,
      startupStopwatch: widget.startupStopwatch,
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
  void dispose() {
    _evaluator?.stop();
    ref.read(syncEngineProvider).stop();
    super.dispose();
  }

  /// 启动后台引擎：同步引擎 + 成就评估器。
  void _startBackgroundEngines() {
    final uid = widget.uid;

    // 同步引擎 — 将本地台账推送到 Firestore
    ref.read(syncEngineProvider).start(uid);

    // 成就评估器 — 监听台账变更自动评估
    final ledger = ref.read(ledgerServiceProvider);
    _evaluator = AchievementEvaluator(
      ledger: ledger,
      onUnlocked: (ids) {
        ref.read(newlyUnlockedProvider.notifier).addAll(ids);
      },
    );
    _evaluator!.start(uid);
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

  @override
  Widget build(BuildContext context) {
    // [R6] 冷启动度量 — 首次 build 时输出启动耗时
    if (widget.startupStopwatch != null && widget.startupStopwatch!.isRunning) {
      debugPrint(
        '[STARTUP] cold start to FirstHabitGate: '
        '${widget.startupStopwatch!.elapsedMilliseconds}ms',
      );
      widget.startupStopwatch!.stop();
    }

    final habitsAsync = ref.watch(habitsProvider);

    // Once habits load, check if this is a first-time user
    if (!_checkedFirstHabit) {
      habitsAsync.whenData((habits) {
        if (habits.isEmpty) {
          _checkedFirstHabit = true;
          // Navigate to adoption flow after build completes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushNamed(
                AppRouter.adoption,
                arguments: true, // isFirstHabit = true
              );
            }
          });
        } else {
          _checkedFirstHabit = true;
          // Reschedule reminders for all active habits on app startup
          if (!_remindersScheduled) {
            _remindersScheduled = true;
            _rescheduleReminders(habits);
          }
        }
      });
    }

    return const HomeScreen();
  }
}

/// Key used in SharedPreferences to track onboarding completion.
const String kOnboardingCompleteKey = 'onboarding_complete';
