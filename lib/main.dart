import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:no_gerd/app.dart';
import 'package:no_gerd/core/di/injection.dart';

/// 플러터 로컬 알림 플러그인
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();
  // TODO: Record 모델 Adapter 등록 (Hive 저장소 구현 시)

  // Timezone DB 초기화
  tz.initializeTimeZones();

  // 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR', null);

  // 로컬 타임존 설정
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettingsIOS = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  // DI 초기화 (새로운 Injectable 기반)
  await configureDependencies();

  // ⚠️ 실제 서비스에서는 권한 승인 이후 호출 권장
  await scheduleDailyNotification();

  runApp(const App());
}

/// 매일 알림 예약
Future<void> scheduleDailyNotification() async {
  /// Android 알림 세부 설정
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'daily_notification_channel_id',
    'Daily Notifications',
    channelDescription: 'This channel is for daily notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  /// 플랫폼 채널 세부 설정
  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  final scheduledTime = _nextInstanceOfNinePM();

  log('Scheduling notification for $scheduledTime');

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '알림',
    '증상을 기록할 시간이에요 !!',
    scheduledTime,
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfNinePM() {
  final now = tz.TZDateTime.now(tz.local);

  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    21, // 오후 9시
  );

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  log('Next notification scheduled for $scheduledDate');
  return scheduledDate;
}
