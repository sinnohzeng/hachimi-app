import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/screens/auth/login_screen.dart';
import 'package:hachimi_app/screens/home/home_screen.dart';
import 'package:hachimi_app/screens/habits/adoption_flow_screen.dart';
import 'package:hachimi_app/screens/timer/focus_setup_screen.dart';
import 'package:hachimi_app/screens/timer/timer_screen.dart';
import 'package:hachimi_app/screens/timer/focus_complete_screen.dart';
import 'package:hachimi_app/screens/habits/habit_detail_screen.dart';
import 'package:hachimi_app/screens/cat_detail/cat_detail_screen.dart';
import 'package:hachimi_app/screens/cat_detail/cat_diary_screen.dart';
import 'package:hachimi_app/screens/cat_detail/cat_chat_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';
import 'package:hachimi_app/screens/settings/settings_screen.dart';
import 'package:hachimi_app/screens/settings/ai_settings_page.dart';
import 'package:hachimi_app/screens/settings/model_test_chat_screen.dart';
import 'package:hachimi_app/screens/cat_room/accessory_shop_screen.dart';
import 'package:hachimi_app/screens/cat_room/inventory_screen.dart';
import 'package:hachimi_app/screens/check_in/check_in_screen.dart';
import 'package:hachimi_app/screens/stats/session_history_screen.dart';
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
  static const String settingsPage = '/settings';
  static const String accessoryShop = '/accessory-shop';
  static const String inventory = '/inventory';
  static const String checkIn = '/check-in';
  static const String catDiary = '/cat-diary';
  static const String catChat = '/cat-chat';
  static const String aiSettings = '/ai-settings';
  static const String modelTestChat = '/model-test-chat';
  static const String sessionHistory = '/session-history';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addHabit:
        // Redirect to adoption flow
        return MaterialPageRoute(builder: (_) => const AdoptionFlowScreen());
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
        return MaterialPageRoute(builder: (_) => TimerScreen(habitId: habitId));
      case focusComplete:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FocusCompleteScreen(
            habitId: args['habitId'] as String,
            minutes: args['minutes'] as int,
            xpResult: args['xpResult'] as XpResult,
            stageUp: args['stageUp'] as StageUpResult?,
            isAbandoned: args['isAbandoned'] as bool? ?? false,
            coinsEarned: args['coinsEarned'] as int? ?? 0,
          ),
        );
      case habitDetail:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HabitDetailScreen(habitId: habitId),
        );
      case catDetail:
        final catId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CatDetailScreen(catId: catId));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case accessoryShop:
        return MaterialPageRoute(builder: (_) => const AccessoryShopScreen());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryScreen());
      case checkIn:
        return MaterialPageRoute(builder: (_) => const CheckInScreen());
      case catDiary:
        final catId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CatDiaryScreen(catId: catId));
      case catChat:
        final catId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CatChatScreen(catId: catId));
      // Settings sub-pages use Shared Axis transition (horizontal)
      case aiSettings:
        return _sharedAxisRoute((_) => const AiSettingsPage());
      case modelTestChat:
        return _sharedAxisRoute((_) => const ModelTestChatScreen());
      case sessionHistory:
        return _sharedAxisRoute((_) => const SessionHistoryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }

  /// M3 Shared Axis transition (horizontal) for same-level navigation.
  static Route<T> _sharedAxisRoute<T>(WidgetBuilder builder) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          ),
      transitionDuration: AppMotion.durationMedium2,
      reverseTransitionDuration: AppMotion.durationMedium2,
    );
  }
}
