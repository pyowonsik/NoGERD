# flutter_local_notifications → Method Channel 직접 구현 전환기

**작성일**: 2026-01-16
**프로젝트**: NoGERD (위식도역류질환 관리 앱)
**기술 스택**: Flutter, Kotlin (Android), Swift (iOS)

---

## 1. 왜 Method Channel로 전환했는가?

### 기존 문제점 (flutter_local_notifications)

```dart
// main.dart - 기존 하드코딩된 알림
await flutterLocalNotificationsPlugin.zonedSchedule(
  0,
  '기록 알림',
  '오늘 하루 증상을 기록해주세요!',
  _nextInstanceOfNinePM(),  // 9PM 고정
  ...
);
```

| 문제 | 설명 |
|------|------|
| **유연성 부족** | 9PM 단일 알림만 하드코딩 |
| **사용자 설정 불가** | 시간 변경, 알림 종류 선택 불가 |
| **패키지 의존성** | 외부 패키지 버전 관리 부담 |
| **제한된 제어** | 네이티브 알림 API 세부 제어 어려움 |
| **블랙박스** | 내부 동작 이해 없이 사용 |

### Method Channel 전환 목표

- **7가지 알림 유형**: 아침/점심/저녁 식사, 약물 복용 3회, 취침
- **사용자 맞춤 설정**: 각 알림별 시간 설정, ON/OFF 토글
- **네이티브 API 직접 제어**: 플랫폼별 최적화
- **학습 목적**: Flutter-Native 통신 원리 이해

---

## 2. 구현 과정

### 아키텍처 설계

```
┌────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│  ┌─────────────────┐    ┌─────────────────────────────┐   │
│  │ AlarmSettingsPage│───▶│ AlarmBloc (Event/State)     │   │
│  └─────────────────┘    └─────────────────────────────┘   │
└────────────────────────────────┬───────────────────────────┘
                                 │
┌────────────────────────────────┼───────────────────────────┐
│                      Domain Layer                          │
│  ┌─────────────────┐    ┌─────────────────────────────┐   │
│  │ AlarmConfig     │    │ ScheduleAlarmUseCase        │   │
│  │ (Entity)        │    │ CancelAlarmUseCase          │   │
│  └─────────────────┘    │ GetAlarmConfigsUseCase      │   │
│                         └─────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐  │
│  │ AlarmRepository (Interface)                          │  │
│  └─────────────────────────────────────────────────────┘  │
└────────────────────────────────┬───────────────────────────┘
                                 │
┌────────────────────────────────┼───────────────────────────┐
│                       Data Layer                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ AlarmRepositoryImpl                                  │   │
│  └───────────┬─────────────────────────┬───────────────┘   │
│              │                         │                    │
│  ┌───────────▼───────────┐ ┌──────────▼────────────────┐  │
│  │ AlarmLocalDataSource  │ │ AlarmPlatformDataSource   │  │
│  │ (SharedPreferences)   │ │ (MethodChannel)           │  │
│  └───────────────────────┘ └──────────┬────────────────┘  │
└────────────────────────────────────────┼───────────────────┘
                                         │
                    ┌────────────────────┴────────────────────┐
                    │          Method Channel                  │
                    │    "com.example.no_gerd/alarm"          │
                    └────────────────────┬────────────────────┘
                                         │
              ┌──────────────────────────┴──────────────────────┐
              │                                                  │
    ┌─────────▼─────────┐                          ┌────────────▼────────────┐
    │   Android (Kotlin) │                          │      iOS (Swift)        │
    │   MainActivity.kt  │                          │   AppDelegate.swift     │
    │   AlarmReceiver.kt │                          │                         │
    │   AlarmManager     │                          │  UNUserNotificationCenter│
    └───────────────────┘                          └─────────────────────────┘
```

### Method Channel 통신

**Flutter 측 (Dart)**
```dart
class AlarmPlatformDataSource {
  static const MethodChannel _channel =
      MethodChannel('com.example.no_gerd/alarm');

  Future<bool> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final result = await _channel.invokeMethod<bool>('scheduleAlarm', {
      'id': id,
      'title': title,
      'body': body,
      'hour': hour,
      'minute': minute,
    });
    return result ?? false;
  }
}
```

**Android 측 (Kotlin)**
```kotlin
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.no_gerd/alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleAlarm" -> {
                        val id = call.argument<Int>("id")!!
                        val hour = call.argument<Int>("hour")!!
                        val minute = call.argument<Int>("minute")!!
                        // AlarmManager로 예약
                        scheduleAlarm(id, title, body, hour, minute)
                        result.success(true)
                    }
                }
            }
    }
}
```

**iOS 측 (Swift)**
```swift
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "com.example.no_gerd/alarm"

    override func application(...) -> Bool {
        let alarmChannel = FlutterMethodChannel(name: CHANNEL, ...)

        alarmChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "scheduleAlarm":
                // UNUserNotificationCenter로 예약
                self.scheduleAlarm(...)
                result(true)
            }
        }
    }
}
```

---

## 3. 트러블슈팅

### Issue #1: iOS 포그라운드에서 알림 미표시

**문제**: 앱이 화면에 떠있을 때 알림이 안 보임

**원인**: iOS는 기본적으로 포그라운드에서 알림을 숨김

**해결**:
```swift
override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: ...) {
    if #available(iOS 14.0, *) {
        completionHandler([.banner, .sound, .badge])
    } else {
        completionHandler([.alert, .sound, .badge])
    }
}
```

### Issue #2: FlutterAppDelegate 상속 충돌

**문제**: `Redundant conformance to UNUserNotificationCenterDelegate`

**원인**: FlutterAppDelegate가 이미 해당 프로토콜 구현

**해결**: delegate 선언 제거 + `override` 키워드 추가
```swift
// ❌ class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate
// ✅ class AppDelegate: FlutterAppDelegate

override func userNotificationCenter(...) { }  // override 필수
```

### Issue #3: iOS 14 미만 버전 호환성

**문제**: `'banner' is only available in iOS 14.0 or newer`

**해결**: 버전 분기 처리
```swift
if #available(iOS 14.0, *) {
    completionHandler([.banner, ...])
} else {
    completionHandler([.alert, ...])  // iOS 13 이하
}
```

### Issue #4: Android Doze 모드

**문제**: 절전 모드에서 알림 지연

**해결**: `setExactAndAllowWhileIdle()` 사용
```kotlin
alarmManager.setExactAndAllowWhileIdle(
    AlarmManager.RTC_WAKEUP,
    calendar.timeInMillis,
    pendingIntent
)
```

---

## 4. Before vs After

| 항목 | Before (flutter_local_notifications) | After (Method Channel) |
|------|--------------------------------------|------------------------|
| **알림 개수** | 1개 (9PM 고정) | 7개 (사용자 설정) |
| **시간 설정** | 불가 | 각 알림별 개별 설정 |
| **ON/OFF** | 불가 | 개별 토글 |
| **아키텍처** | main.dart 단일 파일 | Clean Architecture |
| **상태 관리** | 없음 | BLoC 패턴 |
| **네이티브 제어** | 패키지 의존 | 직접 제어 |
| **코드 이해도** | 블랙박스 | 완전 이해 |

---

## 5. 성과 및 학습

### 기술적 성과

1. **Method Channel 완전 이해**
   - Flutter ↔ Native 양방향 통신 원리
   - Platform-specific 코드 작성 능력

2. **네이티브 알림 API 학습**
   - Android: `AlarmManager`, `BroadcastReceiver`, `NotificationManager`
   - iOS: `UNUserNotificationCenter`, `UNCalendarNotificationTrigger`

3. **Clean Architecture 실전 적용**
   - 레이어 분리 (Domain/Data/Presentation)
   - 의존성 역전 원칙 적용
   - 테스트 가능한 구조

4. **플랫폼별 특성 대응**
   - Android Doze 모드
   - iOS 포그라운드 알림
   - 버전별 API 분기

### 생성 파일

```
lib/features/settings/
├── domain/
│   ├── entities/alarm_config.dart
│   ├── repositories/alarm_repository.dart
│   └── usecases/
│       ├── schedule_alarm_usecase.dart
│       ├── cancel_alarm_usecase.dart
│       └── get_alarm_configs_usecase.dart
├── data/
│   ├── datasources/
│   │   ├── alarm_platform_datasource.dart  ← Method Channel
│   │   └── alarm_local_datasource.dart
│   └── repositories/alarm_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── alarm_bloc.dart
    │   ├── alarm_event.dart
    │   └── alarm_state.dart
    └── pages/alarm_settings_page.dart

android/app/src/main/kotlin/
├── MainActivity.kt      ← Method Channel Handler
└── AlarmReceiver.kt     ← BroadcastReceiver

ios/Runner/
└── AppDelegate.swift    ← Method Channel Handler
```

### 핵심 학습 포인트

> **"패키지에 의존하면 편하지만, 직접 구현하면 이해도가 다르다"**

- 외부 패키지: 빠른 구현, 제한된 커스터마이징
- Method Channel: 학습 비용 높음, 완전한 제어권

---

## 6. 결론

`flutter_local_notifications` 패키지 대신 **Method Channel로 직접 네이티브 알림을 구현**함으로써:

1. **유연한 알림 시스템** 구축 (7가지 알림, 사용자 설정)
2. **Flutter-Native 통신** 완전 이해
3. **Clean Architecture** 실전 경험
4. **플랫폼별 최적화** 능력 확보

단순히 "동작하는 코드"가 아닌, **"이해하고 제어할 수 있는 코드"**를 작성하게 됨.

---

**작성자**: Claude (AI Assistant)
**검토일**: 2026-01-16
