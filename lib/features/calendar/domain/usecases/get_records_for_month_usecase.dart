import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 특정 월의 모든 기록 조회 UseCase
@injectable
class GetRecordsForMonthUseCase
    implements UseCase<Map<DateTime, Map<String, dynamic>>, DateTime> {
  /// 생성자
  const GetRecordsForMonthUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, Map<DateTime, Map<String, dynamic>>>> call(
    DateTime params,
  ) async {
    // 해당 월의 첫날과 마지막 날 계산
    final firstDay = DateTime(params.year, params.month);
    final lastDay = DateTime(params.year, params.month + 1, 0);

    // ignore: avoid_print
    print('[GetRecordsForMonthUseCase] 범위 조회: $firstDay ~ $lastDay');

    // 단일 범위 쿼리로 월별 데이터 조회 (4번의 API 호출)
    return _repository.getAllRecordsInRange(firstDay, lastDay);
  }
}
