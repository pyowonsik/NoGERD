import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';

/// 알림 리포지토리 인터페이스
///
/// 알림 예약, 취소 및 설정 관리를 담당합니다.
abstract class AlarmRepository {
  /// 알림 예약
  ///
  /// [config] - 알림 설정
  /// Returns: 성공 시 true, 실패 시 Failure
  Future<Either<Failure, bool>> scheduleAlarm(AlarmConfig config);

  /// 알림 취소
  ///
  /// [id] - 알림 ID
  /// Returns: 성공 시 true, 실패 시 Failure
  Future<Either<Failure, bool>> cancelAlarm(int id);

  /// 모든 알림 취소
  ///
  /// Returns: 성공 시 true, 실패 시 Failure
  Future<Either<Failure, bool>> cancelAllAlarms();

  /// 알림 설정 저장
  ///
  /// [config] - 알림 설정
  /// Returns: 성공 시 true, 실패 시 Failure
  Future<Either<Failure, bool>> saveAlarmConfig(AlarmConfig config);

  /// 특정 타입의 알림 설정 조회
  ///
  /// [type] - 알림 타입
  /// Returns: 알림 설정 또는 Failure
  Future<Either<Failure, AlarmConfig>> getAlarmConfig(AlarmType type);

  /// 모든 알림 설정 조회
  ///
  /// Returns: 알림 설정 목록 또는 Failure
  Future<Either<Failure, List<AlarmConfig>>> getAllAlarmConfigs();

  /// 알림 권한 요청
  ///
  /// Returns: 성공 시 true, 실패 시 Failure
  Future<Either<Failure, bool>> requestPermission();

  /// 알림 권한 확인
  ///
  /// Returns: 권한 있으면 true, 없으면 false
  Future<Either<Failure, bool>> checkPermission();
}
