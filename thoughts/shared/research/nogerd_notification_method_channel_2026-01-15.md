# NoGERD 알림 기능 Method Channel 구현 가이드

**날짜**: 2026-01-15
**분석 대상**: 알림 기능 (Method Channel 구현)
**프로젝트**: NoGERD (꾸르꾸억) - GERD 증상 관리 앱

---

## 1. 프로젝트 개요

### 목적
- 역류성 식도염(GERD) 증상 추적 및 관리
- 식사, 약물, 생활습관 기록
- 증상 패턴 분석 및 인사이트 제공

### 주요 기능
- 식사/약물/증상/생활습관 기록
- 캘린더 기반 기록 조회
- 건강 점수 분석
- **알림 설정** (식사, 약물 복용, 취침 시간)

---

## 2. 기술 스택

### Flutter & Dart
- **Flutter SDK**: 3.3.4+
- **Dart SDK**: 3.3.4+

### 아키텍처
- **패턴**: Clean Architecture (Domain/Data/Presentation 레이어 분리)
- **상태 관리**: BLoC (flutter_bloc ^8.1.6)
- **의존성 주입**: Injectable ^2.4.4 + GetIt ^8.0.3
- **함수형 에러 처리**: fpdart ^1.1.0

### 데이터 레이어
- **백엔드**: Supabase (supabase_flutter ^2.5.0)
- **로컬 저장소**: Hive ^2.2.3, SharedPreferences
- **보안 저장소**: flutter_secure_storage ^9.0.0

### 라우팅
- **go_router**: ^15.1.1

### 현재 알림 관련 패키지
- ⚠️ **flutter_local_notifications**: ^19.1.0 (이미 존재, 하지만 Method Channel으로 대체 예정)
- **flutter_native_timezone**: ^2.0.0
- **timezone**: ^0.10.0

### 기타 주요 패키지
- **freezed**: 불변 모델 생성
- **json_annotation**: JSON 직렬화
- **table_calendar**: 캘린더 UI
- **rxdart**: 반응형 프로그래밍

---

## 3. 프로젝트 구조

```
NoGERD/
├── android/
│   └── app/src/main/kotlin/com/example/no_gerd/
│       └── MainActivity.kt (단순 FlutterActivity 상속, Method Channel 추가 예정)
│
├── ios/
│   └── Runner/
│       ├── AppDelegate.swift (기본 구조, Method Channel 추가 예정)
│       └── Info.plist
│
├── lib/
│   ├── core/
│   │   ├── di/
│   │   │   ├── injection.dart (GetIt + Injectable)
│   │   │   └── injection.config.dart (자동 생성)
│   │   ├── error/ (failures, exceptions)
│   │   ├── route/ (go_router 설정)
│   │   └── usecase/ (베이스 UseCase)
│   │
│   ├── features/
│   │   ├── auth/ (인증)
│   │   ├── calendar/ (캘린더)
│   │   ├── home/ (홈 화면)
│   │   ├── insights/ (분석)
│   │   ├── record/ (기록)
│   │   └── settings/
│   │       ├── di/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── alarm_settings_page.dart ⭐ (현재 UI만 존재)
│   │           │   └── settings_page.dart
│   │           ├── bloc/
│   │           └── widgets/
│   │
│   ├── shared/ (공통 위젯, 테마, 상수)
│   └── main.dart ⭐ (알림 초기화 코드 존재)
│
└── thoughts/shared/research/ (연구 문서 저장)
```

---

## 4. 현재 알림 코드 분석

### 4.1 main.dart의 현재 구현

**위치**: `lib/main.dart:16-122`

```dart
/// 플러터 로컬 알림 플러그인 (전역 인스턴스)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // ... 다른 초기화 코드 ...

  // Timezone 초기화
  tz.initializeTimeZones();
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // flutter_local_notifications 초기화
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 매일 오후 9시 알림 예약
  await scheduleDailyNotification();

  runApp(const App());
}

/// 매일 오후 9시에 알림 (하드코딩됨)
Future<void> scheduleDailyNotification() async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'daily_notification_channel_id',
    'Daily Notifications',
    channelDescription: 'This channel is for daily notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  final scheduledTime = _nextInstanceOfNinePM();

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
```

**문제점**:
- 오후 9시로 하드코딩
- 사용자 설정 반영 안됨
- 식사/약물/취침 알림 구분 없음

---

### 4.2 alarm_settings_page.dart 분석

**위치**: `lib/features/settings/presentation/pages/alarm_settings_page.dart:1-474`

**주요 기능**:
1. **알림 종류** (총 7개):
   - 식사 알림 3개: 아침(7:30), 점심(12:00), 저녁(18:30)
   - 약물 알림 3개: 아침(8:00), 점심(12:30), 저녁(19:00)
   - 생활습관 알림 1개: 취침(22:00)

2. **데이터 저장**: SharedPreferences 사용
   ```dart
   // 예시 키
   'alarm_breakfast_meal_enabled' (bool)
   'alarm_breakfast_meal_hour' (int)
   'alarm_breakfast_meal_minute' (int)
   ```

3. **UI**: 완성도 높은 디자인 (활성화 상태, 시간 선택, 이모지, 색상 구분)

4. **문제점**:
   - ⚠️ **알림 예약 로직이 전혀 없음** (SharedPreferences 저장만 함)
   - UI와 실제 알림 기능이 분리되어 있지 않음

---

## 5. Method Channel 구현 설계

### 5.1 아키텍처 개요

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Layer                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Presentation (alarm_settings_page.dart)              │   │
│  │  - UI: 알림 활성화/비활성화, 시간 선택                 │   │
│  └───────────────┬──────────────────────────────────────┘   │
│                  │ Event (BLoC)                              │
│  ┌───────────────▼──────────────────────────────────────┐   │
│  │ BLoC (AlarmBloc)                                     │   │
│  │  - 상태 관리, 비즈니스 로직                           │   │
│  └───────────────┬──────────────────────────────────────┘   │
│                  │ UseCase 호출                              │
│  ┌───────────────▼──────────────────────────────────────┐   │
│  │ Domain Layer                                         │   │
│  │  - ScheduleAlarmUseCase                             │   │
│  │  - CancelAlarmUseCase                               │   │
│  └───────────────┬──────────────────────────────────────┘   │
│                  │ Repository Interface                      │
│  ┌───────────────▼──────────────────────────────────────┐   │
│  │ Data Layer (AlarmRepository)                        │   │
│  │  - AlarmRepositoryImpl                              │   │
│  │  - SharedPreferences (설정 저장)                     │   │
│  │  - AlarmPlatform (Method Channel 호출) ⭐            │   │
│  └───────────────┬──────────────────────────────────────┘   │
└──────────────────┼──────────────────────────────────────────┘
                   │ Method Channel
                   │ ('com.example.no_gerd/alarm')
┌──────────────────▼──────────────────────────────────────────┐
│                  Native Layer                                │
│  ┌─────────────────────────┬──────────────────────────────┐ │
│  │   Android (Kotlin)      │      iOS (Swift)             │ │
│  │  - MainActivity.kt      │  - AppDelegate.swift         │ │
│  │  - AlarmManager         │  - UNUserNotificationCenter  │ │
│  │  - WorkManager (선택)   │  - UserNotifications         │ │
│  └─────────────────────────┴──────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

### 5.2 Method Channel 인터페이스

**Channel Name**: `com.example.no_gerd/alarm`

#### Flutter → Native 메서드

| 메서드명 | 파라미터 | 반환값 | 설명 |
|---------|---------|--------|------|
| `scheduleAlarm` | `{id: int, title: String, body: String, hour: int, minute: int}` | `bool` | 알림 예약 |
| `cancelAlarm` | `{id: int}` | `bool` | 알림 취소 |
| `cancelAllAlarms` | - | `bool` | 모든 알림 취소 |
| `requestPermission` | - | `bool` | 알림 권한 요청 |
| `checkPermission` | - | `bool` | 알림 권한 확인 |

#### 알림 ID 설계

```dart
// 고유 ID로 알림 구분
const int ALARM_ID_BREAKFAST_MEAL = 1;
const int ALARM_ID_LUNCH_MEAL = 2;
const int ALARM_ID_DINNER_MEAL = 3;
const int ALARM_ID_BREAKFAST_MEDICATION = 4;
const int ALARM_ID_LUNCH_MEDICATION = 5;
const int ALARM_ID_DINNER_MEDICATION = 6;
const int ALARM_ID_SLEEP = 7;
```

---

## 6. 단계별 구현 가이드

### Phase 1: 기본 인프라 구축

#### 1.1 Flutter 측 구조 생성

```
lib/features/settings/
├── data/
│   ├── datasources/
│   │   ├── alarm_local_datasource.dart (SharedPreferences)
│   │   └── alarm_platform_datasource.dart (Method Channel) ⭐
│   └── repositories/
│       └── alarm_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── alarm_config.dart (Freezed)
│   ├── repositories/
│   │   └── alarm_repository.dart (Interface)
│   └── usecases/
│       ├── schedule_alarm_usecase.dart
│       ├── cancel_alarm_usecase.dart
│       └── get_alarm_configs_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── alarm_bloc.dart
    │   ├── alarm_event.dart
    │   └── alarm_state.dart
    └── pages/
        └── alarm_settings_page.dart (기존, 리팩토링 필요)
```

#### 1.2 Method Channel 구현 (Flutter)

**파일**: `lib/features/settings/data/datasources/alarm_platform_datasource.dart`

```dart
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Method Channel을 통한 네이티브 알림 제어
@LazySingleton()
class AlarmPlatformDataSource {
  static const _channel = MethodChannel('com.example.no_gerd/alarm');

  /// 알림 예약
  Future<bool> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'scheduleAlarm',
        {
          'id': id,
          'title': title,
          'body': body,
          'hour': hour,
          'minute': minute,
        },
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to schedule alarm: ${e.message}');
      return false;
    }
  }

  /// 알림 취소
  Future<bool> cancelAlarm(int id) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'cancelAlarm',
        {'id': id},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to cancel alarm: ${e.message}');
      return false;
    }
  }

  /// 모든 알림 취소
  Future<bool> cancelAllAlarms() async {
    try {
      final result = await _channel.invokeMethod<bool>('cancelAllAlarms');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to cancel all alarms: ${e.message}');
      return false;
    }
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to request permission: ${e.message}');
      return false;
    }
  }

  /// 알림 권한 확인
  Future<bool> checkPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to check permission: ${e.message}');
      return false;
    }
  }
}
```

---

### Phase 2: Android 네이티브 구현

#### 2.1 MainActivity.kt 수정

**파일**: `android/app/src/main/kotlin/com/example/no_gerd/MainActivity.kt`

```kotlin
package com.example.no_gerd

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.no_gerd/alarm"
    private val CHANNEL_ID = "alarm_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Notification Channel 생성 (Android 8.0+)
        createNotificationChannel()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleAlarm" -> {
                        val id = call.argument<Int>("id") ?: 0
                        val title = call.argument<String>("title") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val hour = call.argument<Int>("hour") ?: 0
                        val minute = call.argument<Int>("minute") ?: 0

                        val success = scheduleAlarm(id, title, body, hour, minute)
                        result.success(success)
                    }
                    "cancelAlarm" -> {
                        val id = call.argument<Int>("id") ?: 0
                        val success = cancelAlarm(id)
                        result.success(success)
                    }
                    "cancelAllAlarms" -> {
                        val success = cancelAllAlarms()
                        result.success(success)
                    }
                    "requestPermission" -> {
                        // Android 13+ (Tiramisu) 알림 권한 필요
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            requestPermissions(
                                arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                                100
                            )
                            result.success(true)
                        } else {
                            result.success(true) // 낮은 버전은 자동 허용
                        }
                    }
                    "checkPermission" -> {
                        val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) ==
                                android.content.pm.PackageManager.PERMISSION_GRANTED
                        } else {
                            true
                        }
                        result.success(hasPermission)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "알림"
            val descriptionText = "꾸르꾸억 알림 채널"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE)
                as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun scheduleAlarm(
        id: Int,
        title: String,
        body: String,
        hour: Int,
        minute: Int
    ): Boolean {
        return try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

            val intent = Intent(this, AlarmReceiver::class.java).apply {
                putExtra("id", id)
                putExtra("title", title)
                putExtra("body", body)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                this,
                id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // 다음 알림 시간 계산
            val calendar = Calendar.getInstance().apply {
                timeInMillis = System.currentTimeMillis()
                set(Calendar.HOUR_OF_DAY, hour)
                set(Calendar.MINUTE, minute)
                set(Calendar.SECOND, 0)

                // 이미 지난 시간이면 내일로
                if (timeInMillis <= System.currentTimeMillis()) {
                    add(Calendar.DAY_OF_YEAR, 1)
                }
            }

            // 반복 알림 설정 (매일)
            alarmManager.setRepeating(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                AlarmManager.INTERVAL_DAY,
                pendingIntent
            )

            // Android 6.0+ (Marshmallow) Doze 모드 대응
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    pendingIntent
                )
            }

            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun cancelAlarm(id: Int): Boolean {
        return try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, AlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            alarmManager.cancel(pendingIntent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun cancelAllAlarms(): Boolean {
        return try {
            // 모든 알림 ID (1~7)
            for (id in 1..7) {
                cancelAlarm(id)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
```

#### 2.2 AlarmReceiver.kt 생성

**파일**: `android/app/src/main/kotlin/com/example/no_gerd/AlarmReceiver.kt`

```kotlin
package com.example.no_gerd

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getIntExtra("id", 0)
        val title = intent.getStringExtra("title") ?: "알림"
        val body = intent.getStringExtra("body") ?: ""

        showNotification(context, id, title, body)
    }

    private fun showNotification(
        context: Context,
        id: Int,
        title: String,
        body: String
    ) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
            as NotificationManager

        // 앱 열기 Intent
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, "alarm_channel")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        notificationManager.notify(id, notification)
    }
}
```

#### 2.3 AndroidManifest.xml 수정

**파일**: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 권한 추가 -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <application ...>
        <activity ... />

        <!-- BroadcastReceiver 등록 -->
        <receiver
            android:name=".AlarmReceiver"
            android:enabled="true"
            android:exported="false" />
    </application>
</manifest>
```

---

### Phase 3: iOS 네이티브 구현

#### 3.1 AppDelegate.swift 수정

**파일**: `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.example.no_gerd/alarm",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "scheduleAlarm":
                guard let args = call.arguments as? [String: Any],
                      let id = args["id"] as? Int,
                      let title = args["title"] as? String,
                      let body = args["body"] as? String,
                      let hour = args["hour"] as? Int,
                      let minute = args["minute"] as? Int else {
                    result(false)
                    return
                }
                self?.scheduleAlarm(id: id, title: title, body: body, hour: hour, minute: minute) { success in
                    result(success)
                }

            case "cancelAlarm":
                guard let args = call.arguments as? [String: Any],
                      let id = args["id"] as? Int else {
                    result(false)
                    return
                }
                self?.cancelAlarm(id: id)
                result(true)

            case "cancelAllAlarms":
                self?.cancelAllAlarms()
                result(true)

            case "requestPermission":
                self?.requestPermission { granted in
                    result(granted)
                }

            case "checkPermission":
                self?.checkPermission { granted in
                    result(granted)
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - 알림 예약
    private func scheduleAlarm(
        id: Int,
        title: String,
        body: String,
        hour: Int,
        minute: Int,
        completion: @escaping (Bool) -> Void
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "alarm_\(id)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    // MARK: - 알림 취소
    private func cancelAlarm(id: Int) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["alarm_\(id)"])
    }

    // MARK: - 모든 알림 취소
    private func cancelAllAlarms() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - 권한 요청
    private func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Permission request error: \(error)")
                }
                completion(granted)
            }
    }

    // MARK: - 권한 확인
    private func checkPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
}
```

#### 3.2 Info.plist 수정

**파일**: `ios/Runner/Info.plist`

```xml
<dict>
    <!-- 기존 설정들 ... -->

    <!-- 알림 권한 설명 -->
    <key>NSUserNotificationsUsageDescription</key>
    <string>식사, 약물 복용, 취침 시간을 알려드리기 위해 알림 권한이 필요합니다.</string>
</dict>
```

---

### Phase 4: Domain & Data Layer 구현

#### 4.1 AlarmConfig Entity

**파일**: `lib/features/settings/domain/entities/alarm_config.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_config.freezed.dart';
part 'alarm_config.g.dart';

/// 알림 설정 엔티티
@freezed
class AlarmConfig with _$AlarmConfig {
  const factory AlarmConfig({
    required int id,
    required AlarmType type,
    required bool enabled,
    required int hour,
    required int minute,
  }) = _AlarmConfig;

  factory AlarmConfig.fromJson(Map<String, dynamic> json) =>
      _$AlarmConfigFromJson(json);
}

enum AlarmType {
  breakfastMeal,      // 아침 식사
  lunchMeal,          // 점심 식사
  dinnerMeal,         // 저녁 식사
  breakfastMedication, // 아침 약물
  lunchMedication,     // 점심 약물
  dinnerMedication,    // 저녁 약물
  sleep,              // 취침
}

extension AlarmTypeX on AlarmType {
  int get id {
    switch (this) {
      case AlarmType.breakfastMeal: return 1;
      case AlarmType.lunchMeal: return 2;
      case AlarmType.dinnerMeal: return 3;
      case AlarmType.breakfastMedication: return 4;
      case AlarmType.lunchMedication: return 5;
      case AlarmType.dinnerMedication: return 6;
      case AlarmType.sleep: return 7;
    }
  }

  String get title {
    switch (this) {
      case AlarmType.breakfastMeal: return '아침 식사 알림';
      case AlarmType.lunchMeal: return '점심 식사 알림';
      case AlarmType.dinnerMeal: return '저녁 식사 알림';
      case AlarmType.breakfastMedication: return '아침 약물 알림';
      case AlarmType.lunchMedication: return '점심 약물 알림';
      case AlarmType.dinnerMedication: return '저녁 약물 알림';
      case AlarmType.sleep: return '취침 시간 알림';
    }
  }

  String get body {
    switch (this) {
      case AlarmType.breakfastMeal: return '아침 식사 시간이에요!';
      case AlarmType.lunchMeal: return '점심 식사 시간이에요!';
      case AlarmType.dinnerMeal: return '저녁 식사 시간이에요!';
      case AlarmType.breakfastMedication: return '아침 약 복용 시간이에요!';
      case AlarmType.lunchMedication: return '점심 약 복용 시간이에요!';
      case AlarmType.dinnerMedication: return '저녁 약 복용 시간이에요!';
      case AlarmType.sleep: return '건강한 수면을 위해 잠자리에 드세요!';
    }
  }
}
```

#### 4.2 AlarmRepository Interface

**파일**: `lib/features/settings/domain/repositories/alarm_repository.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';

abstract class AlarmRepository {
  /// 알림 예약
  Future<Either<Failure, void>> scheduleAlarm(AlarmConfig config);

  /// 알림 취소
  Future<Either<Failure, void>> cancelAlarm(int id);

  /// 모든 알림 취소
  Future<Either<Failure, void>> cancelAllAlarms();

  /// 알림 설정 저장
  Future<Either<Failure, void>> saveAlarmConfig(AlarmConfig config);

  /// 알림 설정 불러오기
  Future<Either<Failure, AlarmConfig>> getAlarmConfig(AlarmType type);

  /// 모든 알림 설정 불러오기
  Future<Either<Failure, List<AlarmConfig>>> getAllAlarmConfigs();

  /// 알림 권한 요청
  Future<Either<Failure, bool>> requestPermission();

  /// 알림 권한 확인
  Future<Either<Failure, bool>> checkPermission();
}
```

#### 4.3 AlarmRepositoryImpl

**파일**: `lib/features/settings/data/repositories/alarm_repository_impl.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:no_gerd/core/error/exceptions.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/data/datasources/alarm_local_datasource.dart';
import 'package:no_gerd/features/settings/data/datasources/alarm_platform_datasource.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';

@LazySingleton(as: AlarmRepository)
class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmPlatformDataSource _platformDataSource;
  final AlarmLocalDataSource _localDataSource;

  AlarmRepositoryImpl(
    this._platformDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, void>> scheduleAlarm(AlarmConfig config) async {
    try {
      // 1. 네이티브에 알림 예약 요청
      final success = await _platformDataSource.scheduleAlarm(
        id: config.id,
        title: config.type.title,
        body: config.type.body,
        hour: config.hour,
        minute: config.minute,
      );

      if (!success) {
        return left(const Failure.platform('Failed to schedule alarm'));
      }

      // 2. 로컬에 설정 저장
      await _localDataSource.saveAlarmConfig(config);

      return right(null);
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAlarm(int id) async {
    try {
      final success = await _platformDataSource.cancelAlarm(id);

      if (!success) {
        return left(const Failure.platform('Failed to cancel alarm'));
      }

      return right(null);
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAllAlarms() async {
    try {
      final success = await _platformDataSource.cancelAllAlarms();

      if (!success) {
        return left(const Failure.platform('Failed to cancel all alarms'));
      }

      return right(null);
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAlarmConfig(AlarmConfig config) async {
    try {
      await _localDataSource.saveAlarmConfig(config);
      return right(null);
    } catch (e) {
      return left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AlarmConfig>> getAlarmConfig(AlarmType type) async {
    try {
      final config = await _localDataSource.getAlarmConfig(type);
      return right(config);
    } catch (e) {
      return left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlarmConfig>>> getAllAlarmConfigs() async {
    try {
      final configs = await _localDataSource.getAllAlarmConfigs();
      return right(configs);
    } catch (e) {
      return left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      final granted = await _platformDataSource.requestPermission();
      return right(granted);
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPermission() async {
    try {
      final granted = await _platformDataSource.checkPermission();
      return right(granted);
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }
}
```

---

### Phase 5: BLoC 구현

#### 5.1 AlarmEvent

**파일**: `lib/features/settings/presentation/bloc/alarm_event.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';

part 'alarm_event.freezed.dart';

@freezed
class AlarmEvent with _$AlarmEvent {
  const factory AlarmEvent.loadConfigs() = _LoadConfigs;
  const factory AlarmEvent.toggleAlarm(AlarmType type, bool enabled) = _ToggleAlarm;
  const factory AlarmEvent.updateTime(AlarmType type, int hour, int minute) = _UpdateTime;
  const factory AlarmEvent.requestPermission() = _RequestPermission;
}
```

#### 5.2 AlarmState

**파일**: `lib/features/settings/presentation/bloc/alarm_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';

part 'alarm_state.freezed.dart';

@freezed
class AlarmState with _$AlarmState {
  const factory AlarmState({
    @Default({}) Map<AlarmType, AlarmConfig> configs,
    @Default(false) bool isLoading,
    @Default(false) bool hasPermission,
    String? errorMessage,
  }) = _AlarmState;
}
```

#### 5.3 AlarmBloc

**파일**: `lib/features/settings/presentation/bloc/alarm_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

@injectable
class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository _repository;

  AlarmBloc(this._repository) : super(const AlarmState()) {
    on<_LoadConfigs>(_onLoadConfigs);
    on<_ToggleAlarm>(_onToggleAlarm);
    on<_UpdateTime>(_onUpdateTime);
    on<_RequestPermission>(_onRequestPermission);
  }

  Future<void> _onLoadConfigs(_LoadConfigs event, Emitter<AlarmState> emit) async {
    emit(state.copyWith(isLoading: true));

    // 권한 확인
    final permissionResult = await _repository.checkPermission();
    final hasPermission = permissionResult.getOrElse((_) => false);

    // 설정 불러오기
    final result = await _repository.getAllAlarmConfigs();

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (configs) {
        final configMap = {
          for (var config in configs) config.type: config
        };
        emit(state.copyWith(
          configs: configMap,
          isLoading: false,
          hasPermission: hasPermission,
        ));
      },
    );
  }

  Future<void> _onToggleAlarm(_ToggleAlarm event, Emitter<AlarmState> emit) async {
    final currentConfig = state.configs[event.type];
    if (currentConfig == null) return;

    final updatedConfig = currentConfig.copyWith(enabled: event.enabled);

    if (event.enabled) {
      // 알림 활성화 -> 예약
      final result = await _repository.scheduleAlarm(updatedConfig);
      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {
          final newConfigs = Map<AlarmType, AlarmConfig>.from(state.configs);
          newConfigs[event.type] = updatedConfig;
          emit(state.copyWith(configs: newConfigs));
        },
      );
    } else {
      // 알림 비활성화 -> 취소
      final result = await _repository.cancelAlarm(currentConfig.id);
      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {
          final newConfigs = Map<AlarmType, AlarmConfig>.from(state.configs);
          newConfigs[event.type] = updatedConfig;
          emit(state.copyWith(configs: newConfigs));
        },
      );
    }
  }

  Future<void> _onUpdateTime(_UpdateTime event, Emitter<AlarmState> emit) async {
    final currentConfig = state.configs[event.type];
    if (currentConfig == null) return;

    final updatedConfig = currentConfig.copyWith(
      hour: event.hour,
      minute: event.minute,
    );

    // 시간 변경 -> 재예약 (활성화된 경우만)
    if (currentConfig.enabled) {
      final result = await _repository.scheduleAlarm(updatedConfig);
      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {
          final newConfigs = Map<AlarmType, AlarmConfig>.from(state.configs);
          newConfigs[event.type] = updatedConfig;
          emit(state.copyWith(configs: newConfigs));
        },
      );
    } else {
      // 비활성화 상태면 저장만
      await _repository.saveAlarmConfig(updatedConfig);
      final newConfigs = Map<AlarmType, AlarmConfig>.from(state.configs);
      newConfigs[event.type] = updatedConfig;
      emit(state.copyWith(configs: newConfigs));
    }
  }

  Future<void> _onRequestPermission(_RequestPermission event, Emitter<AlarmState> emit) async {
    final result = await _repository.requestPermission();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (granted) => emit(state.copyWith(hasPermission: granted)),
    );
  }
}
```

---

## 7. 필요한 권한 및 설정

### Android

#### 7.1 권한 (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

#### 7.2 주의사항
- **Android 12+**: `SCHEDULE_EXACT_ALARM` 특수 권한 필요
- **Android 13+**: `POST_NOTIFICATIONS` 런타임 권한 필요
- **Doze 모드**: `setExactAndAllowWhileIdle()` 사용

### iOS

#### 7.1 권한 (Info.plist)
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>식사, 약물 복용, 취침 시간을 알려드리기 위해 알림 권한이 필요합니다.</string>
```

#### 7.2 주의사항
- `UNUserNotificationCenter` 사용
- 권한 요청 시점 중요 (사용자 경험 고려)

---

## 8. 테스트 계획

### 8.1 단위 테스트
- `AlarmPlatformDataSource` 모킹
- `AlarmRepository` 로직 테스트
- `AlarmBloc` 상태 변화 테스트

### 8.2 통합 테스트
- Method Channel 실제 호출 테스트
- 알림 예약/취소 플로우 테스트

### 8.3 수동 테스트
- [ ] 알림 활성화/비활성화
- [ ] 시간 변경
- [ ] 앱 종료 후 알림 울림 확인
- [ ] 권한 거부 시나리오
- [ ] Doze 모드 대응 (Android)

---

## 9. 발견된 패턴 및 컨벤션

### 9.1 네이밍 규칙
- **파일명**: snake_case (예: `alarm_settings_page.dart`)
- **클래스명**: PascalCase (예: `AlarmSettingsPage`)
- **변수명**: camelCase (예: `breakfastMealEnabled`)
- **상수**: UPPER_SNAKE_CASE (예: `ALARM_ID_BREAKFAST_MEAL`)

### 9.2 아키텍처 패턴
- **Clean Architecture** 철저히 준수
- **Feature-First** 구조 (features/settings, features/record 등)
- **Injectable + GetIt** 의존성 주입
- **Freezed** 불변 모델
- **BLoC** 상태 관리
- **fpdart Either** 에러 처리

### 9.3 코드 스타일
- `very_good_analysis` 린트 규칙
- 주석 한글 작성
- 명시적 타입 선언

---

## 10. 주의사항 및 개선 필요 영역

### 10.1 현재 문제점
1. ⚠️ **main.dart의 하드코딩된 알림** (`scheduleDailyNotification()`)
   - 오후 9시로 고정
   - 사용자 설정 무시
   - **해결**: Method Channel 구현 후 제거 필요

2. ⚠️ **alarm_settings_page.dart의 미완성 기능**
   - SharedPreferences 저장만 하고 실제 알림 예약 없음
   - **해결**: BLoC 연결 및 Repository 호출 추가

3. ⚠️ **flutter_local_notifications 패키지 중복**
   - Method Channel 구현 후 제거 고려
   - 또는 병행 사용 (백업용)

### 10.2 기술 부채
- 현재 `alarm_settings_page.dart`가 StatefulWidget으로 로컬 상태 관리
  - BLoC으로 마이그레이션 필요

### 10.3 확장 가능성
- **WorkManager** (Android): 더 안정적인 백그라운드 작업
- **알림 그룹화**: 여러 알림을 카테고리별로 그룹화
- **커스텀 사운드**: 알림음 선택 기능
- **진동 패턴**: 커스텀 진동 패턴

---

## 11. 구현 순서 요약

1. ✅ **Phase 1**: Flutter Method Channel 인프라 (datasource, repository)
2. ✅ **Phase 2**: Android 네이티브 구현 (MainActivity, AlarmReceiver)
3. ✅ **Phase 3**: iOS 네이티브 구현 (AppDelegate)
4. ✅ **Phase 4**: Domain Layer (entities, usecases, repository interface)
5. ✅ **Phase 5**: BLoC 구현 (event, state, bloc)
6. ⏳ **Phase 6**: UI 연결 (alarm_settings_page.dart BLoC 연결)
7. ⏳ **Phase 7**: 테스트 및 권한 처리
8. ⏳ **Phase 8**: 기존 코드 정리 (main.dart, flutter_local_notifications 제거)

---

## 12. 참고 자료

### 공식 문서
- [Flutter Method Channel](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Android AlarmManager](https://developer.android.com/reference/android/app/AlarmManager)
- [iOS UserNotifications](https://developer.apple.com/documentation/usernotifications)

### 예제 코드
- [Flutter Samples - Platform Channels](https://github.com/flutter/samples/tree/main/platform_channels)
- [Android Notification Best Practices](https://developer.android.com/develop/ui/views/notifications)

### 현재 프로젝트 파일
- `lib/main.dart:16-122` - 현재 알림 초기화
- `lib/features/settings/presentation/pages/alarm_settings_page.dart` - UI
- `android/app/src/main/kotlin/com/example/no_gerd/MainActivity.kt` - 네이티브 진입점
- `ios/Runner/AppDelegate.swift` - iOS 진입점

---

**연구 완료일**: 2026-01-15
**작성자**: Claude (연구 목적)
**다음 단계**: Phase 1부터 순차적으로 구현 시작
