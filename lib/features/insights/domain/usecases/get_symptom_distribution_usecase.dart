import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 증상 분포 데이터
class SymptomDistribution {
  /// 생성자
  const SymptomDistribution({
    required this.symptom,
    required this.count,
  });

  /// 증상 타입
  final GerdSymptom symptom;

  /// 발생 횟수
  final int count;
}

/// 증상 분포 조회 UseCase
///
/// 지정된 기간 동안의 증상별 발생 빈도를 반환합니다.
@injectable
class GetSymptomDistributionUseCase
    implements UseCase<List<SymptomDistribution>, DateRangeParams> {
  /// 생성자
  const GetSymptomDistributionUseCase(this._repository);

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
  Future<Either<Failure, List<SymptomDistribution>>> call(
      DateRangeParams params) async {
    if (_useMockData) {
      // 이번 주 = 좋은 시나리오, 지난 주 = 나쁜 시나리오
      final isGood = _isThisWeek(params);
      if (isGood) {
        // 좋은 시나리오: 증상 거의 없음
        return const Right([
          SymptomDistribution(symptom: GerdSymptom.heartburn, count: 1),
        ]);
      } else {
        // 나쁜 시나리오: 다양한 증상 많이 발생
        return const Right([
          SymptomDistribution(
            symptom: GerdSymptom.regurgitation,
            count: 12,
          ),
          SymptomDistribution(symptom: GerdSymptom.heartburn, count: 9),
          SymptomDistribution(symptom: GerdSymptom.chestPain, count: 6),
          SymptomDistribution(symptom: GerdSymptom.nausea, count: 4),
          SymptomDistribution(symptom: GerdSymptom.bloating, count: 3),
        ]);
      }
    }

    try {
      // 범위 조회로 한 번에 데이터 가져오기
      final result = await _repository.getSymptomRecordsInRange(
        params.startDate,
        params.endDate,
      );

      return result.fold(
        Left.new,
        (symptoms) {
          final symptomCounts = <GerdSymptom, int>{};

          for (final symptomRecord in symptoms) {
            for (final symptom in symptomRecord.symptoms) {
              symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
            }
          }

          // 빈도순으로 정렬
          final distributionList = symptomCounts.entries
              .map((e) => SymptomDistribution(symptom: e.key, count: e.value))
              .toList()
            ..sort((a, b) => b.count.compareTo(a.count));

          return Right(distributionList);
        },
      );
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
