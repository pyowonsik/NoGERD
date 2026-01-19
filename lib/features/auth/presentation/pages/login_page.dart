import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_event.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_state.dart';
import 'package:no_gerd/shared/shared.dart';

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // 현재 페이지가 활성화되어 있을 때만 처리 (회원가입 페이지에서 중복 스낵바 방지)
              final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
              if (!isCurrent) return;

              state.maybeWhen(
                authenticated: (user) {
                  context.go('/');
                },
                error: (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ErrorMessageHelper.toKorean(failure.message),
                      ),
                      backgroundColor: Colors.red.shade400,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 로고 영역
                        const AppLogo(),
                        const SizedBox(height: 24),
                        Text(
                          '건강한 일상을 위한 첫 걸음',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary.withAlpha(204),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // 이메일 입력 필드
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: '이메일',
                            hintText: 'example@email.com',
                            filled: true,
                            fillColor: Colors.white.withAlpha(13),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppTheme.textSecondary.withAlpha(179),
                            ),
                            labelStyle: TextStyle(
                              color: AppTheme.textSecondary.withAlpha(179),
                            ),
                            hintStyle: TextStyle(
                              color: AppTheme.textSecondary.withAlpha(100),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.white.withAlpha(26),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppTheme.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요';
                            }
                            if (!value.contains('@')) {
                              return '올바른 이메일 형식이 아닙니다';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 비밀번호 입력 필드
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            hintText: '12자 이상 입력 (특수문자 + 영어 대소문자 + 숫자 조합)',
                            filled: true,
                            fillColor: Colors.white.withAlpha(13),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppTheme.textSecondary.withAlpha(179),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textSecondary.withAlpha(179),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            labelStyle: TextStyle(
                              color: AppTheme.textSecondary.withAlpha(179),
                            ),
                            hintStyle: TextStyle(
                              color: AppTheme.textSecondary.withAlpha(100),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.white.withAlpha(26),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppTheme.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            if (value.length < 12) {
                              return '12자 이상 입력 (특수문자 + 영어 대소문자 + 숫자 조합).';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // 로그인 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: GradientButton(
                            text: isLoading ? '로그인 중...' : '로그인',
                            onPressed: isLoading ? null : _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 구분선
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppTheme.textSecondary.withAlpha(51),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '또는',
                                style: TextStyle(
                                  color: AppTheme.textSecondary.withAlpha(153),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppTheme.textSecondary.withAlpha(51),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 회원가입 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: isLoading ? null : _goToSignUp,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppTheme.primary.withAlpha(128),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              '회원가입',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 하단 안내 문구
                        Text(
                          '계속 진행하면 서비스 이용약관에 동의하게 됩니다',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary.withAlpha(128),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEvent.signIn(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _goToSignUp() {
    context.push('/signup');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
