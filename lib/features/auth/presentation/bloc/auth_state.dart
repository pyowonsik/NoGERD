import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Auth State
@freezed
class AuthState with _$AuthState {
  /// 초기 상태
  const factory AuthState.initial() = _Initial;

  /// 로딩 상태
  const factory AuthState.loading() = _Loading;

  /// 인증됨 상태
  const factory AuthState.authenticated(User user) = _Authenticated;

  /// 미인증 상태
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// 이메일 인증 필요 상태
  const factory AuthState.emailVerificationRequired(String email) =
      _EmailVerificationRequired;

  /// 에러 상태
  const factory AuthState.error(Failure failure) = _Error;
}
