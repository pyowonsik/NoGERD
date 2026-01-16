part of 'settings_bloc.dart';

/// Settings Event
@freezed
class SettingsEvent with _$SettingsEvent {
  /// 설정 로드
  const factory SettingsEvent.loadSettings() = SettingsEventLoadSettings;

  /// 데이터 내보내기
  const factory SettingsEvent.exportData() = SettingsEventExportData;

  /// 모든 데이터 삭제
  const factory SettingsEvent.deleteAllData() = SettingsEventDeleteAllData;
}
