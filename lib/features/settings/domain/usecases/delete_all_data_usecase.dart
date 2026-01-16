import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 모든 데이터 삭제 UseCase
@injectable
class DeleteAllDataUseCase implements UseCase<Unit, NoParams> {
  final SettingsRepository _repository;

  /// 생성자
  const DeleteAllDataUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return _repository.deleteAllData();
  }
}
