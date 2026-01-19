import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 건강 점수 계산 UseCase
///
/// 최근 기록을 기반으로 건강 점수(0-100)를 계산합니다.
@injectable
class CalculateHealthScoreUseCase implements UseCase<int, DateTime> {
  /// 생성자
  const CalculateHealthScoreUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, int>> call(DateTime params) async {
    try {
      // 지난 7일간의 데이터로 건강 점수 계산
      final endDate = DateTime(params.year, params.month, params.day);
      final startDate = endDate.subtract(const Duration(days: 6));

      // 단일 범위 조회로 7일 데이터 가져오기 (7번 → 1번 API 호출)
      final result = await _repository.getAllRecordsInRange(startDate, endDate);

      return result.fold(
        Left.new,
        (recordsByDate) {
          var totalScore = 100;

          for (final dayRecords in recordsByDate.values) {
            // 증상 기록에 따른 점수 감점
            final symptoms = dayRecords['symptoms'] as List<SymptomRecord>;
            for (final symptom in symptoms) {
              totalScore -= symptom.severity; // 심각도만큼 감점
            }

            // 약물 복용에 따른 점수 가산 (관리 중)
            final medications = dayRecords['medications'] as List;
            totalScore += medications.length * 2;

            // 생활습관 기록에 따른 점수 가산
            final lifestyles = dayRecords['lifestyles'] as List;
            totalScore += lifestyles.length;
          }

          // 점수를 0-100 범위로 제한
          final finalScore = totalScore.clamp(0, 100);

          return Right(finalScore);
        },
      );
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
