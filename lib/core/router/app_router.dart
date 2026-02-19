import 'package:flutter/material.dart';
import 'package:hachimi_app/screens/auth/login_screen.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/habits/adoption_flow_screen.dart';
import 'package:hachimi_app/screens/timer/focus_setup_screen.dart';
import 'package:hachimi_app/screens/timer/timer_screen.dart';
import 'package:hachimi_app/screens/timer/focus_complete_screen.dart';
import 'package:hachimi_app/screens/habits/habit_detail_screen.dart';
import 'package:hachimi_app/screens/cat_detail/cat_detail_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';
import 'package:hachimi_app/services/xp_service.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String home = '/home';
  static const String addHabit = '/add-habit';
  static const String adoption = '/adoption';
  static const String focusSetup = '/focus-setup';
  static const String timer = '/timer';
  static const String focusComplete = '/focus-complete';
  static const String habitDetail = '/habit-detail';
  static const String catDetail = '/cat-detail';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addHabit:
        // Redirect to adoption flow
        return MaterialPageRoute(
            builder: (_) => const AdoptionFlowScreen());
      case adoption:
        final isFirst = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => AdoptionFlowScreen(isFirstHabit: isFirst),
        );
      case focusSetup:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => FocusSetupScreen(habitId: habitId),
        );
      case timer:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TimerScreen(habitId: habitId),
        );
      case focusComplete:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FocusCompleteScreen(
            habitId: args['habitId'] as String,
            minutes: args['minutes'] as int,
            xpResult: args['xpResult'] as XpResult,
            stageUp: args['stageUp'] as StageUpResult?,
            isAbandoned: args['isAbandoned'] as bool? ?? false,
          ),
        );
      case habitDetail:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HabitDetailScreen(habitId: habitId),
        );
      case catDetail:
        final catId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CatDetailScreen(catId: catId),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
