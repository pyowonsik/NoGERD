import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/core/route/app_router.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_event.dart';
import 'package:no_gerd/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:no_gerd/features/home/presentation/bloc/home_bloc.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

/// NoGERD 앱 위젯
///
/// MultiBlocProvider를 통해 모든 Feature BLoC을 제공합니다.
class App extends StatefulWidget {
  /// 생성자
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // AuthBloc을 먼저 생성하고 checkStatus 이벤트 발생
    _authBloc = getIt<AuthBloc>()..add(const AuthEvent.checkStatus());
    // 같은 AuthBloc 인스턴스를 사용하는 GoRouter 생성
    _router = AppRouter.createRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Feature BLoC
        BlocProvider<AuthBloc>.value(
          value: _authBloc,
        ),

        // Home Feature BLoC
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
        ),

        // Calendar Feature BLoC
        BlocProvider<CalendarBloc>(
          create: (_) {
            print('🔥 [CalendarBloc] BLoC 생성 시작');
            final bloc = getIt<CalendarBloc>();
            print('🔥 [CalendarBloc] loadMonth 이벤트 추가');
            bloc.add(CalendarEvent.loadMonth(DateTime.now()));
            return bloc;
          },
          lazy: false,
        ),

        // Insights Feature BLoC
        BlocProvider<InsightsBloc>(
          create: (_) => getIt<InsightsBloc>(),
        ),

        // Settings Feature BLoC
        BlocProvider<SettingsBloc>(
          create: (_) => getIt<SettingsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'NoGERD',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
