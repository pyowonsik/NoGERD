import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 증상 분포 데이터
class SymptomDistribution {
  /// 증상 타입
  final GerdSymptom symptom;

  /// 발생 횟수
  final int count;

  /// 생성자
  const SymptomDistribution({
    required this.symptom,
    required this.count,
  });
}

/// 증상 분포 조회 UseCase
///
/// 지정된 기간 동안의 증상별 발생 빈도를 반환합니다.
@injectable
class GetSymptomDistributionUseCase
    implements UseCase<List<SymptomDistribution>, int> {
  /// 생성자
  const GetSymptomDistributionUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, List<SymptomDistribution>>> call(int days) async {
    try {
      final Map<GerdSymptom, int> symptomCounts = {};
      final now = DateTime.now();

      for (int i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: i));
        final result = await _repository.getSymptomRecords(date);

        result.fold(
          (failure) => null,
          (symptoms) {
            for (final symptomRecord in symptoms) {
              for (final symptom in symptomRecord.symptoms) {
                symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
              }
            }
          },
        );
      }

      // 빈도순으로 정렬
      final distributionList = symptomCounts.entries
          .map((e) => SymptomDistribution(symptom: e.key, count: e.value))
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));

      return Right(distributionList);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
