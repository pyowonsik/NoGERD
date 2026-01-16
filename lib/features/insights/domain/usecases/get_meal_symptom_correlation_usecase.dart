import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 식사-증상 연관성 데이터
class MealSymptomCorrelation {
  /// 식사 타입
  final MealType mealType;

  /// 해당 식사 후 증상 발생 횟수
  final int symptomCount;

  /// 전체 식사 횟수
  final int totalMealCount;

  /// 생성자
  const MealSymptomCorrelation({
    required this.mealType,
    required this.symptomCount,
    required this.totalMealCount,
  });

  /// 증상 발생률 (%)
  int get percentage =>
      totalMealCount > 0 ? ((symptomCount / totalMealCount) * 100).round() : 0;
}

/// 식사-증상 연관성 조회 UseCase
///
/// 식사 타입별로 식사 후 2시간 이내 증상 발생률을 계산합니다.
@injectable
class GetMealSymptomCorrelationUseCase
    implements UseCase<List<MealSymptomCorrelation>, DateRangeParams> {
  /// 생성자
  const GetMealSymptomCorrelationUseCase(this._repository);

  final IRecordRepository _repository;

  // 실제 데이터 사용
  static const _useMockData = false;

  /// 이번 주인지 확인
  bool _isThisWeek(DateRangeParams params) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final thisMonday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1));
    return params.startDate.isAtSameMomentAs(thisMonday) ||
        params.startDate.isAfter(thisMonday);
  }

  @override
  Future<Either<Failure, List<MealSymptomCorrelation>>> call(DateRangeParams params) async {
    if (_useMockData) {
      // 이번 주 = 좋은 시나리오, 지난 주 = 나쁜 시나리오
      final isGood = _isThisWeek(params);
      if (isGood) {
        // 좋은 시나리오: 식사 후 증상 거의 없음 (아침 0%, 점심 0%, 저녁 20%)
        return Right([
          const MealSymptomCorrelation(
            mealType: MealType.breakfast,
            symptomCount: 0,
            totalMealCount: 5,
          ),
          const MealSymptomCorrelation(
            mealType: MealType.lunch,
            symptomCount: 0,
            totalMealCount: 5,
          ),
          const MealSymptomCorrelation(
            mealType: MealType.dinner,
            symptomCount: 1,
            totalMealCount: 5,
          ),
        ]);
      } else {
        // 나쁜 시나리오: 식사 후 증상 많음 (아침 40%, 점심 60%, 저녁 80%)
        return Right([
          const MealSymptomCorrelation(
            mealType: MealType.breakfast,
            symptomCount: 2,
            totalMealCount: 5,
          ),
          const MealSymptomCorrelation(
            mealType: MealType.lunch,
            symptomCount: 3,
            totalMealCount: 5,
          ),
          const MealSymptomCorrelation(
            mealType: MealType.dinner,
            symptomCount: 4,
            totalMealCount: 5,
          ),
        ]);
      }
    }

    try {
      final Map<MealType, int> mealCounts = {
        for (final type in MealType.values) type: 0,
      };
      final Map<MealType, int> symptomAfterMealCounts = {
        for (final type in MealType.values) type: 0,
      };

      var currentDate = params.startDate;

      while (!currentDate.isAfter(params.endDate)) {
        // 식사 기록 가져오기
        final mealResult = await _repository.getMealRecords(currentDate);
        // 증상 기록 가져오기
        final symptomResult = await _repository.getSymptomRecords(currentDate);

        mealResult.fold(
          (failure) => null,
          (meals) {
            // 식사 카운트
            for (final meal in meals) {
              mealCounts[meal.mealType] = (mealCounts[meal.mealType] ?? 0) + 1;

              // 해당 식사 후 2시간 이내 증상 발생 확인
              symptomResult.fold(
                (failure) => null,
                (symptoms) {
                  final hasSymptomAfterMeal = symptoms.any((symptom) {
                    final timeDiff =
                        symptom.recordedAt.difference(meal.recordedAt);
                    return timeDiff.inMinutes >= 0 &&
                        timeDiff.inHours < 2; // 2시간 이내
                  });

                  if (hasSymptomAfterMeal) {
                    symptomAfterMealCounts[meal.mealType] =
                        (symptomAfterMealCounts[meal.mealType] ?? 0) + 1;
                  }
                },
              );
            }
          },
        );

        currentDate = currentDate.add(const Duration(days: 1));
      }

      // 결과 리스트 생성 (아침, 점심, 저녁만 포함)
      final correlations = [
        MealType.breakfast,
        MealType.lunch,
        MealType.dinner,
      ].map((type) {
        return MealSymptomCorrelation(
          mealType: type,
          symptomCount: symptomAfterMealCounts[type] ?? 0,
          totalMealCount: mealCounts[type] ?? 0,
        );
      }).toList();

      return Right(correlations);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
