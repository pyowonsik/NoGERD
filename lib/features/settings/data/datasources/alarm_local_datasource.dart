import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';

/// 알림 로컬 데이터 소스 인터페이스
abstract class AlarmLocalDataSource {
  /// 알림 설정 저장
  Future<void> saveAlarmConfig(AlarmConfig config);

  /// 알림 설정 조회
  Future<AlarmConfig?> getAlarmConfig(AlarmType type);

  /// 모든 알림 설정 조회
  Future<List<AlarmConfig>> getAllAlarmConfigs();
}

/// 알림 로컬 데이터 소스 구현체 (SharedPreferences)
@LazySingleton(as: AlarmLocalDataSource)
class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  /// 생성자
  const AlarmLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  /// SharedPreferences 키 생성 헬퍼
  String _getEnabledKey(AlarmType type) => 'alarm_${type.name}_enabled';
  String _getHourKey(AlarmType type) => 'alarm_${type.name}_hour';
  String _getMinuteKey(AlarmType type) => 'alarm_${type.name}_minute';

  @override
  Future<void> saveAlarmConfig(AlarmConfig config) async {
    await _prefs.setBool(_getEnabledKey(config.type), config.enabled);
    await _prefs.setInt(_getHourKey(config.type), config.hour);
    await _prefs.setInt(_getMinuteKey(config.type), config.minute);
  }

  @override
  Future<AlarmConfig?> getAlarmConfig(AlarmType type) async {
    final enabled = _prefs.getBool(_getEnabledKey(type));
    final hour = _prefs.getInt(_getHourKey(type));
    final minute = _prefs.getInt(_getMinuteKey(type));

    // 저장된 설정이 없으면 null 반환
    if (enabled == null || hour == null || minute == null) {
      return null;
    }

    return AlarmConfig(
      type: type,
      enabled: enabled,
      hour: hour,
      minute: minute,
    );
  }

  @override
  Future<List<AlarmConfig>> getAllAlarmConfigs() async {
    final configs = <AlarmConfig>[];

    for (final type in AlarmType.values) {
      final config = await getAlarmConfig(type);
      if (config != null) {
        configs.add(config);
      } else {
        // 저장된 설정이 없으면 기본 설정 추가
        configs.add(AlarmConfig.initial(type));
      }
    }

    return configs;
  }
}
