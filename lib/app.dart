import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/screens/auth/login_screen.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/onboarding/onboarding_screen.dart';

class HachimiApp extends ConsumerWidget {
  const HachimiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsService = ref.read(analyticsServiceProvider);

    return MaterialApp(
      title: 'Hachimi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [analyticsService.observer],
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
        return user != null ? const HomeScreen() : const LoginScreen();
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

/// Key used in SharedPreferences to track onboarding completion.
const String kOnboardingCompleteKey = 'onboarding_complete';
