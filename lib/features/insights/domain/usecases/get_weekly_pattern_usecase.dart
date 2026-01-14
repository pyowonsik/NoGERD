import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 요일별 패턴 데이터
class WeeklyPattern {
  /// 요일 (1=월요일, 7=일요일)
  final int dayOfWeek;

  /// 증상 발생 횟수
  final int symptomCount;

  /// 식사 기록 횟수
  final int mealCount;

  /// 생성자
  const WeeklyPattern({
    required this.dayOfWeek,
    required this.symptomCount,
    required this.mealCount,
  });
}

/// 주간 패턴 조회 UseCase
///
/// 요일별 증상 및 식사 패턴을 분석합니다.
@injectable
class GetWeeklyPatternUseCase
    implements UseCase<List<WeeklyPattern>, NoParams> {
  /// 생성자
  const GetWeeklyPatternUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, List<WeeklyPattern>>> call(NoParams params) async {
    try {
      // 요일별 카운트 초기화 (1=월, 7=일)
      final Map<int, int> symptomCounts = {
        for (int i = 1; i <= 7; i++) i: 0,
      };
      final Map<int, int> mealCounts = {
        for (int i = 1; i <= 7; i++) i: 0,
      };

      // 지난 28일(4주) 데이터 분석
      final now = DateTime.now();
      for (int i = 0; i < 28; i++) {
        final date = now.subtract(Duration(days: i));
        final dayOfWeek = date.weekday; // 1=월, 7=일

        final result = await _repository.getAllRecords(date);

        result.fold(
          (failure) => null,
          (records) {
            final symptoms = records['symptoms'] as List;
            final meals = records['meals'] as List;

            symptomCounts[dayOfWeek] =
                (symptomCounts[dayOfWeek] ?? 0) + symptoms.length;
            mealCounts[dayOfWeek] =
                (mealCounts[dayOfWeek] ?? 0) + meals.length;
          },
        );
      }

      // WeeklyPattern 리스트 생성
      final patterns = <WeeklyPattern>[];
      for (int day = 1; day <= 7; day++) {
        patterns.add(WeeklyPattern(
          dayOfWeek: day,
          symptomCount: symptomCounts[day] ?? 0,
          mealCount: mealCounts[day] ?? 0,
        ));
      }

      return Right(patterns);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
