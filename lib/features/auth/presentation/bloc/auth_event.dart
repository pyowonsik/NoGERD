import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Auth Event
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkStatus() = AuthEventCheckStatus;
  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = AuthEventSignIn;
  const factory AuthEvent.signUp({
    required String email,
    required String password,
  }) = AuthEventSignUp;
  const factory AuthEvent.signOut() = AuthEventSignOut;
  const factory AuthEvent.resendVerification({
    required String email,
  }) = AuthEventResendVerification;
  const factory AuthEvent.verifyOtp({
    required String email,
    required String token,
  }) = AuthEventVerifyOtp;
}
