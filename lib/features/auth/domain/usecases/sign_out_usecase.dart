import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// 로그아웃 UseCase
@injectable
class SignOutUseCase implements UseCase<Unit, NoParams> {
  const SignOutUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.signOut();
  }
}
