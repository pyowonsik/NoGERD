import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 증상 기록 추가 UseCase
@injectable
class AddSymptomRecordUseCase implements UseCase<Unit, SymptomRecord> {
  /// 생성자
  const AddSymptomRecordUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SymptomRecord params) {
    return _repository.addSymptomRecord(params);
  }
}
