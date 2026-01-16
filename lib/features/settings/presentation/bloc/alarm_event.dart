part of 'alarm_bloc.dart';

/// Alarm Event
@freezed
class AlarmEvent with _$AlarmEvent {
  /// 알림 설정 로드
  const factory AlarmEvent.loadConfigs() = AlarmEventLoadConfigs;

  /// 알림 활성화/비활성화
  const factory AlarmEvent.toggleAlarm({
    required AlarmType type,
    required bool enabled,
  }) = AlarmEventToggleAlarm;

  /// 알림 시간 변경
  const factory AlarmEvent.updateTime({
    required AlarmType type,
    required int hour,
    required int minute,
  }) = AlarmEventUpdateTime;

  /// 알림 권한 요청
  const factory AlarmEvent.requestPermission() = AlarmEventRequestPermission;
}
