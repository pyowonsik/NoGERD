import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 트리거 분석 결과
class TriggerAnalysis {
  /// 생성자
  const TriggerAnalysis({
    required this.category,
    required this.count,
  });

  /// 트리거 카테고리
  final TriggerFoodCategory category;

  /// 발생 횟수
  final int count;
}

/// 트리거 분석 UseCase
///
/// 식사 기록에서 트리거 음식을 분석하여 빈도를 계산합니다.
@injectable
class AnalyzeTriggersUseCase
    implements UseCase<List<TriggerAnalysis>, DateRangeParams> {
  /// 생성자
  const AnalyzeTriggersUseCase(this._repository);

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
  Future<Either<Failure, List<TriggerAnalysis>>> call(
      DateRangeParams params) async {
    if (_useMockData) {
      // 이번 주 = 좋은 시나리오, 지난 주 = 나쁜 시나리오
      final isGood = _isThisWeek(params);
      if (isGood) {
        // 좋은 시나리오: 트리거 음식 거의 안 먹음
        return const Right([
          TriggerAnalysis(category: TriggerFoodCategory.caffeine, count: 1),
        ]);
      } else {
        // 나쁜 시나리오: 트리거 음식 많이 섭취
        return const Right([
          TriggerAnalysis(category: TriggerFoodCategory.spicy, count: 10),
          TriggerAnalysis(category: TriggerFoodCategory.fatty, count: 8),
          TriggerAnalysis(category: TriggerFoodCategory.caffeine, count: 7),
          TriggerAnalysis(category: TriggerFoodCategory.carbonated, count: 5),
          TriggerAnalysis(category: TriggerFoodCategory.alcohol, count: 4),
        ]);
      }
    }

    try {
      // 범위 조회로 한 번에 데이터 가져오기
      final result = await _repository.getMealRecordsInRange(
        params.startDate,
        params.endDate,
      );

      return result.fold(
        Left.new,
        (meals) {
          final triggerCounts = <TriggerFoodCategory, int>{};

          for (final meal in meals) {
            final triggers = meal.triggerCategories;
            if (triggers != null) {
              for (final trigger in triggers) {
                triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
              }
            }
          }

          // 빈도순으로 정렬
          final analysisList = triggerCounts.entries
              .map((e) => TriggerAnalysis(category: e.key, count: e.value))
              .toList()
            ..sort((a, b) => b.count.compareTo(a.count));

          return Right(analysisList);
        },
      );
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
