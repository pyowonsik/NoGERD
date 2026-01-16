// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIInsight _$AIInsightFromJson(Map<String, dynamic> json) {
  return _AIInsight.fromJson(json);
}

/// @nodoc
mixin _$AIInsight {
  /// 전반적인 건강 상태 요약
  String get summary => throw _privateConstructorUsedError;

  /// 식단 관련 조언
  String get dietAdvice => throw _privateConstructorUsedError;

  /// 생활습관 개선 조언
  String get lifestyleAdvice => throw _privateConstructorUsedError;

  /// 트리거 경고 메시지
  String get triggerWarning => throw _privateConstructorUsedError;

  /// 생성 시간
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AIInsightCopyWith<AIInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIInsightCopyWith<$Res> {
  factory $AIInsightCopyWith(AIInsight value, $Res Function(AIInsight) then) =
      _$AIInsightCopyWithImpl<$Res, AIInsight>;
  @useResult
  $Res call(
      {String summary,
      String dietAdvice,
      String lifestyleAdvice,
      String triggerWarning,
      DateTime generatedAt});
}

/// @nodoc
class _$AIInsightCopyWithImpl<$Res, $Val extends AIInsight>
    implements $AIInsightCopyWith<$Res> {
  _$AIInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? dietAdvice = null,
    Object? lifestyleAdvice = null,
    Object? triggerWarning = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      dietAdvice: null == dietAdvice
          ? _value.dietAdvice
          : dietAdvice // ignore: cast_nullable_to_non_nullable
              as String,
      lifestyleAdvice: null == lifestyleAdvice
          ? _value.lifestyleAdvice
          : lifestyleAdvice // ignore: cast_nullable_to_non_nullable
              as String,
      triggerWarning: null == triggerWarning
          ? _value.triggerWarning
          : triggerWarning // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIInsightImplCopyWith<$Res>
    implements $AIInsightCopyWith<$Res> {
  factory _$$AIInsightImplCopyWith(
          _$AIInsightImpl value, $Res Function(_$AIInsightImpl) then) =
      __$$AIInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary,
      String dietAdvice,
      String lifestyleAdvice,
      String triggerWarning,
      DateTime generatedAt});
}

/// @nodoc
class __$$AIInsightImplCopyWithImpl<$Res>
    extends _$AIInsightCopyWithImpl<$Res, _$AIInsightImpl>
    implements _$$AIInsightImplCopyWith<$Res> {
  __$$AIInsightImplCopyWithImpl(
      _$AIInsightImpl _value, $Res Function(_$AIInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? dietAdvice = null,
    Object? lifestyleAdvice = null,
    Object? triggerWarning = null,
    Object? generatedAt = null,
  }) {
    return _then(_$AIInsightImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      dietAdvice: null == dietAdvice
          ? _value.dietAdvice
          : dietAdvice // ignore: cast_nullable_to_non_nullable
              as String,
      lifestyleAdvice: null == lifestyleAdvice
          ? _value.lifestyleAdvice
          : lifestyleAdvice // ignore: cast_nullable_to_non_nullable
              as String,
      triggerWarning: null == triggerWarning
          ? _value.triggerWarning
          : triggerWarning // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIInsightImpl implements _AIInsight {
  const _$AIInsightImpl(
      {required this.summary,
      required this.dietAdvice,
      required this.lifestyleAdvice,
      required this.triggerWarning,
      required this.generatedAt});

  factory _$AIInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIInsightImplFromJson(json);

  /// 전반적인 건강 상태 요약
  @override
  final String summary;

  /// 식단 관련 조언
  @override
  final String dietAdvice;

  /// 생활습관 개선 조언
  @override
  final String lifestyleAdvice;

  /// 트리거 경고 메시지
  @override
  final String triggerWarning;

  /// 생성 시간
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'AIInsight(summary: $summary, dietAdvice: $dietAdvice, lifestyleAdvice: $lifestyleAdvice, triggerWarning: $triggerWarning, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIInsightImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.dietAdvice, dietAdvice) ||
                other.dietAdvice == dietAdvice) &&
            (identical(other.lifestyleAdvice, lifestyleAdvice) ||
                other.lifestyleAdvice == lifestyleAdvice) &&
            (identical(other.triggerWarning, triggerWarning) ||
                other.triggerWarning == triggerWarning) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, summary, dietAdvice,
      lifestyleAdvice, triggerWarning, generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AIInsightImplCopyWith<_$AIInsightImpl> get copyWith =>
      __$$AIInsightImplCopyWithImpl<_$AIInsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIInsightImplToJson(
      this,
    );
  }
}

abstract class _AIInsight implements AIInsight {
  const factory _AIInsight(
      {required final String summary,
      required final String dietAdvice,
      required final String lifestyleAdvice,
      required final String triggerWarning,
      required final DateTime generatedAt}) = _$AIInsightImpl;

  factory _AIInsight.fromJson(Map<String, dynamic> json) =
      _$AIInsightImpl.fromJson;

  @override

  /// 전반적인 건강 상태 요약
  String get summary;
  @override

  /// 식단 관련 조언
  String get dietAdvice;
  @override

  /// 생활습관 개선 조언
  String get lifestyleAdvice;
  @override

  /// 트리거 경고 메시지
  String get triggerWarning;
  @override

  /// 생성 시간
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AIInsightImplCopyWith<_$AIInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
