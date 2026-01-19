import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';
import 'package:no_gerd/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:no_gerd/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:no_gerd/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:no_gerd/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_event.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_state.dart';

/// Auth BLoC
@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
    this._authRepository,
  ) : super(const AuthState.initial()) {
    on<AuthEventCheckStatus>(_onCheckStatus);
    on<AuthEventSignIn>(_onSignIn);
    on<AuthEventSignUp>(_onSignUp);
    on<AuthEventSignOut>(_onSignOut);
    on<AuthEventResendVerification>(_onResendVerification);
    on<AuthEventVerifyOtp>(_onVerifyOtp);
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IAuthRepository _authRepository;

  Future<void> _onCheckStatus(
    AuthEventCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) {
        if (user == null) {
          emit(const AuthState.unauthenticated());
        } else {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }

  Future<void> _onSignIn(
    AuthEventSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignUp(
    AuthEventSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _signUpUseCase(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      // 회원가입 성공 시 이메일 인증 필요 상태로 전환
      (user) => emit(AuthState.emailVerificationRequired(event.email)),
    );
  }

  Future<void> _onSignOut(
    AuthEventSignOut event,
    Emitter<AuthState> emit,
  ) async {
    await _signOutUseCase(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onResendVerification(
    AuthEventResendVerification event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.resendVerificationEmail(event.email);
  }

  Future<void> _onVerifyOtp(
    AuthEventVerifyOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.verifyOtp(
      email: event.email,
      token: event.token,
    );

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
}
