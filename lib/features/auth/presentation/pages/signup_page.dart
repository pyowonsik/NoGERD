import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_event.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_state.dart';
import 'package:no_gerd/shared/shared.dart';

/// 회원가입 페이지
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withAlpha(13),
      prefixIcon: Icon(
        prefixIcon,
        color: AppTheme.textSecondary.withAlpha(179),
      ),
      suffixIcon: suffixIcon,
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
    );
  }

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
              state.maybeWhen(
                authenticated: (_) {
                  context.go('/');
                },
                emailVerificationRequired: (email) {
                  // 이메일 인증 페이지로 이동
                  context
                      .go('/verify-email?email=${Uri.encodeComponent(email)}');
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

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // 뒤로가기 버튼
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 헤더
                        Center(
                          child: Column(
                            children: [
                              const AppLogo(size: LogoSize.small),
                              const SizedBox(height: 20),
                              const Text(
                                '회원가입',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '건강 관리를 시작해보세요',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary.withAlpha(179),
                                ),
                              ),
                            ],
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
                          decoration: _buildInputDecoration(
                            label: '이메일',
                            hint: 'example@email.com',
                            prefixIcon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요';
                            }
                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
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
                          decoration: _buildInputDecoration(
                            label: '비밀번호',
                            hint: '영문, 숫자, 특수문자 포함 12자 이상',
                            prefixIcon: Icons.lock_outline,
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
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            if (value.length < 12) {
                              return '비밀번호는 12자 이상이어야 합니다';
                            }
                            if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                              return '영문을 포함해야 합니다';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return '숫자를 포함해야 합니다';
                            }
                            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                              return '특수문자를 포함해야 합니다';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 비밀번호 확인 입력 필드
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: _buildInputDecoration(
                            label: '비밀번호 확인',
                            hint: '비밀번호를 다시 입력',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textSecondary.withAlpha(179),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호 확인을 입력해주세요';
                            }
                            // 비밀번호 조건 불만족 시 중복 에러 방지
                            final password = _passwordController.text;
                            if (password.length < 12 ||
                                !RegExp(r'[a-zA-Z]').hasMatch(password) ||
                                !RegExp(r'[0-9]').hasMatch(password) ||
                                !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
                              return null;
                            }
                            if (value != password) {
                              return '비밀번호가 일치하지 않습니다';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),

                        // 회원가입 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: GradientButton(
                            text: isLoading ? '가입 중...' : '회원가입',
                            onPressed: isLoading ? null : _handleSignUp,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 로그인으로 돌아가기
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary.withAlpha(179),
                                ),
                                children: const [
                                  TextSpan(text: '이미 계정이 있으신가요? '),
                                  TextSpan(
                                    text: '로그인',
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEvent.signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
