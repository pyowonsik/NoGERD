part of 'insights_bloc.dart';

/// Insights State
@freezed
class InsightsState with _$InsightsState {
  /// 생성자
  const factory InsightsState({
    /// 로딩 상태
    required bool isLoading,

    /// 선택된 기간 (일)
    required int selectedDays,

    /// 건강 점수
    required int healthScore,

    /// 이전 건강 점수 (변화율 계산용)
    required int previousHealthScore,

    /// 증상 추이 데이터
    required List<SymptomTrend> symptomTrends,

    /// 트리거 분석 결과
    required List<TriggerAnalysis> triggerAnalysis,

    /// 주간 패턴 데이터
    required List<WeeklyPattern> weeklyPatterns,

    /// 증상 분포 데이터
    required List<SymptomDistribution> symptomDistribution,

    /// 식사-증상 연관성 데이터
    required List<MealSymptomCorrelation> mealSymptomCorrelation,

    /// 생활습관 영향 데이터
    required List<LifestyleImpact> lifestyleImpacts,

    /// 에러
    required Option<Failure> failure,
  }) = _InsightsState;

  /// 초기 상태
  factory InsightsState.initial() => InsightsState(
        isLoading: false,
        selectedDays: 7,
        healthScore: 0,
        previousHealthScore: 0,
        symptomTrends: [],
        triggerAnalysis: [],
        weeklyPatterns: [],
        symptomDistribution: [],
        mealSymptomCorrelation: [],
        lifestyleImpacts: [],
        failure: none(),
      );
}
