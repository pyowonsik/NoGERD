// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(DateTime date) dateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(DateTime date)? dateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(DateTime date)? dateChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeEventStarted value) started,
    required TResult Function(HomeEventRefreshed value) refreshed,
    required TResult Function(HomeEventDateChanged value) dateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeEventStarted value)? started,
    TResult? Function(HomeEventRefreshed value)? refreshed,
    TResult? Function(HomeEventDateChanged value)? dateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeEventStarted value)? started,
    TResult Function(HomeEventRefreshed value)? refreshed,
    TResult Function(HomeEventDateChanged value)? dateChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeEventCopyWith<$Res> {
  factory $HomeEventCopyWith(HomeEvent value, $Res Function(HomeEvent) then) =
      _$HomeEventCopyWithImpl<$Res, HomeEvent>;
}

/// @nodoc
class _$HomeEventCopyWithImpl<$Res, $Val extends HomeEvent>
    implements $HomeEventCopyWith<$Res> {
  _$HomeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$HomeEventStartedImplCopyWith<$Res> {
  factory _$$HomeEventStartedImplCopyWith(_$HomeEventStartedImpl value,
          $Res Function(_$HomeEventStartedImpl) then) =
      __$$HomeEventStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeEventStartedImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$HomeEventStartedImpl>
    implements _$$HomeEventStartedImplCopyWith<$Res> {
  __$$HomeEventStartedImplCopyWithImpl(_$HomeEventStartedImpl _value,
      $Res Function(_$HomeEventStartedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HomeEventStartedImpl implements HomeEventStarted {
  const _$HomeEventStartedImpl();

  @override
  String toString() {
    return 'HomeEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeEventStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(DateTime date) dateChanged,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(DateTime date)? dateChanged,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(DateTime date)? dateChanged,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeEventStarted value) started,
    required TResult Function(HomeEventRefreshed value) refreshed,
    required TResult Function(HomeEventDateChanged value) dateChanged,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeEventStarted value)? started,
    TResult? Function(HomeEventRefreshed value)? refreshed,
    TResult? Function(HomeEventDateChanged value)? dateChanged,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeEventStarted value)? started,
    TResult Function(HomeEventRefreshed value)? refreshed,
    TResult Function(HomeEventDateChanged value)? dateChanged,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class HomeEventStarted implements HomeEvent {
  const factory HomeEventStarted() = _$HomeEventStartedImpl;
}

/// @nodoc
abstract class _$$HomeEventRefreshedImplCopyWith<$Res> {
  factory _$$HomeEventRefreshedImplCopyWith(_$HomeEventRefreshedImpl value,
          $Res Function(_$HomeEventRefreshedImpl) then) =
      __$$HomeEventRefreshedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeEventRefreshedImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$HomeEventRefreshedImpl>
    implements _$$HomeEventRefreshedImplCopyWith<$Res> {
  __$$HomeEventRefreshedImplCopyWithImpl(_$HomeEventRefreshedImpl _value,
      $Res Function(_$HomeEventRefreshedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HomeEventRefreshedImpl implements HomeEventRefreshed {
  const _$HomeEventRefreshedImpl();

  @override
  String toString() {
    return 'HomeEvent.refreshed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeEventRefreshedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(DateTime date) dateChanged,
  }) {
    return refreshed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(DateTime date)? dateChanged,
  }) {
    return refreshed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(DateTime date)? dateChanged,
    required TResult orElse(),
  }) {
    if (refreshed != null) {
      return refreshed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeEventStarted value) started,
    required TResult Function(HomeEventRefreshed value) refreshed,
    required TResult Function(HomeEventDateChanged value) dateChanged,
  }) {
    return refreshed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeEventStarted value)? started,
    TResult? Function(HomeEventRefreshed value)? refreshed,
    TResult? Function(HomeEventDateChanged value)? dateChanged,
  }) {
    return refreshed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeEventStarted value)? started,
    TResult Function(HomeEventRefreshed value)? refreshed,
    TResult Function(HomeEventDateChanged value)? dateChanged,
    required TResult orElse(),
  }) {
    if (refreshed != null) {
      return refreshed(this);
    }
    return orElse();
  }
}

abstract class HomeEventRefreshed implements HomeEvent {
  const factory HomeEventRefreshed() = _$HomeEventRefreshedImpl;
}

/// @nodoc
abstract class _$$HomeEventDateChangedImplCopyWith<$Res> {
  factory _$$HomeEventDateChangedImplCopyWith(_$HomeEventDateChangedImpl value,
          $Res Function(_$HomeEventDateChangedImpl) then) =
      __$$HomeEventDateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime date});
}

/// @nodoc
class __$$HomeEventDateChangedImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$HomeEventDateChangedImpl>
    implements _$$HomeEventDateChangedImplCopyWith<$Res> {
  __$$HomeEventDateChangedImplCopyWithImpl(_$HomeEventDateChangedImpl _value,
      $Res Function(_$HomeEventDateChangedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_$HomeEventDateChangedImpl(
      null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$HomeEventDateChangedImpl implements HomeEventDateChanged {
  const _$HomeEventDateChangedImpl(this.date);

  @override
  final DateTime date;

  @override
  String toString() {
    return 'HomeEvent.dateChanged(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeEventDateChangedImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeEventDateChangedImplCopyWith<_$HomeEventDateChangedImpl>
      get copyWith =>
          __$$HomeEventDateChangedImplCopyWithImpl<_$HomeEventDateChangedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(DateTime date) dateChanged,
  }) {
    return dateChanged(date);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(DateTime date)? dateChanged,
  }) {
    return dateChanged?.call(date);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(DateTime date)? dateChanged,
    required TResult orElse(),
  }) {
    if (dateChanged != null) {
      return dateChanged(date);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeEventStarted value) started,
    required TResult Function(HomeEventRefreshed value) refreshed,
    required TResult Function(HomeEventDateChanged value) dateChanged,
  }) {
    return dateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeEventStarted value)? started,
    TResult? Function(HomeEventRefreshed value)? refreshed,
    TResult? Function(HomeEventDateChanged value)? dateChanged,
  }) {
    return dateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeEventStarted value)? started,
    TResult Function(HomeEventRefreshed value)? refreshed,
    TResult Function(HomeEventDateChanged value)? dateChanged,
    required TResult orElse(),
  }) {
    if (dateChanged != null) {
      return dateChanged(this);
    }
    return orElse();
  }
}

abstract class HomeEventDateChanged implements HomeEvent {
  const factory HomeEventDateChanged(final DateTime date) =
      _$HomeEventDateChangedImpl;

  DateTime get date;
  @JsonKey(ignore: true)
  _$$HomeEventDateChangedImplCopyWith<_$HomeEventDateChangedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HomeState {
  /// 로딩 중 여부
  bool get isLoading => throw _privateConstructorUsedError;

  /// 건강 점수
  int get healthScore => throw _privateConstructorUsedError;

  /// 이전 건강 점수
  int get previousScore => throw _privateConstructorUsedError;

  /// 오늘의 요약
  List<RecordSummary> get todaySummary => throw _privateConstructorUsedError;

  /// 최근 기록
  List<RecentRecord> get recentRecords => throw _privateConstructorUsedError;

  /// 에러
  Option<Failure> get failure => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {bool isLoading,
      int healthScore,
      int previousScore,
      List<RecordSummary> todaySummary,
      List<RecentRecord> recentRecords,
      Option<Failure> failure});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? healthScore = null,
    Object? previousScore = null,
    Object? todaySummary = null,
    Object? recentRecords = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
      previousScore: null == previousScore
          ? _value.previousScore
          : previousScore // ignore: cast_nullable_to_non_nullable
              as int,
      todaySummary: null == todaySummary
          ? _value.todaySummary
          : todaySummary // ignore: cast_nullable_to_non_nullable
              as List<RecordSummary>,
      recentRecords: null == recentRecords
          ? _value.recentRecords
          : recentRecords // ignore: cast_nullable_to_non_nullable
              as List<RecentRecord>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      int healthScore,
      int previousScore,
      List<RecordSummary> todaySummary,
      List<RecentRecord> recentRecords,
      Option<Failure> failure});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? healthScore = null,
    Object? previousScore = null,
    Object? todaySummary = null,
    Object? recentRecords = null,
    Object? failure = null,
  }) {
    return _then(_$HomeStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
      previousScore: null == previousScore
          ? _value.previousScore
          : previousScore // ignore: cast_nullable_to_non_nullable
              as int,
      todaySummary: null == todaySummary
          ? _value._todaySummary
          : todaySummary // ignore: cast_nullable_to_non_nullable
              as List<RecordSummary>,
      recentRecords: null == recentRecords
          ? _value._recentRecords
          : recentRecords // ignore: cast_nullable_to_non_nullable
              as List<RecentRecord>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {required this.isLoading,
      required this.healthScore,
      required this.previousScore,
      required final List<RecordSummary> todaySummary,
      required final List<RecentRecord> recentRecords,
      required this.failure})
      : _todaySummary = todaySummary,
        _recentRecords = recentRecords;

  /// 로딩 중 여부
  @override
  final bool isLoading;

  /// 건강 점수
  @override
  final int healthScore;

  /// 이전 건강 점수
  @override
  final int previousScore;

  /// 오늘의 요약
  final List<RecordSummary> _todaySummary;

  /// 오늘의 요약
  @override
  List<RecordSummary> get todaySummary {
    if (_todaySummary is EqualUnmodifiableListView) return _todaySummary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todaySummary);
  }

  /// 최근 기록
  final List<RecentRecord> _recentRecords;

  /// 최근 기록
  @override
  List<RecentRecord> get recentRecords {
    if (_recentRecords is EqualUnmodifiableListView) return _recentRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentRecords);
  }

  /// 에러
  @override
  final Option<Failure> failure;

  @override
  String toString() {
    return 'HomeState(isLoading: $isLoading, healthScore: $healthScore, previousScore: $previousScore, todaySummary: $todaySummary, recentRecords: $recentRecords, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            (identical(other.previousScore, previousScore) ||
                other.previousScore == previousScore) &&
            const DeepCollectionEquality()
                .equals(other._todaySummary, _todaySummary) &&
            const DeepCollectionEquality()
                .equals(other._recentRecords, _recentRecords) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      healthScore,
      previousScore,
      const DeepCollectionEquality().hash(_todaySummary),
      const DeepCollectionEquality().hash(_recentRecords),
      failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {required final bool isLoading,
      required final int healthScore,
      required final int previousScore,
      required final List<RecordSummary> todaySummary,
      required final List<RecentRecord> recentRecords,
      required final Option<Failure> failure}) = _$HomeStateImpl;

  @override

  /// 로딩 중 여부
  bool get isLoading;
  @override

  /// 건강 점수
  int get healthScore;
  @override

  /// 이전 건강 점수
  int get previousScore;
  @override

  /// 오늘의 요약
  List<RecordSummary> get todaySummary;
  @override

  /// 최근 기록
  List<RecentRecord> get recentRecords;
  @override

  /// 에러
  Option<Failure> get failure;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
