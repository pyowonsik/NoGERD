import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:no_gerd/features/auth/presentation/pages/email_verification_page.dart';
import 'package:no_gerd/features/auth/presentation/pages/login_page.dart';
import 'package:no_gerd/features/auth/presentation/pages/signup_page.dart';
import 'package:no_gerd/features/calendar/presentation/pages/calendar_page.dart';
import 'package:no_gerd/features/home/presentation/pages/home_page.dart';
import 'package:no_gerd/features/insights/presentation/pages/insights_page.dart';
import 'package:no_gerd/features/record/presentation/bloc/record_bloc.dart';
import 'package:no_gerd/features/settings/presentation/pages/settings_page.dart';
import 'package:no_gerd/screens/main_screen.dart';
import 'package:no_gerd/screens/record/quick_record_modal.dart';
import 'package:no_gerd/screens/splash/splash_screen.dart';

/// 앱의 모든 라우트를 정의하는 클래스
abstract final class AppRoutes {
  // Navigator Keys (각 탭별 독립적인 네비게이션 스택)
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'home_tab');
  static final GlobalKey<NavigatorState> calendarTabNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'calendar_tab');
  static final GlobalKey<NavigatorState> insightsTabNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'insights_tab');
  static final GlobalKey<NavigatorState> settingsTabNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'settings_tab');

  static List<RouteBase> get routes => [
        // 1. 인증 불필요 페이지
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/verify-email',
          name: 'verify-email',
          builder: (context, state) {
            // email 파라미터는 쿼리 파라미터로 전달
            final email = state.uri.queryParameters['email'] ?? '';
            return EmailVerificationPage(email: email);
          },
        ),

        // 2. 메인 화면 (StatefulShellRoute - 탭 네비게이션)
        _mainShellRoute,

        // 3. 기록 관련 라우트
        GoRoute(
          path: '/record/symptom',
          name: 'symptom-record',
          builder: (context, state) {
            final recordBloc = state.extra! as RecordBloc;
            return BlocProvider.value(
              value: recordBloc,
              child: const SymptomRecordScreen(),
            );
          },
        ),
        GoRoute(
          path: '/record/meal',
          name: 'meal-record',
          builder: (context, state) {
            final recordBloc = state.extra! as RecordBloc;
            return BlocProvider.value(
              value: recordBloc,
              child: const MealRecordScreen(),
            );
          },
        ),
        GoRoute(
          path: '/record/medication',
          name: 'medication-record',
          builder: (context, state) {
            final recordBloc = state.extra! as RecordBloc;
            return BlocProvider.value(
              value: recordBloc,
              child: const MedicationRecordScreen(),
            );
          },
        ),
        GoRoute(
          path: '/record/lifestyle',
          name: 'lifestyle-record',
          builder: (context, state) {
            final recordBloc = state.extra! as RecordBloc;
            return BlocProvider.value(
              value: recordBloc,
              child: const LifestyleRecordScreen(),
            );
          },
        ),
      ];

  /// StatefulShellRoute: 탭 기반 네비게이션 (IndexedStack 사용)
  static final RouteBase _mainShellRoute = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return MainScreen(navigationShell: navigationShell);
    },
    branches: [
      // 홈 탭 (인덱스 0)
      StatefulShellBranch(
        navigatorKey: homeTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
        ],
      ),

      // 캘린더 탭 (인덱스 1)
      StatefulShellBranch(
        navigatorKey: calendarTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarPage(),
          ),
        ],
      ),

      // 분석 탭 (인덱스 2)
      StatefulShellBranch(
        navigatorKey: insightsTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/insights',
            name: 'insights',
            builder: (context, state) => const InsightsPage(),
          ),
        ],
      ),

      // 설정 탭 (인덱스 3)
      StatefulShellBranch(
        navigatorKey: settingsTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
