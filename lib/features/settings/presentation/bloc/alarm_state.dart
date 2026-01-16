part of 'alarm_bloc.dart';

/// Alarm State
@freezed
class AlarmState with _$AlarmState {
  /// 생성자
  const factory AlarmState({
    /// 알림 설정 맵 (AlarmType -> AlarmConfig)
    required Map<AlarmType, AlarmConfig> configs,

    /// 로딩 상태
    required bool isLoading,

    /// 알림 권한 여부
    required bool hasPermission,

    /// 에러 메시지
    required Option<String> errorMessage,
  }) = _AlarmState;

  /// 초기 상태
  factory AlarmState.initial() => AlarmState(
        configs: {},
        isLoading: false,
        hasPermission: false,
        errorMessage: none(),
      );
}
