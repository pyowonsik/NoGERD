import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Method Channel 사용으로 주석 처리
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:no_gerd/app.dart';
import 'package:no_gerd/core/di/injection.dart';

/// 플러터 로컬 알림 플러그인 (현재 미사용 - Method Channel 사용)
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load();

  // Gemini 초기화
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);

  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Hive 초기화
  await Hive.initFlutter();
  // TODO: Record 모델 Adapter 등록 (Hive 저장소 구현 시)

  // Timezone DB 초기화
  tz.initializeTimeZones();

  // 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR');

  // 로컬 타임존 설정
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // flutter_local_notifications 초기화 (현재 미사용 - Method Channel 사용)
  // const initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  // const initializationSettingsIOS = DarwinInitializationSettings();
  //
  // const initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsIOS,
  // );
  //
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  // );

  // DI 초기화 (새로운 Injectable 기반)
  await configureDependencies();

  runApp(const App());
}
