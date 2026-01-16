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

    // ===== 지난 주 데이터 (AI 분석용) =====

    /// 지난 주 증상 추이 데이터
    required List<SymptomTrend> lastWeekSymptomTrends,

    /// 지난 주 트리거 분석 결과
    required List<TriggerAnalysis> lastWeekTriggerAnalysis,

    /// 지난 주 증상 분포 데이터
    required List<SymptomDistribution> lastWeekSymptomDistribution,

    /// 지난 주 식사-증상 연관성 데이터
    required List<MealSymptomCorrelation> lastWeekMealSymptomCorrelation,

    /// 지난 주 생활습관 영향 데이터
    required List<LifestyleImpact> lastWeekLifestyleImpacts,

    /// 에러
    required Option<Failure> failure,

    /// AI 인사이트 로딩 상태
    required bool isAILoading,

    /// AI 인사이트 결과
    required Option<AIInsight> aiInsight,

    /// 이번 주 AI 리포트 생성 가능 여부
    required bool canGenerateThisWeek,

    /// 다음 리포트 생성 가능 날짜 (월요일)
    required DateTime? nextReportDate,
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
        lastWeekSymptomTrends: [],
        lastWeekTriggerAnalysis: [],
        lastWeekSymptomDistribution: [],
        lastWeekMealSymptomCorrelation: [],
        lastWeekLifestyleImpacts: [],
        failure: none(),
        isAILoading: false,
        aiInsight: none(),
        canGenerateThisWeek: true,
        nextReportDate: null,
      );
}
