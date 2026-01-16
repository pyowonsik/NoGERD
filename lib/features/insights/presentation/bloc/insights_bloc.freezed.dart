// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insights_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InsightsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) loadData,
    required TResult Function() refresh,
    required TResult Function() loadAIInsights,
    required TResult Function() loadSavedInsight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
    TResult? Function()? loadAIInsights,
    TResult? Function()? loadSavedInsight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
    TResult Function()? loadAIInsights,
    TResult Function()? loadSavedInsight,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsEventLoadData value) loadData,
    required TResult Function(InsightsEventRefresh value) refresh,
    required TResult Function(InsightsEventLoadAIInsights value) loadAIInsights,
    required TResult Function(InsightsEventLoadSavedInsight value)
        loadSavedInsight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
    TResult? Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult? Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
    TResult Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsEventCopyWith<$Res> {
  factory $InsightsEventCopyWith(
          InsightsEvent value, $Res Function(InsightsEvent) then) =
      _$InsightsEventCopyWithImpl<$Res, InsightsEvent>;
}

/// @nodoc
class _$InsightsEventCopyWithImpl<$Res, $Val extends InsightsEvent>
    implements $InsightsEventCopyWith<$Res> {
  _$InsightsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InsightsEventLoadDataImplCopyWith<$Res> {
  factory _$$InsightsEventLoadDataImplCopyWith(
          _$InsightsEventLoadDataImpl value,
          $Res Function(_$InsightsEventLoadDataImpl) then) =
      __$$InsightsEventLoadDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int days});
}

/// @nodoc
class __$$InsightsEventLoadDataImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsEventLoadDataImpl>
    implements _$$InsightsEventLoadDataImplCopyWith<$Res> {
  __$$InsightsEventLoadDataImplCopyWithImpl(_$InsightsEventLoadDataImpl _value,
      $Res Function(_$InsightsEventLoadDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
  }) {
    return _then(_$InsightsEventLoadDataImpl(
      null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$InsightsEventLoadDataImpl implements InsightsEventLoadData {
  const _$InsightsEventLoadDataImpl(this.days);

  @override
  final int days;

  @override
  String toString() {
    return 'InsightsEvent.loadData(days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsEventLoadDataImpl &&
            (identical(other.days, days) || other.days == days));
  }

  @override
  int get hashCode => Object.hash(runtimeType, days);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsEventLoadDataImplCopyWith<_$InsightsEventLoadDataImpl>
      get copyWith => __$$InsightsEventLoadDataImplCopyWithImpl<
          _$InsightsEventLoadDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) loadData,
    required TResult Function() refresh,
    required TResult Function() loadAIInsights,
    required TResult Function() loadSavedInsight,
  }) {
    return loadData(days);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
    TResult? Function()? loadAIInsights,
    TResult? Function()? loadSavedInsight,
  }) {
    return loadData?.call(days);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
    TResult Function()? loadAIInsights,
    TResult Function()? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (loadData != null) {
      return loadData(days);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsEventLoadData value) loadData,
    required TResult Function(InsightsEventRefresh value) refresh,
    required TResult Function(InsightsEventLoadAIInsights value) loadAIInsights,
    required TResult Function(InsightsEventLoadSavedInsight value)
        loadSavedInsight,
  }) {
    return loadData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
    TResult? Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult? Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
  }) {
    return loadData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
    TResult Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (loadData != null) {
      return loadData(this);
    }
    return orElse();
  }
}

abstract class InsightsEventLoadData implements InsightsEvent {
  const factory InsightsEventLoadData(final int days) =
      _$InsightsEventLoadDataImpl;

  int get days;
  @JsonKey(ignore: true)
  _$$InsightsEventLoadDataImplCopyWith<_$InsightsEventLoadDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsightsEventRefreshImplCopyWith<$Res> {
  factory _$$InsightsEventRefreshImplCopyWith(_$InsightsEventRefreshImpl value,
          $Res Function(_$InsightsEventRefreshImpl) then) =
      __$$InsightsEventRefreshImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsEventRefreshImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsEventRefreshImpl>
    implements _$$InsightsEventRefreshImplCopyWith<$Res> {
  __$$InsightsEventRefreshImplCopyWithImpl(_$InsightsEventRefreshImpl _value,
      $Res Function(_$InsightsEventRefreshImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InsightsEventRefreshImpl implements InsightsEventRefresh {
  const _$InsightsEventRefreshImpl();

  @override
  String toString() {
    return 'InsightsEvent.refresh()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsEventRefreshImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) loadData,
    required TResult Function() refresh,
    required TResult Function() loadAIInsights,
    required TResult Function() loadSavedInsight,
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
    TResult? Function()? loadAIInsights,
    TResult? Function()? loadSavedInsight,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
    TResult Function()? loadAIInsights,
    TResult Function()? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsEventLoadData value) loadData,
    required TResult Function(InsightsEventRefresh value) refresh,
    required TResult Function(InsightsEventLoadAIInsights value) loadAIInsights,
    required TResult Function(InsightsEventLoadSavedInsight value)
        loadSavedInsight,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
    TResult? Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult? Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
    TResult Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(this);
    }
    return orElse();
  }
}

abstract class InsightsEventRefresh implements InsightsEvent {
  const factory InsightsEventRefresh() = _$InsightsEventRefreshImpl;
}

/// @nodoc
abstract class _$$InsightsEventLoadAIInsightsImplCopyWith<$Res> {
  factory _$$InsightsEventLoadAIInsightsImplCopyWith(
          _$InsightsEventLoadAIInsightsImpl value,
          $Res Function(_$InsightsEventLoadAIInsightsImpl) then) =
      __$$InsightsEventLoadAIInsightsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsEventLoadAIInsightsImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsEventLoadAIInsightsImpl>
    implements _$$InsightsEventLoadAIInsightsImplCopyWith<$Res> {
  __$$InsightsEventLoadAIInsightsImplCopyWithImpl(
      _$InsightsEventLoadAIInsightsImpl _value,
      $Res Function(_$InsightsEventLoadAIInsightsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InsightsEventLoadAIInsightsImpl implements InsightsEventLoadAIInsights {
  const _$InsightsEventLoadAIInsightsImpl();

  @override
  String toString() {
    return 'InsightsEvent.loadAIInsights()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsEventLoadAIInsightsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) loadData,
    required TResult Function() refresh,
    required TResult Function() loadAIInsights,
    required TResult Function() loadSavedInsight,
  }) {
    return loadAIInsights();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
    TResult? Function()? loadAIInsights,
    TResult? Function()? loadSavedInsight,
  }) {
    return loadAIInsights?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
    TResult Function()? loadAIInsights,
    TResult Function()? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (loadAIInsights != null) {
      return loadAIInsights();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsEventLoadData value) loadData,
    required TResult Function(InsightsEventRefresh value) refresh,
    required TResult Function(InsightsEventLoadAIInsights value) loadAIInsights,
    required TResult Function(InsightsEventLoadSavedInsight value)
        loadSavedInsight,
  }) {
    return loadAIInsights(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
    TResult? Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult? Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
  }) {
    return loadAIInsights?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
    TResult Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (loadAIInsights != null) {
      return loadAIInsights(this);
    }
    return orElse();
  }
}

abstract class InsightsEventLoadAIInsights implements InsightsEvent {
  const factory InsightsEventLoadAIInsights() =
      _$InsightsEventLoadAIInsightsImpl;
}

/// @nodoc
abstract class _$$InsightsEventLoadSavedInsightImplCopyWith<$Res> {
  factory _$$InsightsEventLoadSavedInsightImplCopyWith(
          _$InsightsEventLoadSavedInsightImpl value,
          $Res Function(_$InsightsEventLoadSavedInsightImpl) then) =
      __$$InsightsEventLoadSavedInsightImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsEventLoadSavedInsightImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res,
        _$InsightsEventLoadSavedInsightImpl>
    implements _$$InsightsEventLoadSavedInsightImplCopyWith<$Res> {
  __$$InsightsEventLoadSavedInsightImplCopyWithImpl(
      _$InsightsEventLoadSavedInsightImpl _value,
      $Res Function(_$InsightsEventLoadSavedInsightImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InsightsEventLoadSavedInsightImpl
    implements InsightsEventLoadSavedInsight {
  const _$InsightsEventLoadSavedInsightImpl();

  @override
  String toString() {
    return 'InsightsEvent.loadSavedInsight()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsEventLoadSavedInsightImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) loadData,
    required TResult Function() refresh,
    required TResult Function() loadAIInsights,
    required TResult Function() loadSavedInsight,
  }) {
    return loadSavedInsight();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
    TResult? Function()? loadAIInsights,
    TResult? Function()? loadSavedInsight,
  }) {
    return loadSavedInsight?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
    TResult Function()? loadAIInsights,
    TResult Function()? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (loadSavedInsight != null) {
      return loadSavedInsight();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsEventLoadData value) loadData,
    required TResult Function(InsightsEventRefresh value) refresh,
    required TResult Function(InsightsEventLoadAIInsights value) loadAIInsights,
    required TResult Function(InsightsEventLoadSavedInsight value)
        loadSavedInsight,
  }) {
    return loadSavedInsight(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
    TResult? Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult? Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
  }) {
    return loadSavedInsight?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
    TResult Function(InsightsEventLoadAIInsights value)? loadAIInsights,
    TResult Function(InsightsEventLoadSavedInsight value)? loadSavedInsight,
    required TResult orElse(),
  }) {
    if (loadSavedInsight != null) {
      return loadSavedInsight(this);
    }
    return orElse();
  }
}

abstract class InsightsEventLoadSavedInsight implements InsightsEvent {
  const factory InsightsEventLoadSavedInsight() =
      _$InsightsEventLoadSavedInsightImpl;
}

/// @nodoc
mixin _$InsightsState {
  /// 로딩 상태
  bool get isLoading => throw _privateConstructorUsedError;

  /// 선택된 기간 (일)
  int get selectedDays => throw _privateConstructorUsedError;

  /// 건강 점수
  int get healthScore => throw _privateConstructorUsedError;

  /// 이전 건강 점수 (변화율 계산용)
  int get previousHealthScore => throw _privateConstructorUsedError;

  /// 증상 추이 데이터
  List<SymptomTrend> get symptomTrends => throw _privateConstructorUsedError;

  /// 트리거 분석 결과
  List<TriggerAnalysis> get triggerAnalysis =>
      throw _privateConstructorUsedError;

  /// 주간 패턴 데이터
  List<WeeklyPattern> get weeklyPatterns => throw _privateConstructorUsedError;

  /// 증상 분포 데이터
  List<SymptomDistribution> get symptomDistribution =>
      throw _privateConstructorUsedError;

  /// 식사-증상 연관성 데이터
  List<MealSymptomCorrelation> get mealSymptomCorrelation =>
      throw _privateConstructorUsedError;

  /// 생활습관 영향 데이터
  List<LifestyleImpact> get lifestyleImpacts =>
      throw _privateConstructorUsedError; // ===== 지난 주 데이터 (AI 분석용) =====
  /// 지난 주 증상 추이 데이터
  List<SymptomTrend> get lastWeekSymptomTrends =>
      throw _privateConstructorUsedError;

  /// 지난 주 트리거 분석 결과
  List<TriggerAnalysis> get lastWeekTriggerAnalysis =>
      throw _privateConstructorUsedError;

  /// 지난 주 증상 분포 데이터
  List<SymptomDistribution> get lastWeekSymptomDistribution =>
      throw _privateConstructorUsedError;

  /// 지난 주 식사-증상 연관성 데이터
  List<MealSymptomCorrelation> get lastWeekMealSymptomCorrelation =>
      throw _privateConstructorUsedError;

  /// 지난 주 생활습관 영향 데이터
  List<LifestyleImpact> get lastWeekLifestyleImpacts =>
      throw _privateConstructorUsedError;

  /// 에러
  Option<Failure> get failure => throw _privateConstructorUsedError;

  /// AI 인사이트 로딩 상태
  bool get isAILoading => throw _privateConstructorUsedError;

  /// AI 인사이트 결과
  Option<AIInsight> get aiInsight => throw _privateConstructorUsedError;

  /// 이번 주 AI 리포트 생성 가능 여부
  bool get canGenerateThisWeek => throw _privateConstructorUsedError;

  /// 다음 리포트 생성 가능 날짜 (월요일)
  DateTime? get nextReportDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InsightsStateCopyWith<InsightsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsStateCopyWith<$Res> {
  factory $InsightsStateCopyWith(
          InsightsState value, $Res Function(InsightsState) then) =
      _$InsightsStateCopyWithImpl<$Res, InsightsState>;
  @useResult
  $Res call(
      {bool isLoading,
      int selectedDays,
      int healthScore,
      int previousHealthScore,
      List<SymptomTrend> symptomTrends,
      List<TriggerAnalysis> triggerAnalysis,
      List<WeeklyPattern> weeklyPatterns,
      List<SymptomDistribution> symptomDistribution,
      List<MealSymptomCorrelation> mealSymptomCorrelation,
      List<LifestyleImpact> lifestyleImpacts,
      List<SymptomTrend> lastWeekSymptomTrends,
      List<TriggerAnalysis> lastWeekTriggerAnalysis,
      List<SymptomDistribution> lastWeekSymptomDistribution,
      List<MealSymptomCorrelation> lastWeekMealSymptomCorrelation,
      List<LifestyleImpact> lastWeekLifestyleImpacts,
      Option<Failure> failure,
      bool isAILoading,
      Option<AIInsight> aiInsight,
      bool canGenerateThisWeek,
      DateTime? nextReportDate});
}

/// @nodoc
class _$InsightsStateCopyWithImpl<$Res, $Val extends InsightsState>
    implements $InsightsStateCopyWith<$Res> {
  _$InsightsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? selectedDays = null,
    Object? healthScore = null,
    Object? previousHealthScore = null,
    Object? symptomTrends = null,
    Object? triggerAnalysis = null,
    Object? weeklyPatterns = null,
    Object? symptomDistribution = null,
    Object? mealSymptomCorrelation = null,
    Object? lifestyleImpacts = null,
    Object? lastWeekSymptomTrends = null,
    Object? lastWeekTriggerAnalysis = null,
    Object? lastWeekSymptomDistribution = null,
    Object? lastWeekMealSymptomCorrelation = null,
    Object? lastWeekLifestyleImpacts = null,
    Object? failure = null,
    Object? isAILoading = null,
    Object? aiInsight = null,
    Object? canGenerateThisWeek = null,
    Object? nextReportDate = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDays: null == selectedDays
          ? _value.selectedDays
          : selectedDays // ignore: cast_nullable_to_non_nullable
              as int,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
      previousHealthScore: null == previousHealthScore
          ? _value.previousHealthScore
          : previousHealthScore // ignore: cast_nullable_to_non_nullable
              as int,
      symptomTrends: null == symptomTrends
          ? _value.symptomTrends
          : symptomTrends // ignore: cast_nullable_to_non_nullable
              as List<SymptomTrend>,
      triggerAnalysis: null == triggerAnalysis
          ? _value.triggerAnalysis
          : triggerAnalysis // ignore: cast_nullable_to_non_nullable
              as List<TriggerAnalysis>,
      weeklyPatterns: null == weeklyPatterns
          ? _value.weeklyPatterns
          : weeklyPatterns // ignore: cast_nullable_to_non_nullable
              as List<WeeklyPattern>,
      symptomDistribution: null == symptomDistribution
          ? _value.symptomDistribution
          : symptomDistribution // ignore: cast_nullable_to_non_nullable
              as List<SymptomDistribution>,
      mealSymptomCorrelation: null == mealSymptomCorrelation
          ? _value.mealSymptomCorrelation
          : mealSymptomCorrelation // ignore: cast_nullable_to_non_nullable
              as List<MealSymptomCorrelation>,
      lifestyleImpacts: null == lifestyleImpacts
          ? _value.lifestyleImpacts
          : lifestyleImpacts // ignore: cast_nullable_to_non_nullable
              as List<LifestyleImpact>,
      lastWeekSymptomTrends: null == lastWeekSymptomTrends
          ? _value.lastWeekSymptomTrends
          : lastWeekSymptomTrends // ignore: cast_nullable_to_non_nullable
              as List<SymptomTrend>,
      lastWeekTriggerAnalysis: null == lastWeekTriggerAnalysis
          ? _value.lastWeekTriggerAnalysis
          : lastWeekTriggerAnalysis // ignore: cast_nullable_to_non_nullable
              as List<TriggerAnalysis>,
      lastWeekSymptomDistribution: null == lastWeekSymptomDistribution
          ? _value.lastWeekSymptomDistribution
          : lastWeekSymptomDistribution // ignore: cast_nullable_to_non_nullable
              as List<SymptomDistribution>,
      lastWeekMealSymptomCorrelation: null == lastWeekMealSymptomCorrelation
          ? _value.lastWeekMealSymptomCorrelation
          : lastWeekMealSymptomCorrelation // ignore: cast_nullable_to_non_nullable
              as List<MealSymptomCorrelation>,
      lastWeekLifestyleImpacts: null == lastWeekLifestyleImpacts
          ? _value.lastWeekLifestyleImpacts
          : lastWeekLifestyleImpacts // ignore: cast_nullable_to_non_nullable
              as List<LifestyleImpact>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
      isAILoading: null == isAILoading
          ? _value.isAILoading
          : isAILoading // ignore: cast_nullable_to_non_nullable
              as bool,
      aiInsight: null == aiInsight
          ? _value.aiInsight
          : aiInsight // ignore: cast_nullable_to_non_nullable
              as Option<AIInsight>,
      canGenerateThisWeek: null == canGenerateThisWeek
          ? _value.canGenerateThisWeek
          : canGenerateThisWeek // ignore: cast_nullable_to_non_nullable
              as bool,
      nextReportDate: freezed == nextReportDate
          ? _value.nextReportDate
          : nextReportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightsStateImplCopyWith<$Res>
    implements $InsightsStateCopyWith<$Res> {
  factory _$$InsightsStateImplCopyWith(
          _$InsightsStateImpl value, $Res Function(_$InsightsStateImpl) then) =
      __$$InsightsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      int selectedDays,
      int healthScore,
      int previousHealthScore,
      List<SymptomTrend> symptomTrends,
      List<TriggerAnalysis> triggerAnalysis,
      List<WeeklyPattern> weeklyPatterns,
      List<SymptomDistribution> symptomDistribution,
      List<MealSymptomCorrelation> mealSymptomCorrelation,
      List<LifestyleImpact> lifestyleImpacts,
      List<SymptomTrend> lastWeekSymptomTrends,
      List<TriggerAnalysis> lastWeekTriggerAnalysis,
      List<SymptomDistribution> lastWeekSymptomDistribution,
      List<MealSymptomCorrelation> lastWeekMealSymptomCorrelation,
      List<LifestyleImpact> lastWeekLifestyleImpacts,
      Option<Failure> failure,
      bool isAILoading,
      Option<AIInsight> aiInsight,
      bool canGenerateThisWeek,
      DateTime? nextReportDate});
}

/// @nodoc
class __$$InsightsStateImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsStateImpl>
    implements _$$InsightsStateImplCopyWith<$Res> {
  __$$InsightsStateImplCopyWithImpl(
      _$InsightsStateImpl _value, $Res Function(_$InsightsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? selectedDays = null,
    Object? healthScore = null,
    Object? previousHealthScore = null,
    Object? symptomTrends = null,
    Object? triggerAnalysis = null,
    Object? weeklyPatterns = null,
    Object? symptomDistribution = null,
    Object? mealSymptomCorrelation = null,
    Object? lifestyleImpacts = null,
    Object? lastWeekSymptomTrends = null,
    Object? lastWeekTriggerAnalysis = null,
    Object? lastWeekSymptomDistribution = null,
    Object? lastWeekMealSymptomCorrelation = null,
    Object? lastWeekLifestyleImpacts = null,
    Object? failure = null,
    Object? isAILoading = null,
    Object? aiInsight = null,
    Object? canGenerateThisWeek = null,
    Object? nextReportDate = freezed,
  }) {
    return _then(_$InsightsStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDays: null == selectedDays
          ? _value.selectedDays
          : selectedDays // ignore: cast_nullable_to_non_nullable
              as int,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
      previousHealthScore: null == previousHealthScore
          ? _value.previousHealthScore
          : previousHealthScore // ignore: cast_nullable_to_non_nullable
              as int,
      symptomTrends: null == symptomTrends
          ? _value._symptomTrends
          : symptomTrends // ignore: cast_nullable_to_non_nullable
              as List<SymptomTrend>,
      triggerAnalysis: null == triggerAnalysis
          ? _value._triggerAnalysis
          : triggerAnalysis // ignore: cast_nullable_to_non_nullable
              as List<TriggerAnalysis>,
      weeklyPatterns: null == weeklyPatterns
          ? _value._weeklyPatterns
          : weeklyPatterns // ignore: cast_nullable_to_non_nullable
              as List<WeeklyPattern>,
      symptomDistribution: null == symptomDistribution
          ? _value._symptomDistribution
          : symptomDistribution // ignore: cast_nullable_to_non_nullable
              as List<SymptomDistribution>,
      mealSymptomCorrelation: null == mealSymptomCorrelation
          ? _value._mealSymptomCorrelation
          : mealSymptomCorrelation // ignore: cast_nullable_to_non_nullable
              as List<MealSymptomCorrelation>,
      lifestyleImpacts: null == lifestyleImpacts
          ? _value._lifestyleImpacts
          : lifestyleImpacts // ignore: cast_nullable_to_non_nullable
              as List<LifestyleImpact>,
      lastWeekSymptomTrends: null == lastWeekSymptomTrends
          ? _value._lastWeekSymptomTrends
          : lastWeekSymptomTrends // ignore: cast_nullable_to_non_nullable
              as List<SymptomTrend>,
      lastWeekTriggerAnalysis: null == lastWeekTriggerAnalysis
          ? _value._lastWeekTriggerAnalysis
          : lastWeekTriggerAnalysis // ignore: cast_nullable_to_non_nullable
              as List<TriggerAnalysis>,
      lastWeekSymptomDistribution: null == lastWeekSymptomDistribution
          ? _value._lastWeekSymptomDistribution
          : lastWeekSymptomDistribution // ignore: cast_nullable_to_non_nullable
              as List<SymptomDistribution>,
      lastWeekMealSymptomCorrelation: null == lastWeekMealSymptomCorrelation
          ? _value._lastWeekMealSymptomCorrelation
          : lastWeekMealSymptomCorrelation // ignore: cast_nullable_to_non_nullable
              as List<MealSymptomCorrelation>,
      lastWeekLifestyleImpacts: null == lastWeekLifestyleImpacts
          ? _value._lastWeekLifestyleImpacts
          : lastWeekLifestyleImpacts // ignore: cast_nullable_to_non_nullable
              as List<LifestyleImpact>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
      isAILoading: null == isAILoading
          ? _value.isAILoading
          : isAILoading // ignore: cast_nullable_to_non_nullable
              as bool,
      aiInsight: null == aiInsight
          ? _value.aiInsight
          : aiInsight // ignore: cast_nullable_to_non_nullable
              as Option<AIInsight>,
      canGenerateThisWeek: null == canGenerateThisWeek
          ? _value.canGenerateThisWeek
          : canGenerateThisWeek // ignore: cast_nullable_to_non_nullable
              as bool,
      nextReportDate: freezed == nextReportDate
          ? _value.nextReportDate
          : nextReportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$InsightsStateImpl implements _InsightsState {
  const _$InsightsStateImpl(
      {required this.isLoading,
      required this.selectedDays,
      required this.healthScore,
      required this.previousHealthScore,
      required final List<SymptomTrend> symptomTrends,
      required final List<TriggerAnalysis> triggerAnalysis,
      required final List<WeeklyPattern> weeklyPatterns,
      required final List<SymptomDistribution> symptomDistribution,
      required final List<MealSymptomCorrelation> mealSymptomCorrelation,
      required final List<LifestyleImpact> lifestyleImpacts,
      required final List<SymptomTrend> lastWeekSymptomTrends,
      required final List<TriggerAnalysis> lastWeekTriggerAnalysis,
      required final List<SymptomDistribution> lastWeekSymptomDistribution,
      required final List<MealSymptomCorrelation>
          lastWeekMealSymptomCorrelation,
      required final List<LifestyleImpact> lastWeekLifestyleImpacts,
      required this.failure,
      required this.isAILoading,
      required this.aiInsight,
      required this.canGenerateThisWeek,
      required this.nextReportDate})
      : _symptomTrends = symptomTrends,
        _triggerAnalysis = triggerAnalysis,
        _weeklyPatterns = weeklyPatterns,
        _symptomDistribution = symptomDistribution,
        _mealSymptomCorrelation = mealSymptomCorrelation,
        _lifestyleImpacts = lifestyleImpacts,
        _lastWeekSymptomTrends = lastWeekSymptomTrends,
        _lastWeekTriggerAnalysis = lastWeekTriggerAnalysis,
        _lastWeekSymptomDistribution = lastWeekSymptomDistribution,
        _lastWeekMealSymptomCorrelation = lastWeekMealSymptomCorrelation,
        _lastWeekLifestyleImpacts = lastWeekLifestyleImpacts;

  /// 로딩 상태
  @override
  final bool isLoading;

  /// 선택된 기간 (일)
  @override
  final int selectedDays;

  /// 건강 점수
  @override
  final int healthScore;

  /// 이전 건강 점수 (변화율 계산용)
  @override
  final int previousHealthScore;

  /// 증상 추이 데이터
  final List<SymptomTrend> _symptomTrends;

  /// 증상 추이 데이터
  @override
  List<SymptomTrend> get symptomTrends {
    if (_symptomTrends is EqualUnmodifiableListView) return _symptomTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomTrends);
  }

  /// 트리거 분석 결과
  final List<TriggerAnalysis> _triggerAnalysis;

  /// 트리거 분석 결과
  @override
  List<TriggerAnalysis> get triggerAnalysis {
    if (_triggerAnalysis is EqualUnmodifiableListView) return _triggerAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggerAnalysis);
  }

  /// 주간 패턴 데이터
  final List<WeeklyPattern> _weeklyPatterns;

  /// 주간 패턴 데이터
  @override
  List<WeeklyPattern> get weeklyPatterns {
    if (_weeklyPatterns is EqualUnmodifiableListView) return _weeklyPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyPatterns);
  }

  /// 증상 분포 데이터
  final List<SymptomDistribution> _symptomDistribution;

  /// 증상 분포 데이터
  @override
  List<SymptomDistribution> get symptomDistribution {
    if (_symptomDistribution is EqualUnmodifiableListView)
      return _symptomDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomDistribution);
  }

  /// 식사-증상 연관성 데이터
  final List<MealSymptomCorrelation> _mealSymptomCorrelation;

  /// 식사-증상 연관성 데이터
  @override
  List<MealSymptomCorrelation> get mealSymptomCorrelation {
    if (_mealSymptomCorrelation is EqualUnmodifiableListView)
      return _mealSymptomCorrelation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mealSymptomCorrelation);
  }

  /// 생활습관 영향 데이터
  final List<LifestyleImpact> _lifestyleImpacts;

  /// 생활습관 영향 데이터
  @override
  List<LifestyleImpact> get lifestyleImpacts {
    if (_lifestyleImpacts is EqualUnmodifiableListView)
      return _lifestyleImpacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lifestyleImpacts);
  }

// ===== 지난 주 데이터 (AI 분석용) =====
  /// 지난 주 증상 추이 데이터
  final List<SymptomTrend> _lastWeekSymptomTrends;
// ===== 지난 주 데이터 (AI 분석용) =====
  /// 지난 주 증상 추이 데이터
  @override
  List<SymptomTrend> get lastWeekSymptomTrends {
    if (_lastWeekSymptomTrends is EqualUnmodifiableListView)
      return _lastWeekSymptomTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastWeekSymptomTrends);
  }

  /// 지난 주 트리거 분석 결과
  final List<TriggerAnalysis> _lastWeekTriggerAnalysis;

  /// 지난 주 트리거 분석 결과
  @override
  List<TriggerAnalysis> get lastWeekTriggerAnalysis {
    if (_lastWeekTriggerAnalysis is EqualUnmodifiableListView)
      return _lastWeekTriggerAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastWeekTriggerAnalysis);
  }

  /// 지난 주 증상 분포 데이터
  final List<SymptomDistribution> _lastWeekSymptomDistribution;

  /// 지난 주 증상 분포 데이터
  @override
  List<SymptomDistribution> get lastWeekSymptomDistribution {
    if (_lastWeekSymptomDistribution is EqualUnmodifiableListView)
      return _lastWeekSymptomDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastWeekSymptomDistribution);
  }

  /// 지난 주 식사-증상 연관성 데이터
  final List<MealSymptomCorrelation> _lastWeekMealSymptomCorrelation;

  /// 지난 주 식사-증상 연관성 데이터
  @override
  List<MealSymptomCorrelation> get lastWeekMealSymptomCorrelation {
    if (_lastWeekMealSymptomCorrelation is EqualUnmodifiableListView)
      return _lastWeekMealSymptomCorrelation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastWeekMealSymptomCorrelation);
  }

  /// 지난 주 생활습관 영향 데이터
  final List<LifestyleImpact> _lastWeekLifestyleImpacts;

  /// 지난 주 생활습관 영향 데이터
  @override
  List<LifestyleImpact> get lastWeekLifestyleImpacts {
    if (_lastWeekLifestyleImpacts is EqualUnmodifiableListView)
      return _lastWeekLifestyleImpacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastWeekLifestyleImpacts);
  }

  /// 에러
  @override
  final Option<Failure> failure;

  /// AI 인사이트 로딩 상태
  @override
  final bool isAILoading;

  /// AI 인사이트 결과
  @override
  final Option<AIInsight> aiInsight;

  /// 이번 주 AI 리포트 생성 가능 여부
  @override
  final bool canGenerateThisWeek;

  /// 다음 리포트 생성 가능 날짜 (월요일)
  @override
  final DateTime? nextReportDate;

  @override
  String toString() {
    return 'InsightsState(isLoading: $isLoading, selectedDays: $selectedDays, healthScore: $healthScore, previousHealthScore: $previousHealthScore, symptomTrends: $symptomTrends, triggerAnalysis: $triggerAnalysis, weeklyPatterns: $weeklyPatterns, symptomDistribution: $symptomDistribution, mealSymptomCorrelation: $mealSymptomCorrelation, lifestyleImpacts: $lifestyleImpacts, lastWeekSymptomTrends: $lastWeekSymptomTrends, lastWeekTriggerAnalysis: $lastWeekTriggerAnalysis, lastWeekSymptomDistribution: $lastWeekSymptomDistribution, lastWeekMealSymptomCorrelation: $lastWeekMealSymptomCorrelation, lastWeekLifestyleImpacts: $lastWeekLifestyleImpacts, failure: $failure, isAILoading: $isAILoading, aiInsight: $aiInsight, canGenerateThisWeek: $canGenerateThisWeek, nextReportDate: $nextReportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.selectedDays, selectedDays) ||
                other.selectedDays == selectedDays) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            (identical(other.previousHealthScore, previousHealthScore) ||
                other.previousHealthScore == previousHealthScore) &&
            const DeepCollectionEquality()
                .equals(other._symptomTrends, _symptomTrends) &&
            const DeepCollectionEquality()
                .equals(other._triggerAnalysis, _triggerAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._weeklyPatterns, _weeklyPatterns) &&
            const DeepCollectionEquality()
                .equals(other._symptomDistribution, _symptomDistribution) &&
            const DeepCollectionEquality().equals(
                other._mealSymptomCorrelation, _mealSymptomCorrelation) &&
            const DeepCollectionEquality()
                .equals(other._lifestyleImpacts, _lifestyleImpacts) &&
            const DeepCollectionEquality()
                .equals(other._lastWeekSymptomTrends, _lastWeekSymptomTrends) &&
            const DeepCollectionEquality().equals(
                other._lastWeekTriggerAnalysis, _lastWeekTriggerAnalysis) &&
            const DeepCollectionEquality().equals(
                other._lastWeekSymptomDistribution,
                _lastWeekSymptomDistribution) &&
            const DeepCollectionEquality().equals(
                other._lastWeekMealSymptomCorrelation,
                _lastWeekMealSymptomCorrelation) &&
            const DeepCollectionEquality().equals(
                other._lastWeekLifestyleImpacts, _lastWeekLifestyleImpacts) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.isAILoading, isAILoading) ||
                other.isAILoading == isAILoading) &&
            (identical(other.aiInsight, aiInsight) ||
                other.aiInsight == aiInsight) &&
            (identical(other.canGenerateThisWeek, canGenerateThisWeek) ||
                other.canGenerateThisWeek == canGenerateThisWeek) &&
            (identical(other.nextReportDate, nextReportDate) ||
                other.nextReportDate == nextReportDate));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isLoading,
        selectedDays,
        healthScore,
        previousHealthScore,
        const DeepCollectionEquality().hash(_symptomTrends),
        const DeepCollectionEquality().hash(_triggerAnalysis),
        const DeepCollectionEquality().hash(_weeklyPatterns),
        const DeepCollectionEquality().hash(_symptomDistribution),
        const DeepCollectionEquality().hash(_mealSymptomCorrelation),
        const DeepCollectionEquality().hash(_lifestyleImpacts),
        const DeepCollectionEquality().hash(_lastWeekSymptomTrends),
        const DeepCollectionEquality().hash(_lastWeekTriggerAnalysis),
        const DeepCollectionEquality().hash(_lastWeekSymptomDistribution),
        const DeepCollectionEquality().hash(_lastWeekMealSymptomCorrelation),
        const DeepCollectionEquality().hash(_lastWeekLifestyleImpacts),
        failure,
        isAILoading,
        aiInsight,
        canGenerateThisWeek,
        nextReportDate
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsStateImplCopyWith<_$InsightsStateImpl> get copyWith =>
      __$$InsightsStateImplCopyWithImpl<_$InsightsStateImpl>(this, _$identity);
}

abstract class _InsightsState implements InsightsState {
  const factory _InsightsState(
      {required final bool isLoading,
      required final int selectedDays,
      required final int healthScore,
      required final int previousHealthScore,
      required final List<SymptomTrend> symptomTrends,
      required final List<TriggerAnalysis> triggerAnalysis,
      required final List<WeeklyPattern> weeklyPatterns,
      required final List<SymptomDistribution> symptomDistribution,
      required final List<MealSymptomCorrelation> mealSymptomCorrelation,
      required final List<LifestyleImpact> lifestyleImpacts,
      required final List<SymptomTrend> lastWeekSymptomTrends,
      required final List<TriggerAnalysis> lastWeekTriggerAnalysis,
      required final List<SymptomDistribution> lastWeekSymptomDistribution,
      required final List<MealSymptomCorrelation>
          lastWeekMealSymptomCorrelation,
      required final List<LifestyleImpact> lastWeekLifestyleImpacts,
      required final Option<Failure> failure,
      required final bool isAILoading,
      required final Option<AIInsight> aiInsight,
      required final bool canGenerateThisWeek,
      required final DateTime? nextReportDate}) = _$InsightsStateImpl;

  @override

  /// 로딩 상태
  bool get isLoading;
  @override

  /// 선택된 기간 (일)
  int get selectedDays;
  @override

  /// 건강 점수
  int get healthScore;
  @override

  /// 이전 건강 점수 (변화율 계산용)
  int get previousHealthScore;
  @override

  /// 증상 추이 데이터
  List<SymptomTrend> get symptomTrends;
  @override

  /// 트리거 분석 결과
  List<TriggerAnalysis> get triggerAnalysis;
  @override

  /// 주간 패턴 데이터
  List<WeeklyPattern> get weeklyPatterns;
  @override

  /// 증상 분포 데이터
  List<SymptomDistribution> get symptomDistribution;
  @override

  /// 식사-증상 연관성 데이터
  List<MealSymptomCorrelation> get mealSymptomCorrelation;
  @override

  /// 생활습관 영향 데이터
  List<LifestyleImpact> get lifestyleImpacts;
  @override // ===== 지난 주 데이터 (AI 분석용) =====
  /// 지난 주 증상 추이 데이터
  List<SymptomTrend> get lastWeekSymptomTrends;
  @override

  /// 지난 주 트리거 분석 결과
  List<TriggerAnalysis> get lastWeekTriggerAnalysis;
  @override

  /// 지난 주 증상 분포 데이터
  List<SymptomDistribution> get lastWeekSymptomDistribution;
  @override

  /// 지난 주 식사-증상 연관성 데이터
  List<MealSymptomCorrelation> get lastWeekMealSymptomCorrelation;
  @override

  /// 지난 주 생활습관 영향 데이터
  List<LifestyleImpact> get lastWeekLifestyleImpacts;
  @override

  /// 에러
  Option<Failure> get failure;
  @override

  /// AI 인사이트 로딩 상태
  bool get isAILoading;
  @override

  /// AI 인사이트 결과
  Option<AIInsight> get aiInsight;
  @override

  /// 이번 주 AI 리포트 생성 가능 여부
  bool get canGenerateThisWeek;
  @override

  /// 다음 리포트 생성 가능 날짜 (월요일)
  DateTime? get nextReportDate;
  @override
  @JsonKey(ignore: true)
  _$$InsightsStateImplCopyWith<_$InsightsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
