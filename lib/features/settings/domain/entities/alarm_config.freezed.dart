// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlarmConfig _$AlarmConfigFromJson(Map<String, dynamic> json) {
  return _AlarmConfig.fromJson(json);
}

/// @nodoc
mixin _$AlarmConfig {
  /// 알림 타입
  AlarmType get type => throw _privateConstructorUsedError;

  /// 활성화 여부
  bool get enabled => throw _privateConstructorUsedError;

  /// 시간 (0-23)
  int get hour => throw _privateConstructorUsedError;

  /// 분 (0-59)
  int get minute => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlarmConfigCopyWith<AlarmConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmConfigCopyWith<$Res> {
  factory $AlarmConfigCopyWith(
          AlarmConfig value, $Res Function(AlarmConfig) then) =
      _$AlarmConfigCopyWithImpl<$Res, AlarmConfig>;
  @useResult
  $Res call({AlarmType type, bool enabled, int hour, int minute});
}

/// @nodoc
class _$AlarmConfigCopyWithImpl<$Res, $Val extends AlarmConfig>
    implements $AlarmConfigCopyWith<$Res> {
  _$AlarmConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? enabled = null,
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlarmType,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlarmConfigImplCopyWith<$Res>
    implements $AlarmConfigCopyWith<$Res> {
  factory _$$AlarmConfigImplCopyWith(
          _$AlarmConfigImpl value, $Res Function(_$AlarmConfigImpl) then) =
      __$$AlarmConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AlarmType type, bool enabled, int hour, int minute});
}

/// @nodoc
class __$$AlarmConfigImplCopyWithImpl<$Res>
    extends _$AlarmConfigCopyWithImpl<$Res, _$AlarmConfigImpl>
    implements _$$AlarmConfigImplCopyWith<$Res> {
  __$$AlarmConfigImplCopyWithImpl(
      _$AlarmConfigImpl _value, $Res Function(_$AlarmConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? enabled = null,
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$AlarmConfigImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlarmType,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlarmConfigImpl implements _AlarmConfig {
  const _$AlarmConfigImpl(
      {required this.type,
      required this.enabled,
      required this.hour,
      required this.minute});

  factory _$AlarmConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlarmConfigImplFromJson(json);

  /// 알림 타입
  @override
  final AlarmType type;

  /// 활성화 여부
  @override
  final bool enabled;

  /// 시간 (0-23)
  @override
  final int hour;

  /// 분 (0-59)
  @override
  final int minute;

  @override
  String toString() {
    return 'AlarmConfig(type: $type, enabled: $enabled, hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, enabled, hour, minute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmConfigImplCopyWith<_$AlarmConfigImpl> get copyWith =>
      __$$AlarmConfigImplCopyWithImpl<_$AlarmConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlarmConfigImplToJson(
      this,
    );
  }
}

abstract class _AlarmConfig implements AlarmConfig {
  const factory _AlarmConfig(
      {required final AlarmType type,
      required final bool enabled,
      required final int hour,
      required final int minute}) = _$AlarmConfigImpl;

  factory _AlarmConfig.fromJson(Map<String, dynamic> json) =
      _$AlarmConfigImpl.fromJson;

  @override

  /// 알림 타입
  AlarmType get type;
  @override

  /// 활성화 여부
  bool get enabled;
  @override

  /// 시간 (0-23)
  int get hour;
  @override

  /// 분 (0-59)
  int get minute;
  @override
  @JsonKey(ignore: true)
  _$$AlarmConfigImplCopyWith<_$AlarmConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
