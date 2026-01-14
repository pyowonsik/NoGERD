// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecordSummary {
  /// 라벨 (증상, 식사, 약물, 수면 등)
  String get label => throw _privateConstructorUsedError;

  /// 값 (2회, 3회, 7시간 등)
  String get value => throw _privateConstructorUsedError;

  /// 부가 설명 (가벼움, 정상, 양호 등)
  String get subValue => throw _privateConstructorUsedError;

  /// 아이콘 코드
  int get iconCode => throw _privateConstructorUsedError;

  /// 색상 값 (ARGB)
  int get colorValue => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordSummaryCopyWith<RecordSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordSummaryCopyWith<$Res> {
  factory $RecordSummaryCopyWith(
          RecordSummary value, $Res Function(RecordSummary) then) =
      _$RecordSummaryCopyWithImpl<$Res, RecordSummary>;
  @useResult
  $Res call(
      {String label,
      String value,
      String subValue,
      int iconCode,
      int colorValue});
}

/// @nodoc
class _$RecordSummaryCopyWithImpl<$Res, $Val extends RecordSummary>
    implements $RecordSummaryCopyWith<$Res> {
  _$RecordSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? subValue = null,
    Object? iconCode = null,
    Object? colorValue = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      subValue: null == subValue
          ? _value.subValue
          : subValue // ignore: cast_nullable_to_non_nullable
              as String,
      iconCode: null == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as int,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecordSummaryImplCopyWith<$Res>
    implements $RecordSummaryCopyWith<$Res> {
  factory _$$RecordSummaryImplCopyWith(
          _$RecordSummaryImpl value, $Res Function(_$RecordSummaryImpl) then) =
      __$$RecordSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String label,
      String value,
      String subValue,
      int iconCode,
      int colorValue});
}

/// @nodoc
class __$$RecordSummaryImplCopyWithImpl<$Res>
    extends _$RecordSummaryCopyWithImpl<$Res, _$RecordSummaryImpl>
    implements _$$RecordSummaryImplCopyWith<$Res> {
  __$$RecordSummaryImplCopyWithImpl(
      _$RecordSummaryImpl _value, $Res Function(_$RecordSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? subValue = null,
    Object? iconCode = null,
    Object? colorValue = null,
  }) {
    return _then(_$RecordSummaryImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      subValue: null == subValue
          ? _value.subValue
          : subValue // ignore: cast_nullable_to_non_nullable
              as String,
      iconCode: null == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as int,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$RecordSummaryImpl implements _RecordSummary {
  const _$RecordSummaryImpl(
      {required this.label,
      required this.value,
      required this.subValue,
      required this.iconCode,
      required this.colorValue});

  /// 라벨 (증상, 식사, 약물, 수면 등)
  @override
  final String label;

  /// 값 (2회, 3회, 7시간 등)
  @override
  final String value;

  /// 부가 설명 (가벼움, 정상, 양호 등)
  @override
  final String subValue;

  /// 아이콘 코드
  @override
  final int iconCode;

  /// 색상 값 (ARGB)
  @override
  final int colorValue;

  @override
  String toString() {
    return 'RecordSummary(label: $label, value: $value, subValue: $subValue, iconCode: $iconCode, colorValue: $colorValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordSummaryImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.subValue, subValue) ||
                other.subValue == subValue) &&
            (identical(other.iconCode, iconCode) ||
                other.iconCode == iconCode) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, label, value, subValue, iconCode, colorValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordSummaryImplCopyWith<_$RecordSummaryImpl> get copyWith =>
      __$$RecordSummaryImplCopyWithImpl<_$RecordSummaryImpl>(this, _$identity);
}

abstract class _RecordSummary implements RecordSummary {
  const factory _RecordSummary(
      {required final String label,
      required final String value,
      required final String subValue,
      required final int iconCode,
      required final int colorValue}) = _$RecordSummaryImpl;

  @override

  /// 라벨 (증상, 식사, 약물, 수면 등)
  String get label;
  @override

  /// 값 (2회, 3회, 7시간 등)
  String get value;
  @override

  /// 부가 설명 (가벼움, 정상, 양호 등)
  String get subValue;
  @override

  /// 아이콘 코드
  int get iconCode;
  @override

  /// 색상 값 (ARGB)
  int get colorValue;
  @override
  @JsonKey(ignore: true)
  _$$RecordSummaryImplCopyWith<_$RecordSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
