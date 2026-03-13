import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_gerd/core/route/pending_deep_link_service.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';

/// 라우팅 가드: 인증 상태에 따른 redirect 로직
class AppRouteGuard {
  /// 생성자
  const AppRouteGuard(this._authBloc);
  final AuthBloc _authBloc;

  /// 인증 상태에 따른 라우팅 가드 로직
  String? guard(BuildContext context, GoRouterState state) {
    const loginPath = '/login';
    const splashPath = '/splash';
    const homePath = '/';
    final currentPath = state.matchedLocation;

    final isLoginScreen = _checkLoginPage(currentPath);
    final isSplashScreen = currentPath == splashPath;
    final requiresAuth = _requiresAuthentication(currentPath);
    final currentState = _authBloc.state;

    // Freezed의 maybeWhen을 사용한 타입 안전한 분기 처리
    final redirectTo = currentState.maybeWhen(
      // 초기 상태: 스플래시로 리디렉션
      initial: () => isSplashScreen ? null : splashPath,

      // 로딩 중: 현재 위치 유지 (깜빡임 방지)
      loading: () => null,

      // 미인증 상태: 선택적 리디렉션
      unauthenticated: () {
        if (isLoginScreen) return null; // 로그인 페이지 허용
        if (isSplashScreen) return loginPath; // 스플래시 → 로그인
        if (requiresAuth) return _buildLoginPathWithRedirect(currentPath);
        return null; // 공개 페이지 허용
      },

      // 인증 성공: 로그인/스플래시에서 벗어남
      authenticated: (_) {
        if (isLoginScreen) return _getRedirectPath(state, homePath);
        if (isSplashScreen) return _getPendingDeepLinkOrHome(homePath);
        return null; // 모든 페이지 접근 가능
      },

      // 인증 실패: 로그인으로
      error: (_) => isLoginScreen ? null : loginPath,

      // 이메일 인증 필요: 인증 페이지로 (이메일 파라미터 포함)
      emailVerificationRequired: (email) =>
          '/verify-email?email=${Uri.encodeComponent(email)}',

      orElse: () => null,
    );

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
