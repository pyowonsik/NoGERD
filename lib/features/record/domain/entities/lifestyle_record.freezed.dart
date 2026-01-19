// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifestyle_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LifestyleRecord {
  /// 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 기록 시간
  DateTime get recordedAt => throw _privateConstructorUsedError;

  /// 생활습관 유형
  LifestyleType get lifestyleType => throw _privateConstructorUsedError;

  /// 상세 정보 (JSON 형태로 저장)
  /// 예: 수면 - {"duration": 7, "quality": 8}
  /// 예: 운동 - {"type": "걷기", "duration": 30, "intensity": 5}
  /// 예: 스트레스 - {"level": 7}
  Map<String, dynamic> get details => throw _privateConstructorUsedError;

  /// 생성 시간
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 메모
  String? get notes => throw _privateConstructorUsedError;

  /// 수정 시간
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LifestyleRecordCopyWith<LifestyleRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifestyleRecordCopyWith<$Res> {
  factory $LifestyleRecordCopyWith(
          LifestyleRecord value, $Res Function(LifestyleRecord) then) =
      _$LifestyleRecordCopyWithImpl<$Res, LifestyleRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      LifestyleType lifestyleType,
      Map<String, dynamic> details,
      DateTime createdAt,
      String? notes,
      DateTime? updatedAt});
}

/// @nodoc
class _$LifestyleRecordCopyWithImpl<$Res, $Val extends LifestyleRecord>
    implements $LifestyleRecordCopyWith<$Res> {
  _$LifestyleRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? lifestyleType = null,
    Object? details = null,
    Object? createdAt = null,
    Object? notes = freezed,
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
      lifestyleType: null == lifestyleType
          ? _value.lifestyleType
          : lifestyleType // ignore: cast_nullable_to_non_nullable
              as LifestyleType,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LifestyleRecordImplCopyWith<$Res>
    implements $LifestyleRecordCopyWith<$Res> {
  factory _$$LifestyleRecordImplCopyWith(_$LifestyleRecordImpl value,
          $Res Function(_$LifestyleRecordImpl) then) =
      __$$LifestyleRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      LifestyleType lifestyleType,
      Map<String, dynamic> details,
      DateTime createdAt,
      String? notes,
      DateTime? updatedAt});
}

/// @nodoc
class __$$LifestyleRecordImplCopyWithImpl<$Res>
    extends _$LifestyleRecordCopyWithImpl<$Res, _$LifestyleRecordImpl>
    implements _$$LifestyleRecordImplCopyWith<$Res> {
  __$$LifestyleRecordImplCopyWithImpl(
      _$LifestyleRecordImpl _value, $Res Function(_$LifestyleRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? lifestyleType = null,
    Object? details = null,
    Object? createdAt = null,
    Object? notes = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$LifestyleRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lifestyleType: null == lifestyleType
          ? _value.lifestyleType
          : lifestyleType // ignore: cast_nullable_to_non_nullable
              as LifestyleType,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$LifestyleRecordImpl implements _LifestyleRecord {
  const _$LifestyleRecordImpl(
      {required this.id,
      required this.recordedAt,
      required this.lifestyleType,
      required final Map<String, dynamic> details,
      required this.createdAt,
      this.notes,
      this.updatedAt})
      : _details = details;

  /// 고유 ID
  @override
  final String id;

  /// 기록 시간
  @override
  final DateTime recordedAt;

  /// 생활습관 유형
  @override
  final LifestyleType lifestyleType;

  /// 상세 정보 (JSON 형태로 저장)
  /// 예: 수면 - {"duration": 7, "quality": 8}
  /// 예: 운동 - {"type": "걷기", "duration": 30, "intensity": 5}
  /// 예: 스트레스 - {"level": 7}
  final Map<String, dynamic> _details;

  /// 상세 정보 (JSON 형태로 저장)
  /// 예: 수면 - {"duration": 7, "quality": 8}
  /// 예: 운동 - {"type": "걷기", "duration": 30, "intensity": 5}
  /// 예: 스트레스 - {"level": 7}
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  /// 생성 시간
  @override
  final DateTime createdAt;

  /// 메모
  @override
  final String? notes;

  /// 수정 시간
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LifestyleRecord(id: $id, recordedAt: $recordedAt, lifestyleType: $lifestyleType, details: $details, createdAt: $createdAt, notes: $notes, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifestyleRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.lifestyleType, lifestyleType) ||
                other.lifestyleType == lifestyleType) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recordedAt,
      lifestyleType,
      const DeepCollectionEquality().hash(_details),
      createdAt,
      notes,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LifestyleRecordImplCopyWith<_$LifestyleRecordImpl> get copyWith =>
      __$$LifestyleRecordImplCopyWithImpl<_$LifestyleRecordImpl>(
          this, _$identity);
}

abstract class _LifestyleRecord implements LifestyleRecord {
  const factory _LifestyleRecord(
      {required final String id,
      required final DateTime recordedAt,
      required final LifestyleType lifestyleType,
      required final Map<String, dynamic> details,
      required final DateTime createdAt,
      final String? notes,
      final DateTime? updatedAt}) = _$LifestyleRecordImpl;

  @override

  /// 고유 ID
  String get id;
  @override

  /// 기록 시간
  DateTime get recordedAt;
  @override

  /// 생활습관 유형
  LifestyleType get lifestyleType;
  @override

  /// 상세 정보 (JSON 형태로 저장)
  /// 예: 수면 - {"duration": 7, "quality": 8}
  /// 예: 운동 - {"type": "걷기", "duration": 30, "intensity": 5}
  /// 예: 스트레스 - {"level": 7}
  Map<String, dynamic> get details;
  @override

  /// 생성 시간
  DateTime get createdAt;
  @override

  /// 메모
  String? get notes;
  @override

  /// 수정 시간
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$LifestyleRecordImplCopyWith<_$LifestyleRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
