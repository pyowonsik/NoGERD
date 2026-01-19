import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

/// 인증 Repository Interface
abstract class IAuthRepository {
  /// 이메일/비밀번호로 회원가입
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  });

  /// 이메일/비밀번호로 로그인
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  /// 로그아웃
  Future<Either<Failure, Unit>> signOut();

  /// 현재 인증된 사용자 가져오기
  Future<Either<Failure, User?>> getCurrentUser();

  /// 세션 스트림 (인증 상태 변경 감지)
  Stream<User?> authStateChanges();

  /// 이메일 인증 재발송
  Future<Either<Failure, Unit>> resendVerificationEmail(String email);

  /// 비밀번호 재설정 이메일 발송
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  /// OTP 인증
  Future<Either<Failure, User>> verifyOtp({
    required String email,
    required String token,
  });
}
