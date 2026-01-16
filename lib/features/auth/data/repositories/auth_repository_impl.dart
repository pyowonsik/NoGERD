import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// Auth Repository 구현
@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUp(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthDataSourceException catch (e) {
      return Left(_handleAuthError(e.message));
    } catch (e) {
      return Left(Failure.unexpected('회원가입 중 오류 발생: ${e}'));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthDataSourceException catch (e) {
      return Left(_handleAuthError(e.message));
    } catch (e) {
      return Left(Failure.unexpected('로그인 중 오류 발생: ${e}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('로그아웃 중 오류 발생: ${e}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      if (userModel == null) return const Right(null);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(Failure.unexpected('사용자 정보 조회 실패: ${e}'));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map((userModel) {
      return userModel?.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> resendVerificationEmail() async {
    try {
      await _remoteDataSource.resendVerificationEmail();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('인증 이메일 발송 실패: ${e}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('비밀번호 재설정 이메일 발송 실패: ${e}'));
    }
  }

  Failure _handleAuthError(String message) {
    if (message.contains('Email not confirmed')) {
      return const Failure.validation('이메일 인증이 필요합니다');
    }
    if (message.contains('Invalid login credentials')) {
      return const Failure.validation('이메일 또는 비밀번호가 잘못되었습니다');
    }
    if (message.contains('User already registered')) {
      return const Failure.validation('이미 가입된 이메일입니다');
    }
    return Failure.unexpected(message);
  }
}
