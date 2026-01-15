import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 약물 기록 추가 UseCase
@injectable
class AddMedicationRecordUseCase implements UseCase<Unit, MedicationRecord> {
  /// 생성자
  const AddMedicationRecordUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(MedicationRecord params) {
    return _repository.addMedicationRecord(params);
  }
}
