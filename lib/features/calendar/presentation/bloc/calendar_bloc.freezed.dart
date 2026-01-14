// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalendarEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime month) loadMonth,
    required TResult Function(DateTime day) selectDay,
    required TResult Function() goToToday,
    required TResult Function(CalendarFormat format) formatChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime month)? loadMonth,
    TResult? Function(DateTime day)? selectDay,
    TResult? Function()? goToToday,
    TResult? Function(CalendarFormat format)? formatChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime month)? loadMonth,
    TResult Function(DateTime day)? selectDay,
    TResult Function()? goToToday,
    TResult Function(CalendarFormat format)? formatChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CalendarEventLoadMonth value) loadMonth,
    required TResult Function(CalendarEventSelectDay value) selectDay,
    required TResult Function(CalendarEventGoToToday value) goToToday,
    required TResult Function(CalendarEventFormatChanged value) formatChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CalendarEventLoadMonth value)? loadMonth,
    TResult? Function(CalendarEventSelectDay value)? selectDay,
    TResult? Function(CalendarEventGoToToday value)? goToToday,
    TResult? Function(CalendarEventFormatChanged value)? formatChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CalendarEventLoadMonth value)? loadMonth,
    TResult Function(CalendarEventSelectDay value)? selectDay,
    TResult Function(CalendarEventGoToToday value)? goToToday,
    TResult Function(CalendarEventFormatChanged value)? formatChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
          CalendarEvent value, $Res Function(CalendarEvent) then) =
      _$CalendarEventCopyWithImpl<$Res, CalendarEvent>;
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res, $Val extends CalendarEvent>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CalendarEventLoadMonthImplCopyWith<$Res> {
  factory _$$CalendarEventLoadMonthImplCopyWith(
          _$CalendarEventLoadMonthImpl value,
          $Res Function(_$CalendarEventLoadMonthImpl) then) =
      __$$CalendarEventLoadMonthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime month});
}

/// @nodoc
class __$$CalendarEventLoadMonthImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventLoadMonthImpl>
    implements _$$CalendarEventLoadMonthImplCopyWith<$Res> {
  __$$CalendarEventLoadMonthImplCopyWithImpl(
      _$CalendarEventLoadMonthImpl _value,
      $Res Function(_$CalendarEventLoadMonthImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
  }) {
    return _then(_$CalendarEventLoadMonthImpl(
      null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CalendarEventLoadMonthImpl implements CalendarEventLoadMonth {
  const _$CalendarEventLoadMonthImpl(this.month);

  @override
  final DateTime month;

  @override
  String toString() {
    return 'CalendarEvent.loadMonth(month: $month)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventLoadMonthImpl &&
            (identical(other.month, month) || other.month == month));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventLoadMonthImplCopyWith<_$CalendarEventLoadMonthImpl>
      get copyWith => __$$CalendarEventLoadMonthImplCopyWithImpl<
          _$CalendarEventLoadMonthImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime month) loadMonth,
    required TResult Function(DateTime day) selectDay,
    required TResult Function() goToToday,
    required TResult Function(CalendarFormat format) formatChanged,
  }) {
    return loadMonth(month);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime month)? loadMonth,
    TResult? Function(DateTime day)? selectDay,
    TResult? Function()? goToToday,
    TResult? Function(CalendarFormat format)? formatChanged,
  }) {
    return loadMonth?.call(month);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime month)? loadMonth,
    TResult Function(DateTime day)? selectDay,
    TResult Function()? goToToday,
    TResult Function(CalendarFormat format)? formatChanged,
    required TResult orElse(),
  }) {
    if (loadMonth != null) {
      return loadMonth(month);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CalendarEventLoadMonth value) loadMonth,
    required TResult Function(CalendarEventSelectDay value) selectDay,
    required TResult Function(CalendarEventGoToToday value) goToToday,
    required TResult Function(CalendarEventFormatChanged value) formatChanged,
  }) {
    return loadMonth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CalendarEventLoadMonth value)? loadMonth,
    TResult? Function(CalendarEventSelectDay value)? selectDay,
    TResult? Function(CalendarEventGoToToday value)? goToToday,
    TResult? Function(CalendarEventFormatChanged value)? formatChanged,
  }) {
    return loadMonth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CalendarEventLoadMonth value)? loadMonth,
    TResult Function(CalendarEventSelectDay value)? selectDay,
    TResult Function(CalendarEventGoToToday value)? goToToday,
    TResult Function(CalendarEventFormatChanged value)? formatChanged,
    required TResult orElse(),
  }) {
    if (loadMonth != null) {
      return loadMonth(this);
    }
    return orElse();
  }
}

abstract class CalendarEventLoadMonth implements CalendarEvent {
  const factory CalendarEventLoadMonth(final DateTime month) =
      _$CalendarEventLoadMonthImpl;

  DateTime get month;
  @JsonKey(ignore: true)
  _$$CalendarEventLoadMonthImplCopyWith<_$CalendarEventLoadMonthImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CalendarEventSelectDayImplCopyWith<$Res> {
  factory _$$CalendarEventSelectDayImplCopyWith(
          _$CalendarEventSelectDayImpl value,
          $Res Function(_$CalendarEventSelectDayImpl) then) =
      __$$CalendarEventSelectDayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime day});
}

/// @nodoc
class __$$CalendarEventSelectDayImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventSelectDayImpl>
    implements _$$CalendarEventSelectDayImplCopyWith<$Res> {
  __$$CalendarEventSelectDayImplCopyWithImpl(
      _$CalendarEventSelectDayImpl _value,
      $Res Function(_$CalendarEventSelectDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
  }) {
    return _then(_$CalendarEventSelectDayImpl(
      null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CalendarEventSelectDayImpl implements CalendarEventSelectDay {
  const _$CalendarEventSelectDayImpl(this.day);

  @override
  final DateTime day;

  @override
  String toString() {
    return 'CalendarEvent.selectDay(day: $day)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventSelectDayImpl &&
            (identical(other.day, day) || other.day == day));
  }

  @override
  int get hashCode => Object.hash(runtimeType, day);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventSelectDayImplCopyWith<_$CalendarEventSelectDayImpl>
      get copyWith => __$$CalendarEventSelectDayImplCopyWithImpl<
          _$CalendarEventSelectDayImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime month) loadMonth,
    required TResult Function(DateTime day) selectDay,
    required TResult Function() goToToday,
    required TResult Function(CalendarFormat format) formatChanged,
  }) {
    return selectDay(day);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime month)? loadMonth,
    TResult? Function(DateTime day)? selectDay,
    TResult? Function()? goToToday,
    TResult? Function(CalendarFormat format)? formatChanged,
  }) {
    return selectDay?.call(day);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime month)? loadMonth,
    TResult Function(DateTime day)? selectDay,
    TResult Function()? goToToday,
    TResult Function(CalendarFormat format)? formatChanged,
    required TResult orElse(),
  }) {
    if (selectDay != null) {
      return selectDay(day);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CalendarEventLoadMonth value) loadMonth,
    required TResult Function(CalendarEventSelectDay value) selectDay,
    required TResult Function(CalendarEventGoToToday value) goToToday,
    required TResult Function(CalendarEventFormatChanged value) formatChanged,
  }) {
    return selectDay(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CalendarEventLoadMonth value)? loadMonth,
    TResult? Function(CalendarEventSelectDay value)? selectDay,
    TResult? Function(CalendarEventGoToToday value)? goToToday,
    TResult? Function(CalendarEventFormatChanged value)? formatChanged,
  }) {
    return selectDay?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CalendarEventLoadMonth value)? loadMonth,
    TResult Function(CalendarEventSelectDay value)? selectDay,
    TResult Function(CalendarEventGoToToday value)? goToToday,
    TResult Function(CalendarEventFormatChanged value)? formatChanged,
    required TResult orElse(),
  }) {
    if (selectDay != null) {
      return selectDay(this);
    }
    return orElse();
  }
}

abstract class CalendarEventSelectDay implements CalendarEvent {
  const factory CalendarEventSelectDay(final DateTime day) =
      _$CalendarEventSelectDayImpl;

  DateTime get day;
  @JsonKey(ignore: true)
  _$$CalendarEventSelectDayImplCopyWith<_$CalendarEventSelectDayImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CalendarEventGoToTodayImplCopyWith<$Res> {
  factory _$$CalendarEventGoToTodayImplCopyWith(
          _$CalendarEventGoToTodayImpl value,
          $Res Function(_$CalendarEventGoToTodayImpl) then) =
      __$$CalendarEventGoToTodayImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CalendarEventGoToTodayImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventGoToTodayImpl>
    implements _$$CalendarEventGoToTodayImplCopyWith<$Res> {
  __$$CalendarEventGoToTodayImplCopyWithImpl(
      _$CalendarEventGoToTodayImpl _value,
      $Res Function(_$CalendarEventGoToTodayImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CalendarEventGoToTodayImpl implements CalendarEventGoToToday {
  const _$CalendarEventGoToTodayImpl();

  @override
  String toString() {
    return 'CalendarEvent.goToToday()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventGoToTodayImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime month) loadMonth,
    required TResult Function(DateTime day) selectDay,
    required TResult Function() goToToday,
    required TResult Function(CalendarFormat format) formatChanged,
  }) {
    return goToToday();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime month)? loadMonth,
    TResult? Function(DateTime day)? selectDay,
    TResult? Function()? goToToday,
    TResult? Function(CalendarFormat format)? formatChanged,
  }) {
    return goToToday?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime month)? loadMonth,
    TResult Function(DateTime day)? selectDay,
    TResult Function()? goToToday,
    TResult Function(CalendarFormat format)? formatChanged,
    required TResult orElse(),
  }) {
    if (goToToday != null) {
      return goToToday();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CalendarEventLoadMonth value) loadMonth,
    required TResult Function(CalendarEventSelectDay value) selectDay,
    required TResult Function(CalendarEventGoToToday value) goToToday,
    required TResult Function(CalendarEventFormatChanged value) formatChanged,
  }) {
    return goToToday(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CalendarEventLoadMonth value)? loadMonth,
    TResult? Function(CalendarEventSelectDay value)? selectDay,
    TResult? Function(CalendarEventGoToToday value)? goToToday,
    TResult? Function(CalendarEventFormatChanged value)? formatChanged,
  }) {
    return goToToday?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CalendarEventLoadMonth value)? loadMonth,
    TResult Function(CalendarEventSelectDay value)? selectDay,
    TResult Function(CalendarEventGoToToday value)? goToToday,
    TResult Function(CalendarEventFormatChanged value)? formatChanged,
    required TResult orElse(),
  }) {
    if (goToToday != null) {
      return goToToday(this);
    }
    return orElse();
  }
}

abstract class CalendarEventGoToToday implements CalendarEvent {
  const factory CalendarEventGoToToday() = _$CalendarEventGoToTodayImpl;
}

/// @nodoc
abstract class _$$CalendarEventFormatChangedImplCopyWith<$Res> {
  factory _$$CalendarEventFormatChangedImplCopyWith(
          _$CalendarEventFormatChangedImpl value,
          $Res Function(_$CalendarEventFormatChangedImpl) then) =
      __$$CalendarEventFormatChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CalendarFormat format});
}

/// @nodoc
class __$$CalendarEventFormatChangedImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventFormatChangedImpl>
    implements _$$CalendarEventFormatChangedImplCopyWith<$Res> {
  __$$CalendarEventFormatChangedImplCopyWithImpl(
      _$CalendarEventFormatChangedImpl _value,
      $Res Function(_$CalendarEventFormatChangedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? format = null,
  }) {
    return _then(_$CalendarEventFormatChangedImpl(
      null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
    ));
  }
}

/// @nodoc

class _$CalendarEventFormatChangedImpl implements CalendarEventFormatChanged {
  const _$CalendarEventFormatChangedImpl(this.format);

  @override
  final CalendarFormat format;

  @override
  String toString() {
    return 'CalendarEvent.formatChanged(format: $format)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventFormatChangedImpl &&
            (identical(other.format, format) || other.format == format));
  }

  @override
  int get hashCode => Object.hash(runtimeType, format);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventFormatChangedImplCopyWith<_$CalendarEventFormatChangedImpl>
      get copyWith => __$$CalendarEventFormatChangedImplCopyWithImpl<
          _$CalendarEventFormatChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime month) loadMonth,
    required TResult Function(DateTime day) selectDay,
    required TResult Function() goToToday,
    required TResult Function(CalendarFormat format) formatChanged,
  }) {
    return formatChanged(format);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime month)? loadMonth,
    TResult? Function(DateTime day)? selectDay,
    TResult? Function()? goToToday,
    TResult? Function(CalendarFormat format)? formatChanged,
  }) {
    return formatChanged?.call(format);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime month)? loadMonth,
    TResult Function(DateTime day)? selectDay,
    TResult Function()? goToToday,
    TResult Function(CalendarFormat format)? formatChanged,
    required TResult orElse(),
  }) {
    if (formatChanged != null) {
      return formatChanged(format);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CalendarEventLoadMonth value) loadMonth,
    required TResult Function(CalendarEventSelectDay value) selectDay,
    required TResult Function(CalendarEventGoToToday value) goToToday,
    required TResult Function(CalendarEventFormatChanged value) formatChanged,
  }) {
    return formatChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CalendarEventLoadMonth value)? loadMonth,
    TResult? Function(CalendarEventSelectDay value)? selectDay,
    TResult? Function(CalendarEventGoToToday value)? goToToday,
    TResult? Function(CalendarEventFormatChanged value)? formatChanged,
  }) {
    return formatChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CalendarEventLoadMonth value)? loadMonth,
    TResult Function(CalendarEventSelectDay value)? selectDay,
    TResult Function(CalendarEventGoToToday value)? goToToday,
    TResult Function(CalendarEventFormatChanged value)? formatChanged,
    required TResult orElse(),
  }) {
    if (formatChanged != null) {
      return formatChanged(this);
    }
    return orElse();
  }
}

abstract class CalendarEventFormatChanged implements CalendarEvent {
  const factory CalendarEventFormatChanged(final CalendarFormat format) =
      _$CalendarEventFormatChangedImpl;

  CalendarFormat get format;
  @JsonKey(ignore: true)
  _$$CalendarEventFormatChangedImplCopyWith<_$CalendarEventFormatChangedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CalendarState {
  /// 로딩 상태
  bool get isLoading => throw _privateConstructorUsedError;

  /// 포커스된 날짜 (캘린더에서 보이는 월)
  DateTime get focusedDay => throw _privateConstructorUsedError;

  /// 선택된 날짜
  DateTime? get selectedDay => throw _privateConstructorUsedError;

  /// 캘린더 포맷 (월/주/2주)
  CalendarFormat get calendarFormat => throw _privateConstructorUsedError;

  /// 월간 기록 데이터 (날짜별로 그룹화)
  Map<DateTime, Map<String, dynamic>> get monthRecords =>
      throw _privateConstructorUsedError;

  /// 선택된 날짜의 기록
  Map<String, dynamic>? get selectedDayRecords =>
      throw _privateConstructorUsedError;

  /// 에러
  Option<Failure> get failure => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarStateCopyWith<CalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarStateCopyWith<$Res> {
  factory $CalendarStateCopyWith(
          CalendarState value, $Res Function(CalendarState) then) =
      _$CalendarStateCopyWithImpl<$Res, CalendarState>;
  @useResult
  $Res call(
      {bool isLoading,
      DateTime focusedDay,
      DateTime? selectedDay,
      CalendarFormat calendarFormat,
      Map<DateTime, Map<String, dynamic>> monthRecords,
      Map<String, dynamic>? selectedDayRecords,
      Option<Failure> failure});
}

/// @nodoc
class _$CalendarStateCopyWithImpl<$Res, $Val extends CalendarState>
    implements $CalendarStateCopyWith<$Res> {
  _$CalendarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? focusedDay = null,
    Object? selectedDay = freezed,
    Object? calendarFormat = null,
    Object? monthRecords = null,
    Object? selectedDayRecords = freezed,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      focusedDay: null == focusedDay
          ? _value.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: freezed == selectedDay
          ? _value.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calendarFormat: null == calendarFormat
          ? _value.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
      monthRecords: null == monthRecords
          ? _value.monthRecords
          : monthRecords // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, Map<String, dynamic>>,
      selectedDayRecords: freezed == selectedDayRecords
          ? _value.selectedDayRecords
          : selectedDayRecords // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarStateImplCopyWith<$Res>
    implements $CalendarStateCopyWith<$Res> {
  factory _$$CalendarStateImplCopyWith(
          _$CalendarStateImpl value, $Res Function(_$CalendarStateImpl) then) =
      __$$CalendarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      DateTime focusedDay,
      DateTime? selectedDay,
      CalendarFormat calendarFormat,
      Map<DateTime, Map<String, dynamic>> monthRecords,
      Map<String, dynamic>? selectedDayRecords,
      Option<Failure> failure});
}

/// @nodoc
class __$$CalendarStateImplCopyWithImpl<$Res>
    extends _$CalendarStateCopyWithImpl<$Res, _$CalendarStateImpl>
    implements _$$CalendarStateImplCopyWith<$Res> {
  __$$CalendarStateImplCopyWithImpl(
      _$CalendarStateImpl _value, $Res Function(_$CalendarStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? focusedDay = null,
    Object? selectedDay = freezed,
    Object? calendarFormat = null,
    Object? monthRecords = null,
    Object? selectedDayRecords = freezed,
    Object? failure = null,
  }) {
    return _then(_$CalendarStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      focusedDay: null == focusedDay
          ? _value.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: freezed == selectedDay
          ? _value.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calendarFormat: null == calendarFormat
          ? _value.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
      monthRecords: null == monthRecords
          ? _value._monthRecords
          : monthRecords // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, Map<String, dynamic>>,
      selectedDayRecords: freezed == selectedDayRecords
          ? _value._selectedDayRecords
          : selectedDayRecords // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
    ));
  }
}

/// @nodoc

class _$CalendarStateImpl implements _CalendarState {
  const _$CalendarStateImpl(
      {required this.isLoading,
      required this.focusedDay,
      this.selectedDay,
      required this.calendarFormat,
      required final Map<DateTime, Map<String, dynamic>> monthRecords,
      final Map<String, dynamic>? selectedDayRecords,
      required this.failure})
      : _monthRecords = monthRecords,
        _selectedDayRecords = selectedDayRecords;

  /// 로딩 상태
  @override
  final bool isLoading;

  /// 포커스된 날짜 (캘린더에서 보이는 월)
  @override
  final DateTime focusedDay;

  /// 선택된 날짜
  @override
  final DateTime? selectedDay;

  /// 캘린더 포맷 (월/주/2주)
  @override
  final CalendarFormat calendarFormat;

  /// 월간 기록 데이터 (날짜별로 그룹화)
  final Map<DateTime, Map<String, dynamic>> _monthRecords;

  /// 월간 기록 데이터 (날짜별로 그룹화)
  @override
  Map<DateTime, Map<String, dynamic>> get monthRecords {
    if (_monthRecords is EqualUnmodifiableMapView) return _monthRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_monthRecords);
  }

  /// 선택된 날짜의 기록
  final Map<String, dynamic>? _selectedDayRecords;

  /// 선택된 날짜의 기록
  @override
  Map<String, dynamic>? get selectedDayRecords {
    final value = _selectedDayRecords;
    if (value == null) return null;
    if (_selectedDayRecords is EqualUnmodifiableMapView)
      return _selectedDayRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 에러
  @override
  final Option<Failure> failure;

  @override
  String toString() {
    return 'CalendarState(isLoading: $isLoading, focusedDay: $focusedDay, selectedDay: $selectedDay, calendarFormat: $calendarFormat, monthRecords: $monthRecords, selectedDayRecords: $selectedDayRecords, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.focusedDay, focusedDay) ||
                other.focusedDay == focusedDay) &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            (identical(other.calendarFormat, calendarFormat) ||
                other.calendarFormat == calendarFormat) &&
            const DeepCollectionEquality()
                .equals(other._monthRecords, _monthRecords) &&
            const DeepCollectionEquality()
                .equals(other._selectedDayRecords, _selectedDayRecords) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      focusedDay,
      selectedDay,
      calendarFormat,
      const DeepCollectionEquality().hash(_monthRecords),
      const DeepCollectionEquality().hash(_selectedDayRecords),
      failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarStateImplCopyWith<_$CalendarStateImpl> get copyWith =>
      __$$CalendarStateImplCopyWithImpl<_$CalendarStateImpl>(this, _$identity);
}

abstract class _CalendarState implements CalendarState {
  const factory _CalendarState(
      {required final bool isLoading,
      required final DateTime focusedDay,
      final DateTime? selectedDay,
      required final CalendarFormat calendarFormat,
      required final Map<DateTime, Map<String, dynamic>> monthRecords,
      final Map<String, dynamic>? selectedDayRecords,
      required final Option<Failure> failure}) = _$CalendarStateImpl;

  @override

  /// 로딩 상태
  bool get isLoading;
  @override

  /// 포커스된 날짜 (캘린더에서 보이는 월)
  DateTime get focusedDay;
  @override

  /// 선택된 날짜
  DateTime? get selectedDay;
  @override

  /// 캘린더 포맷 (월/주/2주)
  CalendarFormat get calendarFormat;
  @override

  /// 월간 기록 데이터 (날짜별로 그룹화)
  Map<DateTime, Map<String, dynamic>> get monthRecords;
  @override

  /// 선택된 날짜의 기록
  Map<String, dynamic>? get selectedDayRecords;
  @override

  /// 에러
  Option<Failure> get failure;
  @override
  @JsonKey(ignore: true)
  _$$CalendarStateImplCopyWith<_$CalendarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
