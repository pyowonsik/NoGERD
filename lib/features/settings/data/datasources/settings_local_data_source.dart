import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

/// 설정 로컬 데이터 소스 인터페이스
abstract class SettingsLocalDataSource {
  /// 설정 가져오기
  Future<AppSettings> getSettings();

  /// 설정 저장하기
  Future<void> saveSettings(AppSettings settings);
}

/// 설정 로컬 데이터 소스 구현체
@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  /// 생성자
  SettingsLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<AppSettings> getSettings() async {
    // 설정 항목이 없으므로 기본 설정 반환
    return AppSettings.initial();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    // 설정 항목이 없으므로 아무것도 저장하지 않음
    // 추후 설정 항목이 추가되면 여기에 저장 로직 추가
  }
}
