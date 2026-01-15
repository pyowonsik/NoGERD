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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsEventLoadData value) loadData,
    required TResult Function(InsightsEventRefresh value) refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
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
  }) {
    return loadData(days);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
  }) {
    return loadData?.call(days);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
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
  }) {
    return loadData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
  }) {
    return loadData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
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
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? loadData,
    TResult? Function()? refresh,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? loadData,
    TResult Function()? refresh,
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
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsEventLoadData value)? loadData,
    TResult? Function(InsightsEventRefresh value)? refresh,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsEventLoadData value)? loadData,
    TResult Function(InsightsEventRefresh value)? refresh,
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
      throw _privateConstructorUsedError;

  /// 에러
  Option<Failure> get failure => throw _privateConstructorUsedError;

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
      Option<Failure> failure});
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
    Object? failure = null,
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
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
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
      Option<Failure> failure});
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
    Object? failure = null,
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
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
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
      required this.failure})
      : _symptomTrends = symptomTrends,
        _triggerAnalysis = triggerAnalysis,
        _weeklyPatterns = weeklyPatterns,
        _symptomDistribution = symptomDistribution,
        _mealSymptomCorrelation = mealSymptomCorrelation,
        _lifestyleImpacts = lifestyleImpacts;

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

  /// 에러
  @override
  final Option<Failure> failure;

  @override
  String toString() {
    return 'InsightsState(isLoading: $isLoading, selectedDays: $selectedDays, healthScore: $healthScore, previousHealthScore: $previousHealthScore, symptomTrends: $symptomTrends, triggerAnalysis: $triggerAnalysis, weeklyPatterns: $weeklyPatterns, symptomDistribution: $symptomDistribution, mealSymptomCorrelation: $mealSymptomCorrelation, lifestyleImpacts: $lifestyleImpacts, failure: $failure)';
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
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
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
      failure);

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
      required final Option<Failure> failure}) = _$InsightsStateImpl;

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
  @override

  /// 에러
  Option<Failure> get failure;
  @override
  @JsonKey(ignore: true)
  _$$InsightsStateImplCopyWith<_$InsightsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
