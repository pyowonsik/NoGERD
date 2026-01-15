# GoRouter 마이그레이션 구현 계획

**날짜**: 2026-01-14
**작성자**: Claude Code
**관련 연구 문서**: thoughts/shared/research/gorouter_routing_research_2026-01-14.md

---

## 1. 요구사항

### 1.1 기능 개요

NoGERD 프로젝트의 라우팅 시스템을 **Navigator API (Imperative Routing)**에서 **GoRouter (Declarative Routing)**로 마이그레이션하여 다음 기능을 구현합니다:

1. **자동 로그인 처리**: 앱 시작 시 자동으로 인증 상태를 확인하고 적절한 화면으로 라우팅
2. **보안 강화**: Open Redirect 공격 방지 및 경로 검증
3. **딥링킹 지원**: 외부 URL/딥링크를 통한 특정 화면 직접 진입
4. **선언적 라우팅**: 중앙 집중식 라우트 관리로 유지보수성 향상

### 1.2 목표

- ✅ BLoC과 GoRouter의 완벽한 통합 (RouteRefreshListener 패턴)
- ✅ 자동 로그인 처리 (수동 네비게이션 코드 제거)
- ✅ StatefulShellRoute를 사용한 탭 네비게이션 구현
- ✅ 딥링크 처리 시스템 구축 (PendingDeepLinkService)
- ✅ 보안 강화 (Open Redirect 방지)
- ✅ 기존 Navigator 코드 완전 제거

### 1.3 성공 기준

- [ ] 앱 시작 시 자동 로그인이 정상적으로 작동
- [ ] 로그인/로그아웃 시 자동으로 적절한 화면으로 리디렉션
- [ ] 뒤로 가기 버튼이 자동으로 관리됨
- [ ] 탭 전환 시 화면 상태가 유지됨 (IndexedStack)
- [ ] 딥링크를 통한 특정 화면 진입이 가능
- [ ] 모든 Navigator API 코드가 제거됨
- [ ] 빌드 및 실행 시 에러가 없음

---

## 2. 기술적 접근

### 2.1 아키텍처 선택

**BLoC + GoRouter + RouteRefreshListener 패턴**

- **BLoC**: 기존 상태 관리 방식 유지 (변경 없음)
- **GoRouter**: 선언적 라우팅 라이브러리
- **RouteRefreshListener**: BLoC 상태 변경 시 GoRouter redirect 재실행
- **AppRouteGuard**: redirect 로직 중앙 집중 관리
- **PendingDeepLinkService**: 딥링크 임시 저장소 (인증 대기)

### 2.2 참고 프로젝트

1. **kobic**: BLoC + GoRouter 통합 패턴
   - RouteRefreshListener로 BLoC 상태 자동 감지
   - AppRouteGuard의 redirect 로직
   - 공개/보호 페이지 명확한 구분

2. **gear_freak**: 보안 기능 및 딥링킹
   - Open Redirect 방지 로직
   - PendingDeepLinkService (TTL 5분)
   - Switch Expression 기반 redirect

### 2.3 사용할 패키지

| 패키지 | 버전 | 용도 |
|-------|------|------|
| go_router | ^15.1.1 (이미 설치됨) | 선언적 라우팅 |
| app_links | ^6.4.1 (Phase 7) | 딥링킹 지원 (선택) |

### 2.4 파일 구조

```
lib/
├── core/
│   └── route/
│       ├── app_router.dart               # GoRouter 인스턴스 생성
│       ├── app_routes.dart               # 라우트 목록 및 StatefulShellRoute
│       ├── app_route_guard.dart          # redirect 로직 (인증/권한 체크)
│       ├── route_refresh_listener.dart   # AuthBloc 상태 감지
│       └── pending_deep_link_service.dart # 딥링크 임시 저장소
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart            # 간소화 (네비게이션 로직 제거)
│   └── main_screen.dart                  # StatefulShellRoute 연동
├── features/
│   └── auth/
│       └── presentation/
│           └── pages/
│               ├── login_page.dart       # Navigator 제거
│               └── signup_page.dart      # Navigator 제거
└── app.dart                              # MaterialApp.router 적용
```

---

## 3. 구현 단계

### Phase 1: 기반 구조 설정 (핵심 파일 생성)

**목표**: GoRouter 기본 인프라 구축 및 BLoC 통합

#### 작업 목록

- [ ] `lib/core/route/` 디렉토리 생성
- [ ] `route_refresh_listener.dart` 구현 (AuthBloc 상태 감지)
- [ ] `pending_deep_link_service.dart` 구현 (딥링크 임시 저장소)
- [ ] `app_route_guard.dart` 구현 (redirect 로직)
- [ ] 단위 테스트 작성 (PendingDeepLinkService)

#### 예상 영향

**영향 받는 파일:**
- 새로 생성: `lib/core/route/route_refresh_listener.dart`
- 새로 생성: `lib/core/route/pending_deep_link_service.dart`
- 새로 생성: `lib/core/route/app_route_guard.dart`

**의존성:**
- `go_router`: ^15.1.1 (이미 설치됨)
- `flutter_bloc`: ^8.1.6 (이미 설치됨)
- 외부 의존성 없음 (기존 패키지 활용)

#### 검증 방법

- [ ] `RouteRefreshListener`가 AuthBloc 스트림을 정상적으로 구독하는지 확인
- [ ] `PendingDeepLinkService`의 TTL이 정상 작동하는지 단위 테스트
- [ ] `AppRouteGuard`의 redirect 로직이 모든 AuthState를 처리하는지 확인 (컴파일 에러 체크)
- [ ] 빌드 성공 확인 (`flutter pub get && flutter analyze`)

#### 세부 구현

##### 1.1 RouteRefreshListener

```dart
// lib/core/route/route_refresh_listener.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';

/// AuthBloc의 상태 변경을 감지하여 GoRouter의 redirect를 재실행하는 리스너
class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authBloc) {
    notifyListeners();
    _authStreamSubscription = _authBloc.stream.listen((_) {
      debugPrint('🔄 AuthBloc 상태 변경 감지 - GoRouter redirect 재실행');
      notifyListeners();
    });
  }

  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authStreamSubscription;

  @override
  void dispose() {
    _authStreamSubscription.cancel();
    super.dispose();
  }
}
```

##### 1.2 PendingDeepLinkService

```dart
// lib/core/route/pending_deep_link_service.dart
import 'package:flutter/foundation.dart';

/// 딥링크를 임시로 저장하고 인증 완료 후 복원하는 서비스
/// TTL(Time To Live) 5분 적용
class PendingDeepLinkService {
  PendingDeepLinkService._();
  static final instance = PendingDeepLinkService._();

  static const _ttl = Duration(minutes: 5);

  String? _pendingDeepLink;
  DateTime? _pendingDeepLinkTimestamp;

  String? get pendingDeepLink => _pendingDeepLink;

  /// 딥링크 저장
  void setPendingDeepLink(String routePath) {
    _pendingDeepLink = routePath;
    _pendingDeepLinkTimestamp = DateTime.now();
    debugPrint('📌 Pending deep link saved: $routePath');
  }

  /// 보류 중인 딥링크 가져오고 초기화 (TTL 체크)
  String? consumePendingDeepLink() {
    if (_pendingDeepLink != null && _pendingDeepLinkTimestamp != null) {
      final elapsed = DateTime.now().difference(_pendingDeepLinkTimestamp!);
      if (elapsed > _ttl) {
        debugPrint('⏰ Pending deep link expired (TTL: ${_ttl.inMinutes}m)');
        clear();
        return null;
      }
    }

    final link = _pendingDeepLink;
    if (link != null) {
      debugPrint('✅ Consuming pending deep link: $link');
      _pendingDeepLink = null;
      _pendingDeepLinkTimestamp = null;
    }
    return link;
  }

  void clear() {
    _pendingDeepLink = null;
    _pendingDeepLinkTimestamp = null;
  }
}
```

##### 1.3 AppRouteGuard

```dart
// lib/core/route/app_route_guard.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nogerd/core/route/pending_deep_link_service.dart';

/// 라우팅 가드: 인증 상태에 따른 redirect 로직
class AppRouteGuard {
  const AppRouteGuard(this._authBloc);
  final AuthBloc _authBloc;

  String? guard(BuildContext context, GoRouterState state) {
    const loginPath = '/login';
    const splashPath = '/splash';
    const homePath = '/';
    final currentPath = state.matchedLocation;

    final isLoginScreen = _checkLoginPage(currentPath);
    final isSplashScreen = currentPath == splashPath;
    final requiresAuth = _requiresAuthentication(currentPath);
    final currentState = _authBloc.state;

    // Switch Expression으로 타입 안전한 분기 처리
    final redirectTo = switch (currentState) {
      // 초기 상태: 스플래시로 리디렉션
      _Initial() => isSplashScreen ? null : splashPath,

      // 로딩 중: 현재 위치 유지 (깜빡임 방지)
      _Loading() => null,

      // 미인증 상태: 선택적 리디렉션
      _Unauthenticated() => switch (true) {
        _ when isLoginScreen => null, // 로그인 페이지 허용
        _ when isSplashScreen => loginPath, // 스플래시 → 로그인
        _ when requiresAuth => _buildLoginPathWithRedirect(currentPath),
        _ => null, // 공개 페이지 허용
      },

      // 인증 성공: 로그인/스플래시에서 벗어남
      _Authenticated() => switch (true) {
        _ when isLoginScreen => _getRedirectPath(state, homePath),
        _ when isSplashScreen => _getPendingDeepLinkOrHome(homePath),
        _ => null, // 모든 페이지 접근 가능
      },

      // 인증 실패: 로그인으로
      _Error() => isLoginScreen ? null : loginPath,

      // 이메일 인증 필요: 인증 페이지로
      _EmailVerificationRequired() => '/verify-email',

      _ => null,
    };

    if (redirectTo != null) {
      debugPrint('🔀 Redirect: $currentPath → $redirectTo');
    }

    return redirectTo;
  }

  /// 로그인 관련 페이지인지 확인
  bool _checkLoginPage(String path) {
    return path == '/login' || path == '/signup' || path == '/verify-email';
  }

  /// 인증이 필요한 페이지인지 확인
  bool _requiresAuthentication(String path) {
    // 공개 페이지 목록 (인증 불필요)
    const publicPages = ['/login', '/signup', '/verify-email', '/splash'];
    return !publicPages.any((publicPage) => path.startsWith(publicPage));
  }

  /// 로그인 경로에 딥링크 정보 추가 (Open Redirect 공격 방지)
  String _buildLoginPathWithRedirect(String currentPath) {
    if (currentPath != '/splash' &&
        currentPath != '/login' &&
        currentPath != '/signup') {
      return '/login?redirect=${Uri.encodeComponent(currentPath)}';
    }
    return '/login';
  }

  /// redirect 파라미터 검증 (Open Redirect 방지)
  String? _validateRedirect(String? redirect) {
    if (redirect == null || redirect.isEmpty) return null;

    // 1. 내부 경로만 허용 (외부 URL 차단)
    if (!redirect.startsWith('/')) return null;

    // 2. 허용된 경로 prefix 체크
    const allowedPrefixes = [
      '/',
      '/record',
      '/calendar',
      '/insights',
      '/settings',
      '/profile',
    ];
    final isAllowed =
        allowedPrefixes.any((prefix) => redirect.startsWith(prefix));
    return isAllowed ? redirect : null;
  }

  /// 로그인 성공 후 리디렉션 경로 결정
  String _getRedirectPath(GoRouterState state, String defaultPath) {
    final redirectParam = state.uri.queryParameters['redirect'];
    final validatedRedirect = _validateRedirect(redirectParam);

    if (validatedRedirect != null) {
      debugPrint('🔗 Redirecting to deep link: $validatedRedirect');
      return validatedRedirect;
    }
    return defaultPath;
  }

  /// Pending Deep Link 또는 기본 경로로 리디렉션
  String _getPendingDeepLinkOrHome(String defaultPath) {
    final pendingLink =
        PendingDeepLinkService.instance.consumePendingDeepLink();

    if (pendingLink != null) {
      return pendingLink;
    }
    return defaultPath;
  }
}
```

---

### Phase 2: 라우트 정의 (AppRoutes, AppRouter)

**목표**: GoRouter 라우트 정의 및 StatefulShellRoute 구성

#### 작업 목록

- [ ] `app_routes.dart` 구현 (라우트 목록 정의)
- [ ] StatefulShellRoute 설정 (탭 네비게이션)
- [ ] Navigator Keys 정의 (각 탭별 독립 스택)
- [ ] `app_router.dart` 구현 (GoRouter 인스턴스 생성)

#### 예상 영향

**영향 받는 파일:**
- 새로 생성: `lib/core/route/app_routes.dart`
- 새로 생성: `lib/core/route/app_router.dart`

**의존성:**
- Phase 1 완료 필요 (AppRouteGuard, RouteRefreshListener)
- 기존 페이지 파일들 (HomePage, LoginPage 등)

#### 검증 방법

- [ ] 모든 라우트가 정상적으로 정의되었는지 확인
- [ ] StatefulShellRoute의 브랜치 구조가 올바른지 확인
- [ ] GoRouter 인스턴스가 정상적으로 생성되는지 확인
- [ ] `flutter analyze` 실행하여 타입 에러 없는지 확인

#### 세부 구현

##### 2.1 AppRoutes

```dart
// lib/core/route/app_routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nogerd/screens/splash/splash_screen.dart';
import 'package:nogerd/features/auth/presentation/pages/login_page.dart';
import 'package:nogerd/features/auth/presentation/pages/signup_page.dart';
import 'package:nogerd/screens/main_screen.dart';
import 'package:nogerd/features/home/presentation/pages/home_page.dart';
import 'package:nogerd/features/calendar/presentation/pages/calendar_page.dart';
import 'package:nogerd/features/insights/presentation/pages/insights_page.dart';
import 'package:nogerd/features/settings/presentation/pages/settings_page.dart';

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

        // 2. 메인 화면 (StatefulShellRoute - 탭 네비게이션)
        _mainShellRoute,

        // 3. 기록 관련 라우트 (추후 추가 예정)
        // GoRoute(
        //   path: '/record/symptom',
        //   name: 'symptom-record',
        //   builder: (context, state) => const SymptomRecordScreen(),
        // ),
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
```

##### 2.2 AppRouter

```dart
// lib/core/route/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:nogerd/core/route/app_routes.dart';
import 'package:nogerd/core/route/app_route_guard.dart';
import 'package:nogerd/core/route/route_refresh_listener.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nogerd/core/di/injection.dart';

/// GoRouter 인스턴스를 생성하는 클래스
class AppRouter {
  static GoRouter createRouter() {
    final authBloc = getIt<AuthBloc>();

    return GoRouter(
      debugLogDiagnostics: true, // 개발 시 디버그 로그 출력
      initialLocation: '/splash', // 앱 시작 시 스플래시 화면
      navigatorKey: AppRoutes.rootNavigatorKey,
      redirect: AppRouteGuard(authBloc).guard, // 인증 가드
      refreshListenable: RouteRefreshListener(authBloc), // BLoC 상태 감지
      routes: AppRoutes.routes,
    );
  }
}
```

---

### Phase 3: MainScreen 수정 (StatefulShellRoute 연동)

**목표**: MainScreen을 StatefulShellRoute와 연동하여 탭 네비게이션 구현

#### 작업 목록

- [ ] MainScreen의 생성자 변경 (StatefulNavigationShell 추가)
- [ ] IndexedStack 로직 제거 (StatefulShellRoute가 대체)
- [ ] 바텀 네비게이션 onTap 이벤트 수정 (goBranch 사용)
- [ ] 기존 상태 관리 코드 제거 (_currentIndex)

#### 예상 영향

**영향 받는 파일:**
- 수정: `lib/screens/main_screen.dart`

**의존성:**
- Phase 2 완료 필요 (AppRoutes의 StatefulShellRoute 정의)

#### 검증 방법

- [ ] 탭 전환 시 화면이 정상적으로 바뀌는지 확인
- [ ] 탭 전환 후 다시 돌아왔을 때 이전 상태가 유지되는지 확인 (IndexedStack 동작)
- [ ] FAB 버튼이 정상적으로 동작하는지 확인
- [ ] 빌드 에러가 없는지 확인

#### 세부 구현

```dart
// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nogerd/screens/record/quick_record_modal.dart';
import 'package:nogerd/core/di/injection.dart';
import 'package:nogerd/features/record/presentation/bloc/record_bloc.dart';

/// 메인 화면: 4개 탭 (홈, 캘린더, 분석, 설정)
class MainScreen extends StatelessWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // 현재 탭을 다시 탭하면 초기 위치로 리셋
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _showQuickRecordModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: getIt<RecordBloc>(),
        child: const QuickRecordModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // StatefulShellRoute의 body
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: '분석',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickRecordModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
```

---

### Phase 4: App.dart 수정 (MaterialApp.router 적용)

**목표**: MaterialApp을 MaterialApp.router로 변경하여 GoRouter 적용

#### 작업 목록

- [ ] MaterialApp → MaterialApp.router 변경
- [ ] `routerConfig` 파라미터에 AppRouter.createRouter() 전달
- [ ] `home` 파라미터 제거

#### 예상 영향

**영향 받는 파일:**
- 수정: `lib/app.dart`

**의존성:**
- Phase 1, 2, 3 완료 필요

#### 검증 방법

- [ ] 앱이 정상적으로 시작되는지 확인
- [ ] 스플래시 화면이 표시되는지 확인
- [ ] AuthBloc의 checkStatus 이벤트가 발생하는지 확인
- [ ] 빌드 에러가 없는지 확인

#### 세부 구현

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nogerd/core/di/injection.dart';
import 'package:nogerd/core/route/app_router.dart';
import 'package:nogerd/core/theme/app_theme.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nogerd/features/home/presentation/bloc/home_bloc.dart';
import 'package:nogerd/features/record/presentation/bloc/record_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()
            ..add(const AuthEvent.checkStatus()), // 자동 로그인 체크
        ),
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>()
            ..add(const HomeEvent.loadDashboard()),
        ),
        BlocProvider<RecordBloc>(
          create: (_) => getIt<RecordBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'NoGERD',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.createRouter(), // GoRouter 적용
      ),
    );
  }
}
```

---

### Phase 5: SplashScreen 간소화

**목표**: SplashScreen에서 네비게이션 로직 제거 (AppRouteGuard가 대체)

#### 작업 목록

- [ ] `_navigateToNext()` 메서드 제거
- [ ] Future.delayed 로직 제거
- [ ] 순수 UI만 남기기 (로고 + 로딩 인디케이터)

#### 예상 영향

**영향 받는 파일:**
- 수정: `lib/screens/splash/splash_screen.dart`

**의존성:**
- Phase 4 완료 필요 (GoRouter 적용 후)

#### 검증 방법

- [ ] 스플래시 화면이 표시되는지 확인
- [ ] AuthBloc의 상태가 변경되면 자동으로 리디렉션되는지 확인
- [ ] 로딩 중 깜빡임이 없는지 확인

#### 세부 구현

```dart
// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:nogerd/shared/shared.dart';

/// 스플래시 화면: 순수 UI만 표시 (네비게이션 로직은 AppRouteGuard가 처리)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.health_and_safety,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // 앱 이름
            const Text(
              'NoGERD',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // 로딩 인디케이터
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

---

### Phase 6: 페이지별 Navigator 제거

**목표**: 모든 페이지에서 Navigator API 제거 및 GoRouter 메서드로 대체

#### 작업 목록

- [ ] LoginPage의 Navigator 제거 (BlocListener 수정)
- [ ] SignUpPage의 Navigator 제거
- [ ] SettingsPage의 로그아웃 로직 수정
- [ ] QuickRecordModal의 Navigator 제거

#### 예상 영향

**영향 받는 파일:**
- 수정: `lib/features/auth/presentation/pages/login_page.dart`
- 수정: `lib/features/auth/presentation/pages/signup_page.dart`
- 수정: `lib/features/settings/presentation/pages/settings_page.dart`
- 수정: `lib/screens/record/quick_record_modal.dart`

**의존성:**
- Phase 5 완료 필요

#### 검증 방법

- [ ] 로그인 성공 시 자동으로 홈 화면으로 이동하는지 확인
- [ ] 회원가입 성공 시 자동으로 홈 화면으로 이동하는지 확인
- [ ] 로그아웃 시 자동으로 로그인 화면으로 이동하는지 확인
- [ ] 회원가입 버튼 클릭 시 회원가입 화면으로 이동하는지 확인
- [ ] Navigator 관련 컴파일 에러가 없는지 확인

#### 세부 구현

##### 6.1 LoginPage

```dart
// lib/features/auth/presentation/pages/login_page.dart
// BlocListener 수정

BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      authenticated: (user) {
        // GoRouter의 redirect가 자동으로 홈으로 이동
        // 수동 네비게이션 불필요!
      },
      error: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Colors.red,
          ),
        );
      },
      orElse: () {},
    );
  },
  child: /* 로그인 UI */,
)

// 회원가입 버튼
ElevatedButton(
  onPressed: () => context.push('/signup'), // GoRouter 사용
  child: const Text('회원가입'),
)
```

##### 6.2 SignUpPage

```dart
// lib/features/auth/presentation/pages/signup_page.dart
// BlocListener 수정

BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      authenticated: (_) {
        // GoRouter의 redirect가 자동으로 홈으로 이동
      },
      error: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Colors.red,
          ),
        );
      },
      orElse: () {},
    );
  },
  child: /* 회원가입 UI */,
)
```

##### 6.3 SettingsPage (로그아웃)

```dart
// lib/features/settings/presentation/pages/settings_page.dart
// _handleLogout 메서드 수정

void _handleLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('정말 로그아웃하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            context.read<AuthBloc>().add(const AuthEvent.signOut());
            // GoRouter의 redirect가 자동으로 로그인 페이지로 이동
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('로그아웃'),
        ),
      ],
    ),
  );
}
```

##### 6.4 QuickRecordModal

```dart
// lib/screens/record/quick_record_modal.dart
// Navigator.push 제거

GestureDetector(
  onTap: () {
    Navigator.pop(context); // 모달 닫기만 유지
    context.push('/record/symptom'); // GoRouter 사용
  },
  child: /* UI */,
)
```

---

### Phase 7: DeepLink 지원 추가 (선택)

**목표**: app_links 패키지를 사용하여 딥링킹 지원

#### 작업 목록

- [ ] `app_links` 패키지 추가 (pubspec.yaml)
- [ ] `deep_link_service.dart` 구현
- [ ] main.dart에서 DeepLinkService 초기화
- [ ] Android/iOS 네이티브 설정 (AndroidManifest.xml, Info.plist)

#### 예상 영향

**영향 받는 파일:**
- 수정: `pubspec.yaml`
- 새로 생성: `lib/core/route/deep_link_service.dart`
- 수정: `lib/main.dart`
- 수정: `android/app/src/main/AndroidManifest.xml` (선택)
- 수정: `ios/Runner/Info.plist` (선택)

**의존성:**
- Phase 1-6 완료 필요
- `app_links` 패키지 설치

#### 검증 방법

- [ ] 앱이 종료된 상태에서 딥링크로 시작 시 원하는 화면으로 이동하는지 확인
- [ ] 앱이 실행 중일 때 딥링크 수신 시 화면 전환되는지 확인
- [ ] 로그인 전 딥링크 수신 시 Pending 처리되는지 확인
- [ ] 로그인 후 Pending 딥링크로 복원되는지 확인

#### 세부 구현

##### 7.1 pubspec.yaml

```yaml
dependencies:
  app_links: ^6.4.1
```

##### 7.2 DeepLinkService

```dart
// lib/core/route/deep_link_service.dart
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:nogerd/core/route/pending_deep_link_service.dart';

/// 딥링크 처리 서비스
class DeepLinkService {
  DeepLinkService._();
  static final instance = DeepLinkService._();

  late final AppLinks _appLinks;
  GoRouter? _router;

  Future<void> initialize(GoRouter router) async {
    _appLinks = AppLinks();
    _router = router;

    // 초기 딥링크 처리 (앱이 딥링크로 시작된 경우)
    await _handleInitialLink();

    // 딥링크 리스너 시작 (앱 실행 중 딥링크 수신)
    _startListening();
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri == null) return;

      debugPrint('🔗 Initial deep link: $uri');

      final routePath = _parseDeepLinkUrl(uri.toString());
      if (routePath != null) {
        // 인증 완료까지 보류
        PendingDeepLinkService.instance.setPendingDeepLink(routePath);
      }
    } catch (e) {
      debugPrint('❌ Failed to handle initial link: $e');
    }
  }

  void _startListening() {
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('🔗 Incoming deep link: $uri');

      final routePath = _parseDeepLinkUrl(uri.toString());
      if (routePath != null && _router != null) {
        _router!.go(routePath);
      }
    });
  }

  String? _parseDeepLinkUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Custom Scheme (nogerd://record/symptom)
    if (uri.scheme == 'nogerd') {
      if (uri.host.isNotEmpty) {
        return '/${uri.host}${uri.path}';
      } else {
        return uri.path;
      }
    }

    // HTTPS App Links (https://nogerd.com/record/symptom)
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      // TODO: 실제 도메인으로 필터링
      // if (uri.host == 'nogerd.com') {
      return uri.path;
      // }
    }

    return null;
  }
}
```

##### 7.3 main.dart 수정

```dart
// lib/main.dart
import 'package:nogerd/core/route/deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const App());

  // 딥링크 서비스 초기화 (앱 실행 후)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final router = AppRouter.createRouter();
    await DeepLinkService.instance.initialize(router);
  });
}
```

**주의:** Phase 7은 선택 사항입니다. 딥링킹이 필요하지 않다면 Phase 6까지만 구현해도 충분합니다.

---

## 4. 리스크 및 대응

### 리스크 1: AuthBloc 상태 변경 시 GoRouter가 재생성되지 않음

- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - RouteRefreshListener가 정상적으로 AuthBloc 스트림을 구독하는지 확인
  - `refreshListenable`이 GoRouter에 정상적으로 연결되었는지 확인
  - 디버그 로그를 추가하여 상태 변경 감지 여부 확인

### 리스크 2: StatefulShellRoute에서 탭 상태가 유지되지 않음

- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - `StatefulShellRoute.indexedStack` 사용 (기본값)
  - 각 브랜치마다 독립적인 NavigatorKey 할당
  - `initialLocation` 파라미터 정확히 설정

### 리스크 3: Pending DeepLink가 소비되지 않음

- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - TTL 체크 로직 단위 테스트
  - 디버그 로그로 setPendingDeepLink/consumePendingDeepLink 호출 확인
  - AppRouteGuard에서 consumePendingDeepLink 호출 위치 확인

### 리스크 4: Navigator 관련 코드 누락으로 빌드 실패

- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - Phase 6 전에 전체 프로젝트에서 `Navigator.` 검색
  - `flutter analyze` 실행하여 미리 확인
  - 단계별로 빌드 테스트 수행

### 리스크 5: 딥링크 처리 중 인증 상태 확인 타이밍 이슈

- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - PendingDeepLinkService를 사용하여 인증 완료까지 대기
  - AppRouteGuard의 redirect 로직에서 처리
  - kobic의 _waitForAuthInitialization 패턴 참고 (필요 시)

---

## 5. 전체 검증 계획

### 5.1 자동 테스트

#### 단위 테스트

- [ ] `PendingDeepLinkService.consumePendingDeepLink()` TTL 체크
- [ ] `PendingDeepLinkService.setPendingDeepLink()` 저장 및 타임스탬프
- [ ] `AppRouteGuard._validateRedirect()` Open Redirect 방지
- [ ] `AppRouteGuard._requiresAuthentication()` 경로 분류

#### 위젯 테스트

- [ ] MainScreen 탭 전환 테스트
- [ ] SplashScreen UI 렌더링 테스트

#### 통합 테스트

- [ ] 로그인 → 홈 화면 자동 전환
- [ ] 로그아웃 → 로그인 화면 자동 전환
- [ ] 탭 전환 후 상태 유지 확인

### 5.2 수동 테스트

#### 시나리오 1: 자동 로그인 (기존 세션 있음)

1. 앱을 완전히 종료
2. 앱 재시작
3. 스플래시 화면이 표시됨
4. AuthBloc.checkStatus가 실행됨
5. 기존 세션이 유효하면 자동으로 홈 화면으로 이동
6. **예상 결과**: 로그인 화면을 거치지 않고 바로 홈 화면 표시

#### 시나리오 2: 자동 로그인 (세션 없음)

1. 앱을 완전히 종료
2. 앱 재시작
3. 스플래시 화면이 표시됨
4. AuthBloc.checkStatus가 실행됨
5. 세션이 없으면 자동으로 로그인 화면으로 이동
6. **예상 결과**: 로그인 화면 표시

#### 시나리오 3: 로그인 후 홈 화면 전환

1. 로그인 화면에서 이메일/비밀번호 입력
2. 로그인 버튼 클릭
3. AuthBloc.signIn 이벤트 발생
4. 로그인 성공 → Authenticated 상태
5. RouteRefreshListener가 상태 변경 감지
6. AppRouteGuard의 redirect가 재실행되어 홈 화면으로 이동
7. **예상 결과**: 수동 네비게이션 없이 자동으로 홈 화면 표시

#### 시나리오 4: 로그아웃 후 로그인 화면 전환

1. 설정 화면에서 로그아웃 버튼 클릭
2. 확인 다이얼로그에서 로그아웃 확인
3. AuthBloc.signOut 이벤트 발생
4. 로그아웃 성공 → Unauthenticated 상태
5. RouteRefreshListener가 상태 변경 감지
6. AppRouteGuard의 redirect가 재실행되어 로그인 화면으로 이동
7. **예상 결과**: 자동으로 로그인 화면 표시

#### 시나리오 5: 탭 전환 및 상태 유지

1. 홈 화면에서 임의의 스크롤 위치로 이동
2. 캘린더 탭으로 전환
3. 다시 홈 탭으로 전환
4. **예상 결과**: 이전 스크롤 위치가 유지됨 (IndexedStack 동작)

#### 시나리오 6: 딥링크 처리 (인증 후)

1. 앱이 이미 로그인된 상태
2. 외부에서 딥링크 수신 (예: nogerd://record/symptom)
3. DeepLinkService가 URL 파싱
4. GoRouter.go()로 해당 화면으로 이동
5. **예상 결과**: 증상 기록 화면으로 이동

#### 시나리오 7: 딥링크 처리 (인증 전)

1. 앱이 로그아웃 상태
2. 외부에서 딥링크 수신 (예: nogerd://record/symptom)
3. PendingDeepLinkService에 경로 저장
4. AppRouteGuard가 로그인 화면으로 리디렉션
5. 로그인 성공 후 Pending 딥링크로 이동
6. **예상 결과**: 로그인 후 자동으로 증상 기록 화면으로 이동

### 5.3 성능 체크

- [ ] 앱 시작 시간 측정 (이전 vs 이후)
- [ ] 탭 전환 속도 측정
- [ ] 메모리 사용량 확인 (IndexedStack 사용 시)
- [ ] GoRouter 라우팅 오버헤드 확인

---

## 6. 참고 사항

### 6.1 주의할 점

1. **BlocListener에서 수동 네비게이션 제거**
   - GoRouter의 redirect가 자동으로 처리하므로 `context.go()` 불필요
   - 단, 에러 처리는 유지 (SnackBar 표시 등)

2. **Context 사용 주의**
   - `context.go('/path')`: 스택을 교체 (pushReplacement와 유사)
   - `context.push('/path')`: 스택에 추가 (push와 유사)
   - `context.pop()`: 현재 화면 닫기 (pop과 동일)

3. **SplashScreen 로직 변경**
   - 네비게이션 로직을 AppRouteGuard로 완전히 이동
   - SplashScreen은 순수 UI만 표시

4. **MainScreen 구조 변경**
   - StatefulWidget에서 StatelessWidget으로 변경 가능
   - StatefulShellRoute가 상태 관리를 대신함

### 6.2 참고 문서

- [GoRouter 공식 문서](https://pub.dev/documentation/go_router/latest/)
- [GoRouter StatefulShellRoute 예제](https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart)
- [app_links 공식 문서](https://pub.dev/packages/app_links)
- [GoRouter + BLoC 통합 이슈](https://github.com/flutter/flutter/issues/99112)

### 6.3 참고 프로젝트 파일 위치

#### gear_freak 핵심 파일

```
/Users/pyowonsik/Downloads/workspace/gear_freak/gear_freak_flutter/lib/
├── core/route/
│   ├── router_provider.dart
│   ├── app_routes.dart
│   ├── app_route.dart
│   └── app_route_guard.dart
├── feature/auth/presentation/provider/
│   ├── auth_state.dart
│   └── auth_notifier.dart
└── shared/service/
    ├── deep_link_service.dart
    └── pending_deep_link_service.dart
```

#### kobic 핵심 파일

```
/Users/pyowonsik/Downloads/workspace/kobic/
├── feature/application/app_router/lib/src/route/
│   ├── app_router.dart
│   ├── app_routes.dart
│   ├── app_route_guard.dart
│   └── global_auth_manager.dart
└── feature/common/auth/lib/src/presentation/route/
    └── route_refresh_listener.dart
```

---

## 7. 마일스톤

| Phase | 예상 소요 시간 | 완료 기준 |
|-------|------------|--------|
| Phase 1 | 2시간 | RouteRefreshListener, AppRouteGuard, PendingDeepLinkService 구현 완료 및 빌드 성공 |
| Phase 2 | 1시간 | AppRoutes, AppRouter 구현 완료 및 빌드 성공 |
| Phase 3 | 1시간 | MainScreen 수정 완료 및 탭 전환 테스트 성공 |
| Phase 4 | 30분 | App.dart 수정 완료 및 앱 실행 성공 |
| Phase 5 | 30분 | SplashScreen 간소화 완료 |
| Phase 6 | 1.5시간 | 모든 Navigator 코드 제거 및 GoRouter 메서드로 대체 |
| Phase 7 | 2시간 | DeepLinkService 구현 및 딥링킹 테스트 성공 (선택) |
| **총합** | **8.5시간** | 모든 Phase 완료 및 전체 검증 통과 |

---

## 8. 결론

이 구현 계획을 따라 단계적으로 마이그레이션을 진행하면 안전하게 GoRouter를 도입할 수 있습니다.

**핵심 포인트:**
1. ✅ BLoC + RouteRefreshListener 패턴으로 자동 로그인 처리
2. ✅ AppRouteGuard의 중앙 집중식 redirect 로직
3. ✅ PendingDeepLinkService로 딥링크 처리
4. ✅ StatefulShellRoute로 탭 네비게이션 구현
5. ✅ Open Redirect 방지로 보안 강화

**다음 단계:**
1. Phase 1부터 순차적으로 구현
2. 각 Phase 완료 후 검증 수행
3. Phase 6 완료 후 전체 수동 테스트
4. Phase 7은 필요 시 선택적으로 구현

---

**작성일**: 2026-01-14
**작성자**: Claude Code
**문서 버전**: 1.0
