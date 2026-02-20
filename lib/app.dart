import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/focus_timer_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/locale_provider.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/screens/auth/login_screen.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/onboarding/onboarding_screen.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'package:hachimi_app/providers/cat_provider.dart';

class HachimiApp extends ConsumerWidget {
  const HachimiApp({super.key});

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
              ? AppTheme.lightThemeFromScheme(darkDynamic!)
              : AppTheme.darkTheme(themeSettings.seedColor),
          themeMode: themeSettings.mode,
          locale: locale,
          // i18n support
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          home: const AuthGate(),
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
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete =
          prefs.getBool(kOnboardingCompleteKey) ?? false;
    });
  }

  void _onOnboardingComplete() {
    setState(() => _onboardingComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    // Still loading onboarding state
    if (_onboardingComplete == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show onboarding if not completed
    if (!_onboardingComplete!) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    // Onboarding done — check auth state
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        debugPrint('[APP] authState: data, user=${user?.uid}');
        if (user == null) return const LoginScreen();
        return _VersionGate(uid: user.uid);
      },
      loading: () {
        debugPrint('[APP] authState: loading');
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (e, __) {
        debugPrint('[APP] authState: error=$e');
        return const LoginScreen();
      },
    );
  }
}

/// _VersionGate — detects old data schema and prompts data reset.
/// Inserted between AuthGate and _FirstHabitGate.
class _VersionGate extends ConsumerStatefulWidget {
  final String uid;
  const _VersionGate({required this.uid});

  @override
  ConsumerState<_VersionGate> createState() => _VersionGateState();
}

class _VersionGateState extends ConsumerState<_VersionGate> {
  bool _checked = false;
  bool _needsMigration = false;
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    _checkMigration();
  }

  Future<void> _checkMigration() async {
    final migrationService = ref.read(migrationServiceProvider);
    final needs = await migrationService.checkNeedsMigration(widget.uid);

    // Lazy migrate per-cat accessories to user-level inventory
    await migrationService.migrateAccessoriesToInventory(widget.uid);

    if (mounted) {
      setState(() {
        _checked = true;
        _needsMigration = needs;
      });
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
    if (!_checked) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_needsMigration) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: AppSpacing.paddingXl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🐱',
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.migrationTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  context.l10n.migrationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
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

    return _FirstHabitGate(uid: widget.uid);
  }
}

/// _FirstHabitGate — shows HomeScreen immediately, but if the user has
/// zero habits, auto-navigates to the adoption flow with first-time messaging.
class _FirstHabitGate extends ConsumerStatefulWidget {
  final String uid;
  const _FirstHabitGate({required this.uid});

  @override
  ConsumerState<_FirstHabitGate> createState() => _FirstHabitGateState();
}

class _FirstHabitGateState extends ConsumerState<_FirstHabitGate> {
  bool _checkedFirstHabit = false;
  bool _remindersScheduled = false;

  @override
  void initState() {
    super.initState();
    _checkInterruptedSession();
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
              Navigator.of(context).pushNamed(
                AppRouter.timer,
                arguments: habitId,
              );
            }
          } else {
            await FocusTimerNotifier.clearSavedState();
          }
        });
      });
    }

    // Session check complete — no state tracking needed
  }

  /// Reschedule daily reminders for all active habits with reminderTime set.
  /// Only runs if notification permission is already granted.
  Future<void> _rescheduleReminders(List<Habit> habits) async {
    final notifService = NotificationService();
    final hasPermission = await notifService.isPermissionGranted();
    if (!hasPermission) return;

    final catsAsync = ref.read(catsProvider);
    final cats = catsAsync.value ?? [];

    for (final habit in habits) {
      if (habit.isActive && habit.reminderTime != null) {
        final parts = habit.reminderTime!.split(':');
        if (parts.length != 2) continue;
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour == null || minute == null) continue;

        // Find the cat name for the notification
        final cat = habit.catId != null
            ? cats.where((c) => c.id == habit.catId).firstOrNull
            : null;
        final catName = cat?.name ?? 'Your cat';

        await notifService.scheduleDailyReminder(
          habitId: habit.id,
          habitName: habit.name,
          catName: catName,
          hour: hour,
          minute: minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
