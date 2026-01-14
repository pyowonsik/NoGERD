part of 'settings_bloc.dart';

/// Settings State
@freezed
class SettingsState with _$SettingsState {
  /// 생성자
  const factory SettingsState({
    /// 로딩 상태
    required bool isLoading,

    /// 처리 중 (백업, 내보내기, 삭제)
    required bool isProcessing,

    /// 앱 설정
    required AppSettings settings,

    /// 성공/에러 메시지
    required Option<String> message,

    /// 에러
    required Option<Failure> failure,
  }) = _SettingsState;

  /// 초기 상태
  factory SettingsState.initial() => SettingsState(
        isLoading: false,
        isProcessing: false,
        settings: AppSettings.initial(),
        message: none(),
        failure: none(),
      );
}
