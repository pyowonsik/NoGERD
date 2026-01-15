// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppSettings {
  /// 일일 기록 알림 활성화
  bool get dailyReminderEnabled => throw _privateConstructorUsedError;

  /// 알림 시간
  TimeOfDay get reminderTime => throw _privateConstructorUsedError;

  /// 약 복용 알림 활성화
  bool get medicationReminderEnabled => throw _privateConstructorUsedError;

  /// 다크 모드 활성화
  bool get darkModeEnabled => throw _privateConstructorUsedError;

  /// 언어 코드
  String get languageCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {bool dailyReminderEnabled,
      TimeOfDay reminderTime,
      bool medicationReminderEnabled,
      bool darkModeEnabled,
      String languageCode});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyReminderEnabled = null,
    Object? reminderTime = null,
    Object? medicationReminderEnabled = null,
    Object? darkModeEnabled = null,
    Object? languageCode = null,
  }) {
    return _then(_value.copyWith(
      dailyReminderEnabled: null == dailyReminderEnabled
          ? _value.dailyReminderEnabled
          : dailyReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderTime: null == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      medicationReminderEnabled: null == medicationReminderEnabled
          ? _value.medicationReminderEnabled
          : medicationReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      darkModeEnabled: null == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool dailyReminderEnabled,
      TimeOfDay reminderTime,
      bool medicationReminderEnabled,
      bool darkModeEnabled,
      String languageCode});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyReminderEnabled = null,
    Object? reminderTime = null,
    Object? medicationReminderEnabled = null,
    Object? darkModeEnabled = null,
    Object? languageCode = null,
  }) {
    return _then(_$AppSettingsImpl(
      dailyReminderEnabled: null == dailyReminderEnabled
          ? _value.dailyReminderEnabled
          : dailyReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderTime: null == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      medicationReminderEnabled: null == medicationReminderEnabled
          ? _value.medicationReminderEnabled
          : medicationReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      darkModeEnabled: null == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {required this.dailyReminderEnabled,
      required this.reminderTime,
      required this.medicationReminderEnabled,
      required this.darkModeEnabled,
      required this.languageCode});

  /// 일일 기록 알림 활성화
  @override
  final bool dailyReminderEnabled;

  /// 알림 시간
  @override
  final TimeOfDay reminderTime;

  /// 약 복용 알림 활성화
  @override
  final bool medicationReminderEnabled;

  /// 다크 모드 활성화
  @override
  final bool darkModeEnabled;

  /// 언어 코드
  @override
  final String languageCode;

  @override
  String toString() {
    return 'AppSettings(dailyReminderEnabled: $dailyReminderEnabled, reminderTime: $reminderTime, medicationReminderEnabled: $medicationReminderEnabled, darkModeEnabled: $darkModeEnabled, languageCode: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.dailyReminderEnabled, dailyReminderEnabled) ||
                other.dailyReminderEnabled == dailyReminderEnabled) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            (identical(other.medicationReminderEnabled,
                    medicationReminderEnabled) ||
                other.medicationReminderEnabled == medicationReminderEnabled) &&
            (identical(other.darkModeEnabled, darkModeEnabled) ||
                other.darkModeEnabled == darkModeEnabled) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dailyReminderEnabled,
      reminderTime, medicationReminderEnabled, darkModeEnabled, languageCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {required final bool dailyReminderEnabled,
      required final TimeOfDay reminderTime,
      required final bool medicationReminderEnabled,
      required final bool darkModeEnabled,
      required final String languageCode}) = _$AppSettingsImpl;

  @override

  /// 일일 기록 알림 활성화
  bool get dailyReminderEnabled;
  @override

  /// 알림 시간
  TimeOfDay get reminderTime;
  @override

  /// 약 복용 알림 활성화
  bool get medicationReminderEnabled;
  @override

  /// 다크 모드 활성화
  bool get darkModeEnabled;
  @override

  /// 언어 코드
  String get languageCode;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
