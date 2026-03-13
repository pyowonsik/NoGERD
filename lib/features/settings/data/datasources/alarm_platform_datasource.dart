import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/exceptions.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';

/// 알림 플랫폼 데이터 소스 인터페이스
abstract class AlarmPlatformDataSource {
  /// 알림 예약
  Future<bool> scheduleAlarm(AlarmConfig config);

  /// 알림 취소
  Future<bool> cancelAlarm(int id);

  /// 모든 알림 취소
  Future<bool> cancelAllAlarms();

  /// 알림 권한 요청
  Future<bool> requestPermission();

  /// 알림 권한 확인
  Future<bool> checkPermission();
}

/// 알림 플랫폼 데이터 소스 구현체 (Method Channel)
/// Flutter에서 Android/iOS 네이티브 알림 기능 호출
@LazySingleton(as: AlarmPlatformDataSource)
class AlarmPlatformDataSourceImpl implements AlarmPlatformDataSource {
  /// 생성자
  const AlarmPlatformDataSourceImpl();

  // 1. MethodChannel 정의 - Android/iOS 네이티브 코드와 통신하는 채널
  static const _channel = MethodChannel('com.pyowonsik.nogerd/alarm');

  /// 알림 예약 (Flutter → Native)
  /// MethodChannel을 통해 네이티브 AlarmManager 호출
  @override
  Future<bool> scheduleAlarm(AlarmConfig config) async {
    try {
      // 2. invokeMethod로 네이티브 함수 호출 + 파라미터 전달
      final result = await _channel.invokeMethod<bool>(
        'scheduleAlarm', // 네이티브에서 처리할 메서드 이름
        {
          'id': config.type.id,
          'title': config.type.title,
          'body': config.type.body,
          'hour': config.hour,
          'minute': config.minute,
        },
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        'Failed to schedule alarm: ${e.message}',
      );
    } catch (e) {
      throw CacheException(
        'Unexpected error while scheduling alarm: $e',
      );
    }
  }

  @override
  Future<bool> cancelAlarm(int id) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'cancelAlarm',
        {'id': id},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        'Failed to cancel alarm: ${e.message}',
      );
    } catch (e) {
      throw CacheException(
        'Unexpected error while canceling alarm: $e',
      );
    }
  }

  @override
  Future<bool> cancelAllAlarms() async {
    try {
      final result = await _channel.invokeMethod<bool>('cancelAllAlarms');
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        'Failed to cancel all alarms: ${e.message}',
      );
    } catch (e) {
      throw CacheException(
        'Unexpected error while canceling all alarms: $e',
      );
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        'Failed to request permission: ${e.message}',
      );
    } catch (e) {
      throw CacheException(
        'Unexpected error while requesting permission: $e',
      );
    }
  }

  @override
  Future<bool> checkPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        'Failed to check permission: ${e.message}',
      );
    } catch (e) {
      throw CacheException(
        'Unexpected error while checking permission: $e',
      );
    }
  }
}
