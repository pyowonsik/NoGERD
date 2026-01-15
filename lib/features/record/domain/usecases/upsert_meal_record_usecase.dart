import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 식사 기록 UPSERT UseCase (있으면 수정, 없으면 추가)
@injectable
class UpsertMealRecordUseCase implements UseCase<Unit, MealRecord> {
  /// 생성자
  const UpsertMealRecordUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(MealRecord params) {
    return _repository.upsertMealRecord(params);
  }
}
