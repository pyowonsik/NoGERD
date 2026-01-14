import 'package:go_router/go_router.dart';
import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/core/route/app_route_guard.dart';
import 'package:no_gerd/core/route/app_routes.dart';
import 'package:no_gerd/core/route/route_refresh_listener.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';

/// GoRouter 인스턴스를 생성하는 클래스
class AppRouter {
  static GoRouter createRouter({AuthBloc? authBloc}) {
    final bloc = authBloc ?? getIt<AuthBloc>();

    return GoRouter(
      debugLogDiagnostics: true, // 개발 시 디버그 로그 출력
      initialLocation: '/splash', // 앱 시작 시 스플래시 화면
      navigatorKey: AppRoutes.rootNavigatorKey,
      redirect: AppRouteGuard(bloc).guard, // 인증 가드
      refreshListenable: RouteRefreshListener(bloc), // BLoC 상태 감지
      routes: AppRoutes.routes,
    );
  }
}
