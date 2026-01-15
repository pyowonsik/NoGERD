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

  /// 약물 복용 여부 (true: 복용함, false: 복용 안함)
  bool get isTaken => throw _privateConstructorUsedError;

  /// 약물 종류 목록 (복용 안함일 경우 null, 여러 종류 선택 가능)
  List<MedicationType>? get medicationTypes =>
      throw _privateConstructorUsedError;

  /// 약물 이름 (복용 안함일 경우 null)
  String? get medicationName => throw _privateConstructorUsedError;

  /// 용량 (복용 안함일 경우 null)
  String? get dosage => throw _privateConstructorUsedError;

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
      bool isTaken,
      List<MedicationType>? medicationTypes,
      String? medicationName,
      String? dosage,
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
    Object? isTaken = null,
    Object? medicationTypes = freezed,
    Object? medicationName = freezed,
    Object? dosage = freezed,
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
      isTaken: null == isTaken
          ? _value.isTaken
          : isTaken // ignore: cast_nullable_to_non_nullable
              as bool,
      medicationTypes: freezed == medicationTypes
          ? _value.medicationTypes
          : medicationTypes // ignore: cast_nullable_to_non_nullable
              as List<MedicationType>?,
      medicationName: freezed == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String?,
      dosage: freezed == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      bool isTaken,
      List<MedicationType>? medicationTypes,
      String? medicationName,
      String? dosage,
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
    Object? isTaken = null,
    Object? medicationTypes = freezed,
    Object? medicationName = freezed,
    Object? dosage = freezed,
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
      isTaken: null == isTaken
          ? _value.isTaken
          : isTaken // ignore: cast_nullable_to_non_nullable
              as bool,
      medicationTypes: freezed == medicationTypes
          ? _value._medicationTypes
          : medicationTypes // ignore: cast_nullable_to_non_nullable
              as List<MedicationType>?,
      medicationName: freezed == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String?,
      dosage: freezed == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      this.isTaken = true,
      final List<MedicationType>? medicationTypes,
      this.medicationName,
      this.dosage,
      this.purpose,
      this.effectiveness,
      this.notes,
      required this.createdAt,
      this.updatedAt})
      : _medicationTypes = medicationTypes;

  /// 고유 ID
  @override
  final String id;

  /// 기록 시간
  @override
  final DateTime recordedAt;

  /// 약물 복용 여부 (true: 복용함, false: 복용 안함)
  @override
  @JsonKey()
  final bool isTaken;

  /// 약물 종류 목록 (복용 안함일 경우 null, 여러 종류 선택 가능)
  final List<MedicationType>? _medicationTypes;

  /// 약물 종류 목록 (복용 안함일 경우 null, 여러 종류 선택 가능)
  @override
  List<MedicationType>? get medicationTypes {
    final value = _medicationTypes;
    if (value == null) return null;
    if (_medicationTypes is EqualUnmodifiableListView) return _medicationTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 약물 이름 (복용 안함일 경우 null)
  @override
  final String? medicationName;

  /// 용량 (복용 안함일 경우 null)
  @override
  final String? dosage;

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
    return 'MedicationRecord(id: $id, recordedAt: $recordedAt, isTaken: $isTaken, medicationTypes: $medicationTypes, medicationName: $medicationName, dosage: $dosage, purpose: $purpose, effectiveness: $effectiveness, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.isTaken, isTaken) || other.isTaken == isTaken) &&
            const DeepCollectionEquality()
                .equals(other._medicationTypes, _medicationTypes) &&
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
      isTaken,
      const DeepCollectionEquality().hash(_medicationTypes),
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
      final bool isTaken,
      final List<MedicationType>? medicationTypes,
      final String? medicationName,
      final String? dosage,
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

  /// 약물 복용 여부 (true: 복용함, false: 복용 안함)
  bool get isTaken;
  @override

  /// 약물 종류 목록 (복용 안함일 경우 null, 여러 종류 선택 가능)
  List<MedicationType>? get medicationTypes;
  @override

  /// 약물 이름 (복용 안함일 경우 null)
  String? get medicationName;
  @override

  /// 용량 (복용 안함일 경우 null)
  String? get dosage;
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
