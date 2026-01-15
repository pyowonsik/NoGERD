import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Auth State
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.emailVerificationRequired(String email) =
      _EmailVerificationRequired;
  const factory AuthState.error(Failure failure) = _Error;
}
