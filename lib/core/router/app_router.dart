import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/auth/components/email_auth_screen.dart';
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
import 'package:hachimi_app/screens/cat_room/accessory_shop_screen.dart';
import 'package:hachimi_app/screens/cat_room/inventory_screen.dart';
import 'package:hachimi_app/screens/check_in/check_in_screen.dart';
import 'package:hachimi_app/screens/stats/session_history_screen.dart';
import 'package:hachimi_app/screens/awareness/awareness_screen.dart';
import 'package:hachimi_app/screens/awareness/daily_light_screen.dart';
import 'package:hachimi_app/screens/awareness/weekly_review_screen.dart';
import 'package:hachimi_app/screens/awareness/worry_processor_screen.dart';
import 'package:hachimi_app/screens/awareness/worry_edit_screen.dart';
import 'package:hachimi_app/screens/awareness/daily_detail_screen.dart';
import 'package:hachimi_app/screens/journey/journey_screen.dart';
import 'package:hachimi_app/screens/journey/weekly_plan_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_plan_screen.dart';
import 'package:hachimi_app/screens/journey/yearly_plan_screen.dart';
import 'package:hachimi_app/screens/journey/list_detail_screen.dart';
import 'package:hachimi_app/screens/journey/highlight_moments_screen.dart';
import 'package:hachimi_app/screens/journey/growth_review_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_activities/habit_pact_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_activities/worry_unload_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_activities/self_praise_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_activities/support_map_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_activities/future_self_screen.dart';
import 'package:hachimi_app/screens/journey/monthly_activities/ideal_vs_real_screen.dart';
import 'package:hachimi_app/screens/onboarding/lumi_onboarding_screen.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/models/xp_result.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String home = '/home';
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
  static const String emailAuth = '/email-auth';
  static const String sessionHistory = '/session-history';
  static const String awareness = '/awareness';
  static const String dailyLight = '/daily-light';
  static const String weeklyReview = '/weekly-review';
  static const String worryProcessor = '/worry-processor';
  static const String worryEdit = '/worry-edit';
  static const String dailyDetail = '/daily-detail';
  static const String onboardingLumi = '/onboarding-lumi';
  static const String journey = '/journey';
  static const String weeklyPlan = '/weekly-plan';
  static const String monthlyPlan = '/monthly-plan';
  static const String yearlyPlan = '/yearly-plan';
  static const String listDetail = '/list-detail';
  static const String highlightMoments = '/highlight-moments';
  static const String growthReview = '/growth-review';
  static const String habitPact = '/habit-pact';
  static const String worryUnload = '/worry-unload';
  static const String selfPraise = '/self-praise';
  static const String supportMap = '/support-map';
  static const String futureSelf = '/future-self';
  static const String idealVsReal = '/ideal-vs-real';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        final linkMode = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(linkMode: linkMode),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
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
      case emailAuth:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => EmailAuthScreen(
            startAsLogin: args['startAsLogin'] as bool? ?? false,
            linkMode: args['linkMode'] as bool? ?? false,
          ),
        );
      case awareness:
        return MaterialPageRoute(builder: (_) => const AwarenessScreen());
      case dailyLight:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) =>
              DailyLightScreen(quickMode: args['quickMode'] as bool? ?? false),
        );
      case weeklyReview:
        return MaterialPageRoute(builder: (_) => const WeeklyReviewScreen());
      case worryProcessor:
        return MaterialPageRoute(builder: (_) => const WorryProcessorScreen());
      case worryEdit:
        final worryId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => WorryEditScreen(worryId: worryId),
        );
      case dailyDetail:
        final date = settings.arguments as String?;
        if (date == null) {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
        return MaterialPageRoute(builder: (_) => DailyDetailScreen(date: date));
      case onboardingLumi:
        return MaterialPageRoute(
          builder: (_) => LumiOnboardingScreen(onComplete: () {}),
        );
      case journey:
        return MaterialPageRoute(builder: (_) => const JourneyScreen());
      case weeklyPlan:
        return MaterialPageRoute(builder: (_) => const WeeklyPlanScreen());
      case monthlyPlan:
        return MaterialPageRoute(builder: (_) => const MonthlyPlanScreen());
      case yearlyPlan:
        return MaterialPageRoute(builder: (_) => const YearlyPlanScreen());
      case listDetail:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => ListDetailScreen(
            listType: args['type'] as ListType? ?? ListType.custom,
            listId: args['listId'] as String?,
          ),
        );
      case highlightMoments:
        return MaterialPageRoute(
          builder: (_) => const HighlightMomentsScreen(),
        );
      case growthReview:
        return MaterialPageRoute(builder: (_) => const GrowthReviewScreen());
      case habitPact:
        return MaterialPageRoute(builder: (_) => const HabitPactScreen());
      case worryUnload:
        return MaterialPageRoute(builder: (_) => const WorryUnloadScreen());
      case selfPraise:
        return MaterialPageRoute(builder: (_) => const SelfPraiseScreen());
      case supportMap:
        return MaterialPageRoute(builder: (_) => const SupportMapScreen());
      case futureSelf:
        return MaterialPageRoute(builder: (_) => const FutureSelfScreen());
      case idealVsReal:
        return MaterialPageRoute(builder: (_) => const IdealVsRealScreen());
      // Settings sub-pages use Shared Axis transition (horizontal)
      case sessionHistory:
        return _sharedAxisRoute((_) => const SessionHistoryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const _NotFoundScreen());
    }
  }

  /// M3 Shared Axis transition — 同级导航使用水平共享轴。
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

/// 404 页面 — 未知路由兜底。
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.explore_off_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.routeNotFound,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRouter.home, (_) => false),
              child: Text(context.l10n.routeGoHome),
            ),
          ],
        ),
      ),
    );
  }
}
