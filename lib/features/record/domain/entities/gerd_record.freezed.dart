// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gerd_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GerdRecord _$GerdRecordFromJson(Map<String, dynamic> json) {
  return _GerdRecord.fromJson(json);
}

/// @nodoc
mixin _$GerdRecord {
  String get date => throw _privateConstructorUsedError;
  List<String> get symptoms => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GerdRecordCopyWith<GerdRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GerdRecordCopyWith<$Res> {
  factory $GerdRecordCopyWith(
          GerdRecord value, $Res Function(GerdRecord) then) =
      _$GerdRecordCopyWithImpl<$Res, GerdRecord>;
  @useResult
  $Res call({String date, List<String> symptoms, String status, String notes});
}

/// @nodoc
class _$GerdRecordCopyWithImpl<$Res, $Val extends GerdRecord>
    implements $GerdRecordCopyWith<$Res> {
  _$GerdRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? symptoms = null,
    Object? status = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      symptoms: null == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GerdRecordImplCopyWith<$Res>
    implements $GerdRecordCopyWith<$Res> {
  factory _$$GerdRecordImplCopyWith(
          _$GerdRecordImpl value, $Res Function(_$GerdRecordImpl) then) =
      __$$GerdRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, List<String> symptoms, String status, String notes});
}

/// @nodoc
class __$$GerdRecordImplCopyWithImpl<$Res>
    extends _$GerdRecordCopyWithImpl<$Res, _$GerdRecordImpl>
    implements _$$GerdRecordImplCopyWith<$Res> {
  __$$GerdRecordImplCopyWithImpl(
      _$GerdRecordImpl _value, $Res Function(_$GerdRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? symptoms = null,
    Object? status = null,
    Object? notes = null,
  }) {
    return _then(_$GerdRecordImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      symptoms: null == symptoms
          ? _value._symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GerdRecordImpl implements _GerdRecord {
  const _$GerdRecordImpl(
      {required this.date,
      required final List<String> symptoms,
      required this.status,
      required this.notes})
      : _symptoms = symptoms;

  factory _$GerdRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$GerdRecordImplFromJson(json);

  @override
  final String date;
  final List<String> _symptoms;
  @override
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  @override
  final String status;
  @override
  final String notes;

  @override
  String toString() {
    return 'GerdRecord(date: $date, symptoms: $symptoms, status: $status, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GerdRecordImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date,
      const DeepCollectionEquality().hash(_symptoms), status, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GerdRecordImplCopyWith<_$GerdRecordImpl> get copyWith =>
      __$$GerdRecordImplCopyWithImpl<_$GerdRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GerdRecordImplToJson(
      this,
    );
  }
}

abstract class _GerdRecord implements GerdRecord {
  const factory _GerdRecord(
      {required final String date,
      required final List<String> symptoms,
      required final String status,
      required final String notes}) = _$GerdRecordImpl;

  factory _GerdRecord.fromJson(Map<String, dynamic> json) =
      _$GerdRecordImpl.fromJson;

  @override
  String get date;
  @override
  List<String> get symptoms;
  @override
  String get status;
  @override
  String get notes;
  @override
  @JsonKey(ignore: true)
  _$$GerdRecordImplCopyWith<_$GerdRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
