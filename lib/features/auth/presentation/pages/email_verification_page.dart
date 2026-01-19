import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_event.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_state.dart';
import 'package:no_gerd/shared/shared.dart';

/// 이메일 인증 페이지 (OTP 입력 방식)
class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({required this.email, super.key});

  final String email;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final code = _otpController.text.trim();
    if (code.length >= 6) {
      context.read<AuthBloc>().add(
            AuthEvent.verifyOtp(
              email: widget.email,
              token: code,
            ),
          );
    }
  }

  void _resendCode() {
    context.read<AuthBloc>().add(
          AuthEvent.resendVerification(email: widget.email),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('인증 코드를 다시 보냈습니다'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('이메일 인증이 완료되었습니다!'),
                      backgroundColor: Colors.green.shade400,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  context.go('/');
                },
                error: (failure) {
                  // 코드 초기화
                  _otpController.clear();
                  _focusNode.requestFocus();

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
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이메일 아이콘
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 60,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 타이틀
                        const Text(
                          '이메일 인증',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 설명
                        Text(
                          '${widget.email}\n으로 전송된 인증 코드를 입력해주세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary.withAlpha(204),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // OTP 입력 필드
                        TextFormField(
                          controller: _otpController,
                          focusNode: _focusNode,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 8,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            letterSpacing: 8,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '인증 코드 입력',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0,
                              color: AppTheme.textSecondary.withAlpha(100),
                            ),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: AppTheme.primary.withAlpha(50),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppTheme.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 40),

                        // 인증 버튼
                        if (isLoading)
                          const CircularProgressIndicator(
                            color: AppTheme.primary,
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: GradientButton(
                              text: '인증하기',
                              onPressed: _otpController.text.length >= 6
                                  ? _verifyOtp
                                  : null,
                            ),
                          ),
                        const SizedBox(height: 24),

                        // 재전송 버튼
                        TextButton.icon(
                          onPressed: isLoading ? null : _resendCode,
                          icon: const Icon(
                            Icons.refresh_rounded,
                            size: 18,
                          ),
                          label: const Text('인증 코드 다시 받기'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 로그인으로 돌아가기
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: Text(
                            '로그인 화면으로 돌아가기',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary.withAlpha(179),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // 도움말
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.textSecondary.withAlpha(13),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.help_outline_rounded,
                                    size: 18,
                                    color: AppTheme.textSecondary.withAlpha(179),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '코드가 오지 않나요?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          AppTheme.textSecondary.withAlpha(204),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• 스팸 폴더를 확인해주세요\n• 이메일 주소가 올바른지 확인해주세요\n• 몇 분 후에 다시 시도해주세요',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary.withAlpha(153),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
