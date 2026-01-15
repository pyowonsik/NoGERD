import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 생활습관 기록 추가 UseCase
@injectable
class AddLifestyleRecordUseCase implements UseCase<Unit, LifestyleRecord> {
  /// 생성자
  const AddLifestyleRecordUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(LifestyleRecord params) {
    return _repository.addLifestyleRecord(params);
  }
}
