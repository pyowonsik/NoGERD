// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecordEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordEventCopyWith<$Res> {
  factory $RecordEventCopyWith(
          RecordEvent value, $Res Function(RecordEvent) then) =
      _$RecordEventCopyWithImpl<$Res, RecordEvent>;
}

/// @nodoc
class _$RecordEventCopyWithImpl<$Res, $Val extends RecordEvent>
    implements $RecordEventCopyWith<$Res> {
  _$RecordEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$RecordEventAddSymptomRecordImplCopyWith<$Res> {
  factory _$$RecordEventAddSymptomRecordImplCopyWith(
          _$RecordEventAddSymptomRecordImpl value,
          $Res Function(_$RecordEventAddSymptomRecordImpl) then) =
      __$$RecordEventAddSymptomRecordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SymptomRecord record});

  $SymptomRecordCopyWith<$Res> get record;
}

/// @nodoc
class __$$RecordEventAddSymptomRecordImplCopyWithImpl<$Res>
    extends _$RecordEventCopyWithImpl<$Res, _$RecordEventAddSymptomRecordImpl>
    implements _$$RecordEventAddSymptomRecordImplCopyWith<$Res> {
  __$$RecordEventAddSymptomRecordImplCopyWithImpl(
      _$RecordEventAddSymptomRecordImpl _value,
      $Res Function(_$RecordEventAddSymptomRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? record = null,
  }) {
    return _then(_$RecordEventAddSymptomRecordImpl(
      null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as SymptomRecord,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SymptomRecordCopyWith<$Res> get record {
    return $SymptomRecordCopyWith<$Res>(_value.record, (value) {
      return _then(_value.copyWith(record: value));
    });
  }
}

/// @nodoc

class _$RecordEventAddSymptomRecordImpl implements RecordEventAddSymptomRecord {
  const _$RecordEventAddSymptomRecordImpl(this.record);

  @override
  final SymptomRecord record;

  @override
  String toString() {
    return 'RecordEvent.addSymptomRecord(record: $record)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordEventAddSymptomRecordImpl &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordEventAddSymptomRecordImplCopyWith<_$RecordEventAddSymptomRecordImpl>
      get copyWith => __$$RecordEventAddSymptomRecordImplCopyWithImpl<
          _$RecordEventAddSymptomRecordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) {
    return addSymptomRecord(record);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) {
    return addSymptomRecord?.call(record);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addSymptomRecord != null) {
      return addSymptomRecord(record);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) {
    return addSymptomRecord(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) {
    return addSymptomRecord?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addSymptomRecord != null) {
      return addSymptomRecord(this);
    }
    return orElse();
  }
}

abstract class RecordEventAddSymptomRecord implements RecordEvent {
  const factory RecordEventAddSymptomRecord(final SymptomRecord record) =
      _$RecordEventAddSymptomRecordImpl;

  SymptomRecord get record;
  @JsonKey(ignore: true)
  _$$RecordEventAddSymptomRecordImplCopyWith<_$RecordEventAddSymptomRecordImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordEventAddMealRecordImplCopyWith<$Res> {
  factory _$$RecordEventAddMealRecordImplCopyWith(
          _$RecordEventAddMealRecordImpl value,
          $Res Function(_$RecordEventAddMealRecordImpl) then) =
      __$$RecordEventAddMealRecordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MealRecord record});

  $MealRecordCopyWith<$Res> get record;
}

/// @nodoc
class __$$RecordEventAddMealRecordImplCopyWithImpl<$Res>
    extends _$RecordEventCopyWithImpl<$Res, _$RecordEventAddMealRecordImpl>
    implements _$$RecordEventAddMealRecordImplCopyWith<$Res> {
  __$$RecordEventAddMealRecordImplCopyWithImpl(
      _$RecordEventAddMealRecordImpl _value,
      $Res Function(_$RecordEventAddMealRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? record = null,
  }) {
    return _then(_$RecordEventAddMealRecordImpl(
      null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as MealRecord,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $MealRecordCopyWith<$Res> get record {
    return $MealRecordCopyWith<$Res>(_value.record, (value) {
      return _then(_value.copyWith(record: value));
    });
  }
}

/// @nodoc

class _$RecordEventAddMealRecordImpl implements RecordEventAddMealRecord {
  const _$RecordEventAddMealRecordImpl(this.record);

  @override
  final MealRecord record;

  @override
  String toString() {
    return 'RecordEvent.addMealRecord(record: $record)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordEventAddMealRecordImpl &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordEventAddMealRecordImplCopyWith<_$RecordEventAddMealRecordImpl>
      get copyWith => __$$RecordEventAddMealRecordImplCopyWithImpl<
          _$RecordEventAddMealRecordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) {
    return addMealRecord(record);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) {
    return addMealRecord?.call(record);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addMealRecord != null) {
      return addMealRecord(record);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) {
    return addMealRecord(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) {
    return addMealRecord?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addMealRecord != null) {
      return addMealRecord(this);
    }
    return orElse();
  }
}

abstract class RecordEventAddMealRecord implements RecordEvent {
  const factory RecordEventAddMealRecord(final MealRecord record) =
      _$RecordEventAddMealRecordImpl;

  MealRecord get record;
  @JsonKey(ignore: true)
  _$$RecordEventAddMealRecordImplCopyWith<_$RecordEventAddMealRecordImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordEventAddMedicationRecordImplCopyWith<$Res> {
  factory _$$RecordEventAddMedicationRecordImplCopyWith(
          _$RecordEventAddMedicationRecordImpl value,
          $Res Function(_$RecordEventAddMedicationRecordImpl) then) =
      __$$RecordEventAddMedicationRecordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MedicationRecord record});

  $MedicationRecordCopyWith<$Res> get record;
}

/// @nodoc
class __$$RecordEventAddMedicationRecordImplCopyWithImpl<$Res>
    extends _$RecordEventCopyWithImpl<$Res,
        _$RecordEventAddMedicationRecordImpl>
    implements _$$RecordEventAddMedicationRecordImplCopyWith<$Res> {
  __$$RecordEventAddMedicationRecordImplCopyWithImpl(
      _$RecordEventAddMedicationRecordImpl _value,
      $Res Function(_$RecordEventAddMedicationRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? record = null,
  }) {
    return _then(_$RecordEventAddMedicationRecordImpl(
      null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as MedicationRecord,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $MedicationRecordCopyWith<$Res> get record {
    return $MedicationRecordCopyWith<$Res>(_value.record, (value) {
      return _then(_value.copyWith(record: value));
    });
  }
}

/// @nodoc

class _$RecordEventAddMedicationRecordImpl
    implements RecordEventAddMedicationRecord {
  const _$RecordEventAddMedicationRecordImpl(this.record);

  @override
  final MedicationRecord record;

  @override
  String toString() {
    return 'RecordEvent.addMedicationRecord(record: $record)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordEventAddMedicationRecordImpl &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordEventAddMedicationRecordImplCopyWith<
          _$RecordEventAddMedicationRecordImpl>
      get copyWith => __$$RecordEventAddMedicationRecordImplCopyWithImpl<
          _$RecordEventAddMedicationRecordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) {
    return addMedicationRecord(record);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) {
    return addMedicationRecord?.call(record);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addMedicationRecord != null) {
      return addMedicationRecord(record);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) {
    return addMedicationRecord(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) {
    return addMedicationRecord?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addMedicationRecord != null) {
      return addMedicationRecord(this);
    }
    return orElse();
  }
}

abstract class RecordEventAddMedicationRecord implements RecordEvent {
  const factory RecordEventAddMedicationRecord(final MedicationRecord record) =
      _$RecordEventAddMedicationRecordImpl;

  MedicationRecord get record;
  @JsonKey(ignore: true)
  _$$RecordEventAddMedicationRecordImplCopyWith<
          _$RecordEventAddMedicationRecordImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordEventAddLifestyleRecordImplCopyWith<$Res> {
  factory _$$RecordEventAddLifestyleRecordImplCopyWith(
          _$RecordEventAddLifestyleRecordImpl value,
          $Res Function(_$RecordEventAddLifestyleRecordImpl) then) =
      __$$RecordEventAddLifestyleRecordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LifestyleRecord record});

  $LifestyleRecordCopyWith<$Res> get record;
}

/// @nodoc
class __$$RecordEventAddLifestyleRecordImplCopyWithImpl<$Res>
    extends _$RecordEventCopyWithImpl<$Res, _$RecordEventAddLifestyleRecordImpl>
    implements _$$RecordEventAddLifestyleRecordImplCopyWith<$Res> {
  __$$RecordEventAddLifestyleRecordImplCopyWithImpl(
      _$RecordEventAddLifestyleRecordImpl _value,
      $Res Function(_$RecordEventAddLifestyleRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? record = null,
  }) {
    return _then(_$RecordEventAddLifestyleRecordImpl(
      null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as LifestyleRecord,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LifestyleRecordCopyWith<$Res> get record {
    return $LifestyleRecordCopyWith<$Res>(_value.record, (value) {
      return _then(_value.copyWith(record: value));
    });
  }
}

/// @nodoc

class _$RecordEventAddLifestyleRecordImpl
    implements RecordEventAddLifestyleRecord {
  const _$RecordEventAddLifestyleRecordImpl(this.record);

  @override
  final LifestyleRecord record;

  @override
  String toString() {
    return 'RecordEvent.addLifestyleRecord(record: $record)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordEventAddLifestyleRecordImpl &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordEventAddLifestyleRecordImplCopyWith<
          _$RecordEventAddLifestyleRecordImpl>
      get copyWith => __$$RecordEventAddLifestyleRecordImplCopyWithImpl<
          _$RecordEventAddLifestyleRecordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) {
    return addLifestyleRecord(record);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) {
    return addLifestyleRecord?.call(record);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addLifestyleRecord != null) {
      return addLifestyleRecord(record);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) {
    return addLifestyleRecord(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) {
    return addLifestyleRecord?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) {
    if (addLifestyleRecord != null) {
      return addLifestyleRecord(this);
    }
    return orElse();
  }
}

abstract class RecordEventAddLifestyleRecord implements RecordEvent {
  const factory RecordEventAddLifestyleRecord(final LifestyleRecord record) =
      _$RecordEventAddLifestyleRecordImpl;

  LifestyleRecord get record;
  @JsonKey(ignore: true)
  _$$RecordEventAddLifestyleRecordImplCopyWith<
          _$RecordEventAddLifestyleRecordImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordEventLoadRecordsImplCopyWith<$Res> {
  factory _$$RecordEventLoadRecordsImplCopyWith(
          _$RecordEventLoadRecordsImpl value,
          $Res Function(_$RecordEventLoadRecordsImpl) then) =
      __$$RecordEventLoadRecordsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime date});
}

/// @nodoc
class __$$RecordEventLoadRecordsImplCopyWithImpl<$Res>
    extends _$RecordEventCopyWithImpl<$Res, _$RecordEventLoadRecordsImpl>
    implements _$$RecordEventLoadRecordsImplCopyWith<$Res> {
  __$$RecordEventLoadRecordsImplCopyWithImpl(
      _$RecordEventLoadRecordsImpl _value,
      $Res Function(_$RecordEventLoadRecordsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_$RecordEventLoadRecordsImpl(
      null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$RecordEventLoadRecordsImpl implements RecordEventLoadRecords {
  const _$RecordEventLoadRecordsImpl(this.date);

  @override
  final DateTime date;

  @override
  String toString() {
    return 'RecordEvent.loadRecords(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordEventLoadRecordsImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordEventLoadRecordsImplCopyWith<_$RecordEventLoadRecordsImpl>
      get copyWith => __$$RecordEventLoadRecordsImplCopyWithImpl<
          _$RecordEventLoadRecordsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) {
    return loadRecords(date);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) {
    return loadRecords?.call(date);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) {
    if (loadRecords != null) {
      return loadRecords(date);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) {
    return loadRecords(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) {
    return loadRecords?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) {
    if (loadRecords != null) {
      return loadRecords(this);
    }
    return orElse();
  }
}

abstract class RecordEventLoadRecords implements RecordEvent {
  const factory RecordEventLoadRecords(final DateTime date) =
      _$RecordEventLoadRecordsImpl;

  DateTime get date;
  @JsonKey(ignore: true)
  _$$RecordEventLoadRecordsImplCopyWith<_$RecordEventLoadRecordsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordEventDeleteRecordImplCopyWith<$Res> {
  factory _$$RecordEventDeleteRecordImplCopyWith(
          _$RecordEventDeleteRecordImpl value,
          $Res Function(_$RecordEventDeleteRecordImpl) then) =
      __$$RecordEventDeleteRecordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id, RecordType recordType});
}

/// @nodoc
class __$$RecordEventDeleteRecordImplCopyWithImpl<$Res>
    extends _$RecordEventCopyWithImpl<$Res, _$RecordEventDeleteRecordImpl>
    implements _$$RecordEventDeleteRecordImplCopyWith<$Res> {
  __$$RecordEventDeleteRecordImplCopyWithImpl(
      _$RecordEventDeleteRecordImpl _value,
      $Res Function(_$RecordEventDeleteRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordType = null,
  }) {
    return _then(_$RecordEventDeleteRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordType: null == recordType
          ? _value.recordType
          : recordType // ignore: cast_nullable_to_non_nullable
              as RecordType,
    ));
  }
}

/// @nodoc

class _$RecordEventDeleteRecordImpl implements RecordEventDeleteRecord {
  const _$RecordEventDeleteRecordImpl(
      {required this.id, required this.recordType});

  @override
  final String id;
  @override
  final RecordType recordType;

  @override
  String toString() {
    return 'RecordEvent.deleteRecord(id: $id, recordType: $recordType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordEventDeleteRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordType, recordType) ||
                other.recordType == recordType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, recordType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordEventDeleteRecordImplCopyWith<_$RecordEventDeleteRecordImpl>
      get copyWith => __$$RecordEventDeleteRecordImplCopyWithImpl<
          _$RecordEventDeleteRecordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SymptomRecord record) addSymptomRecord,
    required TResult Function(MealRecord record) addMealRecord,
    required TResult Function(MedicationRecord record) addMedicationRecord,
    required TResult Function(LifestyleRecord record) addLifestyleRecord,
    required TResult Function(DateTime date) loadRecords,
    required TResult Function(String id, RecordType recordType) deleteRecord,
  }) {
    return deleteRecord(id, recordType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SymptomRecord record)? addSymptomRecord,
    TResult? Function(MealRecord record)? addMealRecord,
    TResult? Function(MedicationRecord record)? addMedicationRecord,
    TResult? Function(LifestyleRecord record)? addLifestyleRecord,
    TResult? Function(DateTime date)? loadRecords,
    TResult? Function(String id, RecordType recordType)? deleteRecord,
  }) {
    return deleteRecord?.call(id, recordType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SymptomRecord record)? addSymptomRecord,
    TResult Function(MealRecord record)? addMealRecord,
    TResult Function(MedicationRecord record)? addMedicationRecord,
    TResult Function(LifestyleRecord record)? addLifestyleRecord,
    TResult Function(DateTime date)? loadRecords,
    TResult Function(String id, RecordType recordType)? deleteRecord,
    required TResult orElse(),
  }) {
    if (deleteRecord != null) {
      return deleteRecord(id, recordType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordEventAddSymptomRecord value)
        addSymptomRecord,
    required TResult Function(RecordEventAddMealRecord value) addMealRecord,
    required TResult Function(RecordEventAddMedicationRecord value)
        addMedicationRecord,
    required TResult Function(RecordEventAddLifestyleRecord value)
        addLifestyleRecord,
    required TResult Function(RecordEventLoadRecords value) loadRecords,
    required TResult Function(RecordEventDeleteRecord value) deleteRecord,
  }) {
    return deleteRecord(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult? Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult? Function(RecordEventAddMedicationRecord value)?
        addMedicationRecord,
    TResult? Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult? Function(RecordEventLoadRecords value)? loadRecords,
    TResult? Function(RecordEventDeleteRecord value)? deleteRecord,
  }) {
    return deleteRecord?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordEventAddSymptomRecord value)? addSymptomRecord,
    TResult Function(RecordEventAddMealRecord value)? addMealRecord,
    TResult Function(RecordEventAddMedicationRecord value)? addMedicationRecord,
    TResult Function(RecordEventAddLifestyleRecord value)? addLifestyleRecord,
    TResult Function(RecordEventLoadRecords value)? loadRecords,
    TResult Function(RecordEventDeleteRecord value)? deleteRecord,
    required TResult orElse(),
  }) {
    if (deleteRecord != null) {
      return deleteRecord(this);
    }
    return orElse();
  }
}

abstract class RecordEventDeleteRecord implements RecordEvent {
  const factory RecordEventDeleteRecord(
      {required final String id,
      required final RecordType recordType}) = _$RecordEventDeleteRecordImpl;

  String get id;
  RecordType get recordType;
  @JsonKey(ignore: true)
  _$$RecordEventDeleteRecordImplCopyWith<_$RecordEventDeleteRecordImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecordState {
  /// 로딩 상태
  bool get isLoading => throw _privateConstructorUsedError;

  /// 증상 기록 목록
  List<SymptomRecord> get symptomRecords => throw _privateConstructorUsedError;

  /// 식사 기록 목록
  List<MealRecord> get mealRecords => throw _privateConstructorUsedError;

  /// 약물 기록 목록
  List<MedicationRecord> get medicationRecords =>
      throw _privateConstructorUsedError;

  /// 생활습관 기록 목록
  List<LifestyleRecord> get lifestyleRecords =>
      throw _privateConstructorUsedError;

  /// 에러
  Option<Failure> get failure => throw _privateConstructorUsedError;

  /// 성공 메시지
  Option<String> get successMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordStateCopyWith<RecordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordStateCopyWith<$Res> {
  factory $RecordStateCopyWith(
          RecordState value, $Res Function(RecordState) then) =
      _$RecordStateCopyWithImpl<$Res, RecordState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<SymptomRecord> symptomRecords,
      List<MealRecord> mealRecords,
      List<MedicationRecord> medicationRecords,
      List<LifestyleRecord> lifestyleRecords,
      Option<Failure> failure,
      Option<String> successMessage});
}

/// @nodoc
class _$RecordStateCopyWithImpl<$Res, $Val extends RecordState>
    implements $RecordStateCopyWith<$Res> {
  _$RecordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? symptomRecords = null,
    Object? mealRecords = null,
    Object? medicationRecords = null,
    Object? lifestyleRecords = null,
    Object? failure = null,
    Object? successMessage = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      symptomRecords: null == symptomRecords
          ? _value.symptomRecords
          : symptomRecords // ignore: cast_nullable_to_non_nullable
              as List<SymptomRecord>,
      mealRecords: null == mealRecords
          ? _value.mealRecords
          : mealRecords // ignore: cast_nullable_to_non_nullable
              as List<MealRecord>,
      medicationRecords: null == medicationRecords
          ? _value.medicationRecords
          : medicationRecords // ignore: cast_nullable_to_non_nullable
              as List<MedicationRecord>,
      lifestyleRecords: null == lifestyleRecords
          ? _value.lifestyleRecords
          : lifestyleRecords // ignore: cast_nullable_to_non_nullable
              as List<LifestyleRecord>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
      successMessage: null == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecordStateImplCopyWith<$Res>
    implements $RecordStateCopyWith<$Res> {
  factory _$$RecordStateImplCopyWith(
          _$RecordStateImpl value, $Res Function(_$RecordStateImpl) then) =
      __$$RecordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<SymptomRecord> symptomRecords,
      List<MealRecord> mealRecords,
      List<MedicationRecord> medicationRecords,
      List<LifestyleRecord> lifestyleRecords,
      Option<Failure> failure,
      Option<String> successMessage});
}

/// @nodoc
class __$$RecordStateImplCopyWithImpl<$Res>
    extends _$RecordStateCopyWithImpl<$Res, _$RecordStateImpl>
    implements _$$RecordStateImplCopyWith<$Res> {
  __$$RecordStateImplCopyWithImpl(
      _$RecordStateImpl _value, $Res Function(_$RecordStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? symptomRecords = null,
    Object? mealRecords = null,
    Object? medicationRecords = null,
    Object? lifestyleRecords = null,
    Object? failure = null,
    Object? successMessage = null,
  }) {
    return _then(_$RecordStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      symptomRecords: null == symptomRecords
          ? _value._symptomRecords
          : symptomRecords // ignore: cast_nullable_to_non_nullable
              as List<SymptomRecord>,
      mealRecords: null == mealRecords
          ? _value._mealRecords
          : mealRecords // ignore: cast_nullable_to_non_nullable
              as List<MealRecord>,
      medicationRecords: null == medicationRecords
          ? _value._medicationRecords
          : medicationRecords // ignore: cast_nullable_to_non_nullable
              as List<MedicationRecord>,
      lifestyleRecords: null == lifestyleRecords
          ? _value._lifestyleRecords
          : lifestyleRecords // ignore: cast_nullable_to_non_nullable
              as List<LifestyleRecord>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
      successMessage: null == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ));
  }
}

/// @nodoc

class _$RecordStateImpl implements _RecordState {
  const _$RecordStateImpl(
      {required this.isLoading,
      required final List<SymptomRecord> symptomRecords,
      required final List<MealRecord> mealRecords,
      required final List<MedicationRecord> medicationRecords,
      required final List<LifestyleRecord> lifestyleRecords,
      required this.failure,
      required this.successMessage})
      : _symptomRecords = symptomRecords,
        _mealRecords = mealRecords,
        _medicationRecords = medicationRecords,
        _lifestyleRecords = lifestyleRecords;

  /// 로딩 상태
  @override
  final bool isLoading;

  /// 증상 기록 목록
  final List<SymptomRecord> _symptomRecords;

  /// 증상 기록 목록
  @override
  List<SymptomRecord> get symptomRecords {
    if (_symptomRecords is EqualUnmodifiableListView) return _symptomRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomRecords);
  }

  /// 식사 기록 목록
  final List<MealRecord> _mealRecords;

  /// 식사 기록 목록
  @override
  List<MealRecord> get mealRecords {
    if (_mealRecords is EqualUnmodifiableListView) return _mealRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mealRecords);
  }

  /// 약물 기록 목록
  final List<MedicationRecord> _medicationRecords;

  /// 약물 기록 목록
  @override
  List<MedicationRecord> get medicationRecords {
    if (_medicationRecords is EqualUnmodifiableListView)
      return _medicationRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicationRecords);
  }

  /// 생활습관 기록 목록
  final List<LifestyleRecord> _lifestyleRecords;

  /// 생활습관 기록 목록
  @override
  List<LifestyleRecord> get lifestyleRecords {
    if (_lifestyleRecords is EqualUnmodifiableListView)
      return _lifestyleRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lifestyleRecords);
  }

  /// 에러
  @override
  final Option<Failure> failure;

  /// 성공 메시지
  @override
  final Option<String> successMessage;

  @override
  String toString() {
    return 'RecordState(isLoading: $isLoading, symptomRecords: $symptomRecords, mealRecords: $mealRecords, medicationRecords: $medicationRecords, lifestyleRecords: $lifestyleRecords, failure: $failure, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._symptomRecords, _symptomRecords) &&
            const DeepCollectionEquality()
                .equals(other._mealRecords, _mealRecords) &&
            const DeepCollectionEquality()
                .equals(other._medicationRecords, _medicationRecords) &&
            const DeepCollectionEquality()
                .equals(other._lifestyleRecords, _lifestyleRecords) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_symptomRecords),
      const DeepCollectionEquality().hash(_mealRecords),
      const DeepCollectionEquality().hash(_medicationRecords),
      const DeepCollectionEquality().hash(_lifestyleRecords),
      failure,
      successMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordStateImplCopyWith<_$RecordStateImpl> get copyWith =>
      __$$RecordStateImplCopyWithImpl<_$RecordStateImpl>(this, _$identity);
}

abstract class _RecordState implements RecordState {
  const factory _RecordState(
      {required final bool isLoading,
      required final List<SymptomRecord> symptomRecords,
      required final List<MealRecord> mealRecords,
      required final List<MedicationRecord> medicationRecords,
      required final List<LifestyleRecord> lifestyleRecords,
      required final Option<Failure> failure,
      required final Option<String> successMessage}) = _$RecordStateImpl;

  @override

  /// 로딩 상태
  bool get isLoading;
  @override

  /// 증상 기록 목록
  List<SymptomRecord> get symptomRecords;
  @override

  /// 식사 기록 목록
  List<MealRecord> get mealRecords;
  @override

  /// 약물 기록 목록
  List<MedicationRecord> get medicationRecords;
  @override

  /// 생활습관 기록 목록
  List<LifestyleRecord> get lifestyleRecords;
  @override

  /// 에러
  Option<Failure> get failure;
  @override

  /// 성공 메시지
  Option<String> get successMessage;
  @override
  @JsonKey(ignore: true)
  _$$RecordStateImplCopyWith<_$RecordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
