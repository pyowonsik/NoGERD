import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 특정 날짜 + 생활습관 타입의 기록 조회 UseCase (UPSERT용)
@injectable
class GetLifestyleRecordByDateAndTypeUseCase
    implements UseCase<LifestyleRecord?, GetLifestyleRecordParams> {
  /// 생성자
  const GetLifestyleRecordByDateAndTypeUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, LifestyleRecord?>> call(
    GetLifestyleRecordParams params,
  ) {
    return _repository.getLifestyleRecordByDateAndType(
      params.date,
      params.lifestyleType,
    );
  }
}

/// 생활습관 기록 조회 파라미터
class GetLifestyleRecordParams {
  /// 생성자
  const GetLifestyleRecordParams({
    required this.date,
    required this.lifestyleType,
  });

  /// 조회 날짜
  final DateTime date;

  /// 생활습관 타입
  final LifestyleType lifestyleType;
}
