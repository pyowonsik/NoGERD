import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// 앱 설정 엔티티
/// 현재는 설정 항목이 없지만, 추후 확장을 위해 구조 유지
@freezed
class AppSettings with _$AppSettings {
  /// 생성자
  const factory AppSettings() = _AppSettings;

  /// 초기 설정
  factory AppSettings.initial() => const AppSettings();
}
