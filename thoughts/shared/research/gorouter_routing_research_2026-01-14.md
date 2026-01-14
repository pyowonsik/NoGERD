# GoRouter 라우팅 구현 연구 보고서

**날짜**: 2026-01-14
**분석 대상**: gear_freak, kobic 프로젝트의 GoRouter 구현 + NoGERD 현재 라우팅 방식
**목적**: NoGERD 프로젝트에 GoRouter 기반 자동 로그인 및 딥링킹 구현

---

## 📋 목차

1. [프로젝트별 라우팅 방식 비교](#1-프로젝트별-라우팅-방식-비교)
2. [gear_freak 프로젝트 분석](#2-gear_freak-프로젝트-분석)
3. [kobic 프로젝트 분석](#3-kobic-프로젝트-분석)
4. [NoGERD 현재 라우팅 구조](#4-nogerd-현재-라우팅-구조)
5. [GoRouter 마이그레이션 전략](#5-gorouter-마이그레이션-전략)
6. [구현 계획](#6-구현-계획)
7. [참고 코드 샘플](#7-참고-코드-샘플)

---

## 1. 프로젝트별 라우팅 방식 비교

| 항목 | gear_freak | kobic | NoGERD (현재) |
|-----|-----------|-------|-------------|
| **라우팅 방식** | GoRouter | GoRouter | Navigator API (Imperative) |
| **go_router 버전** | ^15.1.2 | ^16.2.5 | ^15.1.1 (미사용) |
| **상태 관리** | Riverpod | BLoC | BLoC |
| **라우트 정의** | 직접 정의 | TypedGoRoute | 없음 (MaterialRoute) |
| **자동 로그인** | ✅ redirect + AuthNotifier | ✅ redirect + RouteRefreshListener | ⚠️ SplashScreen에서 수동 처리 |
| **딥링킹** | ✅ DeepLinkService + app_links | ✅ DeepLinkService + app_links | ❌ 미구현 |
| **탭 네비게이션** | StatefulShellRoute | StatefulShellRoute | IndexedStack (수동) |
| **보안** | Open Redirect 방지 | Open Redirect 방지 | 없음 |

---

## 2. gear_freak 프로젝트 분석

### 2.1 아키텍처 개요

gear_freak는 **Riverpod + GoRouter**를 사용하며, 매우 체계적인 라우팅 구조를 갖추고 있습니다.

**핵심 파일 구조:**
```
lib/core/route/
├── router_provider.dart          # GoRouter Provider 정의
├── app_routes.dart                # 라우트 목록
├── app_route.dart                 # StatefulShellRoute 정의
└── app_route_guard.dart           # redirect 로직
```

### 2.2 GoRouter 초기화

**파일**: `lib/core/route/router_provider.dart`

```dart
final routerProvider = Provider<GoRouter>((ref) {
  // AuthNotifier를 watch하여 상태 변경 감지 (중요!)
  ref.watch(authNotifierProvider);

  final routeGuard = AppRouteGuard(ref);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    redirect: routeGuard.guard,  // 모든 라우팅에 가드 적용
    routes: AppRoutes.routes,
  );
});
```

**핵심 포인트:**
- `ref.watch(authNotifierProvider)` → 인증 상태 변경 시 GoRouter 자동 재생성
- `redirect`에 통합된 가드 로직 적용
- `initialLocation: '/splash'` → 앱 시작 시 항상 스플래시 화면

### 2.3 자동 로그인 처리 로직

#### AuthNotifier (Riverpod StateNotifier)

**파일**: `lib/feature/auth/presentation/provider/auth_notifier.dart`

```dart
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this.getMeUseCase,
  ) : super(const AuthInitial()) {
    // 앱 시작 시 자동으로 세션 확인
    _checkSession();
  }

  /// 앱 시작 시 세션 확인 (자동 로그인)
  Future<void> _checkSession() async {
    state = const AuthLoading();

    final result = await getMeUseCase(null);

    await result.fold(
      (failure) {
        state = const AuthUnauthenticated();
      },
      (user) async {
        if (user != null) {
          state = AuthAuthenticated(user);
          // 세션 확인 후 FCM 토큰 등록
          await FcmService.instance.initialize();
        } else {
          state = const AuthUnauthenticated();
        }
      },
    );
  }
}
```

**인증 상태 정의 (Sealed Class 패턴):**
```dart
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}       // 앱 시작 직후
class AuthLoading extends AuthState {}       // 세션 확인 중
class AuthAuthenticated extends AuthState {  // 인증 성공
  const AuthAuthenticated(this.user);
  final User user;
}
class AuthUnauthenticated extends AuthState {} // 미인증
class AuthError extends AuthState {           // 인증 실패
  const AuthError(this.message);
  final String message;
}
```

#### AppRouteGuard (redirect 로직)

**파일**: `lib/core/route/app_route_guard.dart`

```dart
class AppRouteGuard {
  const AppRouteGuard(this.ref);
  final Ref ref;

  String? guard(BuildContext context, GoRouterState goRouterState) {
    const loginPath = '/login';
    const splashPath = '/splash';
    const homePath = '/main/home';
    final currentPath = goRouterState.matchedLocation;

    final authState = ref.read(authNotifierProvider);

    // Switch Expression으로 깔끔한 분기 처리
    final redirectTo = switch (authState) {
      // 초기 상태: 스플래시로
      AuthInitial() => isSplashScreen ? null : splashPath,

      // 로딩 중: 현재 위치 유지 (깜빡임 방지)
      AuthLoading() => null,

      // 미인증 상태
      AuthUnauthenticated() => switch (true) {
        _ when isLoginScreen => null,  // 로그인 화면 허용
        _ when isSplashScreen => loginPath,  // 스플래시 → 로그인
        _ when requiresAuth => _buildLoginPathWithRedirect(currentPath),
        _ => loginPath,
      },

      // 인증 성공
      AuthAuthenticated() => switch (true) {
        _ when isLoginScreen => _getRedirectPath(goRouterState, homePath),
        _ when isSplashScreen => _getPendingDeepLinkOrHome(homePath),
        _ => null,  // 모든 페이지 접근 가능
      },

      // 인증 실패
      AuthError() => loginPath,
    };

    return redirectTo;
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

    // 1. 내부 경로만 허용
    if (!redirect.startsWith('/')) return null;

    // 2. 허용된 경로 prefix 체크
    final allowedPrefixes = [
      '/', '/product', '/chat', '/profile', '/review', '/notifications', '/search',
    ];
    final isAllowed = allowedPrefixes.any((prefix) => redirect.startsWith(prefix));
    return isAllowed ? redirect : null;
  }

  /// 로그인 성공 후 리디렉션
  String _getRedirectPath(GoRouterState goRouterState, String defaultPath) {
    final redirectParam = goRouterState.uri.queryParameters['redirect'];
    final validatedRedirect = _validateRedirect(redirectParam);

    if (validatedRedirect != null) {
      return validatedRedirect;  // 딥링크로 들어왔던 페이지로
    }
    return defaultPath;  // 일반 로그인은 홈으로
  }

  /// Pending Deep Link 또는 기본 경로로 리디렉션
  String _getPendingDeepLinkOrHome(String defaultPath) {
    final pendingLink = PendingDeepLinkService.instance.consumePendingDeepLink();

    if (pendingLink != null) {
      return pendingLink;
    }
    return defaultPath;
  }
}
```

### 2.4 DeepLink 처리

#### DeepLinkService

**파일**: `lib/shared/service/deep_link_service.dart`

```dart
class DeepLinkService {
  static final instance = DeepLinkService._();

  Future<void> initialize(GoRouter router) async {
    _appLinks = AppLinks();
    _router = router;

    // 초기 딥링크 처리 (앱이 딥링크로 시작된 경우)
    await _handleInitialLink();

    // 딥링크 리스너 시작
    _startListening();
  }

  /// 앱 시작 시 초기 딥링크 처리
  Future<void> _handleInitialLink() async {
    final uri = await _appLinks.getInitialLink();
    if (uri == null) return;

    // 중복 체크
    final isDuplicate = await _isDuplicateDeepLink(uri);
    if (isDuplicate) return;

    // URL 파싱하여 경로 추출
    final routePath = _parseDeepLinkUrl(uri.toString());
    if (routePath != null) {
      // 인증 완료까지 보류
      PendingDeepLinkService.instance.setPendingDeepLink(routePath);
    }
  }

  /// 딥링크 URL 파싱
  String? _parseDeepLinkUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Custom Scheme (gearfreak://product/123)
    if (uri.scheme == 'gearfreak' || uri.scheme == 'gear-freaks') {
      if (uri.host.isNotEmpty) {
        return '/${uri.host}${uri.path}';
      } else {
        return uri.path;
      }
    }

    // HTTPS App Links (https://gear-freaks.com/product/123)
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      return uri.path;
    }

    return routePath;
  }

  /// 앱 실행 중 딥링크 수신 (바로 라우팅)
  void _startListening() {
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      final routePath = _parseDeepLinkUrl(uri.toString());
      if (routePath != null) {
        _router?.go(routePath);
      }
    });
  }
}
```

#### PendingDeepLinkService (딥링크 임시 저장소)

**파일**: `lib/shared/service/pending_deep_link_service.dart`

```dart
class PendingDeepLinkService {
  static final instance = PendingDeepLinkService._();
  static const _ttl = Duration(minutes: 5);  // TTL: 5분

  String? _pendingDeepLink;
  DateTime? _pendingDeepLinkTimestamp;

  /// 딥링크 저장
  void setPendingDeepLink(String routePath) {
    _pendingDeepLink = routePath;
    _pendingDeepLinkTimestamp = DateTime.now();
  }

  /// 보류 중인 딥링크 가져오고 초기화 (TTL 체크)
  String? consumePendingDeepLink() {
    if (_pendingDeepLink != null && _pendingDeepLinkTimestamp != null) {
      final elapsed = DateTime.now().difference(_pendingDeepLinkTimestamp!);
      if (elapsed > _ttl) {
        clear();  // TTL 초과 시 자동 삭제
        return null;
      }
    }

    final link = _pendingDeepLink;
    if (link != null) {
      _pendingDeepLink = null;
      _pendingDeepLinkTimestamp = null;
    }
    return link;
  }
}
```

### 2.5 자동 로그인 흐름

```
1. 앱 시작
   ↓
2. AuthNotifier 생성 → _checkSession() 자동 호출
   ↓
3. state = AuthLoading (스플래시 화면 표시)
   ↓
4. getMeUseCase 호출 (서버에서 세션 확인)
   ↓
5-A. 세션 유효 → state = AuthAuthenticated
     ↓
     ref.watch(authNotifierProvider) 감지 → GoRouter 재생성
     ↓
     AppRouteGuard: 스플래시 → Pending DeepLink 또는 /main/home

5-B. 세션 없음 → state = AuthUnauthenticated
     ↓
     AppRouteGuard: 스플래시 → /login
```

### 2.6 gear_freak의 주요 특징

✅ **장점:**
1. **Sealed Class 패턴**: Dart 3.0의 패턴 매칭으로 타입 안전한 상태 관리
2. **Switch Expression**: 가독성 높은 redirect 로직
3. **Open Redirect 방지**: 보안을 위한 경로 검증 로직
4. **TTL 적용**: Pending DeepLink 5분 후 자동 만료
5. **중복 처리 방지**: SharedPreferences로 1분 이내 동일 딥링크 차단
6. **자동 재연결**: Riverpod의 `ref.watch`로 인증 상태 변경 시 자동 GoRouter 재생성

---

## 3. kobic 프로젝트 분석

### 3.1 아키텍처 개요

kobic는 **BLoC + GoRouter**를 사용하며, TypedGoRoute와 GlobalAuthManager를 활용한 구조입니다.

**핵심 파일 구조:**
```
feature/application/app_router/lib/src/
├── route/
│   ├── app_router.dart               # GoRouter 정의
│   ├── app_routes.dart               # 라우트 목록
│   └── app_route_guard.dart          # redirect 로직
feature/common/auth/lib/src/
└── presentation/
    └── route/
        └── route_refresh_listener.dart  # AuthBloc 상태 감지
```

### 3.2 GoRouter 초기화

**파일**: `feature/application/app_router/lib/src/route/app_router.dart`

```dart
static GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: StoreRouteName.path, // '/store'
  navigatorKey: _navigatorKey, // GlobalAuthManager와 공유
  observers: [
    appGetIt<GoRouteObserver>(param1: RouteNavigatorKeys.debugLabel),
  ],

  // 핵심: redirect와 refreshListenable
  redirect: appGetIt<AppRouteGuard>().guard,
  refreshListenable: appGetIt<RouteRefreshListener>(),  // BLoC 상태 감지
  routes: AppRoutes.routes,
);
```

**핵심 포인트:**
- `refreshListenable: RouteRefreshListener()` → AuthBloc 상태 변경 시 redirect 재실행
- `initialLocation: '/store'` → 공개 페이지로 시작
- `GlobalAuthManager`와 NavigatorKey 공유

### 3.3 자동 로그인 처리 로직

#### RouteRefreshListener (AuthBloc 상태 감지)

**파일**: `feature/common/auth/lib/src/presentation/route/route_refresh_listener.dart`

```dart
@lazySingleton
class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authBloc) {
    notifyListeners();
    _authStreamSubscription = _authBloc.stream.asBroadcastStream().listen((_) {
      notifyListeners(); // AuthBloc 상태 변경 시 GoRouter에 통지
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

**동작 원리:**
1. `AuthBloc`의 스트림을 구독
2. 인증 상태 변경 시 `notifyListeners()` 호출
3. GoRouter의 `refreshListenable`에 연결되어 자동으로 `redirect` 재실행

#### AppRouteGuard (redirect 로직)

**파일**: `feature/application/app_router/lib/src/route/app_route_guard.dart`

```dart
String? guard(BuildContext _, GoRouterState goRouterState) {
  const loginPath = AuthRouteName.path;
  const initialPath = SplashRouteName.path;
  const homePath = StoreRouteName.path;
  const extraInfoPath = ExtraInfoRouteName.path;
  final currentPath = goRouterState.matchedLocation;

  final isLoginScreen = checkLoginPage(currentPath);
  final isSplashScreen = currentPath == initialPath;
  final isExtraInfoScreen = currentPath.contains(extraInfoPath);
  final requiresAuth = _requiresAuthentication(currentPath);
  final currentState = _authBloc.state;

  final redirectTo = switch (currentState) {
    // 초기 상태: 스플래시 화면으로 리디렉션
    AuthStateInitial() => isSplashScreen ? null : initialPath,

    // 로딩 상태: 현재 위치 유지 (리디렉션 없음)
    AuthStateLoading() => null,

    // 미인증 상태: 선택적 리디렉션
    Unauthenticated() => switch (true) {
      _ when isLoginScreen => null, // 로그인 페이지 접근 허용
      _ when requiresAuth => loginPath, // 인증 필요 페이지는 로그인으로
      _ when isSplashScreen => homePath, // 스플래시에서 스토어로
      _ => null, // 공개 페이지 모두 허용
    },

    // 인증 실패 상태
    Failed() => switch (true) {
      _ when isLoginScreen => null,
      _ when requiresAuth => loginPath,
      _ when isSplashScreen => homePath,
      _ => null, // 인증 실패여도 공개 페이지 접근 허용
    },

    // 인증 상태: 추가 유저 정보 체크
    Authenticated(user: _, hasExtraInfo: final userHasExtraInfo) => switch (true) {
      _ when isLoginScreen || isSplashScreen => homePath,
      _ when isExtraInfoScreen => null,
      _ when !userHasExtraInfo => extraInfoPath, // 추가 정보 미입력 시 리디렉션
      _ => null,
    },
  };

  return redirectTo;
}

/// 인증 필요 페이지 정의
bool _requiresAuthentication(String path) {
  final authRequiredPages = [
    MyPageRouteName.path,
    MyLibraryRouteName.path,
    BookContentViewerRouteName.name,
  ];

  return authRequiredPages.any((requiredPage) => path.contains(requiredPage));
}
```

#### GlobalAuthManager (전역 인증 관리)

**파일**: `feature/application/app_router/lib/src/route/global_auth_manager.dart`

```dart
class GlobalAuthManager {
  static final GlobalAuthManager _instance = GlobalAuthManager._internal();
  static GlobalAuthManager get instance => _instance;

  GlobalKey<NavigatorState>? _navigatorKey;
  bool _isLoginDialogShowing = false;
  String? _originalPath;
  VoidCallback? _onAuthSuccess;

  // 인증 상태 확인
  bool isStrictlyAuthenticated() {
    final authState = appGetIt<AuthBloc>().state;
    return authState is Authenticated;
  }

  // 인증 요구 (로그인 다이얼로그 표시)
  FutureOr<bool> requireAuthentication({
    String message = '이 기능을 사용하려면 로그인이 필요합니다',
    String? originalPath,
    VoidCallback? onSuccess,
  }) {
    if (isStrictlyAuthenticated()) {
      onSuccess?.call();
      return true;
    }

    _saveOriginalPath(originalPath);
    _onAuthSuccess = onSuccess;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoginRequiredDialog(message);
    });

    return false;
  }

  // AuthBloc 상태 변경 리스너
  void startAuthStateListener() {
    _authStateSubscription = appGetIt<AuthBloc>().stream.listen((authState) {
      if (authState is Authenticated && _isLoginDialogShowing) {
        // 인증 성공 시 로그인 페이지 닫고 원본 경로 복원
        _isLoginDialogShowing = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = _safeContext;
          if (context != null) {
            context.pop(); // 로그인 페이지 닫기
            _restoreOriginalPath(); // 원본 경로로 복원
            _onAuthSuccess?.call(); // 성공 콜백 실행
          }
        });
      }
    });
  }
}
```

### 3.4 DeepLink 처리

#### DeepLinkService

**파일**: `feature/application/app_router/lib/src/route/deep_link_service.dart`

```dart
class DeepLinkService {
  static final instance = DeepLinkService._();
  late final AppLinks _appLinks;

  Future<void> initialize() async {
    _appLinks = AppLinks();
    await Future<void>(handleInitialLink); // 초기 딥링크 처리
    startListening(); // 딥링크 수신 대기
  }

  Future<void> handleIncomingLink(String url) async {
    // 1. URL 파싱
    final result = parseDeepLink(url);
    if (result is! DeepLinkSuccess) return;

    final routePath = result.route.routePath;

    // 2. 인증 상태 초기화 대기
    await _waitForAuthInitialization();

    // 3. 같은 경로 재진입 시 타임스탬프 추가
    final currentLocation = AppRouter.router.routeInformationProvider.value.uri.path;
    final targetPath = Uri.parse(routePath).path;

    var finalRoutePath = routePath;
    if (currentLocation == targetPath) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      finalRoutePath = '$routePath?_t=$timestamp';
    }

    // 4. 인증 필요 여부 확인
    if (result.route.requiresAuth &&
        !GlobalAuthManager.instance.isStrictlyAuthenticated()) {
      await GlobalAuthManager.instance.requireAuthentication(
        onSuccess: () {
          AppRouter.router.go(finalRoutePath);
        },
        originalPath: finalRoutePath,
      );
      return;
    }

    // 5. 라우팅 실행
    AppRouter.router.go(finalRoutePath);
  }

  // 인증 상태 초기화 대기 (최대 2초)
  Future<void> _waitForAuthInitialization() async {
    final authBloc = appGetIt<AuthBloc>();
    if (authBloc.state is! AuthStateInitial) return;

    try {
      await authBloc.stream
          .firstWhere((state) => state is! AuthStateInitial)
          .timeout(const Duration(seconds: 2));
    } on TimeoutException {
      Log.w('⚠️ 인증 상태 초기화 대기 타임아웃 (2초) - 계속 진행');
    }
  }
}
```

### 3.5 자동 로그인 흐름

```
1. 앱 시작 → AuthBloc.InitializeAuthEvent 발생
   ↓
2. GetUserUsecase 호출 → 로컬 토큰 확인
   ↓
3. 인증 성공 → Authenticated 상태
   ↓
4. RouteRefreshListener가 AuthBloc 상태 변경 감지
   ↓
5. notifyListeners() → GoRouter의 redirect 재실행
   ↓
6. AppRouteGuard.guard 실행
   ↓
7. 현재 경로와 인증 상태에 따라 리디렉션
   - 스플래시 → 스토어 (로그인 완료)
   - 로그인 페이지 → 스토어 (이미 로그인됨)
   - 보호된 페이지 → 해당 페이지 유지 (인증됨)
```

### 3.6 kobic의 주요 특징

✅ **장점:**
1. **BLoC 통합**: RouteRefreshListener로 BLoC 상태 변경 자동 감지
2. **공개 페이지 우선**: 인증 실패 시에도 스토어 등 공개 페이지 접근 허용
3. **추가 정보 체크**: 로그인 후 필수 정보 입력 여부 확인 및 리디렉션
4. **GlobalAuthManager**: 앱 전역에서 인증 관리 (다이얼로그 표시, 원본 경로 복원)
5. **TypedGoRoute**: 타입 안전 라우팅 (go_router_builder 사용)
6. **DeepLink 인증 대기**: 딥링크 처리 전 인증 상태 초기화 대기 (최대 2초)

⚠️ **주의사항:**
- GlobalAuthManager는 싱글톤 패턴으로 구현되어 있어 테스트가 어려울 수 있음
- TypedGoRoute는 코드 생성이 필요하므로 빌드 시간이 증가할 수 있음

---

## 4. NoGERD 현재 라우팅 구조

### 4.1 현재 라우팅 방식

NoGERD는 **Navigator API 직접 사용 (Imperative Routing)** 방식입니다.

```dart
// 로그인 성공 시
Navigator.of(context).pushReplacement(
  MaterialPageRoute<void>(
    builder: (_) => const MainScreen(),
  ),
);

// 회원가입 페이지로 이동
Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => const SignUpPage()),
);
```

### 4.2 현재 자동 로그인 처리

**파일**: `lib/screens/splash/splash_screen.dart`

```dart
void _navigateToNext() {
  Future.delayed(const Duration(milliseconds: 2500), () {
    if (mounted) {
      final authState = context.read<AuthBloc>().state;

      final nextScreen = authState.maybeWhen(
        authenticated: (_) => const MainScreen(),
        orElse: () => const LoginPage(),
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  });
}
```

**처리 흐름:**
```
App 시작
    ↓
App.dart의 AuthBloc 생성
    ↓
AuthBloc.add(AuthEvent.checkStatus())
    ↓
SplashScreen 표시 (애니메이션 중)
    ↓
2500ms 지연 후 AuthBloc 상태 확인
    ↓
├─ authenticated 상태 → MainScreen 이동
└─ 기타 상태 → LoginPage 이동
```

### 4.3 현재 구조의 문제점

❌ **문제점:**
1. **딥링킹 미지원**: 외부에서 특정 화면으로 직접 진입 불가
2. **네비게이션 상태 추적 어려움**: 현재 어떤 화면 스택이 쌓여있는지 파악 어려움
3. **뒤로 가기 버튼 수동 관리**: AppBar의 leading을 수동으로 설정해야 함
4. **BlocListener 기반 네비게이션**: 화면 전환 로직이 UI 코드에 분산됨
5. **재사용성 낮음**: 동일한 네비게이션 로직을 여러 곳에서 반복
6. **URL 기반 네비게이션 불가**: 웹 지원 시 문제 발생

### 4.4 현재 라우팅 관련 파일 목록

| 파일 경로 | 역할 | 라우팅 방식 |
|---------|------|---------|
| `lib/main.dart` | 앱 진입점 | MaterialApp 설정 |
| `lib/app.dart` | App 위젯 | MultiBlocProvider |
| `lib/screens/splash/splash_screen.dart` | 스플래시 화면 | 조건부 네비게이션 |
| `lib/features/auth/presentation/pages/login_page.dart` | 로그인 | BlocListener |
| `lib/features/auth/presentation/pages/signup_page.dart` | 회원가입 | BlocListener |
| `lib/screens/main_screen.dart` | 메인 화면 | IndexedStack + 바텀 네비게이션 |

---

## 5. GoRouter 마이그레이션 전략

### 5.1 마이그레이션 접근 방식

NoGERD 프로젝트는 **BLoC**을 사용하고 있으므로, **kobic 프로젝트의 접근 방식**을 기반으로 마이그레이션하는 것이 적합합니다.

**선택 이유:**
- ✅ BLoC 상태 관리 방식 동일
- ✅ RouteRefreshListener 패턴 적용 가능
- ✅ 공개/보호 페이지 구분이 명확함
- ✅ Sealed Class 패턴으로 타입 안전성 확보 가능

### 5.2 적용할 핵심 패턴

#### 1. RouteRefreshListener (kobic 방식)

```dart
class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authBloc) {
    _authStreamSubscription = _authBloc.stream.listen((_) {
      notifyListeners(); // AuthBloc 상태 변경 시 GoRouter에 통지
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

#### 2. AppRouteGuard (kobic 방식 + gear_freak 보안 기능)

```dart
String? guard(BuildContext context, GoRouterState state) {
  final authState = _authBloc.state;
  final currentPath = state.matchedLocation;

  return switch (authState) {
    _Initial() => currentPath == '/splash' ? null : '/splash',
    _Loading() => null, // 현재 위치 유지
    _Unauthenticated() => switch (true) {
      _ when _isLoginScreen(currentPath) => null,
      _ when _requiresAuth(currentPath) => _buildLoginWithRedirect(currentPath),
      _ => null, // 공개 페이지 허용
    },
    _Authenticated() => switch (true) {
      _ when _isLoginScreen(currentPath) => _getRedirectPath(state),
      _ when currentPath == '/splash' => '/',
      _ => null,
    },
    _Error() => '/login',
  };
}
```

#### 3. PendingDeepLinkService (gear_freak 방식)

```dart
class PendingDeepLinkService {
  static final instance = PendingDeepLinkService._();
  static const _ttl = Duration(minutes: 5);

  String? _pendingDeepLink;
  DateTime? _pendingDeepLinkTimestamp;

  void setPendingDeepLink(String routePath) {
    _pendingDeepLink = routePath;
    _pendingDeepLinkTimestamp = DateTime.now();
  }

  String? consumePendingDeepLink() {
    if (_pendingDeepLink != null && _pendingDeepLinkTimestamp != null) {
      final elapsed = DateTime.now().difference(_pendingDeepLinkTimestamp!);
      if (elapsed > _ttl) {
        clear();
        return null;
      }
    }

    final link = _pendingDeepLink;
    if (link != null) {
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

### 5.3 라우트 구조 설계

```
NoGERD 라우트 구조 (제안)

/splash (초기 진입점, redirect로 자동 처리)
├─ authenticated → / (메인 화면)
└─ unauthenticated → /login

/login (로그인 화면)
├─ /signup (회원가입)
└─ /verify-email (이메일 인증)

/ (메인 화면 - StatefulShellRoute)
├─ / (홈 - 인덱스 0)
├─ /calendar (캘린더 - 인덱스 1)
├─ /insights (분석 - 인덱스 2)
└─ /settings (설정 - 인덱스 3)

/record (기록 관련)
├─ /record/symptom (증상 기록)
├─ /record/meal (식사 기록)
└─ /record/medication (약물 기록)

/profile (프로필)
└─ /profile/edit (프로필 편집)
```

---

## 6. 구현 계획

### 6.1 Phase 1: 기반 구조 설정

#### 1. GoRouter 설정 파일 생성

**파일 구조:**
```
lib/core/route/
├── app_router.dart               # GoRouter 인스턴스
├── app_routes.dart               # 라우트 목록
├── app_route_guard.dart          # redirect 로직
├── route_refresh_listener.dart   # AuthBloc 상태 감지
└── pending_deep_link_service.dart # 딥링크 임시 저장소
```

#### 2. RouteRefreshListener 구현

```dart
// lib/core/route/route_refresh_listener.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';

class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authBloc) {
    notifyListeners();
    _authStreamSubscription = _authBloc.stream.listen((_) {
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

#### 3. AppRouteGuard 구현

```dart
// lib/core/route/app_route_guard.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nogerd/core/route/pending_deep_link_service.dart';

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

    final redirectTo = switch (currentState) {
      _Initial() => isSplashScreen ? null : splashPath,
      _Loading() => null,
      _Unauthenticated() => switch (true) {
        _ when isLoginScreen => null,
        _ when isSplashScreen => loginPath,
        _ when requiresAuth => _buildLoginPathWithRedirect(currentPath),
        _ => null,
      },
      _Authenticated() => switch (true) {
        _ when isLoginScreen => _getRedirectPath(state, homePath),
        _ when isSplashScreen => _getPendingDeepLinkOrHome(homePath),
        _ => null,
      },
      _Error() => isLoginScreen ? null : loginPath,
      _ => null,
    };

    return redirectTo;
  }

  bool _checkLoginPage(String path) {
    return path == '/login' || path == '/signup' || path == '/verify-email';
  }

  bool _requiresAuthentication(String path) {
    // 공개 페이지 목록 (인증 불필요)
    const publicPages = ['/login', '/signup', '/verify-email', '/splash'];
    return !publicPages.any((publicPage) => path.startsWith(publicPage));
  }

  String _buildLoginPathWithRedirect(String currentPath) {
    if (currentPath != '/splash' &&
        currentPath != '/login' &&
        currentPath != '/signup') {
      return '/login?redirect=${Uri.encodeComponent(currentPath)}';
    }
    return '/login';
  }

  String? _validateRedirect(String? redirect) {
    if (redirect == null || redirect.isEmpty) return null;

    // 내부 경로만 허용
    if (!redirect.startsWith('/')) return null;

    // 허용된 경로 prefix 체크
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

  String _getRedirectPath(GoRouterState state, String defaultPath) {
    final redirectParam = state.uri.queryParameters['redirect'];
    final validatedRedirect = _validateRedirect(redirectParam);

    if (validatedRedirect != null) {
      return validatedRedirect;
    }
    return defaultPath;
  }

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

#### 4. PendingDeepLinkService 구현

```dart
// lib/core/route/pending_deep_link_service.dart
import 'package:flutter/foundation.dart';

class PendingDeepLinkService {
  PendingDeepLinkService._();
  static final instance = PendingDeepLinkService._();

  static const _ttl = Duration(minutes: 5);

  String? _pendingDeepLink;
  DateTime? _pendingDeepLinkTimestamp;

  String? get pendingDeepLink => _pendingDeepLink;

  void setPendingDeepLink(String routePath) {
    _pendingDeepLink = routePath;
    _pendingDeepLinkTimestamp = DateTime.now();
    debugPrint('📌 Pending deep link saved: $routePath');
  }

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

### 6.2 Phase 2: 라우트 정의

#### 1. AppRoutes 정의

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

abstract final class AppRoutes {
  // Navigator Keys (탭별 독립적인 스택)
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
        // 인증 불필요 페이지
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

        // 메인 화면 (StatefulShellRoute)
        _mainShellRoute,

        // 기록 관련 라우트 (추후 추가)
        // GoRoute(
        //   path: '/record/symptom',
        //   name: 'symptom-record',
        //   builder: (context, state) => const SymptomRecordScreen(),
        // ),
      ];

  static final RouteBase _mainShellRoute = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return MainScreen(navigationShell: navigationShell);
    },
    branches: [
      // 홈 탭
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

      // 캘린더 탭
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

      // 분석 탭
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

      // 설정 탭
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

#### 2. AppRouter 구현

```dart
// lib/core/route/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nogerd/core/route/app_routes.dart';
import 'package:nogerd/core/route/app_route_guard.dart';
import 'package:nogerd/core/route/route_refresh_listener.dart';
import 'package:nogerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nogerd/core/di/injection.dart';

class AppRouter {
  static GoRouter createRouter() {
    final authBloc = getIt<AuthBloc>();

    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/splash',
      navigatorKey: AppRoutes.rootNavigatorKey,
      redirect: AppRouteGuard(authBloc).guard,
      refreshListenable: RouteRefreshListener(authBloc),
      routes: AppRoutes.routes,
    );
  }
}
```

### 6.3 Phase 3: MainScreen 수정

#### MainScreen을 StatefulShellRoute와 연동

```dart
// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '캘린더'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: '분석'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
```

### 6.4 Phase 4: App.dart 수정

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
            ..add(const AuthEvent.checkStatus()),
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
        routerConfig: AppRouter.createRouter(),
      ),
    );
  }
}
```

### 6.5 Phase 5: SplashScreen 제거 또는 간소화

#### 옵션 1: SplashScreen 제거 (권장)

GoRouter의 redirect 기능으로 자동 로그인 처리가 되므로, SplashScreen을 제거하고 로딩 인디케이터로 대체합니다.

```dart
// AppRouteGuard의 guard 메서드에서 처리
_Loading() => null, // 현재 위치 유지 (로딩 중)
```

#### 옵션 2: SplashScreen 간소화

애니메이션만 표시하고, 네비게이션 로직은 제거합니다.

```dart
// lib/screens/splash/splash_screen.dart
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

### 6.6 Phase 6: 페이지별 Navigator 제거

#### LoginPage 수정

```dart
// Before (Navigator 사용)
Navigator.of(context).pushReplacement(
  MaterialPageRoute<void>(
    builder: (_) => const MainScreen(),
  ),
);

// After (GoRouter 사용)
context.go('/');
```

```dart
// lib/features/auth/presentation/pages/login_page.dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      authenticated: (user) {
        // GoRouter의 redirect가 자동으로 처리하므로
        // 수동 네비게이션 불필요
        // context.go('/'); // 이것도 불필요할 수 있음
      },
      error: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      orElse: () {},
    );
  },
  child: /* 로그인 UI */,
)

// 회원가입 버튼
ElevatedButton(
  onPressed: () => context.push('/signup'),
  child: const Text('회원가입'),
)
```

#### SignUpPage 수정

```dart
// lib/features/auth/presentation/pages/signup_page.dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      authenticated: (_) {
        // GoRouter의 redirect가 자동으로 홈으로 이동
      },
      error: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      orElse: () {},
    );
  },
  child: /* 회원가입 UI */,
)
```

#### SettingsPage 로그아웃 수정

```dart
// lib/features/settings/presentation/pages/settings_page.dart
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
          child: const Text('로그아웃'),
        ),
      ],
    ),
  );
}
```

### 6.7 Phase 7: DeepLink 지원 추가 (선택)

#### app_links 패키지 추가

```yaml
# pubspec.yaml
dependencies:
  app_links: ^6.4.1
```

#### DeepLinkService 구현

```dart
// lib/core/route/deep_link_service.dart
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:nogerd/core/route/pending_deep_link_service.dart';

class DeepLinkService {
  DeepLinkService._();
  static final instance = DeepLinkService._();

  late final AppLinks _appLinks;
  GoRouter? _router;

  Future<void> initialize(GoRouter router) async {
    _appLinks = AppLinks();
    _router = router;

    // 초기 딥링크 처리
    await _handleInitialLink();

    // 딥링크 리스너 시작
    _startListening();
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri == null) return;

      debugPrint('🔗 Initial deep link: $uri');

      final routePath = _parseDeepLinkUrl(uri.toString());
      if (routePath != null) {
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
      return uri.path;
    }

    return null;
  }
}
```

#### main.dart에서 DeepLinkService 초기화

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const App());

  // 딥링크 서비스 초기화 (앱 실행 후)
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final router = AppRouter.createRouter();
    DeepLinkService.instance.initialize(router);
  });
}
```

---

## 7. 참고 코드 샘플

### 7.1 gear_freak 핵심 파일 위치

```
/Users/pyowonsik/Downloads/workspace/gear_freak/gear_freak_flutter/lib/
├── core/route/
│   ├── router_provider.dart (line 1-30)
│   ├── app_routes.dart (line 1-100)
│   ├── app_route.dart (line 1-150)
│   └── app_route_guard.dart (line 1-200)
├── feature/auth/presentation/provider/
│   ├── auth_state.dart
│   └── auth_notifier.dart (line 1-100)
└── shared/service/
    ├── deep_link_service.dart (line 1-150)
    └── pending_deep_link_service.dart (line 1-80)
```

### 7.2 kobic 핵심 파일 위치

```
/Users/pyowonsik/Downloads/workspace/kobic/
├── feature/application/app_router/lib/src/route/
│   ├── app_router.dart (line 1-50)
│   ├── app_routes.dart (line 1-200)
│   ├── app_route_guard.dart (line 1-150)
│   └── global_auth_manager.dart (line 1-200)
└── feature/common/auth/lib/src/presentation/route/
    └── route_refresh_listener.dart (line 1-30)
```

### 7.3 참고 코드 스니펫

#### Sealed Class 패턴 (Dart 3.0)

```dart
// Before (freezed)
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated(User user) = _Authenticated;
  // ...
}

// After (sealed class)
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);
  final User user;
}

// Switch Expression 사용 시 컴파일 타임 완전성 체크
final action = switch (authState) {
  AuthInitial() => 'initial',
  Authenticated(:final user) => 'logged in as ${user.name}',
  // 모든 케이스를 처리하지 않으면 컴파일 에러
};
```

#### StatefulShellRoute 기본 구조

```dart
StatefulShellRoute.indexedStack(
  branches: [
    StatefulShellBranch(
      navigatorKey: homeTabNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
    // 더 많은 브랜치...
  ],
  builder: (context, state, navigationShell) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          // 더 많은 아이템...
        ],
      ),
    );
  },
)
```

---

## 8. 결론 및 권장사항

### 8.1 최종 권장사항

NoGERD 프로젝트에 GoRouter를 도입하기 위해 다음 전략을 권장합니다:

1. **kobic의 BLoC 통합 패턴 적용**
   - RouteRefreshListener로 AuthBloc 상태 자동 감지
   - AppRouteGuard의 redirect 로직으로 자동 로그인 처리

2. **gear_freak의 보안 기능 차용**
   - Open Redirect 방지 로직
   - PendingDeepLinkService의 TTL 메커니즘
   - Sealed Class 패턴으로 타입 안전성 확보

3. **단계적 마이그레이션**
   - Phase 1-3: GoRouter 기본 구조 설정 및 라우트 정의
   - Phase 4-6: 기존 Navigator 코드 제거 및 GoRouter로 전환
   - Phase 7: DeepLink 지원 추가 (선택)

### 8.2 예상되는 이점

✅ **개발 경험 향상:**
- Declarative Routing으로 라우트 구조 명확화
- 중복된 네비게이션 로직 제거
- 타입 안전한 라우팅 (Named Route 사용 시)

✅ **사용자 경험 향상:**
- 자동 로그인 처리 (수동 네비게이션 불필요)
- 딥링킹 지원 (향후 마케팅 활용 가능)
- 뒤로 가기 버튼 자동 관리

✅ **유지보수성 향상:**
- 라우팅 로직 중앙 관리
- 보안 정책 통합 적용 (Open Redirect 방지)
- 테스트 용이성 증가

### 8.3 주의사항

⚠️ **마이그레이션 시 주의할 점:**
1. **BlocListener 네비게이션 제거**: GoRouter의 redirect가 자동으로 처리하므로 수동 네비게이션 불필요
2. **SplashScreen 로직 변경**: 네비게이션 로직을 AppRouteGuard로 이동
3. **MainScreen 구조 변경**: StatefulShellRoute와 연동되도록 수정
4. **Context 사용 주의**: `context.go()`는 스택 교체, `context.push()`는 스택 추가

### 8.4 다음 단계

1. **구현 계획 검토**: 이 문서의 Phase 1-7을 팀과 검토
2. **프로토타입 작성**: Phase 1-3만 먼저 구현하여 동작 확인
3. **단계적 마이그레이션**: 한 화면씩 차례로 GoRouter로 전환
4. **테스트**: 자동 로그인, 딥링킹, 뒤로 가기 동작 확인
5. **배포**: 충분한 테스트 후 프로덕션 배포

---

## 9. 추가 리소스

### 9.1 공식 문서

- [GoRouter 공식 문서](https://pub.dev/documentation/go_router/latest/)
- [GoRouter 예제](https://github.com/flutter/packages/tree/main/packages/go_router/example)
- [app_links 공식 문서](https://pub.dev/packages/app_links)

### 9.2 참고 프로젝트

- **gear_freak**: `/Users/pyowonsik/Downloads/workspace/gear_freak/gear_freak_flutter`
- **kobic**: `/Users/pyowonsik/Downloads/workspace/kobic`

### 9.3 관련 이슈

- [GoRouter + BLoC 통합 이슈](https://github.com/flutter/flutter/issues/99112)
- [StatefulShellRoute 사용법](https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart)

---

**작성일**: 2026-01-14
**작성자**: Claude Code
**문서 버전**: 1.0
