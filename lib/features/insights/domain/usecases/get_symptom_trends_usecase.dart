import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 증상 추이 데이터
class SymptomTrend {
  /// 날짜
  final DateTime date;

  /// 증상 발생 횟수
  final int count;

  /// 평균 심각도
  final double averageSeverity;

  /// 생성자
  const SymptomTrend({
    required this.date,
    required this.count,
    required this.averageSeverity,
  });
}

/// 증상 추이 조회 UseCase
///
/// 지정된 기간 동안의 증상 발생 추이를 반환합니다.
@injectable
class GetSymptomTrendsUseCase
    implements UseCase<List<SymptomTrend>, int> {
  /// 생성자
  const GetSymptomTrendsUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, List<SymptomTrend>>> call(int days) async {
    try {
      final trends = <SymptomTrend>[];
      final now = DateTime.now();

      for (int i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: i));
        final result = await _repository.getSymptomRecords(date);

        result.fold(
          (failure) => null,
          (symptoms) {
            if (symptoms.isNotEmpty) {
              final totalSeverity = symptoms.fold<int>(
                0,
                (sum, symptom) => sum + symptom.severity,
              );
              final averageSeverity = totalSeverity / symptoms.length;

              trends.add(SymptomTrend(
                date: date,
                count: symptoms.length,
                averageSeverity: averageSeverity,
              ));
            } else {
              trends.add(SymptomTrend(
                date: date,
                count: 0,
                averageSeverity: 0,
              ));
            }
          },
        );
      }

      // 날짜 순으로 정렬 (오래된 순)
      trends.sort((a, b) => a.date.compareTo(b.date));

      return Right(trends);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
