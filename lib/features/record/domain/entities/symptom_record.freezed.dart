// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symptom_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SymptomRecord {
  /// 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 기록 시간
  DateTime get recordedAt => throw _privateConstructorUsedError;

  /// 증상 목록
  List<GerdSymptom> get symptoms => throw _privateConstructorUsedError;

  /// 심각도 (1-10)
  int get severity => throw _privateConstructorUsedError;

  /// 메모
  String? get notes => throw _privateConstructorUsedError;

  /// 생성 시간
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 수정 시간
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SymptomRecordCopyWith<SymptomRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SymptomRecordCopyWith<$Res> {
  factory $SymptomRecordCopyWith(
          SymptomRecord value, $Res Function(SymptomRecord) then) =
      _$SymptomRecordCopyWithImpl<$Res, SymptomRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      List<GerdSymptom> symptoms,
      int severity,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$SymptomRecordCopyWithImpl<$Res, $Val extends SymptomRecord>
    implements $SymptomRecordCopyWith<$Res> {
  _$SymptomRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? symptoms = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      symptoms: null == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<GerdSymptom>,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SymptomRecordImplCopyWith<$Res>
    implements $SymptomRecordCopyWith<$Res> {
  factory _$$SymptomRecordImplCopyWith(
          _$SymptomRecordImpl value, $Res Function(_$SymptomRecordImpl) then) =
      __$$SymptomRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      List<GerdSymptom> symptoms,
      int severity,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SymptomRecordImplCopyWithImpl<$Res>
    extends _$SymptomRecordCopyWithImpl<$Res, _$SymptomRecordImpl>
    implements _$$SymptomRecordImplCopyWith<$Res> {
  __$$SymptomRecordImplCopyWithImpl(
      _$SymptomRecordImpl _value, $Res Function(_$SymptomRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? symptoms = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SymptomRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      symptoms: null == symptoms
          ? _value._symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<GerdSymptom>,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$SymptomRecordImpl implements _SymptomRecord {
  const _$SymptomRecordImpl(
      {required this.id,
      required this.recordedAt,
      required final List<GerdSymptom> symptoms,
      required this.severity,
      this.notes,
      required this.createdAt,
      this.updatedAt})
      : _symptoms = symptoms;

  /// 고유 ID
  @override
  final String id;

  /// 기록 시간
  @override
  final DateTime recordedAt;

  /// 증상 목록
  final List<GerdSymptom> _symptoms;

  /// 증상 목록
  @override
  List<GerdSymptom> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  /// 심각도 (1-10)
  @override
  final int severity;

  /// 메모
  @override
  final String? notes;

  /// 생성 시간
  @override
  final DateTime createdAt;

  /// 수정 시간
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SymptomRecord(id: $id, recordedAt: $recordedAt, symptoms: $symptoms, severity: $severity, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymptomRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recordedAt,
      const DeepCollectionEquality().hash(_symptoms),
      severity,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SymptomRecordImplCopyWith<_$SymptomRecordImpl> get copyWith =>
      __$$SymptomRecordImplCopyWithImpl<_$SymptomRecordImpl>(this, _$identity);
}

abstract class _SymptomRecord implements SymptomRecord {
  const factory _SymptomRecord(
      {required final String id,
      required final DateTime recordedAt,
      required final List<GerdSymptom> symptoms,
      required final int severity,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$SymptomRecordImpl;

  @override

  /// 고유 ID
  String get id;
  @override

  /// 기록 시간
  DateTime get recordedAt;
  @override

  /// 증상 목록
  List<GerdSymptom> get symptoms;
  @override

  /// 심각도 (1-10)
  int get severity;
  @override

  /// 메모
  String? get notes;
  @override

  /// 생성 시간
  DateTime get createdAt;
  @override

  /// 수정 시간
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SymptomRecordImplCopyWith<_$SymptomRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
