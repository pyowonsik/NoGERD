import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/exceptions.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/data/datasources/alarm_local_datasource.dart';
import 'package:no_gerd/features/settings/data/datasources/alarm_platform_datasource.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';

/// 알림 Repository 구현체
@LazySingleton(as: AlarmRepository)
class AlarmRepositoryImpl implements AlarmRepository {
  /// 생성자
  AlarmRepositoryImpl(
    this._platformDataSource,
    this._localDataSource,
  );
  final AlarmPlatformDataSource _platformDataSource;
  final AlarmLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, bool>> scheduleAlarm(AlarmConfig config) async {
    try {
      // 네이티브에 알림 예약
      final success = await _platformDataSource.scheduleAlarm(config);

      if (success) {
        // 성공 시 로컬에 설정 저장
        await _localDataSource.saveAlarmConfig(config);
      }

      return right(success);
    } on CacheException catch (e) {
      return left(Failure.cache(e.message));
    } catch (e) {
      return left(Failure.unexpected('알림 예약 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAlarm(int id) async {
    try {
      final success = await _platformDataSource.cancelAlarm(id);
      return right(success);
    } on CacheException catch (e) {
      return left(Failure.cache(e.message));
    } catch (e) {
      return left(Failure.unexpected('알림 취소 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAllAlarms() async {
    try {
      final success = await _platformDataSource.cancelAllAlarms();
      return right(success);
    } on CacheException catch (e) {
      return left(Failure.cache(e.message));
    } catch (e) {
      return left(Failure.unexpected('전체 알림 취소 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveAlarmConfig(AlarmConfig config) async {
    try {
      await _localDataSource.saveAlarmConfig(config);
      return right(true);
    } catch (e) {
      return left(Failure.cache('알림 설정 저장 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, AlarmConfig>> getAlarmConfig(AlarmType type) async {
    try {
      final config = await _localDataSource.getAlarmConfig(type);

      if (config == null) {
        // 저장된 설정이 없으면 기본 설정 반환
        return right(AlarmConfig.initial(type));
      }

      return right(config);
    } catch (e) {
      return left(Failure.cache('알림 설정 조회 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AlarmConfig>>> getAllAlarmConfigs() async {
    try {
      final configs = await _localDataSource.getAllAlarmConfigs();
      return right(configs);
    } catch (e) {
      return left(Failure.cache('전체 알림 설정 조회 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      final granted = await _platformDataSource.requestPermission();
      return right(granted);
    } on CacheException catch (e) {
      return left(Failure.permission(e.message));
    } catch (e) {
      return left(Failure.permission('권한 요청 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPermission() async {
    try {
      final hasPermission = await _platformDataSource.checkPermission();
      return right(hasPermission);
    } on CacheException catch (e) {
      return left(Failure.permission(e.message));
    } catch (e) {
      return left(Failure.permission('권한 확인 실패: $e'));
    }
  }
}
