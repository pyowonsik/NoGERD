import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 트리거 분석 결과
class TriggerAnalysis {
  /// 트리거 카테고리
  final TriggerFoodCategory category;

  /// 발생 횟수
  final int count;

  /// 생성자
  const TriggerAnalysis({
    required this.category,
    required this.count,
  });
}

/// 트리거 분석 UseCase
///
/// 식사 기록에서 트리거 음식을 분석하여 빈도를 계산합니다.
@injectable
class AnalyzeTriggersUseCase
    implements UseCase<List<TriggerAnalysis>, DateTime> {
  /// 생성자
  const AnalyzeTriggersUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, List<TriggerAnalysis>>> call(DateTime params) async {
    try {
      final Map<TriggerFoodCategory, int> triggerCounts = {};

      // 지난 30일간의 식사 기록 분석
      for (int i = 0; i < 30; i++) {
        final date = params.subtract(Duration(days: i));
        final result = await _repository.getMealRecords(date);

        result.fold(
          (failure) => null,
          (meals) {
            for (final meal in meals) {
              final triggers = meal.triggerCategories;
              if (triggers != null) {
                for (final trigger in triggers) {
                  triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
                }
              }
            }
          },
        );
      }

      // 빈도순으로 정렬
      final analysisList = triggerCounts.entries
          .map((e) => TriggerAnalysis(category: e.key, count: e.value))
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));

      return Right(analysisList);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
