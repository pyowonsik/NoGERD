import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 특정 날짜 + 식사 타입의 기록 조회 UseCase (UPSERT용)
@injectable
class GetMealRecordByDateAndTypeUseCase
    implements UseCase<MealRecord?, GetMealRecordParams> {
  /// 생성자
  const GetMealRecordByDateAndTypeUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, MealRecord?>> call(GetMealRecordParams params) {
    return _repository.getMealRecordByDateAndType(params.date, params.mealType);
  }
}

/// 식사 기록 조회 파라미터
class GetMealRecordParams {
  /// 생성자
  const GetMealRecordParams({
    required this.date,
    required this.mealType,
  });

  /// 조회 날짜
  final DateTime date;

  /// 식사 타입
  final MealType mealType;
}
