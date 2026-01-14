import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:no_gerd/features/home/presentation/bloc/home_bloc.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:no_gerd/screens/splash/splash_screen.dart';
import 'package:no_gerd/shared/shared.dart';

/// NoGERD 앱 위젯
///
/// MultiBlocProvider를 통해 모든 Feature BLoC을 제공합니다.
class App extends StatelessWidget {
  /// 생성자
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Home Feature BLoC
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
        ),

        // Calendar Feature BLoC
        BlocProvider<CalendarBloc>(
          create: (_) => getIt<CalendarBloc>(),
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NoGERD',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
