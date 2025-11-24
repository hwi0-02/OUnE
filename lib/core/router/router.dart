import 'package:app_project/features/auth/onboarding_screen.dart';
import 'package:app_project/features/auth/profile_setup_screen.dart';
import 'package:app_project/features/calendar/calendar_screen.dart';
import 'package:app_project/features/compatibility/compatibility_input_screen.dart';
import 'package:app_project/features/compatibility/compatibility_result_screen.dart';
import 'package:app_project/features/compatibility/services/compatibility_service.dart';
import 'package:app_project/features/dream/dream_search_screen.dart';
import 'package:app_project/features/fun/fun_content_screen.dart';
import 'package:app_project/features/home/detailed_fortune_screen.dart';
import 'package:app_project/features/home/home_screen.dart';
import 'package:app_project/features/name_analysis/name_analysis_screen.dart';
import 'package:app_project/features/rewards/check_in_screen.dart';
import 'package:app_project/features/settings/saju_settings_screen.dart';
import 'package:app_project/features/storage/storage_screen.dart';
import 'package:app_project/features/store/store_screen.dart';
import 'package:app_project/features/tarot/models/tarot_draw_result.dart';
import 'package:app_project/features/tarot/tarot_result_screen.dart';
import 'package:app_project/features/tarot/tarot_screen.dart';
import 'package:app_project/features/theme_fortune/theme_fortune_screen.dart';
import 'package:app_project/features/wallet/earn_candy_screen.dart';
import 'package:app_project/features/yearly_fortune/yearly_fortune_screen.dart';
import 'package:app_project/features/saju/saju_analysis_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/tarot',
      builder: (context, state) => const TarotScreen(),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final drawResult = state.extra as TarotDrawResult?;
            return TarotResultScreen(drawResult: drawResult);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/compatibility',
      builder: (context, state) => const CompatibilityInputScreen(),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final result = state.extra as CompatibilityResult;
            return CompatibilityResultScreen(result: result);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/rewards/check-in',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/store',
      builder: (context, state) => const StoreScreen(),
    ),
    GoRoute(
      path: '/detailed-fortune',
      builder: (context, state) => const DetailedFortuneScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/yearly-fortune',
      builder: (context, state) => const YearlyFortuneScreen(),
    ),
    GoRoute(
      path: '/dream',
      builder: (context, state) => const DreamSearchScreen(),
    ),
    GoRoute(
      path: '/fun',
      builder: (context, state) => const FunContentScreen(),
    ),
    GoRoute(
      path: '/name-analysis',
      builder: (context, state) => const NameAnalysisScreen(),
    ),
    GoRoute(
      path: '/theme-fortune',
      builder: (context, state) => const ThemeFortuneScreen(),
    ),
    GoRoute(
      path: '/earn-candy',
      builder: (context, state) => const EarnCandyScreen(),
    ),
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/storage',
      builder: (context, state) => const StorageScreen(),
    ),
    GoRoute(
      path: '/saju-settings',
      builder: (context, state) => const SajuSettingsScreen(),
    ),
    GoRoute(
      path: '/saju-analysis',
      builder: (context, state) => const SajuAnalysisScreen(),
    ),
  ],
);
