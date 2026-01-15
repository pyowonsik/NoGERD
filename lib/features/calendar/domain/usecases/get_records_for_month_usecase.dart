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
    try {
      // 해당 월의 첫날과 마지막 날 계산
      final firstDay = DateTime(params.year, params.month, 1);
      final lastDay = DateTime(params.year, params.month + 1, 0);

      final Map<DateTime, Map<String, dynamic>> monthRecords = {};

      // 해당 월의 모든 날짜에 대해 기록 조회
      for (var day = firstDay;
          day.isBefore(lastDay.add(const Duration(days: 1)));
          day = day.add(const Duration(days: 1))) {
        final result = await _repository.getAllRecords(day);

        result.fold(
          (failure) => null, // 실패해도 계속 진행
          (records) {
            // 기록이 있는 날짜만 추가
            final hasRecords = (records['symptoms'] as List).isNotEmpty ||
                (records['meals'] as List).isNotEmpty ||
                (records['medications'] as List).isNotEmpty ||
                (records['lifestyles'] as List).isNotEmpty;

            if (hasRecords) {
              monthRecords[DateTime(day.year, day.month, day.day)] = records;
            }
          },
        );
      }

      return Right(monthRecords);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }
}
