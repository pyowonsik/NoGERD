import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/pages/login_page.dart';
import 'package:no_gerd/screens/main_screen.dart';
import 'package:no_gerd/shared/shared.dart';

/// 스플래시 스크린 (미니멀 디자인)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNext();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeIn.value,
              child: Transform.scale(
                scale: _scale.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고
              const AppLogo(size: LogoSize.large),
              const SizedBox(height: 32),

              // 앱 이름
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: const Text(
                  'NoGERD',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 슬로건
              Text(
                '건강한 일상을 위한 첫걸음',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary.withAlpha(179),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
