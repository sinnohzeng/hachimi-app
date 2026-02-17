import 'package:flutter/material.dart';
import 'package:hachimi_app/screens/auth/login_screen.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/habits/add_habit_screen.dart';
import 'package:hachimi_app/screens/timer/timer_screen.dart';
import 'package:hachimi_app/screens/habits/habit_detail_screen.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String home = '/home';
  static const String addHabit = '/add-habit';
  static const String timer = '/timer';
  static const String habitDetail = '/habit-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addHabit:
        return MaterialPageRoute(builder: (_) => const AddHabitScreen());
      case timer:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TimerScreen(habitId: habitId),
        );
      case habitDetail:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HabitDetailScreen(habitId: habitId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
