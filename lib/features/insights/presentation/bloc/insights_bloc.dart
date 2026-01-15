import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/analyze_triggers_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/calculate_health_score_usecase.dart';
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
  ) : super(InsightsState.initial()) {
    on<InsightsEventLoadData>(_onLoadData);
    on<InsightsEventRefresh>(_onRefresh);
  }

  final CalculateHealthScoreUseCase _calculateHealthScoreUseCase;
  final AnalyzeTriggersUseCase _analyzeTriggersUseCase;
  final GetSymptomTrendsUseCase _getSymptomTrendsUseCase;
  final GetWeeklyPatternUseCase _getWeeklyPatternUseCase;
  final GetSymptomDistributionUseCase _getSymptomDistributionUseCase;
  final GetMealSymptomCorrelationUseCase _getMealSymptomCorrelationUseCase;
  final GetLifestyleImpactUseCase _getLifestyleImpactUseCase;

  Future<void> _onLoadData(
    InsightsEventLoadData event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedDays: event.days));

    final now = DateTime.now();

    // 모든 데이터를 병렬로 로딩 (성능 향상)
    final healthScoreFuture = _calculateHealthScoreUseCase(now);
    final trendsFuture = _getSymptomTrendsUseCase(event.days);
    final triggersFuture = _analyzeTriggersUseCase(now);
    final patternsFuture = _getWeeklyPatternUseCase(const NoParams());
    final distributionFuture = _getSymptomDistributionUseCase(event.days);
    final correlationFuture = _getMealSymptomCorrelationUseCase(event.days);
    final lifestyleFuture = _getLifestyleImpactUseCase(event.days);

    final healthScoreResult = await healthScoreFuture;
    final trendsResult = await trendsFuture;
    final triggersResult = await triggersFuture;
    final patternsResult = await patternsFuture;
    final distributionResult = await distributionFuture;
    final correlationResult = await correlationFuture;
    final lifestyleResult = await lifestyleFuture;

    // 결과 처리
    healthScoreResult.fold(
      (failure) => emit(state.copyWith(failure: some(failure))),
      (score) {
        emit(state.copyWith(
          healthScore: score,
          previousHealthScore: state.healthScore, // 이전 점수 저장
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

    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onRefresh(
    InsightsEventRefresh event,
    Emitter<InsightsState> emit,
  ) async {
    // 현재 선택된 기간으로 다시 로드
    add(InsightsEvent.loadData(state.selectedDays));
  }
}
