// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecentRecord {
  /// 제목
  String get title => throw _privateConstructorUsedError;

  /// 부제목
  String get subtitle => throw _privateConstructorUsedError;

  /// 시간
  String get time => throw _privateConstructorUsedError;

  /// 이모지
  String get emoji => throw _privateConstructorUsedError;

  /// 색상 값 (ARGB)
  int get colorValue => throw _privateConstructorUsedError;

  /// 원본 엔티티 (상세보기에 사용)
  dynamic get originalEntity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecentRecordCopyWith<RecentRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentRecordCopyWith<$Res> {
  factory $RecentRecordCopyWith(
          RecentRecord value, $Res Function(RecentRecord) then) =
      _$RecentRecordCopyWithImpl<$Res, RecentRecord>;
  @useResult
  $Res call(
      {String title,
      String subtitle,
      String time,
      String emoji,
      int colorValue,
      dynamic originalEntity});
}

/// @nodoc
class _$RecentRecordCopyWithImpl<$Res, $Val extends RecentRecord>
    implements $RecentRecordCopyWith<$Res> {
  _$RecentRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subtitle = null,
    Object? time = null,
    Object? emoji = null,
    Object? colorValue = null,
    Object? originalEntity = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      originalEntity: freezed == originalEntity
          ? _value.originalEntity
          : originalEntity // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentRecordImplCopyWith<$Res>
    implements $RecentRecordCopyWith<$Res> {
  factory _$$RecentRecordImplCopyWith(
          _$RecentRecordImpl value, $Res Function(_$RecentRecordImpl) then) =
      __$$RecentRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String subtitle,
      String time,
      String emoji,
      int colorValue,
      dynamic originalEntity});
}

/// @nodoc
class __$$RecentRecordImplCopyWithImpl<$Res>
    extends _$RecentRecordCopyWithImpl<$Res, _$RecentRecordImpl>
    implements _$$RecentRecordImplCopyWith<$Res> {
  __$$RecentRecordImplCopyWithImpl(
      _$RecentRecordImpl _value, $Res Function(_$RecentRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subtitle = null,
    Object? time = null,
    Object? emoji = null,
    Object? colorValue = null,
    Object? originalEntity = freezed,
  }) {
    return _then(_$RecentRecordImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      originalEntity: freezed == originalEntity
          ? _value.originalEntity
          : originalEntity // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$RecentRecordImpl implements _RecentRecord {
  const _$RecentRecordImpl(
      {required this.title,
      required this.subtitle,
      required this.time,
      required this.emoji,
      required this.colorValue,
      this.originalEntity});

  /// 제목
  @override
  final String title;

  /// 부제목
  @override
  final String subtitle;

  /// 시간
  @override
  final String time;

  /// 이모지
  @override
  final String emoji;

  /// 색상 값 (ARGB)
  @override
  final int colorValue;

  /// 원본 엔티티 (상세보기에 사용)
  @override
  final dynamic originalEntity;

  @override
  String toString() {
    return 'RecentRecord(title: $title, subtitle: $subtitle, time: $time, emoji: $emoji, colorValue: $colorValue, originalEntity: $originalEntity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentRecordImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            const DeepCollectionEquality()
                .equals(other.originalEntity, originalEntity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, subtitle, time, emoji,
      colorValue, const DeepCollectionEquality().hash(originalEntity));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentRecordImplCopyWith<_$RecentRecordImpl> get copyWith =>
      __$$RecentRecordImplCopyWithImpl<_$RecentRecordImpl>(this, _$identity);
}

abstract class _RecentRecord implements RecentRecord {
  const factory _RecentRecord(
      {required final String title,
      required final String subtitle,
      required final String time,
      required final String emoji,
      required final int colorValue,
      final dynamic originalEntity}) = _$RecentRecordImpl;

  @override

  /// 제목
  String get title;
  @override

  /// 부제목
  String get subtitle;
  @override

  /// 시간
  String get time;
  @override

  /// 이모지
  String get emoji;
  @override

  /// 색상 값 (ARGB)
  int get colorValue;
  @override

  /// 원본 엔티티 (상세보기에 사용)
  dynamic get originalEntity;
  @override
  @JsonKey(ignore: true)
  _$$RecentRecordImplCopyWith<_$RecentRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
