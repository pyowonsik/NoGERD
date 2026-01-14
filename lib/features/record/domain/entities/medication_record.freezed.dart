// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MedicationRecord {
  /// 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 기록 시간
  DateTime get recordedAt => throw _privateConstructorUsedError;

  /// 약물 종류
  MedicationType get medicationType => throw _privateConstructorUsedError;

  /// 약물 이름
  String get medicationName => throw _privateConstructorUsedError;

  /// 용량
  String get dosage => throw _privateConstructorUsedError;

  /// 복용 목적
  String? get purpose => throw _privateConstructorUsedError;

  /// 효과 평가 (1-10)
  int? get effectiveness => throw _privateConstructorUsedError;

  /// 메모
  String? get notes => throw _privateConstructorUsedError;

  /// 생성 시간
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 수정 시간
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MedicationRecordCopyWith<MedicationRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationRecordCopyWith<$Res> {
  factory $MedicationRecordCopyWith(
          MedicationRecord value, $Res Function(MedicationRecord) then) =
      _$MedicationRecordCopyWithImpl<$Res, MedicationRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      MedicationType medicationType,
      String medicationName,
      String dosage,
      String? purpose,
      int? effectiveness,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MedicationRecordCopyWithImpl<$Res, $Val extends MedicationRecord>
    implements $MedicationRecordCopyWith<$Res> {
  _$MedicationRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? medicationType = null,
    Object? medicationName = null,
    Object? dosage = null,
    Object? purpose = freezed,
    Object? effectiveness = freezed,
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
      medicationType: null == medicationType
          ? _value.medicationType
          : medicationType // ignore: cast_nullable_to_non_nullable
              as MedicationType,
      medicationName: null == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      effectiveness: freezed == effectiveness
          ? _value.effectiveness
          : effectiveness // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$MedicationRecordImplCopyWith<$Res>
    implements $MedicationRecordCopyWith<$Res> {
  factory _$$MedicationRecordImplCopyWith(_$MedicationRecordImpl value,
          $Res Function(_$MedicationRecordImpl) then) =
      __$$MedicationRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      MedicationType medicationType,
      String medicationName,
      String dosage,
      String? purpose,
      int? effectiveness,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$MedicationRecordImplCopyWithImpl<$Res>
    extends _$MedicationRecordCopyWithImpl<$Res, _$MedicationRecordImpl>
    implements _$$MedicationRecordImplCopyWith<$Res> {
  __$$MedicationRecordImplCopyWithImpl(_$MedicationRecordImpl _value,
      $Res Function(_$MedicationRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? medicationType = null,
    Object? medicationName = null,
    Object? dosage = null,
    Object? purpose = freezed,
    Object? effectiveness = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MedicationRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      medicationType: null == medicationType
          ? _value.medicationType
          : medicationType // ignore: cast_nullable_to_non_nullable
              as MedicationType,
      medicationName: null == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      effectiveness: freezed == effectiveness
          ? _value.effectiveness
          : effectiveness // ignore: cast_nullable_to_non_nullable
              as int?,
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

class _$MedicationRecordImpl implements _MedicationRecord {
  const _$MedicationRecordImpl(
      {required this.id,
      required this.recordedAt,
      required this.medicationType,
      required this.medicationName,
      required this.dosage,
      this.purpose,
      this.effectiveness,
      this.notes,
      required this.createdAt,
      this.updatedAt});

  /// 고유 ID
  @override
  final String id;

  /// 기록 시간
  @override
  final DateTime recordedAt;

  /// 약물 종류
  @override
  final MedicationType medicationType;

  /// 약물 이름
  @override
  final String medicationName;

  /// 용량
  @override
  final String dosage;

  /// 복용 목적
  @override
  final String? purpose;

  /// 효과 평가 (1-10)
  @override
  final int? effectiveness;

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
    return 'MedicationRecord(id: $id, recordedAt: $recordedAt, medicationType: $medicationType, medicationName: $medicationName, dosage: $dosage, purpose: $purpose, effectiveness: $effectiveness, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.medicationType, medicationType) ||
                other.medicationType == medicationType) &&
            (identical(other.medicationName, medicationName) ||
                other.medicationName == medicationName) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.effectiveness, effectiveness) ||
                other.effectiveness == effectiveness) &&
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
      medicationType,
      medicationName,
      dosage,
      purpose,
      effectiveness,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationRecordImplCopyWith<_$MedicationRecordImpl> get copyWith =>
      __$$MedicationRecordImplCopyWithImpl<_$MedicationRecordImpl>(
          this, _$identity);
}

abstract class _MedicationRecord implements MedicationRecord {
  const factory _MedicationRecord(
      {required final String id,
      required final DateTime recordedAt,
      required final MedicationType medicationType,
      required final String medicationName,
      required final String dosage,
      final String? purpose,
      final int? effectiveness,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$MedicationRecordImpl;

  @override

  /// 고유 ID
  String get id;
  @override

  /// 기록 시간
  DateTime get recordedAt;
  @override

  /// 약물 종류
  MedicationType get medicationType;
  @override

  /// 약물 이름
  String get medicationName;
  @override

  /// 용량
  String get dosage;
  @override

  /// 복용 목적
  String? get purpose;
  @override

  /// 효과 평가 (1-10)
  int? get effectiveness;
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
  _$$MedicationRecordImplCopyWith<_$MedicationRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
