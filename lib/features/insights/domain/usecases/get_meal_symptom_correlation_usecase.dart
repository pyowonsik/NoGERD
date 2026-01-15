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
    implements UseCase<List<MealSymptomCorrelation>, int> {
  /// 생성자
  const GetMealSymptomCorrelationUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, List<MealSymptomCorrelation>>> call(int days) async {
    try {
      final Map<MealType, int> mealCounts = {
        for (final type in MealType.values) type: 0,
      };
      final Map<MealType, int> symptomAfterMealCounts = {
        for (final type in MealType.values) type: 0,
      };

      final now = DateTime.now();

      for (int i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: i));

        // 식사 기록 가져오기
        final mealResult = await _repository.getMealRecords(date);
        // 증상 기록 가져오기
        final symptomResult = await _repository.getSymptomRecords(date);

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
