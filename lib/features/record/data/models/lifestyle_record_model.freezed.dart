// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifestyle_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LifestyleRecordModel _$LifestyleRecordModelFromJson(Map<String, dynamic> json) {
  return _LifestyleRecordModel.fromJson(json);
}

/// @nodoc
mixin _$LifestyleRecordModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_datetime')
  DateTime get recordedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'lifestyle_type')
  String get lifestyleType => throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LifestyleRecordModelCopyWith<LifestyleRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifestyleRecordModelCopyWith<$Res> {
  factory $LifestyleRecordModelCopyWith(LifestyleRecordModel value,
          $Res Function(LifestyleRecordModel) then) =
      _$LifestyleRecordModelCopyWithImpl<$Res, LifestyleRecordModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'record_datetime') DateTime recordedAt,
      @JsonKey(name: 'lifestyle_type') String lifestyleType,
      Map<String, dynamic> details,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? notes,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$LifestyleRecordModelCopyWithImpl<$Res,
        $Val extends LifestyleRecordModel>
    implements $LifestyleRecordModelCopyWith<$Res> {
  _$LifestyleRecordModelCopyWithImpl(this._value, this._then);

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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lifestyleType: null == lifestyleType
          ? _value.lifestyleType
          : lifestyleType // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$LifestyleRecordModelImplCopyWith<$Res>
    implements $LifestyleRecordModelCopyWith<$Res> {
  factory _$$LifestyleRecordModelImplCopyWith(_$LifestyleRecordModelImpl value,
          $Res Function(_$LifestyleRecordModelImpl) then) =
      __$$LifestyleRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'record_datetime') DateTime recordedAt,
      @JsonKey(name: 'lifestyle_type') String lifestyleType,
      Map<String, dynamic> details,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? notes,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$LifestyleRecordModelImplCopyWithImpl<$Res>
    extends _$LifestyleRecordModelCopyWithImpl<$Res, _$LifestyleRecordModelImpl>
    implements _$$LifestyleRecordModelImplCopyWith<$Res> {
  __$$LifestyleRecordModelImplCopyWithImpl(_$LifestyleRecordModelImpl _value,
      $Res Function(_$LifestyleRecordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? recordedAt = null,
    Object? lifestyleType = null,
    Object? details = null,
    Object? createdAt = null,
    Object? notes = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$LifestyleRecordModelImpl(
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
      lifestyleType: null == lifestyleType
          ? _value.lifestyleType
          : lifestyleType // ignore: cast_nullable_to_non_nullable
              as String,
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
@JsonSerializable()
class _$LifestyleRecordModelImpl extends _LifestyleRecordModel {
  const _$LifestyleRecordModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'record_datetime') required this.recordedAt,
      @JsonKey(name: 'lifestyle_type') required this.lifestyleType,
      required final Map<String, dynamic> details,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.notes,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _details = details,
        super._();

  factory _$LifestyleRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LifestyleRecordModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'record_datetime')
  final DateTime recordedAt;
  @override
  @JsonKey(name: 'lifestyle_type')
  final String lifestyleType;
  final Map<String, dynamic> _details;
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LifestyleRecordModel(id: $id, userId: $userId, recordedAt: $recordedAt, lifestyleType: $lifestyleType, details: $details, createdAt: $createdAt, notes: $notes, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifestyleRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      recordedAt,
      lifestyleType,
      const DeepCollectionEquality().hash(_details),
      createdAt,
      notes,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LifestyleRecordModelImplCopyWith<_$LifestyleRecordModelImpl>
      get copyWith =>
          __$$LifestyleRecordModelImplCopyWithImpl<_$LifestyleRecordModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LifestyleRecordModelImplToJson(
      this,
    );
  }
}

abstract class _LifestyleRecordModel extends LifestyleRecordModel {
  const factory _LifestyleRecordModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'record_datetime') required final DateTime recordedAt,
          @JsonKey(name: 'lifestyle_type') required final String lifestyleType,
          required final Map<String, dynamic> details,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          final String? notes,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$LifestyleRecordModelImpl;
  const _LifestyleRecordModel._() : super._();

  factory _LifestyleRecordModel.fromJson(Map<String, dynamic> json) =
      _$LifestyleRecordModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'record_datetime')
  DateTime get recordedAt;
  @override
  @JsonKey(name: 'lifestyle_type')
  String get lifestyleType;
  @override
  Map<String, dynamic> get details;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$LifestyleRecordModelImplCopyWith<_$LifestyleRecordModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
