import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// 앱 설정 엔티티
@freezed
class AppSettings with _$AppSettings {
  /// 생성자
  const factory AppSettings({
    /// 일일 기록 알림 활성화
    required bool dailyReminderEnabled,

    /// 알림 시간
    required TimeOfDay reminderTime,

    /// 약 복용 알림 활성화
    required bool medicationReminderEnabled,

    /// 다크 모드 활성화
    required bool darkModeEnabled,

    /// 언어 코드
    required String languageCode,
  }) = _AppSettings;

  /// 초기 설정
  factory AppSettings.initial() => const AppSettings(
        dailyReminderEnabled: true,
        reminderTime: TimeOfDay(hour: 21, minute: 0),
        medicationReminderEnabled: true,
        darkModeEnabled: false,
        languageCode: 'ko',
      );
}
