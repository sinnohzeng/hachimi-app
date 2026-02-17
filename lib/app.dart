import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

class HachimiApp extends ConsumerWidget {
  const HachimiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final analyticsService = ref.read(analyticsServiceProvider);

    // Determine initial route based on auth state
    final initialRoute = authState.when(
      data: (user) => user != null ? AppRouter.home : AppRouter.login,
      loading: () => AppRouter.login,
      error: (_, __) => AppRouter.login,
    );

    return MaterialApp(
      title: 'Hachimi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [analyticsService.observer],
    );
  }
}
