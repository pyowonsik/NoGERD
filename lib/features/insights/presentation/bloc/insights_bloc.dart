import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/domain/usecases/analyze_triggers_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/calculate_health_score_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_ai_insights_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_lifestyle_impact_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_meal_symptom_correlation_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_symptom_distribution_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_symptom_trends_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_weekly_pattern_usecase.dart';

part 'insights_bloc.freezed.dart';
part 'insights_event.dart';
part 'insights_state.dart';

/// Insights BLoC
@injectable
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  /// 생성자
  InsightsBloc(
    this._calculateHealthScoreUseCase,
    this._analyzeTriggersUseCase,
    this._getSymptomTrendsUseCase,
    this._getWeeklyPatternUseCase,
    this._getSymptomDistributionUseCase,
    this._getMealSymptomCorrelationUseCase,
    this._getLifestyleImpactUseCase,
    this._getAIInsightsUseCase,
  ) : super(InsightsState.initial()) {
    on<InsightsEventLoadData>(_onLoadData);
    on<InsightsEventRefresh>(_onRefresh);
    on<InsightsEventLoadAIInsights>(_onLoadAIInsights);
    on<InsightsEventLoadSavedInsight>(_onLoadSavedInsight);
  }

  final CalculateHealthScoreUseCase _calculateHealthScoreUseCase;
  final AnalyzeTriggersUseCase _analyzeTriggersUseCase;
  final GetSymptomTrendsUseCase _getSymptomTrendsUseCase;
  final GetWeeklyPatternUseCase _getWeeklyPatternUseCase;
  final GetSymptomDistributionUseCase _getSymptomDistributionUseCase;
  final GetMealSymptomCorrelationUseCase _getMealSymptomCorrelationUseCase;
  final GetLifestyleImpactUseCase _getLifestyleImpactUseCase;
  final GetAIInsightsUseCase _getAIInsightsUseCase;

  Future<void> _onLoadData(
    InsightsEventLoadData event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedDays: event.days));

    final now = DateTime.now();

    // 이번 주, 지난 주 날짜 범위 계산
    final thisWeekRange =
        GetSymptomTrendsUseCase.getWeekRange(WeekType.thisWeek);
    final lastWeekRange =
        GetSymptomTrendsUseCase.getWeekRange(WeekType.lastWeek);

    // ===== 이번 주 데이터 로드 (UI 표시용) =====
    final healthScoreFuture = _calculateHealthScoreUseCase(now);
    final trendsFuture = _getSymptomTrendsUseCase(thisWeekRange);
    final triggersFuture = _analyzeTriggersUseCase(thisWeekRange);
    final patternsFuture = _getWeeklyPatternUseCase(const NoParams());
    final distributionFuture = _getSymptomDistributionUseCase(thisWeekRange);
    final correlationFuture = _getMealSymptomCorrelationUseCase(thisWeekRange);
    final lifestyleFuture = _getLifestyleImpactUseCase(thisWeekRange);

    // ===== 지난 주 데이터 로드 (AI 분석용) =====
    final lastWeekTrendsFuture = _getSymptomTrendsUseCase(lastWeekRange);
    final lastWeekTriggersFuture = _analyzeTriggersUseCase(lastWeekRange);
    final lastWeekDistributionFuture =
        _getSymptomDistributionUseCase(lastWeekRange);
    final lastWeekCorrelationFuture =
        _getMealSymptomCorrelationUseCase(lastWeekRange);
    final lastWeekLifestyleFuture = _getLifestyleImpactUseCase(lastWeekRange);

    // 이번 주 결과 대기
    final healthScoreResult = await healthScoreFuture;
    final trendsResult = await trendsFuture;
    final triggersResult = await triggersFuture;
    final patternsResult = await patternsFuture;
    final distributionResult = await distributionFuture;
    final correlationResult = await correlationFuture;
    final lifestyleResult = await lifestyleFuture;

    // 지난 주 결과 대기
    final lastWeekTrendsResult = await lastWeekTrendsFuture;
    final lastWeekTriggersResult = await lastWeekTriggersFuture;
    final lastWeekDistributionResult = await lastWeekDistributionFuture;
    final lastWeekCorrelationResult = await lastWeekCorrelationFuture;
    final lastWeekLifestyleResult = await lastWeekLifestyleFuture;

    // ===== 이번 주 결과 처리 =====
    healthScoreResult.fold(
      (failure) => emit(state.copyWith(failure: some(failure))),
      (score) {
        emit(state.copyWith(
          healthScore: score,
          previousHealthScore: state.healthScore,
        ));
      },
    );

    trendsResult.fold(
      (failure) => null,
      (trends) => emit(state.copyWith(symptomTrends: trends)),
    );

    triggersResult.fold(
      (failure) => null,
      (triggers) => emit(state.copyWith(triggerAnalysis: triggers)),
    );

    patternsResult.fold(
      (failure) => null,
      (patterns) => emit(state.copyWith(weeklyPatterns: patterns)),
    );

    distributionResult.fold(
      (failure) => null,
      (distribution) => emit(state.copyWith(symptomDistribution: distribution)),
    );

    correlationResult.fold(
      (failure) => null,
      (correlation) =>
          emit(state.copyWith(mealSymptomCorrelation: correlation)),
    );

    lifestyleResult.fold(
      (failure) => null,
      (lifestyle) => emit(state.copyWith(lifestyleImpacts: lifestyle)),
    );

    // ===== 지난 주 결과 처리 (AI용) =====
    lastWeekTrendsResult.fold(
      (failure) => null,
      (trends) => emit(state.copyWith(lastWeekSymptomTrends: trends)),
    );

    lastWeekTriggersResult.fold(
      (failure) => null,
      (triggers) => emit(state.copyWith(lastWeekTriggerAnalysis: triggers)),
    );

    lastWeekDistributionResult.fold(
      (failure) => null,
      (distribution) =>
          emit(state.copyWith(lastWeekSymptomDistribution: distribution)),
    );

    lastWeekCorrelationResult.fold(
      (failure) => null,
      (correlation) =>
          emit(state.copyWith(lastWeekMealSymptomCorrelation: correlation)),
    );

    lastWeekLifestyleResult.fold(
      (failure) => null,
      (lifestyle) => emit(state.copyWith(lastWeekLifestyleImpacts: lifestyle)),
    );

    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onRefresh(
    InsightsEventRefresh event,
    Emitter<InsightsState> emit,
  ) async {
    // 현재 선택된 기간으로 다시 로드
    add(InsightsEvent.loadData(state.selectedDays));
  }

  /// AI 인사이트 로드
  Future<void> _onLoadAIInsights(
    InsightsEventLoadAIInsights event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(isAILoading: true, failure: none()));

    final result = await _getAIInsightsUseCase(state);

    result.fold(
      (failure) => emit(state.copyWith(
        isAILoading: false,
        failure: some(failure),
      )),
      (insight) => emit(state.copyWith(
        isAILoading: false,
        aiInsight: some(insight),
        canGenerateThisWeek: false,
        nextReportDate: _getAIInsightsUseCase.getNextMonday(),
        failure: none(),
      )),
    );
  }

  /// 저장된 AI 리포트 로드
  Future<void> _onLoadSavedInsight(
    InsightsEventLoadSavedInsight event,
    Emitter<InsightsState> emit,
  ) async {
    final savedInsight = _getAIInsightsUseCase.getSavedInsight();
    final canGenerate = _getAIInsightsUseCase.canGenerateThisWeek();
    final nextMonday = _getAIInsightsUseCase.getNextMonday();

    if (savedInsight != null) {
      emit(state.copyWith(
        aiInsight: some(savedInsight),
        canGenerateThisWeek: canGenerate,
        nextReportDate: canGenerate ? null : nextMonday,
      ));
    } else {
      emit(state.copyWith(
        aiInsight: none(),
        canGenerateThisWeek: canGenerate,
        nextReportDate: canGenerate ? null : nextMonday,
      ));
    }
  }
}
