import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/analyze_triggers_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/calculate_health_score_usecase.dart';
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
  ) : super(InsightsState.initial()) {
    on<InsightsEventLoadData>(_onLoadData);
    on<InsightsEventRefresh>(_onRefresh);
  }

  final CalculateHealthScoreUseCase _calculateHealthScoreUseCase;
  final AnalyzeTriggersUseCase _analyzeTriggersUseCase;
  final GetSymptomTrendsUseCase _getSymptomTrendsUseCase;
  final GetWeeklyPatternUseCase _getWeeklyPatternUseCase;

  Future<void> _onLoadData(
    InsightsEventLoadData event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedDays: event.days));

    final now = DateTime.now();

    // 건강 점수 계산
    final healthScoreResult = await _calculateHealthScoreUseCase(now);

    // 증상 추이 조회
    final trendsResult = await _getSymptomTrendsUseCase(event.days);

    // 트리거 분석
    final triggersResult = await _analyzeTriggersUseCase(now);

    // 주간 패턴 조회
    final patternsResult = await _getWeeklyPatternUseCase(const NoParams());

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
