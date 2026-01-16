// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function() exportData,
    required TResult Function() deleteAllData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function()? exportData,
    TResult? Function()? deleteAllData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function()? exportData,
    TResult Function()? deleteAllData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SettingsEventLoadSettings value) loadSettings,
    required TResult Function(SettingsEventExportData value) exportData,
    required TResult Function(SettingsEventDeleteAllData value) deleteAllData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsEventLoadSettings value)? loadSettings,
    TResult? Function(SettingsEventExportData value)? exportData,
    TResult? Function(SettingsEventDeleteAllData value)? deleteAllData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsEventLoadSettings value)? loadSettings,
    TResult Function(SettingsEventExportData value)? exportData,
    TResult Function(SettingsEventDeleteAllData value)? deleteAllData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEventCopyWith<$Res> {
  factory $SettingsEventCopyWith(
          SettingsEvent value, $Res Function(SettingsEvent) then) =
      _$SettingsEventCopyWithImpl<$Res, SettingsEvent>;
}

/// @nodoc
class _$SettingsEventCopyWithImpl<$Res, $Val extends SettingsEvent>
    implements $SettingsEventCopyWith<$Res> {
  _$SettingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SettingsEventLoadSettingsImplCopyWith<$Res> {
  factory _$$SettingsEventLoadSettingsImplCopyWith(
          _$SettingsEventLoadSettingsImpl value,
          $Res Function(_$SettingsEventLoadSettingsImpl) then) =
      __$$SettingsEventLoadSettingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SettingsEventLoadSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$SettingsEventLoadSettingsImpl>
    implements _$$SettingsEventLoadSettingsImplCopyWith<$Res> {
  __$$SettingsEventLoadSettingsImplCopyWithImpl(
      _$SettingsEventLoadSettingsImpl _value,
      $Res Function(_$SettingsEventLoadSettingsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SettingsEventLoadSettingsImpl implements SettingsEventLoadSettings {
  const _$SettingsEventLoadSettingsImpl();

  @override
  String toString() {
    return 'SettingsEvent.loadSettings()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsEventLoadSettingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function() exportData,
    required TResult Function() deleteAllData,
  }) {
    return loadSettings();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function()? exportData,
    TResult? Function()? deleteAllData,
  }) {
    return loadSettings?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function()? exportData,
    TResult Function()? deleteAllData,
    required TResult orElse(),
  }) {
    if (loadSettings != null) {
      return loadSettings();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SettingsEventLoadSettings value) loadSettings,
    required TResult Function(SettingsEventExportData value) exportData,
    required TResult Function(SettingsEventDeleteAllData value) deleteAllData,
  }) {
    return loadSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsEventLoadSettings value)? loadSettings,
    TResult? Function(SettingsEventExportData value)? exportData,
    TResult? Function(SettingsEventDeleteAllData value)? deleteAllData,
  }) {
    return loadSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsEventLoadSettings value)? loadSettings,
    TResult Function(SettingsEventExportData value)? exportData,
    TResult Function(SettingsEventDeleteAllData value)? deleteAllData,
    required TResult orElse(),
  }) {
    if (loadSettings != null) {
      return loadSettings(this);
    }
    return orElse();
  }
}

abstract class SettingsEventLoadSettings implements SettingsEvent {
  const factory SettingsEventLoadSettings() = _$SettingsEventLoadSettingsImpl;
}

/// @nodoc
abstract class _$$SettingsEventExportDataImplCopyWith<$Res> {
  factory _$$SettingsEventExportDataImplCopyWith(
          _$SettingsEventExportDataImpl value,
          $Res Function(_$SettingsEventExportDataImpl) then) =
      __$$SettingsEventExportDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SettingsEventExportDataImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$SettingsEventExportDataImpl>
    implements _$$SettingsEventExportDataImplCopyWith<$Res> {
  __$$SettingsEventExportDataImplCopyWithImpl(
      _$SettingsEventExportDataImpl _value,
      $Res Function(_$SettingsEventExportDataImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SettingsEventExportDataImpl implements SettingsEventExportData {
  const _$SettingsEventExportDataImpl();

  @override
  String toString() {
    return 'SettingsEvent.exportData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsEventExportDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function() exportData,
    required TResult Function() deleteAllData,
  }) {
    return exportData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function()? exportData,
    TResult? Function()? deleteAllData,
  }) {
    return exportData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function()? exportData,
    TResult Function()? deleteAllData,
    required TResult orElse(),
  }) {
    if (exportData != null) {
      return exportData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SettingsEventLoadSettings value) loadSettings,
    required TResult Function(SettingsEventExportData value) exportData,
    required TResult Function(SettingsEventDeleteAllData value) deleteAllData,
  }) {
    return exportData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsEventLoadSettings value)? loadSettings,
    TResult? Function(SettingsEventExportData value)? exportData,
    TResult? Function(SettingsEventDeleteAllData value)? deleteAllData,
  }) {
    return exportData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsEventLoadSettings value)? loadSettings,
    TResult Function(SettingsEventExportData value)? exportData,
    TResult Function(SettingsEventDeleteAllData value)? deleteAllData,
    required TResult orElse(),
  }) {
    if (exportData != null) {
      return exportData(this);
    }
    return orElse();
  }
}

abstract class SettingsEventExportData implements SettingsEvent {
  const factory SettingsEventExportData() = _$SettingsEventExportDataImpl;
}

/// @nodoc
abstract class _$$SettingsEventDeleteAllDataImplCopyWith<$Res> {
  factory _$$SettingsEventDeleteAllDataImplCopyWith(
          _$SettingsEventDeleteAllDataImpl value,
          $Res Function(_$SettingsEventDeleteAllDataImpl) then) =
      __$$SettingsEventDeleteAllDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SettingsEventDeleteAllDataImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$SettingsEventDeleteAllDataImpl>
    implements _$$SettingsEventDeleteAllDataImplCopyWith<$Res> {
  __$$SettingsEventDeleteAllDataImplCopyWithImpl(
      _$SettingsEventDeleteAllDataImpl _value,
      $Res Function(_$SettingsEventDeleteAllDataImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SettingsEventDeleteAllDataImpl implements SettingsEventDeleteAllData {
  const _$SettingsEventDeleteAllDataImpl();

  @override
  String toString() {
    return 'SettingsEvent.deleteAllData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsEventDeleteAllDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function() exportData,
    required TResult Function() deleteAllData,
  }) {
    return deleteAllData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function()? exportData,
    TResult? Function()? deleteAllData,
  }) {
    return deleteAllData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function()? exportData,
    TResult Function()? deleteAllData,
    required TResult orElse(),
  }) {
    if (deleteAllData != null) {
      return deleteAllData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SettingsEventLoadSettings value) loadSettings,
    required TResult Function(SettingsEventExportData value) exportData,
    required TResult Function(SettingsEventDeleteAllData value) deleteAllData,
  }) {
    return deleteAllData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsEventLoadSettings value)? loadSettings,
    TResult? Function(SettingsEventExportData value)? exportData,
    TResult? Function(SettingsEventDeleteAllData value)? deleteAllData,
  }) {
    return deleteAllData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsEventLoadSettings value)? loadSettings,
    TResult Function(SettingsEventExportData value)? exportData,
    TResult Function(SettingsEventDeleteAllData value)? deleteAllData,
    required TResult orElse(),
  }) {
    if (deleteAllData != null) {
      return deleteAllData(this);
    }
    return orElse();
  }
}

abstract class SettingsEventDeleteAllData implements SettingsEvent {
  const factory SettingsEventDeleteAllData() = _$SettingsEventDeleteAllDataImpl;
}

/// @nodoc
mixin _$SettingsState {
  /// 로딩 상태
  bool get isLoading => throw _privateConstructorUsedError;

  /// 처리 중 (백업, 내보내기, 삭제)
  bool get isProcessing => throw _privateConstructorUsedError;

  /// 앱 설정
  AppSettings get settings => throw _privateConstructorUsedError;

  /// 성공/에러 메시지
  Option<String> get message => throw _privateConstructorUsedError;

  /// 에러
  Option<Failure> get failure => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isProcessing,
      AppSettings settings,
      Option<String> message,
      Option<Failure> failure});

  $AppSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isProcessing = null,
    Object? settings = null,
    Object? message = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as AppSettings,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppSettingsCopyWith<$Res> get settings {
    return $AppSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
          _$SettingsStateImpl value, $Res Function(_$SettingsStateImpl) then) =
      __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isProcessing,
      AppSettings settings,
      Option<String> message,
      Option<Failure> failure});

  @override
  $AppSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
      _$SettingsStateImpl _value, $Res Function(_$SettingsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isProcessing = null,
    Object? settings = null,
    Object? message = null,
    Object? failure = null,
  }) {
    return _then(_$SettingsStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as AppSettings,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as Option<String>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<Failure>,
    ));
  }
}

/// @nodoc

class _$SettingsStateImpl implements _SettingsState {
  const _$SettingsStateImpl(
      {required this.isLoading,
      required this.isProcessing,
      required this.settings,
      required this.message,
      required this.failure});

  /// 로딩 상태
  @override
  final bool isLoading;

  /// 처리 중 (백업, 내보내기, 삭제)
  @override
  final bool isProcessing;

  /// 앱 설정
  @override
  final AppSettings settings;

  /// 성공/에러 메시지
  @override
  final Option<String> message;

  /// 에러
  @override
  final Option<Failure> failure;

  @override
  String toString() {
    return 'SettingsState(isLoading: $isLoading, isProcessing: $isProcessing, settings: $settings, message: $message, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isLoading, isProcessing, settings, message, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState(
      {required final bool isLoading,
      required final bool isProcessing,
      required final AppSettings settings,
      required final Option<String> message,
      required final Option<Failure> failure}) = _$SettingsStateImpl;

  @override

  /// 로딩 상태
  bool get isLoading;
  @override

  /// 처리 중 (백업, 내보내기, 삭제)
  bool get isProcessing;
  @override

  /// 앱 설정
  AppSettings get settings;
  @override

  /// 성공/에러 메시지
  Option<String> get message;
  @override

  /// 에러
  Option<Failure> get failure;
  @override
  @JsonKey(ignore: true)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
