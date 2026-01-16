import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// SignUp UseCase 파라미터
class SignUpParams {
  SignUpParams({required this.email, required this.password});
  final String email;
  final String password;
}

/// 회원가입 UseCase
@injectable
class SignUpUseCase implements UseCase<User, SignUpParams> {
  const SignUpUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}
