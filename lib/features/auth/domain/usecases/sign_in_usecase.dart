import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// SignIn UseCase 파라미터
class SignInParams {
  SignInParams({required this.email, required this.password});
  final String email;
  final String password;
}

/// 로그인 UseCase
@injectable
class SignInUseCase implements UseCase<User, SignInParams> {
  const SignInUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
