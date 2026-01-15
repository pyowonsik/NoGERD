// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealRecordModel _$MealRecordModelFromJson(Map<String, dynamic> json) {
  return _MealRecordModel.fromJson(json);
}

/// @nodoc
mixin _$MealRecordModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_datetime')
  DateTime get recordedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_type')
  String get mealType => throw _privateConstructorUsedError;
  List<String> get foods => throw _privateConstructorUsedError;
  @JsonKey(name: 'trigger_categories')
  List<String>? get triggerCategories => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullness_level')
  int get fullnessLevel => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MealRecordModelCopyWith<MealRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealRecordModelCopyWith<$Res> {
  factory $MealRecordModelCopyWith(
          MealRecordModel value, $Res Function(MealRecordModel) then) =
      _$MealRecordModelCopyWithImpl<$Res, MealRecordModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'record_datetime') DateTime recordedAt,
      @JsonKey(name: 'meal_type') String mealType,
      List<String> foods,
      @JsonKey(name: 'trigger_categories') List<String>? triggerCategories,
      @JsonKey(name: 'fullness_level') int fullnessLevel,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$MealRecordModelCopyWithImpl<$Res, $Val extends MealRecordModel>
    implements $MealRecordModelCopyWith<$Res> {
  _$MealRecordModelCopyWithImpl(this._value, this._then);

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
    Object? mealType = null,
    Object? foods = null,
    Object? triggerCategories = freezed,
    Object? fullnessLevel = null,
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
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      triggerCategories: freezed == triggerCategories
          ? _value.triggerCategories
          : triggerCategories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      fullnessLevel: null == fullnessLevel
          ? _value.fullnessLevel
          : fullnessLevel // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MealRecordModelImplCopyWith<$Res>
    implements $MealRecordModelCopyWith<$Res> {
  factory _$$MealRecordModelImplCopyWith(_$MealRecordModelImpl value,
          $Res Function(_$MealRecordModelImpl) then) =
      __$$MealRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'record_datetime') DateTime recordedAt,
      @JsonKey(name: 'meal_type') String mealType,
      List<String> foods,
      @JsonKey(name: 'trigger_categories') List<String>? triggerCategories,
      @JsonKey(name: 'fullness_level') int fullnessLevel,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$MealRecordModelImplCopyWithImpl<$Res>
    extends _$MealRecordModelCopyWithImpl<$Res, _$MealRecordModelImpl>
    implements _$$MealRecordModelImplCopyWith<$Res> {
  __$$MealRecordModelImplCopyWithImpl(
      _$MealRecordModelImpl _value, $Res Function(_$MealRecordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? recordedAt = null,
    Object? mealType = null,
    Object? foods = null,
    Object? triggerCategories = freezed,
    Object? fullnessLevel = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MealRecordModelImpl(
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
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      triggerCategories: freezed == triggerCategories
          ? _value._triggerCategories
          : triggerCategories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      fullnessLevel: null == fullnessLevel
          ? _value.fullnessLevel
          : fullnessLevel // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$MealRecordModelImpl extends _MealRecordModel {
  const _$MealRecordModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'record_datetime') required this.recordedAt,
      @JsonKey(name: 'meal_type') required this.mealType,
      required final List<String> foods,
      @JsonKey(name: 'trigger_categories')
      final List<String>? triggerCategories,
      @JsonKey(name: 'fullness_level') required this.fullnessLevel,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _foods = foods,
        _triggerCategories = triggerCategories,
        super._();

  factory _$MealRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealRecordModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'record_datetime')
  final DateTime recordedAt;
  @override
  @JsonKey(name: 'meal_type')
  final String mealType;
  final List<String> _foods;
  @override
  List<String> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  final List<String>? _triggerCategories;
  @override
  @JsonKey(name: 'trigger_categories')
  List<String>? get triggerCategories {
    final value = _triggerCategories;
    if (value == null) return null;
    if (_triggerCategories is EqualUnmodifiableListView)
      return _triggerCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'fullness_level')
  final int fullnessLevel;
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
    return 'MealRecordModel(id: $id, userId: $userId, recordedAt: $recordedAt, mealType: $mealType, foods: $foods, triggerCategories: $triggerCategories, fullnessLevel: $fullnessLevel, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            const DeepCollectionEquality()
                .equals(other._triggerCategories, _triggerCategories) &&
            (identical(other.fullnessLevel, fullnessLevel) ||
                other.fullnessLevel == fullnessLevel) &&
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
      mealType,
      const DeepCollectionEquality().hash(_foods),
      const DeepCollectionEquality().hash(_triggerCategories),
      fullnessLevel,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealRecordModelImplCopyWith<_$MealRecordModelImpl> get copyWith =>
      __$$MealRecordModelImplCopyWithImpl<_$MealRecordModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealRecordModelImplToJson(
      this,
    );
  }
}

abstract class _MealRecordModel extends MealRecordModel {
  const factory _MealRecordModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'record_datetime') required final DateTime recordedAt,
          @JsonKey(name: 'meal_type') required final String mealType,
          required final List<String> foods,
          @JsonKey(name: 'trigger_categories')
          final List<String>? triggerCategories,
          @JsonKey(name: 'fullness_level') required final int fullnessLevel,
          final String? notes,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$MealRecordModelImpl;
  const _MealRecordModel._() : super._();

  factory _MealRecordModel.fromJson(Map<String, dynamic> json) =
      _$MealRecordModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'record_datetime')
  DateTime get recordedAt;
  @override
  @JsonKey(name: 'meal_type')
  String get mealType;
  @override
  List<String> get foods;
  @override
  @JsonKey(name: 'trigger_categories')
  List<String>? get triggerCategories;
  @override
  @JsonKey(name: 'fullness_level')
  int get fullnessLevel;
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
  _$$MealRecordModelImplCopyWith<_$MealRecordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
