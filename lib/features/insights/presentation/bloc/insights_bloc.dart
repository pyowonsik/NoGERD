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
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'insights_bloc.freezed.dart';
part 'insights_event.dart';
part 'insights_state.dart';

/// Insights BLoC
@injectable
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  // 테스트용: 지난주 데이터를 나쁜 목 데이터로 채움
  // (이제 Repository에서 통합 관리하므로 false)
  static const _useLastWeekMockData = false;

  /// 생성자
  InsightsBloc(
    this._repository,
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

  final IRecordRepository _repository;
  // ignore: unused_field
  final CalculateHealthScoreUseCase _calculateHealthScoreUseCase;
  // ignore: unused_field
  final AnalyzeTriggersUseCase _analyzeTriggersUseCase;
  // ignore: unused_field
  final GetSymptomTrendsUseCase _getSymptomTrendsUseCase;
  final GetWeeklyPatternUseCase _getWeeklyPatternUseCase;
  // ignore: unused_field
  final GetSymptomDistributionUseCase _getSymptomDistributionUseCase;
  // ignore: unused_field
  final GetMealSymptomCorrelationUseCase _getMealSymptomCorrelationUseCase;
  // ignore: unused_field
  final GetLifestyleImpactUseCase _getLifestyleImpactUseCase;
  final GetAIInsightsUseCase _getAIInsightsUseCase;

  Future<void> _onLoadData(
    InsightsEventLoadData event,
    Emitter<InsightsState> emit,
  ) async {
    // ignore: avoid_print
    print('======== [InsightsBloc] _onLoadData 시작 (최적화 버전) ========');
    emit(state.copyWith(isLoading: true, selectedDays: event.days));

    final now = DateTime.now();

    // 이번 주, 지난 주 날짜 범위 계산
    final thisWeekRange =
        GetSymptomTrendsUseCase.getWeekRange(WeekType.thisWeek);
    final lastWeekRange =
        GetSymptomTrendsUseCase.getWeekRange(WeekType.lastWeek);

    // ignore: avoid_print
    print(
      '[InsightsBloc] 이번 주: '
      '${thisWeekRange.startDate} ~ ${thisWeekRange.endDate}',
    );
    // ignore: avoid_print
    print(
      '[InsightsBloc] 지난 주: '
      '${lastWeekRange.startDate} ~ ${lastWeekRange.endDate}',
    );

    // ===== 데이터를 한 번만 가져오기 (최적화) =====
    // ignore: avoid_print
    print('[InsightsBloc] 최적화된 데이터 로드 시작 (3개 쿼리: 이번주, 지난주, 4주 패턴)');

    // 이번 주, 지난 주 데이터를 각각 한 번만 가져옴
    final thisWeekDataFuture = _repository.getAllRecordsInRange(
      thisWeekRange.startDate,
      thisWeekRange.endDate,
    );
    final lastWeekDataFuture = _repository.getAllRecordsInRange(
      lastWeekRange.startDate,
      lastWeekRange.endDate,
    );

    // 주간 패턴 (28일) - 별도 UseCase 사용 (이미 최적화됨)
    final patternsFuture = _getWeeklyPatternUseCase(const NoParams());

    // 병렬 대기
    final thisWeekDataResult = await thisWeekDataFuture;
    final lastWeekDataResult = await lastWeekDataFuture;
    final patternsResult = await patternsFuture;

    // ignore: avoid_print
    print('[InsightsBloc] 데이터 로드 완료, 로컬 계산 시작...');

    // ===== 주간 패턴 처리 =====
    patternsResult.fold(
      (failure) => null,
      (patterns) => emit(state.copyWith(weeklyPatterns: patterns)),
    );

    // ===== 이번 주 데이터에서 모든 메트릭 계산 =====
    thisWeekDataResult.fold(
      (failure) => emit(state.copyWith(failure: some(failure))),
      (recordsByDate) {
        final thisWeekSymptoms = _extractSymptoms(recordsByDate);
        final thisWeekMeals = _extractMeals(recordsByDate);
        final thisWeekLifestyles = _extractLifestyles(recordsByDate);

        // 건강 점수 계산 (이번 주 데이터 활용)
        final healthScore = _calculateHealthScore(recordsByDate);
        emit(
          state.copyWith(
            healthScore: healthScore,
            previousHealthScore: state.healthScore,
          ),
        );

        // 증상 추이 계산
        final trends = _calculateSymptomTrends(
          thisWeekSymptoms,
          thisWeekRange.startDate,
          thisWeekRange.endDate,
        );
        emit(state.copyWith(symptomTrends: trends));

        // 증상 분포 계산
        final distribution = _calculateSymptomDistribution(thisWeekSymptoms);
        emit(state.copyWith(symptomDistribution: distribution));

        // 트리거 분석 계산
        final triggers = _calculateTriggerAnalysis(thisWeekMeals);
        emit(state.copyWith(triggerAnalysis: triggers));

        // 식사-증상 연관성 계산
        final correlation = _calculateMealSymptomCorrelation(
          thisWeekMeals,
          thisWeekSymptoms,
        );
        emit(state.copyWith(mealSymptomCorrelation: correlation));

        // 생활습관 영향 계산
        final lifestyle = _calculateLifestyleImpact(
          thisWeekLifestyles,
          thisWeekRange.startDate,
          thisWeekRange.endDate,
        );
        emit(state.copyWith(lifestyleImpacts: lifestyle));
      },
    );

    // ===== 지난 주 데이터에서 모든 메트릭 계산 (AI용) =====
    if (_useLastWeekMockData) {
      // 테스트용 나쁜 목 데이터 사용
      // ignore: avoid_print
      print('[InsightsBloc] 🧪 테스트 모드: 지난주 나쁜 목 데이터 사용');
      _emitBadMockDataForLastWeek(emit, lastWeekRange);
    } else {
      lastWeekDataResult.fold(
        (failure) => null,
        (recordsByDate) {
          final lastWeekSymptoms = _extractSymptoms(recordsByDate);
          final lastWeekMeals = _extractMeals(recordsByDate);
          final lastWeekLifestyles = _extractLifestyles(recordsByDate);

          // 증상 추이 계산
          final trends = _calculateSymptomTrends(
            lastWeekSymptoms,
            lastWeekRange.startDate,
            lastWeekRange.endDate,
          );
          emit(state.copyWith(lastWeekSymptomTrends: trends));

          // 증상 분포 계산
          final distribution = _calculateSymptomDistribution(lastWeekSymptoms);
          emit(state.copyWith(lastWeekSymptomDistribution: distribution));

          // 트리거 분석 계산
          final triggers = _calculateTriggerAnalysis(lastWeekMeals);
          emit(state.copyWith(lastWeekTriggerAnalysis: triggers));

          // 식사-증상 연관성 계산
          final correlation = _calculateMealSymptomCorrelation(
            lastWeekMeals,
            lastWeekSymptoms,
          );
          emit(state.copyWith(lastWeekMealSymptomCorrelation: correlation));

          // 생활습관 영향 계산
          final lifestyle = _calculateLifestyleImpact(
            lastWeekLifestyles,
            lastWeekRange.startDate,
            lastWeekRange.endDate,
          );
          emit(state.copyWith(lastWeekLifestyleImpacts: lifestyle));
        },
      );
    }

    // ignore: avoid_print
    print('======== [InsightsBloc] _onLoadData 완료 ========');
    emit(state.copyWith(isLoading: false));
  }

  // ===== 헬퍼 메서드: 데이터 추출 =====

  List<SymptomRecord> _extractSymptoms(
    Map<DateTime, Map<String, dynamic>> recordsByDate,
  ) {
    final symptoms = <SymptomRecord>[];
    for (final dayRecords in recordsByDate.values) {
      final daySymptoms = dayRecords['symptoms'] as List<SymptomRecord>? ?? [];
      symptoms.addAll(daySymptoms);
    }
    return symptoms;
  }

  List<MealRecord> _extractMeals(
    Map<DateTime, Map<String, dynamic>> recordsByDate,
  ) {
    final meals = <MealRecord>[];
    for (final dayRecords in recordsByDate.values) {
      final dayMeals = dayRecords['meals'] as List<MealRecord>? ?? [];
      meals.addAll(dayMeals);
    }
    return meals;
  }

  List<LifestyleRecord> _extractLifestyles(
    Map<DateTime, Map<String, dynamic>> recordsByDate,
  ) {
    final lifestyles = <LifestyleRecord>[];
    for (final dayRecords in recordsByDate.values) {
      final dayLifestyles =
          dayRecords['lifestyles'] as List<LifestyleRecord>? ?? [];
      lifestyles.addAll(dayLifestyles);
    }
    return lifestyles;
  }

  // ===== 헬퍼 메서드: 건강 점수 계산 =====

  int _calculateHealthScore(
    Map<DateTime, Map<String, dynamic>> recordsByDate,
  ) {
    var totalScore = 100;

    for (final dayRecords in recordsByDate.values) {
      // 증상 기록에 따른 점수 감점
      final symptoms = dayRecords['symptoms'] as List<SymptomRecord>? ?? [];
      for (final symptom in symptoms) {
        totalScore -= symptom.severity; // 심각도만큼 감점
      }

      // 약물 복용에 따른 점수 가산 (관리 중)
      final medications = dayRecords['medications'] as List? ?? [];
      totalScore += medications.length * 2;

      // 생활습관 기록에 따른 점수 가산
      final lifestyles = dayRecords['lifestyles'] as List? ?? [];
      totalScore += lifestyles.length;
    }

    // 점수를 0-100 범위로 제한
    return totalScore.clamp(0, 100);
  }

  // ===== 헬퍼 메서드: 증상 추이 계산 =====

  List<SymptomTrend> _calculateSymptomTrends(
    List<SymptomRecord> symptoms,
    DateTime startDate,
    DateTime endDate,
  ) {
    // 날짜별로 그룹핑
    final symptomsByDate = <DateTime, List<SymptomRecord>>{};
    for (final symptom in symptoms) {
      final date = DateTime(
        symptom.recordedAt.year,
        symptom.recordedAt.month,
        symptom.recordedAt.day,
      );
      symptomsByDate.putIfAbsent(date, () => []).add(symptom);
    }

    // 범위 내 모든 날짜에 대해 SymptomTrend 생성
    final trends = <SymptomTrend>[];
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEndDate =
        DateTime(endDate.year, endDate.month, endDate.day);

    while (!currentDate.isAfter(normalizedEndDate)) {
      final daySymptoms = symptomsByDate[currentDate] ?? [];

      if (daySymptoms.isNotEmpty) {
        final totalSeverity = daySymptoms.fold<int>(
          0,
          (sum, symptom) => sum + symptom.severity,
        );
        final averageSeverity = totalSeverity / daySymptoms.length;

        trends.add(
          SymptomTrend(
            date: currentDate,
            count: daySymptoms.length,
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

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return trends;
  }

  // ===== 헬퍼 메서드: 증상 분포 계산 =====

  List<SymptomDistribution> _calculateSymptomDistribution(
    List<SymptomRecord> symptoms,
  ) {
    final symptomCounts = <GerdSymptom, int>{};

    for (final symptomRecord in symptoms) {
      for (final symptom in symptomRecord.symptoms) {
        symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
      }
    }

    // 빈도순으로 정렬
    final distributionList = symptomCounts.entries
        .map((e) => SymptomDistribution(symptom: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return distributionList;
  }

  // ===== 헬퍼 메서드: 트리거 분석 계산 =====

  List<TriggerAnalysis> _calculateTriggerAnalysis(List<MealRecord> meals) {
    final triggerCounts = <TriggerFoodCategory, int>{};

    for (final meal in meals) {
      final triggers = meal.triggerCategories;
      if (triggers != null) {
        for (final trigger in triggers) {
          triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
        }
      }
    }

    // 빈도순으로 정렬
    final analysisList = triggerCounts.entries
        .map((e) => TriggerAnalysis(category: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return analysisList;
  }

  // ===== 헬퍼 메서드: 식사-증상 연관성 계산 =====

  List<MealSymptomCorrelation> _calculateMealSymptomCorrelation(
    List<MealRecord> meals,
    List<SymptomRecord> symptoms,
  ) {
    final mealCounts = <MealType, int>{
      for (final type in MealType.values) type: 0,
    };
    final symptomAfterMealCounts = <MealType, int>{
      for (final type in MealType.values) type: 0,
    };

    // 식사 카운트 및 식사 후 증상 발생 확인
    for (final meal in meals) {
      mealCounts[meal.mealType] = (mealCounts[meal.mealType] ?? 0) + 1;

      // 해당 식사 후 2시간 이내 증상 발생 확인
      final hasSymptomAfterMeal = symptoms.any((symptom) {
        final timeDiff = symptom.recordedAt.difference(meal.recordedAt);
        return timeDiff.inMinutes >= 0 && timeDiff.inHours < 2;
      });

      if (hasSymptomAfterMeal) {
        symptomAfterMealCounts[meal.mealType] =
            (symptomAfterMealCounts[meal.mealType] ?? 0) + 1;
      }
    }

    // 결과 리스트 생성 (아침, 점심, 저녁만 포함)
    return [MealType.breakfast, MealType.lunch, MealType.dinner].map((type) {
      return MealSymptomCorrelation(
        mealType: type,
        symptomCount: symptomAfterMealCounts[type] ?? 0,
        totalMealCount: mealCounts[type] ?? 0,
      );
    }).toList();
  }

  // ===== 헬퍼 메서드: 생활습관 영향 계산 =====

  List<LifestyleImpact> _calculateLifestyleImpact(
    List<LifestyleRecord> records,
    DateTime startDate,
    DateTime endDate,
  ) {
    final lifestyleData = <LifestyleType, List<double>>{};

    for (final record in records) {
      final details = record.details;

      // 수면 정보
      final sleepHours = (details['sleep_hours'] as num?)?.toDouble();
      if (sleepHours != null) {
        lifestyleData
            .putIfAbsent(LifestyleType.sleep, () => [])
            .add(sleepHours);
      }

      // 스트레스 정보
      final stressLevel = (details['stress_level'] as num?)?.toDouble();
      if (stressLevel != null) {
        lifestyleData
            .putIfAbsent(LifestyleType.stress, () => [])
            .add(stressLevel);
      }

      // 운동 정보 (boolean -> 1 또는 0으로 변환)
      final exercised = details['exercised'] as bool?;
      if (exercised != null) {
        lifestyleData
            .putIfAbsent(LifestyleType.exercise, () => [])
            .add(exercised ? 1.0 : 0.0);
      }
    }

    // 총 일수 계산
    final totalDays = endDate.difference(startDate).inDays + 1;

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
      final exerciseCount = exerciseValues.where((v) => v == 1.0).length;
      impacts.add(_analyzeExercise(exerciseCount, totalDays));
    }

    // 스트레스 분석
    if (lifestyleData.containsKey(LifestyleType.stress)) {
      final stressValues = lifestyleData[LifestyleType.stress]!;
      final averageStress =
          stressValues.reduce((a, b) => a + b) / stressValues.length;
      impacts.add(_analyzeStress(averageStress));
    }

    return impacts;
  }

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

  LifestyleImpact _analyzeExercise(int exerciseCount, int totalDays) {
    String statusLabel;
    String description;

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
      (failure) => emit(
        state.copyWith(
          isAILoading: false,
          failure: some(failure),
        ),
      ),
      (insight) => emit(
        state.copyWith(
          isAILoading: false,
          aiInsight: some(insight),
          canGenerateThisWeek: false,
          nextReportDate: _getAIInsightsUseCase.getNextMonday(),
          failure: none(),
        ),
      ),
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
      emit(
        state.copyWith(
          aiInsight: some(savedInsight),
          canGenerateThisWeek: canGenerate,
          nextReportDate: canGenerate ? null : nextMonday,
        ),
      );
    } else {
      emit(
        state.copyWith(
          aiInsight: none(),
          canGenerateThisWeek: canGenerate,
          nextReportDate: canGenerate ? null : nextMonday,
        ),
      );
    }
  }

  // ===== 테스트용: 지난주 나쁜 목 데이터 생성 =====

  void _emitBadMockDataForLastWeek(
    Emitter<InsightsState> emit,
    DateRangeParams lastWeekRange,
  ) {
    // 1. 증상 추이 - 매일 심한 증상 2-4회
    final mockTrends = <SymptomTrend>[];
    var currentDate = lastWeekRange.startDate;
    while (!currentDate.isAfter(lastWeekRange.endDate)) {
      mockTrends.add(
        SymptomTrend(
          date: currentDate,
          count: 3, // 매일 3회 증상
          averageSeverity: 8.5, // 심한 증상
        ),
      );
      currentDate = currentDate.add(const Duration(days: 1));
    }
    emit(state.copyWith(lastWeekSymptomTrends: mockTrends));

    // 2. 증상 분포 - 가슴쓰림, 산역류, 역류가 많음
    final mockDistribution = [
      const SymptomDistribution(symptom: GerdSymptom.heartburn, count: 12),
      const SymptomDistribution(symptom: GerdSymptom.acidReflux, count: 10),
      const SymptomDistribution(symptom: GerdSymptom.regurgitation, count: 8),
      const SymptomDistribution(symptom: GerdSymptom.nausea, count: 5),
      const SymptomDistribution(symptom: GerdSymptom.bloating, count: 4),
    ];
    emit(state.copyWith(lastWeekSymptomDistribution: mockDistribution));

    // 3. 트리거 분석 - 기름진 음식, 매운 음식, 카페인, 술 많이 먹음
    final mockTriggers = [
      const TriggerAnalysis(category: TriggerFoodCategory.fatty, count: 8),
      const TriggerAnalysis(category: TriggerFoodCategory.spicy, count: 7),
      const TriggerAnalysis(category: TriggerFoodCategory.caffeine, count: 6),
      const TriggerAnalysis(category: TriggerFoodCategory.alcohol, count: 5),
      const TriggerAnalysis(category: TriggerFoodCategory.carbonated, count: 4),
    ];
    emit(state.copyWith(lastWeekTriggerAnalysis: mockTriggers));

    // 4. 식사-증상 연관성 - 저녁, 야식 후 증상 많음
    final mockCorrelation = [
      const MealSymptomCorrelation(
        mealType: MealType.breakfast,
        symptomCount: 2,
        totalMealCount: 7,
      ),
      const MealSymptomCorrelation(
        mealType: MealType.lunch,
        symptomCount: 3,
        totalMealCount: 7,
      ),
      const MealSymptomCorrelation(
        mealType: MealType.dinner,
        symptomCount: 6,
        totalMealCount: 7,
      ),
    ];
    emit(state.copyWith(lastWeekMealSymptomCorrelation: mockCorrelation));

    // 5. 생활습관 - 수면 부족, 스트레스 높음, 운동 안 함
    final mockLifestyle = [
      const LifestyleImpact(
        lifestyleType: LifestyleType.sleep,
        averageValue: 5.2,
        statusLabel: '부족',
        description: '평균 5.2시간 수면',
      ),
      const LifestyleImpact(
        lifestyleType: LifestyleType.stress,
        averageValue: 8.0,
        statusLabel: '주의',
        description: '높은 스트레스 수준',
      ),
      const LifestyleImpact(
        lifestyleType: LifestyleType.exercise,
        averageValue: 0.0,
        statusLabel: '부족',
        description: '운동 기록 없음',
      ),
    ];
    emit(state.copyWith(lastWeekLifestyleImpacts: mockLifestyle));
  }
}
