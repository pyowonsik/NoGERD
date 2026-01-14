part of 'settings_bloc.dart';

/// Settings Event
@freezed
class SettingsEvent with _$SettingsEvent {
  /// 설정 로드
  const factory SettingsEvent.loadSettings() = SettingsEventLoadSettings;

  /// 일일 알림 업데이트
  const factory SettingsEvent.updateDailyReminder(bool enabled) =
      SettingsEventUpdateDailyReminder;

  /// 알림 시간 업데이트
  const factory SettingsEvent.updateReminderTime(TimeOfDay time) =
      SettingsEventUpdateReminderTime;

  /// 약 복용 알림 업데이트
  const factory SettingsEvent.updateMedicationReminder(bool enabled) =
      SettingsEventUpdateMedicationReminder;

  /// 다크 모드 업데이트
  const factory SettingsEvent.updateDarkMode(bool enabled) =
      SettingsEventUpdateDarkMode;

  /// 언어 업데이트
  const factory SettingsEvent.updateLanguage(String languageCode) =
      SettingsEventUpdateLanguage;

  /// 데이터 백업
  const factory SettingsEvent.backupData() = SettingsEventBackupData;

  /// 데이터 내보내기
  const factory SettingsEvent.exportData() = SettingsEventExportData;

  /// 모든 데이터 삭제
  const factory SettingsEvent.deleteAllData() = SettingsEventDeleteAllData;
}
