import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Auth Event
@freezed
class AuthEvent with _$AuthEvent {
  /// 인증 상태 확인 이벤트
  const factory AuthEvent.checkStatus() = AuthEventCheckStatus;

  /// 로그인 이벤트
  const factory AuthEvent.signIn({
    /// 이메일
    required String email,

    /// 비밀번호
    required String password,
  }) = AuthEventSignIn;

  /// 회원가입 이벤트
  const factory AuthEvent.signUp({
    /// 이메일
    required String email,

    /// 비밀번호
    required String password,
  }) = AuthEventSignUp;

  /// 로그아웃 이벤트
  const factory AuthEvent.signOut() = AuthEventSignOut;

  /// 인증 이메일 재전송 이벤트
  const factory AuthEvent.resendVerification({
    /// 이메일
    required String email,
  }) = AuthEventResendVerification;

  /// OTP 인증 이벤트
  const factory AuthEvent.verifyOtp({
    /// 이메일
    required String email,

    /// 인증 토큰
    required String token,
  }) = AuthEventVerifyOtp;
}
