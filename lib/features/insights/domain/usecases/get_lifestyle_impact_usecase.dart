import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 생활습관 영향 데이터
class LifestyleImpact {
  /// 생활습관 유형
  final LifestyleType lifestyleType;

  /// 평균 값 (수면 시간, 운동 횟수, 스트레스 레벨 등)
  final double averageValue;

  /// 상태 라벨 (양호, 보통, 부족 등)
  final String statusLabel;

  /// 설명
  final String description;

  /// 생성자
  const LifestyleImpact({
    required this.lifestyleType,
    required this.averageValue,
    required this.statusLabel,
    required this.description,
  });
}

/// 생활습관 영향 분석 UseCase
///
/// 지정된 기간 동안의 생활습관 기록을 분석하여 건강에 미치는 영향을 평가합니다.
@injectable
class GetLifestyleImpactUseCase
    implements UseCase<List<LifestyleImpact>, int> {
  /// 생성자
  const GetLifestyleImpactUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, List<LifestyleImpact>>> call(int days) async {
    try {
      final Map<LifestyleType, List<double>> lifestyleData = {};
      final now = DateTime.now();

      for (int i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: i));
        final result = await _repository.getLifestyleRecords(date);

        result.fold(
          (failure) => null,
          (records) {
            for (final record in records) {
              final type = record.lifestyleType;
              final details = record.details;

              // 통합 생활습관 기록 처리
              // 수면 정보
              final sleepHours = (details['sleep_hours'] as num?)?.toDouble();
              if (sleepHours != null) {
                lifestyleData.putIfAbsent(LifestyleType.sleep, () => []).add(sleepHours);
              }

              // 스트레스 정보
              final stressLevel = (details['stress_level'] as num?)?.toDouble();
              if (stressLevel != null) {
                lifestyleData.putIfAbsent(LifestyleType.stress, () => []).add(stressLevel);
              }

              // 운동 정보 (boolean -> 1 또는 0으로 변환)
              final exercised = details['exercised'] as bool?;
              if (exercised != null) {
                lifestyleData.putIfAbsent(LifestyleType.exercise, () => []).add(exercised ? 1.0 : 0.0);
              }
            }
          },
        );
      }

      // 분석 결과 생성
      final impacts = <LifestyleImpact>[];

      // 수면 분석
      if (lifestyleData.containsKey(LifestyleType.sleep)) {
        final sleepValues = lifestyleData[LifestyleType.sleep]!;
        final averageSleep =
            sleepValues.reduce((a, b) => a + b) / sleepValues.length;
        impacts.add(_analyzeSleep(averageSleep));
      }

      // 운동 분석
      if (lifestyleData.containsKey(LifestyleType.exercise)) {
        final exerciseValues = lifestyleData[LifestyleType.exercise]!;
        // 운동한 횟수 계산 (1.0 값의 개수)
        final exerciseCount = exerciseValues.where((v) => v == 1.0).length;
        impacts.add(_analyzeExercise(exerciseCount, days));
      }

      // 스트레스 분석
      if (lifestyleData.containsKey(LifestyleType.stress)) {
        final stressValues = lifestyleData[LifestyleType.stress]!;
        final averageStress =
            stressValues.reduce((a, b) => a + b) / stressValues.length;
        impacts.add(_analyzeStress(averageStress));
      }

      return Right(impacts);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  /// 수면 분석
  LifestyleImpact _analyzeSleep(double averageHours) {
    String statusLabel;
    String description;

    if (averageHours >= 7) {
      statusLabel = '양호';
      description = '평균 ${averageHours.toStringAsFixed(1)}시간 수면';
    } else if (averageHours >= 6) {
      statusLabel = '보통';
      description = '평균 ${averageHours.toStringAsFixed(1)}시간 수면';
    } else {
      statusLabel = '부족';
      description = '평균 ${averageHours.toStringAsFixed(1)}시간 수면';
    }

    return LifestyleImpact(
      lifestyleType: LifestyleType.sleep,
      averageValue: averageHours,
      statusLabel: statusLabel,
      description: description,
    );
  }

  /// 운동 분석
  LifestyleImpact _analyzeExercise(int exerciseCount, int totalDays) {
    String statusLabel;
    String description;

    // 주간 기준으로 환산 (7일 기준)
    final weeklyCount = totalDays >= 7
        ? (exerciseCount / (totalDays / 7)).round()
        : exerciseCount;

    if (weeklyCount >= 3) {
      statusLabel = '양호';
      description = '주 $weeklyCount회 운동';
    } else if (weeklyCount >= 1) {
      statusLabel = '보통';
      description = '주 $weeklyCount회 운동';
    } else {
      statusLabel = '부족';
      description = '운동 기록 없음';
    }

    return LifestyleImpact(
      lifestyleType: LifestyleType.exercise,
      averageValue: weeklyCount.toDouble(),
      statusLabel: statusLabel,
      description: description,
    );
  }

  /// 스트레스 분석
  LifestyleImpact _analyzeStress(double averageLevel) {
    String statusLabel;
    String description;

    if (averageLevel <= 3) {
      statusLabel = '양호';
      description = '낮은 스트레스 수준';
    } else if (averageLevel <= 6) {
      statusLabel = '보통';
      description = '보통 스트레스 수준';
    } else {
      statusLabel = '주의';
      description = '높은 스트레스 수준';
    }

    return LifestyleImpact(
      lifestyleType: LifestyleType.stress,
      averageValue: averageLevel,
      statusLabel: statusLabel,
      description: description,
    );
  }
}
