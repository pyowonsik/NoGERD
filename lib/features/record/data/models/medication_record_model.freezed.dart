// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicationRecordModel _$MedicationRecordModelFromJson(
    Map<String, dynamic> json) {
  return _MedicationRecordModel.fromJson(json);
}

/// @nodoc
mixin _$MedicationRecordModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_datetime')
  DateTime get recordedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_taken')
  bool get isTaken => throw _privateConstructorUsedError;
  @JsonKey(name: 'medication_types')
  List<String>? get medicationTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'medication_name')
  String? get medicationName => throw _privateConstructorUsedError;
  String? get dosage => throw _privateConstructorUsedError;
  String? get purpose => throw _privateConstructorUsedError;
  int? get effectiveness => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MedicationRecordModelCopyWith<MedicationRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationRecordModelCopyWith<$Res> {
  factory $MedicationRecordModelCopyWith(MedicationRecordModel value,
          $Res Function(MedicationRecordModel) then) =
      _$MedicationRecordModelCopyWithImpl<$Res, MedicationRecordModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'record_datetime') DateTime recordedAt,
      @JsonKey(name: 'is_taken') bool isTaken,
      @JsonKey(name: 'medication_types') List<String>? medicationTypes,
      @JsonKey(name: 'medication_name') String? medicationName,
      String? dosage,
      String? purpose,
      int? effectiveness,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$MedicationRecordModelCopyWithImpl<$Res,
        $Val extends MedicationRecordModel>
    implements $MedicationRecordModelCopyWith<$Res> {
  _$MedicationRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
              as List<String>?,
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
abstract class _$$MedicationRecordModelImplCopyWith<$Res>
    implements $MedicationRecordModelCopyWith<$Res> {
  factory _$$MedicationRecordModelImplCopyWith(
          _$MedicationRecordModelImpl value,
          $Res Function(_$MedicationRecordModelImpl) then) =
      __$$MedicationRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'record_datetime') DateTime recordedAt,
      @JsonKey(name: 'is_taken') bool isTaken,
      @JsonKey(name: 'medication_types') List<String>? medicationTypes,
      @JsonKey(name: 'medication_name') String? medicationName,
      String? dosage,
      String? purpose,
      int? effectiveness,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$MedicationRecordModelImplCopyWithImpl<$Res>
    extends _$MedicationRecordModelCopyWithImpl<$Res,
        _$MedicationRecordModelImpl>
    implements _$$MedicationRecordModelImplCopyWith<$Res> {
  __$$MedicationRecordModelImplCopyWithImpl(_$MedicationRecordModelImpl _value,
      $Res Function(_$MedicationRecordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
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
    return _then(_$MedicationRecordModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
              as List<String>?,
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
@JsonSerializable()
class _$MedicationRecordModelImpl extends _MedicationRecordModel {
  const _$MedicationRecordModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'record_datetime') required this.recordedAt,
      @JsonKey(name: 'is_taken') this.isTaken = true,
      @JsonKey(name: 'medication_types') final List<String>? medicationTypes,
      @JsonKey(name: 'medication_name') this.medicationName,
      this.dosage,
      this.purpose,
      this.effectiveness,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _medicationTypes = medicationTypes,
        super._();

  factory _$MedicationRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicationRecordModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'record_datetime')
  final DateTime recordedAt;
  @override
  @JsonKey(name: 'is_taken')
  final bool isTaken;
  final List<String>? _medicationTypes;
  @override
  @JsonKey(name: 'medication_types')
  List<String>? get medicationTypes {
    final value = _medicationTypes;
    if (value == null) return null;
    if (_medicationTypes is EqualUnmodifiableListView) return _medicationTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'medication_name')
  final String? medicationName;
  @override
  final String? dosage;
  @override
  final String? purpose;
  @override
  final int? effectiveness;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MedicationRecordModel(id: $id, userId: $userId, recordedAt: $recordedAt, isTaken: $isTaken, medicationTypes: $medicationTypes, medicationName: $medicationName, dosage: $dosage, purpose: $purpose, effectiveness: $effectiveness, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
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
  _$$MedicationRecordModelImplCopyWith<_$MedicationRecordModelImpl>
      get copyWith => __$$MedicationRecordModelImplCopyWithImpl<
          _$MedicationRecordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicationRecordModelImplToJson(
      this,
    );
  }
}

abstract class _MedicationRecordModel extends MedicationRecordModel {
  const factory _MedicationRecordModel(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'record_datetime') required final DateTime recordedAt,
      @JsonKey(name: 'is_taken') final bool isTaken,
      @JsonKey(name: 'medication_types') final List<String>? medicationTypes,
      @JsonKey(name: 'medication_name') final String? medicationName,
      final String? dosage,
      final String? purpose,
      final int? effectiveness,
      final String? notes,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$MedicationRecordModelImpl;
  const _MedicationRecordModel._() : super._();

  factory _MedicationRecordModel.fromJson(Map<String, dynamic> json) =
      _$MedicationRecordModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'record_datetime')
  DateTime get recordedAt;
  @override
  @JsonKey(name: 'is_taken')
  bool get isTaken;
  @override
  @JsonKey(name: 'medication_types')
  List<String>? get medicationTypes;
  @override
  @JsonKey(name: 'medication_name')
  String? get medicationName;
  @override
  String? get dosage;
  @override
  String? get purpose;
  @override
  int? get effectiveness;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MedicationRecordModelImplCopyWith<_$MedicationRecordModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
