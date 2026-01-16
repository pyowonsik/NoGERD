import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 주간 타입
enum WeekType {
  /// 이번 주
  thisWeek,

  /// 지난 주
  lastWeek,
}

/// 증상 추이 데이터
class SymptomTrend {
  /// 생성자
  const SymptomTrend({
    required this.date,
    required this.count,
    required this.averageSeverity,
  });

  /// 날짜
  final DateTime date;

  /// 증상 발생 횟수
  final int count;

  /// 평균 심각도
  final double averageSeverity;
}

/// 증상 추이 조회 UseCase
///
/// 지정된 기간 동안의 증상 발생 추이를 반환합니다.
@injectable
class GetSymptomTrendsUseCase
    implements UseCase<List<SymptomTrend>, DateRangeParams> {
  /// 생성자
  const GetSymptomTrendsUseCase(this._repository);

  final IRecordRepository _repository;

  // 실제 데이터 사용
  static const _useMockData = false;

  /// 이번 주인지 확인 (이번 주면 좋은 시나리오, 지난 주면 나쁜 시나리오)
  static bool _isThisWeek(DateRangeParams params) {
    final thisWeekRange = getWeekRange(WeekType.thisWeek);
    return params.startDate.isAtSameMomentAs(thisWeekRange.startDate) ||
        params.startDate.isAfter(thisWeekRange.startDate);
  }

  /// 주간 날짜 범위 계산
  static DateRangeParams getWeekRange(WeekType weekType) {
    final now = DateTime.now();
    final weekday = now.weekday; // 1(월) ~ 7(일)
    final thisMonday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1));
    final thisSunday = thisMonday.add(const Duration(days: 6));

    if (weekType == WeekType.thisWeek) {
      return DateRangeParams(startDate: thisMonday, endDate: thisSunday);
    } else {
      final lastMonday = thisMonday.subtract(const Duration(days: 7));
      final lastSunday = lastMonday.add(const Duration(days: 6));
      return DateRangeParams(startDate: lastMonday, endDate: lastSunday);
    }
  }

  @override
  Future<Either<Failure, List<SymptomTrend>>> call(
      DateRangeParams params) async {
    if (_useMockData) {
      // 이번 주 = 좋은 시나리오, 지난 주 = 나쁜 시나리오
      final isGood = _isThisWeek(params);
      return Right(_generateMockTrends(params, isGood: isGood));
    }

    try {
      final trends = <SymptomTrend>[];
      var currentDate = params.startDate;

      while (!currentDate.isAfter(params.endDate)) {
        final result = await _repository.getSymptomRecords(currentDate);

        result.fold(
          (failure) => null,
          (symptoms) {
            if (symptoms.isNotEmpty) {
              final totalSeverity = symptoms.fold<int>(
                0,
                (sum, symptom) => sum + symptom.severity,
              );
              final averageSeverity = totalSeverity / symptoms.length;

              trends.add(
                SymptomTrend(
                  date: currentDate,
                  count: symptoms.length,
                  averageSeverity: averageSeverity,
                ),
              );
            } else {
              trends.add(
                SymptomTrend(
                  date: currentDate,
                  count: 0,
                  averageSeverity: 0,
                ),
              );
            }
          },
        );

        currentDate = currentDate.add(const Duration(days: 1));
      }

      // 날짜 순으로 정렬 (오래된 순)
      trends.sort((a, b) => a.date.compareTo(b.date));

      return Right(trends);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  /// Mock 데이터 생성
  List<SymptomTrend> _generateMockTrends(DateRangeParams params,
      {required bool isGood}) {
    final trends = <SymptomTrend>[];
    var currentDate = params.startDate;

    while (!currentDate.isAfter(params.endDate)) {
      // 주말 제외 (월~금만 기록 있음)
      final isWeekday = currentDate.weekday >= 1 && currentDate.weekday <= 5;

      if (isWeekday) {
        if (isGood) {
          // 좋은 시나리오: 증상 거의 없음 (0~1개, 낮은 심각도)
          final count = currentDate.day % 2; // 0 또는 1
          trends.add(
            SymptomTrend(
              date: currentDate,
              count: count,
              averageSeverity: count > 0 ? 1.5 : 0,
            ),
          );
        } else {
          // 나쁜 시나리오: 증상 많음 (2~4개, 높은 심각도)
          final count = (currentDate.day % 3) + 2;
          trends.add(
            SymptomTrend(
              date: currentDate,
              count: count,
              averageSeverity: 3.5 + (count * 0.3),
            ),
          );
        }
      } else {
        // 주말: 기록 없음
        trends.add(
          SymptomTrend(
            date: currentDate,
            count: 0,
            averageSeverity: 0,
          ),
        );
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // 날짜 순으로 정렬 (오래된 순)
    trends.sort((a, b) => a.date.compareTo(b.date));
    return trends;
  }
}
