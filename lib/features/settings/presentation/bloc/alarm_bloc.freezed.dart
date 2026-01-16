// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlarmEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadConfigs,
    required TResult Function(AlarmType type, bool enabled) toggleAlarm,
    required TResult Function(AlarmType type, int hour, int minute) updateTime,
    required TResult Function() requestPermission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadConfigs,
    TResult? Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult? Function(AlarmType type, int hour, int minute)? updateTime,
    TResult? Function()? requestPermission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadConfigs,
    TResult Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult Function(AlarmType type, int hour, int minute)? updateTime,
    TResult Function()? requestPermission,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AlarmEventLoadConfigs value) loadConfigs,
    required TResult Function(AlarmEventToggleAlarm value) toggleAlarm,
    required TResult Function(AlarmEventUpdateTime value) updateTime,
    required TResult Function(AlarmEventRequestPermission value)
        requestPermission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult? Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult? Function(AlarmEventUpdateTime value)? updateTime,
    TResult? Function(AlarmEventRequestPermission value)? requestPermission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult Function(AlarmEventUpdateTime value)? updateTime,
    TResult Function(AlarmEventRequestPermission value)? requestPermission,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmEventCopyWith<$Res> {
  factory $AlarmEventCopyWith(
          AlarmEvent value, $Res Function(AlarmEvent) then) =
      _$AlarmEventCopyWithImpl<$Res, AlarmEvent>;
}

/// @nodoc
class _$AlarmEventCopyWithImpl<$Res, $Val extends AlarmEvent>
    implements $AlarmEventCopyWith<$Res> {
  _$AlarmEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AlarmEventLoadConfigsImplCopyWith<$Res> {
  factory _$$AlarmEventLoadConfigsImplCopyWith(
          _$AlarmEventLoadConfigsImpl value,
          $Res Function(_$AlarmEventLoadConfigsImpl) then) =
      __$$AlarmEventLoadConfigsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AlarmEventLoadConfigsImplCopyWithImpl<$Res>
    extends _$AlarmEventCopyWithImpl<$Res, _$AlarmEventLoadConfigsImpl>
    implements _$$AlarmEventLoadConfigsImplCopyWith<$Res> {
  __$$AlarmEventLoadConfigsImplCopyWithImpl(_$AlarmEventLoadConfigsImpl _value,
      $Res Function(_$AlarmEventLoadConfigsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AlarmEventLoadConfigsImpl implements AlarmEventLoadConfigs {
  const _$AlarmEventLoadConfigsImpl();

  @override
  String toString() {
    return 'AlarmEvent.loadConfigs()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmEventLoadConfigsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadConfigs,
    required TResult Function(AlarmType type, bool enabled) toggleAlarm,
    required TResult Function(AlarmType type, int hour, int minute) updateTime,
    required TResult Function() requestPermission,
  }) {
    return loadConfigs();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadConfigs,
    TResult? Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult? Function(AlarmType type, int hour, int minute)? updateTime,
    TResult? Function()? requestPermission,
  }) {
    return loadConfigs?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadConfigs,
    TResult Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult Function(AlarmType type, int hour, int minute)? updateTime,
    TResult Function()? requestPermission,
    required TResult orElse(),
  }) {
    if (loadConfigs != null) {
      return loadConfigs();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AlarmEventLoadConfigs value) loadConfigs,
    required TResult Function(AlarmEventToggleAlarm value) toggleAlarm,
    required TResult Function(AlarmEventUpdateTime value) updateTime,
    required TResult Function(AlarmEventRequestPermission value)
        requestPermission,
  }) {
    return loadConfigs(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult? Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult? Function(AlarmEventUpdateTime value)? updateTime,
    TResult? Function(AlarmEventRequestPermission value)? requestPermission,
  }) {
    return loadConfigs?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult Function(AlarmEventUpdateTime value)? updateTime,
    TResult Function(AlarmEventRequestPermission value)? requestPermission,
    required TResult orElse(),
  }) {
    if (loadConfigs != null) {
      return loadConfigs(this);
    }
    return orElse();
  }
}

abstract class AlarmEventLoadConfigs implements AlarmEvent {
  const factory AlarmEventLoadConfigs() = _$AlarmEventLoadConfigsImpl;
}

/// @nodoc
abstract class _$$AlarmEventToggleAlarmImplCopyWith<$Res> {
  factory _$$AlarmEventToggleAlarmImplCopyWith(
          _$AlarmEventToggleAlarmImpl value,
          $Res Function(_$AlarmEventToggleAlarmImpl) then) =
      __$$AlarmEventToggleAlarmImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AlarmType type, bool enabled});
}

/// @nodoc
class __$$AlarmEventToggleAlarmImplCopyWithImpl<$Res>
    extends _$AlarmEventCopyWithImpl<$Res, _$AlarmEventToggleAlarmImpl>
    implements _$$AlarmEventToggleAlarmImplCopyWith<$Res> {
  __$$AlarmEventToggleAlarmImplCopyWithImpl(_$AlarmEventToggleAlarmImpl _value,
      $Res Function(_$AlarmEventToggleAlarmImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? enabled = null,
  }) {
    return _then(_$AlarmEventToggleAlarmImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlarmType,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AlarmEventToggleAlarmImpl implements AlarmEventToggleAlarm {
  const _$AlarmEventToggleAlarmImpl(
      {required this.type, required this.enabled});

  @override
  final AlarmType type;
  @override
  final bool enabled;

  @override
  String toString() {
    return 'AlarmEvent.toggleAlarm(type: $type, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmEventToggleAlarmImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, enabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmEventToggleAlarmImplCopyWith<_$AlarmEventToggleAlarmImpl>
      get copyWith => __$$AlarmEventToggleAlarmImplCopyWithImpl<
          _$AlarmEventToggleAlarmImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadConfigs,
    required TResult Function(AlarmType type, bool enabled) toggleAlarm,
    required TResult Function(AlarmType type, int hour, int minute) updateTime,
    required TResult Function() requestPermission,
  }) {
    return toggleAlarm(type, enabled);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadConfigs,
    TResult? Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult? Function(AlarmType type, int hour, int minute)? updateTime,
    TResult? Function()? requestPermission,
  }) {
    return toggleAlarm?.call(type, enabled);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadConfigs,
    TResult Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult Function(AlarmType type, int hour, int minute)? updateTime,
    TResult Function()? requestPermission,
    required TResult orElse(),
  }) {
    if (toggleAlarm != null) {
      return toggleAlarm(type, enabled);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AlarmEventLoadConfigs value) loadConfigs,
    required TResult Function(AlarmEventToggleAlarm value) toggleAlarm,
    required TResult Function(AlarmEventUpdateTime value) updateTime,
    required TResult Function(AlarmEventRequestPermission value)
        requestPermission,
  }) {
    return toggleAlarm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult? Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult? Function(AlarmEventUpdateTime value)? updateTime,
    TResult? Function(AlarmEventRequestPermission value)? requestPermission,
  }) {
    return toggleAlarm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult Function(AlarmEventUpdateTime value)? updateTime,
    TResult Function(AlarmEventRequestPermission value)? requestPermission,
    required TResult orElse(),
  }) {
    if (toggleAlarm != null) {
      return toggleAlarm(this);
    }
    return orElse();
  }
}

abstract class AlarmEventToggleAlarm implements AlarmEvent {
  const factory AlarmEventToggleAlarm(
      {required final AlarmType type,
      required final bool enabled}) = _$AlarmEventToggleAlarmImpl;

  AlarmType get type;
  bool get enabled;
  @JsonKey(ignore: true)
  _$$AlarmEventToggleAlarmImplCopyWith<_$AlarmEventToggleAlarmImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AlarmEventUpdateTimeImplCopyWith<$Res> {
  factory _$$AlarmEventUpdateTimeImplCopyWith(_$AlarmEventUpdateTimeImpl value,
          $Res Function(_$AlarmEventUpdateTimeImpl) then) =
      __$$AlarmEventUpdateTimeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AlarmType type, int hour, int minute});
}

/// @nodoc
class __$$AlarmEventUpdateTimeImplCopyWithImpl<$Res>
    extends _$AlarmEventCopyWithImpl<$Res, _$AlarmEventUpdateTimeImpl>
    implements _$$AlarmEventUpdateTimeImplCopyWith<$Res> {
  __$$AlarmEventUpdateTimeImplCopyWithImpl(_$AlarmEventUpdateTimeImpl _value,
      $Res Function(_$AlarmEventUpdateTimeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$AlarmEventUpdateTimeImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlarmType,
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

class _$AlarmEventUpdateTimeImpl implements AlarmEventUpdateTime {
  const _$AlarmEventUpdateTimeImpl(
      {required this.type, required this.hour, required this.minute});

  @override
  final AlarmType type;
  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString() {
    return 'AlarmEvent.updateTime(type: $type, hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmEventUpdateTimeImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, hour, minute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmEventUpdateTimeImplCopyWith<_$AlarmEventUpdateTimeImpl>
      get copyWith =>
          __$$AlarmEventUpdateTimeImplCopyWithImpl<_$AlarmEventUpdateTimeImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadConfigs,
    required TResult Function(AlarmType type, bool enabled) toggleAlarm,
    required TResult Function(AlarmType type, int hour, int minute) updateTime,
    required TResult Function() requestPermission,
  }) {
    return updateTime(type, hour, minute);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadConfigs,
    TResult? Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult? Function(AlarmType type, int hour, int minute)? updateTime,
    TResult? Function()? requestPermission,
  }) {
    return updateTime?.call(type, hour, minute);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadConfigs,
    TResult Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult Function(AlarmType type, int hour, int minute)? updateTime,
    TResult Function()? requestPermission,
    required TResult orElse(),
  }) {
    if (updateTime != null) {
      return updateTime(type, hour, minute);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AlarmEventLoadConfigs value) loadConfigs,
    required TResult Function(AlarmEventToggleAlarm value) toggleAlarm,
    required TResult Function(AlarmEventUpdateTime value) updateTime,
    required TResult Function(AlarmEventRequestPermission value)
        requestPermission,
  }) {
    return updateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult? Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult? Function(AlarmEventUpdateTime value)? updateTime,
    TResult? Function(AlarmEventRequestPermission value)? requestPermission,
  }) {
    return updateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult Function(AlarmEventUpdateTime value)? updateTime,
    TResult Function(AlarmEventRequestPermission value)? requestPermission,
    required TResult orElse(),
  }) {
    if (updateTime != null) {
      return updateTime(this);
    }
    return orElse();
  }
}

abstract class AlarmEventUpdateTime implements AlarmEvent {
  const factory AlarmEventUpdateTime(
      {required final AlarmType type,
      required final int hour,
      required final int minute}) = _$AlarmEventUpdateTimeImpl;

  AlarmType get type;
  int get hour;
  int get minute;
  @JsonKey(ignore: true)
  _$$AlarmEventUpdateTimeImplCopyWith<_$AlarmEventUpdateTimeImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AlarmEventRequestPermissionImplCopyWith<$Res> {
  factory _$$AlarmEventRequestPermissionImplCopyWith(
          _$AlarmEventRequestPermissionImpl value,
          $Res Function(_$AlarmEventRequestPermissionImpl) then) =
      __$$AlarmEventRequestPermissionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AlarmEventRequestPermissionImplCopyWithImpl<$Res>
    extends _$AlarmEventCopyWithImpl<$Res, _$AlarmEventRequestPermissionImpl>
    implements _$$AlarmEventRequestPermissionImplCopyWith<$Res> {
  __$$AlarmEventRequestPermissionImplCopyWithImpl(
      _$AlarmEventRequestPermissionImpl _value,
      $Res Function(_$AlarmEventRequestPermissionImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AlarmEventRequestPermissionImpl implements AlarmEventRequestPermission {
  const _$AlarmEventRequestPermissionImpl();

  @override
  String toString() {
    return 'AlarmEvent.requestPermission()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmEventRequestPermissionImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadConfigs,
    required TResult Function(AlarmType type, bool enabled) toggleAlarm,
    required TResult Function(AlarmType type, int hour, int minute) updateTime,
    required TResult Function() requestPermission,
  }) {
    return requestPermission();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadConfigs,
    TResult? Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult? Function(AlarmType type, int hour, int minute)? updateTime,
    TResult? Function()? requestPermission,
  }) {
    return requestPermission?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadConfigs,
    TResult Function(AlarmType type, bool enabled)? toggleAlarm,
    TResult Function(AlarmType type, int hour, int minute)? updateTime,
    TResult Function()? requestPermission,
    required TResult orElse(),
  }) {
    if (requestPermission != null) {
      return requestPermission();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AlarmEventLoadConfigs value) loadConfigs,
    required TResult Function(AlarmEventToggleAlarm value) toggleAlarm,
    required TResult Function(AlarmEventUpdateTime value) updateTime,
    required TResult Function(AlarmEventRequestPermission value)
        requestPermission,
  }) {
    return requestPermission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult? Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult? Function(AlarmEventUpdateTime value)? updateTime,
    TResult? Function(AlarmEventRequestPermission value)? requestPermission,
  }) {
    return requestPermission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AlarmEventLoadConfigs value)? loadConfigs,
    TResult Function(AlarmEventToggleAlarm value)? toggleAlarm,
    TResult Function(AlarmEventUpdateTime value)? updateTime,
    TResult Function(AlarmEventRequestPermission value)? requestPermission,
    required TResult orElse(),
  }) {
    if (requestPermission != null) {
      return requestPermission(this);
    }
    return orElse();
  }
}

abstract class AlarmEventRequestPermission implements AlarmEvent {
  const factory AlarmEventRequestPermission() =
      _$AlarmEventRequestPermissionImpl;
}

/// @nodoc
mixin _$AlarmState {
  /// 알림 설정 맵 (AlarmType -> AlarmConfig)
  Map<AlarmType, AlarmConfig> get configs => throw _privateConstructorUsedError;

  /// 로딩 상태
  bool get isLoading => throw _privateConstructorUsedError;

  /// 알림 권한 여부
  bool get hasPermission => throw _privateConstructorUsedError;

  /// 에러 메시지
  Option<String> get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlarmStateCopyWith<AlarmState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmStateCopyWith<$Res> {
  factory $AlarmStateCopyWith(
          AlarmState value, $Res Function(AlarmState) then) =
      _$AlarmStateCopyWithImpl<$Res, AlarmState>;
  @useResult
  $Res call(
      {Map<AlarmType, AlarmConfig> configs,
      bool isLoading,
      bool hasPermission,
      Option<String> errorMessage});
}

/// @nodoc
class _$AlarmStateCopyWithImpl<$Res, $Val extends AlarmState>
    implements $AlarmStateCopyWith<$Res> {
  _$AlarmStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configs = null,
    Object? isLoading = null,
    Object? hasPermission = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      configs: null == configs
          ? _value.configs
          : configs // ignore: cast_nullable_to_non_nullable
              as Map<AlarmType, AlarmConfig>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPermission: null == hasPermission
          ? _value.hasPermission
          : hasPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlarmStateImplCopyWith<$Res>
    implements $AlarmStateCopyWith<$Res> {
  factory _$$AlarmStateImplCopyWith(
          _$AlarmStateImpl value, $Res Function(_$AlarmStateImpl) then) =
      __$$AlarmStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<AlarmType, AlarmConfig> configs,
      bool isLoading,
      bool hasPermission,
      Option<String> errorMessage});
}

/// @nodoc
class __$$AlarmStateImplCopyWithImpl<$Res>
    extends _$AlarmStateCopyWithImpl<$Res, _$AlarmStateImpl>
    implements _$$AlarmStateImplCopyWith<$Res> {
  __$$AlarmStateImplCopyWithImpl(
      _$AlarmStateImpl _value, $Res Function(_$AlarmStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configs = null,
    Object? isLoading = null,
    Object? hasPermission = null,
    Object? errorMessage = null,
  }) {
    return _then(_$AlarmStateImpl(
      configs: null == configs
          ? _value._configs
          : configs // ignore: cast_nullable_to_non_nullable
              as Map<AlarmType, AlarmConfig>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPermission: null == hasPermission
          ? _value.hasPermission
          : hasPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as Option<String>,
    ));
  }
}

/// @nodoc

class _$AlarmStateImpl implements _AlarmState {
  const _$AlarmStateImpl(
      {required final Map<AlarmType, AlarmConfig> configs,
      required this.isLoading,
      required this.hasPermission,
      required this.errorMessage})
      : _configs = configs;

  /// 알림 설정 맵 (AlarmType -> AlarmConfig)
  final Map<AlarmType, AlarmConfig> _configs;

  /// 알림 설정 맵 (AlarmType -> AlarmConfig)
  @override
  Map<AlarmType, AlarmConfig> get configs {
    if (_configs is EqualUnmodifiableMapView) return _configs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_configs);
  }

  /// 로딩 상태
  @override
  final bool isLoading;

  /// 알림 권한 여부
  @override
  final bool hasPermission;

  /// 에러 메시지
  @override
  final Option<String> errorMessage;

  @override
  String toString() {
    return 'AlarmState(configs: $configs, isLoading: $isLoading, hasPermission: $hasPermission, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmStateImpl &&
            const DeepCollectionEquality().equals(other._configs, _configs) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasPermission, hasPermission) ||
                other.hasPermission == hasPermission) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_configs),
      isLoading,
      hasPermission,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmStateImplCopyWith<_$AlarmStateImpl> get copyWith =>
      __$$AlarmStateImplCopyWithImpl<_$AlarmStateImpl>(this, _$identity);
}

abstract class _AlarmState implements AlarmState {
  const factory _AlarmState(
      {required final Map<AlarmType, AlarmConfig> configs,
      required final bool isLoading,
      required final bool hasPermission,
      required final Option<String> errorMessage}) = _$AlarmStateImpl;

  @override

  /// 알림 설정 맵 (AlarmType -> AlarmConfig)
  Map<AlarmType, AlarmConfig> get configs;
  @override

  /// 로딩 상태
  bool get isLoading;
  @override

  /// 알림 권한 여부
  bool get hasPermission;
  @override

  /// 에러 메시지
  Option<String> get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$AlarmStateImplCopyWith<_$AlarmStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
