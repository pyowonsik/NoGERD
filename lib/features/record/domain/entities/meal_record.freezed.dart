// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MealRecord {
  /// 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 기록 시간
  DateTime get recordedAt => throw _privateConstructorUsedError;

  /// 식사 유형
  MealType get mealType => throw _privateConstructorUsedError;

  /// 음식 목록
  List<String> get foods => throw _privateConstructorUsedError;

  /// 포만감 (1-10)
  int get fullnessLevel => throw _privateConstructorUsedError;

  /// 생성 시간
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 트리거 음식 카테고리
  List<TriggerFoodCategory>? get triggerCategories =>
      throw _privateConstructorUsedError;

  /// 메모
  String? get notes => throw _privateConstructorUsedError;

  /// 수정 시간
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MealRecordCopyWith<MealRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealRecordCopyWith<$Res> {
  factory $MealRecordCopyWith(
          MealRecord value, $Res Function(MealRecord) then) =
      _$MealRecordCopyWithImpl<$Res, MealRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      MealType mealType,
      List<String> foods,
      int fullnessLevel,
      DateTime createdAt,
      List<TriggerFoodCategory>? triggerCategories,
      String? notes,
      DateTime? updatedAt});
}

/// @nodoc
class _$MealRecordCopyWithImpl<$Res, $Val extends MealRecord>
    implements $MealRecordCopyWith<$Res> {
  _$MealRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? mealType = null,
    Object? foods = null,
    Object? fullnessLevel = null,
    Object? createdAt = null,
    Object? triggerCategories = freezed,
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
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fullnessLevel: null == fullnessLevel
          ? _value.fullnessLevel
          : fullnessLevel // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      triggerCategories: freezed == triggerCategories
          ? _value.triggerCategories
          : triggerCategories // ignore: cast_nullable_to_non_nullable
              as List<TriggerFoodCategory>?,
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
abstract class _$$MealRecordImplCopyWith<$Res>
    implements $MealRecordCopyWith<$Res> {
  factory _$$MealRecordImplCopyWith(
          _$MealRecordImpl value, $Res Function(_$MealRecordImpl) then) =
      __$$MealRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      MealType mealType,
      List<String> foods,
      int fullnessLevel,
      DateTime createdAt,
      List<TriggerFoodCategory>? triggerCategories,
      String? notes,
      DateTime? updatedAt});
}

/// @nodoc
class __$$MealRecordImplCopyWithImpl<$Res>
    extends _$MealRecordCopyWithImpl<$Res, _$MealRecordImpl>
    implements _$$MealRecordImplCopyWith<$Res> {
  __$$MealRecordImplCopyWithImpl(
      _$MealRecordImpl _value, $Res Function(_$MealRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? mealType = null,
    Object? foods = null,
    Object? fullnessLevel = null,
    Object? createdAt = null,
    Object? triggerCategories = freezed,
    Object? notes = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MealRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fullnessLevel: null == fullnessLevel
          ? _value.fullnessLevel
          : fullnessLevel // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      triggerCategories: freezed == triggerCategories
          ? _value._triggerCategories
          : triggerCategories // ignore: cast_nullable_to_non_nullable
              as List<TriggerFoodCategory>?,
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

class _$MealRecordImpl implements _MealRecord {
  const _$MealRecordImpl(
      {required this.id,
      required this.recordedAt,
      required this.mealType,
      required final List<String> foods,
      required this.fullnessLevel,
      required this.createdAt,
      final List<TriggerFoodCategory>? triggerCategories,
      this.notes,
      this.updatedAt})
      : _foods = foods,
        _triggerCategories = triggerCategories;

  /// 고유 ID
  @override
  final String id;

  /// 기록 시간
  @override
  final DateTime recordedAt;

  /// 식사 유형
  @override
  final MealType mealType;

  /// 음식 목록
  final List<String> _foods;

  /// 음식 목록
  @override
  List<String> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  /// 포만감 (1-10)
  @override
  final int fullnessLevel;

  /// 생성 시간
  @override
  final DateTime createdAt;

  /// 트리거 음식 카테고리
  final List<TriggerFoodCategory>? _triggerCategories;

  /// 트리거 음식 카테고리
  @override
  List<TriggerFoodCategory>? get triggerCategories {
    final value = _triggerCategories;
    if (value == null) return null;
    if (_triggerCategories is EqualUnmodifiableListView)
      return _triggerCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 메모
  @override
  final String? notes;

  /// 수정 시간
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MealRecord(id: $id, recordedAt: $recordedAt, mealType: $mealType, foods: $foods, fullnessLevel: $fullnessLevel, createdAt: $createdAt, triggerCategories: $triggerCategories, notes: $notes, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.fullnessLevel, fullnessLevel) ||
                other.fullnessLevel == fullnessLevel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._triggerCategories, _triggerCategories) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recordedAt,
      mealType,
      const DeepCollectionEquality().hash(_foods),
      fullnessLevel,
      createdAt,
      const DeepCollectionEquality().hash(_triggerCategories),
      notes,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealRecordImplCopyWith<_$MealRecordImpl> get copyWith =>
      __$$MealRecordImplCopyWithImpl<_$MealRecordImpl>(this, _$identity);
}

abstract class _MealRecord implements MealRecord {
  const factory _MealRecord(
      {required final String id,
      required final DateTime recordedAt,
      required final MealType mealType,
      required final List<String> foods,
      required final int fullnessLevel,
      required final DateTime createdAt,
      final List<TriggerFoodCategory>? triggerCategories,
      final String? notes,
      final DateTime? updatedAt}) = _$MealRecordImpl;

  @override

  /// 고유 ID
  String get id;
  @override

  /// 기록 시간
  DateTime get recordedAt;
  @override

  /// 식사 유형
  MealType get mealType;
  @override

  /// 음식 목록
  List<String> get foods;
  @override

  /// 포만감 (1-10)
  int get fullnessLevel;
  @override

  /// 생성 시간
  DateTime get createdAt;
  @override

  /// 트리거 음식 카테고리
  List<TriggerFoodCategory>? get triggerCategories;
  @override

  /// 메모
  String? get notes;
  @override

  /// 수정 시간
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MealRecordImplCopyWith<_$MealRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
