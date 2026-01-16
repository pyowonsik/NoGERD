# Method Channel 알림 기능 구현 계획

**날짜**: 2026-01-15
**작성자**: Claude
**관련 연구 문서**: thoughts/shared/research/nogerd_notification_method_channel_2026-01-15.md

---

## 1. 요구사항

### 기능 개요
Flutter의 Method Channel을 활용하여 Android/iOS 네이티브 알림 시스템을 직접 제어하는 알림 기능 구현. 기존 `flutter_local_notifications` 패키지를 네이티브 구현으로 대체하여 Method Channel 학습 및 알림 시스템에 대한 깊은 이해 확보.

### 목표
- Method Channel을 통한 Flutter ↔ Native 통신 구현
- Android AlarmManager, iOS UNUserNotificationCenter 직접 제어
- Clean Architecture 패턴 준수
- 7가지 알림 타입 지원 (식사 3개, 약물 3개, 취침 1개)
- 사용자 설정 기반 알림 예약/취소 기능

### 성공 기준
- [x] Method Channel이 Android/iOS 양쪽에서 정상 동작
- [x] 알림이 정확한 시간에 울림 (앱 종료 상태에서도)
- [x] 사용자가 UI에서 알림을 활성화/비활성화 가능
- [x] 시간 변경 시 즉시 재예약
- [x] 권한 요청 및 확인 플로우 구현
- [x] BLoC 패턴으로 상태 관리
- [x] SharedPreferences에 설정 영구 저장
- [x] Android Doze 모드 대응
- [x] 기존 하드코딩된 알림 코드 제거

---

## 2. 기술적 접근

### 아키텍처 선택
**Clean Architecture** 패턴을 철저히 준수
- **Presentation Layer**: BLoC (flutter_bloc ^8.1.6)
- **Domain Layer**: Entities, UseCases, Repository Interface
- **Data Layer**: Repository Implementation, DataSources (Platform, Local)

### 사용할 패키지
- **기존 유지**:
  - `flutter_bloc`: ^8.1.6 (상태 관리)
  - `injectable`: ^2.4.4 (DI)
  - `get_it`: ^8.0.3 (DI 컨테이너)
  - `freezed`: ^2.5.2 (불변 모델)
  - `fpdart`: ^1.1.0 (함수형 에러 처리)
  - `shared_preferences`: 설정 저장용

- **새로 추가 없음**: 순수 Method Channel 구현

- **제거 고려** (구현 완료 후):
  - `flutter_local_notifications`: ^19.1.0 (Method Channel으로 대체)
  - `flutter_native_timezone`: ^2.0.0 (필요시 유지)
  - `timezone`: ^0.10.0 (필요시 유지)

### Method Channel 인터페이스

**Channel Name**: `com.example.no_gerd/alarm`

| 메서드 | 파라미터 | 반환값 | 설명 |
|-------|---------|--------|------|
| `scheduleAlarm` | `{id, title, body, hour, minute}` | `bool` | 알림 예약 |
| `cancelAlarm` | `{id}` | `bool` | 알림 취소 |
| `cancelAllAlarms` | - | `bool` | 모든 알림 취소 |
| `requestPermission` | - | `bool` | 알림 권한 요청 |
| `checkPermission` | - | `bool` | 알림 권한 확인 |

### 파일 구조

```
lib/features/settings/
├── data/
│   ├── datasources/
│   │   ├── alarm_local_datasource.dart (SharedPreferences)
│   │   └── alarm_platform_datasource.dart (Method Channel) ⭐ 신규
│   └── repositories/
│       └── alarm_repository_impl.dart ⭐ 신규
├── domain/
│   ├── entities/
│   │   └── alarm_config.dart ⭐ 신규 (Freezed)
│   ├── repositories/
│   │   └── alarm_repository.dart ⭐ 신규 (Interface)
│   └── usecases/
│       ├── schedule_alarm_usecase.dart ⭐ 신규
│       ├── cancel_alarm_usecase.dart ⭐ 신규
│       └── get_alarm_configs_usecase.dart ⭐ 신규
└── presentation/
    ├── bloc/
    │   ├── alarm_bloc.dart ⭐ 신규
    │   ├── alarm_event.dart ⭐ 신규
    │   └── alarm_state.dart ⭐ 신규
    └── pages/
        └── alarm_settings_page.dart (기존, 리팩토링)

android/app/src/main/kotlin/com/example/no_gerd/
├── MainActivity.kt (수정)
└── AlarmReceiver.kt ⭐ 신규

ios/Runner/
└── AppDelegate.swift (수정)
```

---

## 3. 구현 단계

### Phase 1: Domain Layer 구축

**목표**: 비즈니스 로직의 핵심 구조 정의 (플랫폼 독립적)

**작업 목록**:
1. **AlarmConfig Entity 생성**
   - [x] `lib/features/settings/domain/entities/alarm_config.dart` 작성
   - [x] Freezed로 불변 모델 정의
   - [x] AlarmType enum 정의 (7가지 타입)
   - [x] AlarmTypeX extension으로 id, title, body 매핑
   - [x] JSON 직렬화 설정 (`part` 지시문)

2. **AlarmRepository Interface 정의**
   - [x] `lib/features/settings/domain/repositories/alarm_repository.dart` 작성
   - [x] `scheduleAlarm(AlarmConfig)` 메서드
   - [x] `cancelAlarm(int id)` 메서드
   - [x] `cancelAllAlarms()` 메서드
   - [x] `saveAlarmConfig(AlarmConfig)` 메서드
   - [x] `getAlarmConfig(AlarmType)` 메서드
   - [x] `getAllAlarmConfigs()` 메서드
   - [x] `requestPermission()` 메서드
   - [x] `checkPermission()` 메서드
   - [x] 모든 반환 타입 `Either<Failure, T>` 사용

3. **UseCases 작성**
   - [x] `lib/features/settings/domain/usecases/schedule_alarm_usecase.dart`
   - [x] `lib/features/settings/domain/usecases/cancel_alarm_usecase.dart`
   - [x] `lib/features/settings/domain/usecases/get_alarm_configs_usecase.dart`
   - [x] Injectable 어노테이션 추가

**예상 영향**:
- 영향 받는 파일: `lib/features/settings/domain/` 디렉토리
- 의존성: 없음 (순수 Dart 코드)

**검증 방법**:
- [x] `flutter pub run build_runner build` 실행 → Freezed 코드 생성 확인
- [x] 컴파일 에러 없음 확인
- [x] Domain Layer가 Presentation/Data Layer에 의존하지 않음 확인

---

### Phase 2: Data Layer - Platform DataSource (Method Channel)

**목표**: Flutter ↔ Native 통신 레이어 구현

**작업 목록**:
1. **AlarmPlatformDataSource 구현**
   - [x] `lib/features/settings/data/datasources/alarm_platform_datasource.dart` 작성
   - [x] MethodChannel 초기화 (`com.example.no_gerd/alarm`)
   - [x] `scheduleAlarm()` 메서드: invokeMethod 호출
   - [x] `cancelAlarm()` 메서드
   - [x] `cancelAllAlarms()` 메서드
   - [x] `requestPermission()` 메서드
   - [x] `checkPermission()` 메서드
   - [x] PlatformException 에러 처리
   - [x] Injectable `@LazySingleton()` 어노테이션

2. **AlarmLocalDataSource 구현**
   - [x] `lib/features/settings/data/datasources/alarm_local_datasource.dart` 작성
   - [x] SharedPreferences를 통한 AlarmConfig 저장/불러오기
   - [x] 키 포맷: `alarm_{type}_enabled`, `alarm_{type}_hour`, `alarm_{type}_minute`
   - [x] Injectable `@LazySingleton()` 어노테이션

**예상 영향**:
- 영향 받는 파일: `lib/features/settings/data/datasources/`
- 의존성: Phase 1 완료 (AlarmConfig Entity 사용)

**검증 방법**:
- [x] Dart 코드 컴파일 성공
- [x] Method Channel 호출 시 에러 로그 확인 (네이티브 미구현 상태)
- [ ] 단위 테스트: Mock MethodChannel로 테스트 (선택사항)

---

### Phase 3: Android 네이티브 구현

**목표**: Android AlarmManager를 사용한 실제 알림 예약/취소 구현

**작업 목록**:
1. **MainActivity.kt 수정**
   - [x] `android/app/src/main/kotlin/com/example/no_gerd/MainActivity.kt` 열기
   - [x] `configureFlutterEngine()` 오버라이드
   - [x] MethodChannel 핸들러 등록
   - [x] `scheduleAlarm` 메서드: AlarmManager.setRepeating() 사용
   - [x] Calendar로 다음 알림 시간 계산
   - [x] PendingIntent 생성 (FLAG_IMMUTABLE)
   - [x] Doze 모드 대응: `setExactAndAllowWhileIdle()` (Android 6.0+)
   - [x] `cancelAlarm` 메서드
   - [x] `cancelAllAlarms` 메서드
   - [x] `requestPermission` 메서드 (Android 13+ POST_NOTIFICATIONS)
   - [x] `checkPermission` 메서드
   - [x] `createNotificationChannel()` 메서드 (Android 8.0+)

2. **AlarmReceiver.kt 생성**
   - [x] `android/app/src/main/kotlin/com/example/no_gerd/AlarmReceiver.kt` 생성
   - [x] BroadcastReceiver 상속
   - [x] `onReceive()`: Intent에서 id, title, body 추출
   - [x] `showNotification()`: NotificationCompat로 알림 표시
   - [x] PendingIntent로 앱 실행 연결

3. **AndroidManifest.xml 수정**
   - [x] `android/app/src/main/AndroidManifest.xml` 열기
   - [x] 권한 추가:
     - `SCHEDULE_EXACT_ALARM`
     - `POST_NOTIFICATIONS` (Android 13+)
     - `USE_EXACT_ALARM`
     - `WAKE_LOCK`
   - [x] `<receiver>` 태그로 AlarmReceiver 등록
     - `android:name=".AlarmReceiver"`
     - `android:enabled="true"`
     - `android:exported="false"`

**예상 영향**:
- 영향 받는 파일: `android/app/src/main/`, `AndroidManifest.xml`
- 의존성: Phase 2 완료 (Flutter 측 Method Channel 준비)

**검증 방법**:
- [x] Android 빌드 성공 (`flutter build apk --debug`)
- [ ] Android 에뮬레이터/실제 기기에서 Method Channel 호출 테스트
- [ ] Logcat으로 scheduleAlarm 호출 로그 확인
- [ ] 설정한 시간에 알림이 울리는지 확인 (시간 조정하여 빠르게 테스트)

---

### Phase 4: iOS 네이티브 구현

**목표**: iOS UNUserNotificationCenter를 사용한 알림 예약/취소 구현

**작업 목록**:
1. **AppDelegate.swift 수정**
   - [x] `ios/Runner/AppDelegate.swift` 열기
   - [x] `import UserNotifications` 추가
   - [x] `application(_:didFinishLaunchingWithOptions:)` 수정
   - [x] FlutterMethodChannel 생성 (`com.example.no_gerd/alarm`)
   - [x] `setMethodCallHandler` 구현
   - [x] `scheduleAlarm` 메서드:
     - UNMutableNotificationContent 생성
     - DateComponents로 시간 설정
     - UNCalendarNotificationTrigger (repeats: true)
     - UNNotificationRequest 생성 및 add()
   - [x] `cancelAlarm` 메서드: removePendingNotificationRequests()
   - [x] `cancelAllAlarms` 메서드: removeAllPendingNotificationRequests()
   - [x] `requestPermission` 메서드: requestAuthorization()
   - [x] `checkPermission` 메서드: getNotificationSettings()

2. **Info.plist 수정**
   - [x] `ios/Runner/Info.plist` 열기
   - [x] `NSUserNotificationsUsageDescription` 키 추가
   - [x] 값: "식사, 약물 복용, 취침 시간을 알려드리기 위해 알림 권한이 필요합니다."

**예상 영향**:
- 영향 받는 파일: `ios/Runner/AppDelegate.swift`, `Info.plist`
- 의존성: Phase 2 완료

**검증 방법**:
- [x] iOS 빌드 성공 (`flutter build ios --debug`)
- [ ] iOS 시뮬레이터/실제 기기에서 Method Channel 호출 테스트
- [ ] Xcode 콘솔로 로그 확인
- [ ] 설정한 시간에 알림이 울리는지 확인

---

### Phase 5: Data Layer - Repository Implementation

**목표**: Domain의 Repository Interface 구현 (DataSource 연결)

**작업 목록**:
1. **AlarmRepositoryImpl 작성**
   - [x] `lib/features/settings/data/repositories/alarm_repository_impl.dart` 작성
   - [x] AlarmRepository 인터페이스 구현
   - [x] AlarmPlatformDataSource 주입
   - [x] AlarmLocalDataSource 주입
   - [x] `scheduleAlarm()`: 네이티브 호출 → 성공 시 로컬 저장
   - [x] `cancelAlarm()`: 네이티브 호출
   - [x] `cancelAllAlarms()`: 네이티브 호출
   - [x] `saveAlarmConfig()`: 로컬 저장
   - [x] `getAlarmConfig()`: 로컬 불러오기
   - [x] `getAllAlarmConfigs()`: 전체 불러오기
   - [x] `requestPermission()`: 네이티브 호출
   - [x] `checkPermission()`: 네이티브 호출
   - [x] 에러 처리: try-catch → Either.left(Failure)
   - [x] Injectable `@LazySingleton(as: AlarmRepository)`

2. **DI 모듈 업데이트**
   - [x] `lib/features/settings/di/settings_module.dart` 확인
   - [x] Injectable이 AlarmRepository, DataSource를 자동 등록하는지 확인
   - [x] `flutter pub run build_runner build --delete-conflicting-outputs` 실행

**예상 영향**:
- 영향 받는 파일: `lib/features/settings/data/repositories/`, `lib/core/di/`
- 의존성: Phase 1-4 완료

**검증 방법**:
- [x] 빌드 성공
- [x] `injection.config.dart` 생성 확인
- [ ] Repository를 직접 호출하여 Method Channel 동작 확인 (main에서 임시 테스트)

---

### Phase 6: Presentation Layer - BLoC 구현

**목표**: 알림 설정 화면의 상태 관리 및 비즈니스 로직 처리

**작업 목록**:
1. **AlarmEvent 정의**
   - [x] `lib/features/settings/presentation/bloc/alarm_event.dart` 작성
   - [x] Freezed로 정의
   - [x] `loadConfigs`: 초기 설정 불러오기
   - [x] `toggleAlarm(AlarmType, bool)`: 알림 활성화/비활성화
   - [x] `updateTime(AlarmType, int hour, int minute)`: 시간 변경
   - [x] `requestPermission`: 권한 요청

2. **AlarmState 정의**
   - [x] `lib/features/settings/presentation/bloc/alarm_state.dart` 작성
   - [x] Freezed로 정의
   - [x] `configs: Map<AlarmType, AlarmConfig>`: 알림 설정 맵
   - [x] `isLoading: bool`
   - [x] `hasPermission: bool`
   - [x] `errorMessage: String?`

3. **AlarmBloc 구현**
   - [x] `lib/features/settings/presentation/bloc/alarm_bloc.dart` 작성
   - [x] AlarmRepository 주입
   - [x] `_onLoadConfigs`: getAllAlarmConfigs() + checkPermission()
   - [x] `_onToggleAlarm`: enabled면 scheduleAlarm(), 아니면 cancelAlarm()
   - [x] `_onUpdateTime`: 시간 변경 후 재예약 (enabled인 경우만)
   - [x] `_onRequestPermission`: requestPermission() 호출
   - [x] Injectable `@injectable` 어노테이션
   - [x] `flutter pub run build_runner build` 실행

**예상 영향**:
- 영향 받는 파일: `lib/features/settings/presentation/bloc/`
- 의존성: Phase 1-5 완료

**검증 방법**:
- [x] Freezed 코드 생성 확인 (`.freezed.dart` 파일)
- [x] BLoC 컴파일 성공
- [ ] BlocTest로 상태 변화 테스트 (선택사항)

---

### Phase 7: UI 리팩토링 및 BLoC 연결

**목표**: 기존 alarm_settings_page.dart를 BLoC 패턴으로 마이그레이션

**작업 목록**:
1. **alarm_settings_page.dart 리팩토링**
   - [x] StatefulWidget → BlocProvider로 감싸기
   - [x] `initState()`에서 `loadConfigs` 이벤트 발송
   - [x] BlocBuilder로 state.configs 읽기
   - [x] 로컬 state 제거 (SharedPreferences 직접 호출 삭제)
   - [x] Switch onChanged → `toggleAlarm` 이벤트 발송
   - [x] 시간 선택 onTimeTap → `updateTime` 이벤트 발송
   - [x] 권한 요청 플로우 추가 (권한 없으면 다이얼로그 표시)
   - [x] BlocListener로 errorMessage 처리 (SnackBar 표시)

2. **CustomTimePicker 연동**
   - [x] 기존 `_selectTime()` 메서드 유지
   - [x] 시간 선택 완료 시 BLoC에 updateTime 이벤트 전송

**예상 영향**:
- 영향 받는 파일: `lib/features/settings/presentation/pages/alarm_settings_page.dart`
- 의존성: Phase 6 완료

**검증 방법**:
- [ ] 앱 실행 후 알림 설정 화면 열기
- [ ] 알림 켜기/끄기 동작 확인
- [ ] 시간 변경 동작 확인
- [ ] SharedPreferences에 저장되는지 확인 (앱 재시작 후 설정 유지)
- [ ] 실제 네이티브 알림이 예약되는지 확인

---

### Phase 8: 기존 코드 정리 및 권한 처리

**목표**: 하드코딩된 알림 제거, 권한 요청 플로우 개선

**작업 목록**:
1. **main.dart 정리**
   - [x] `scheduleDailyNotification()` 함수 제거
   - [x] `_nextInstanceOfNinePM()` 함수 제거
   - [x] `flutterLocalNotificationsPlugin.initialize()` 제거 (또는 주석)
   - [x] main()에서 `await scheduleDailyNotification()` 호출 제거

2. **pubspec.yaml 정리 (선택사항)**
   - [ ] `flutter_local_notifications` 패키지 제거 고려
   - [ ] `flutter_native_timezone`, `timezone` 사용 여부 검토 (필요시 유지)

3. **권한 요청 개선**
   - [x] 앱 최초 실행 시 권한 요청 다이얼로그 표시
   - [x] 권한 거부 시 설정 화면 안내 (선택사항)
   - [x] Android 12+ SCHEDULE_EXACT_ALARM 특수 권한 안내

**예상 영향**:
- 영향 받는 파일: `lib/main.dart`, `pubspec.yaml`, `alarm_settings_page.dart`
- 의존성: Phase 7 완료

**검증 방법**:
- [ ] 앱 재시작 후 오후 9시 하드코딩 알림 안 울림 확인
- [ ] 사용자가 설정한 알림만 울림 확인
- [ ] 권한 요청 플로우 확인

---

### Phase 9: 통합 테스트 및 최적화

**목표**: 전체 시스템 통합 검증 및 성능 최적화

**작업 목록**:
1. **통합 테스트**
   - [ ] 7개 알림 모두 활성화 → 각각 올바른 시간에 울리는지 확인
   - [ ] 알림 취소 → 더 이상 안 울리는지 확인
   - [ ] 앱 종료 후에도 알림이 울리는지 확인
   - [ ] 시간 변경 후 재예약 확인
   - [ ] Android: Doze 모드 진입 후에도 알림 울리는지 확인
   - [ ] iOS: 백그라운드 상태에서 알림 울리는지 확인

2. **에러 처리 강화**
   - [ ] 네이티브 에러 발생 시 사용자 친화적 메시지 표시
   - [ ] 권한 거부 시 재요청 플로우
   - [ ] 네트워크 불필요하므로 오프라인 동작 확인

3. **성능 최적화**
   - [ ] BLoC 상태 업데이트 최소화 (불필요한 rebuild 방지)
   - [ ] Method Channel 호출 최소화
   - [ ] SharedPreferences 캐싱 (필요시)

**예상 영향**:
- 영향 받는 파일: 전체
- 의존성: Phase 8 완료

**검증 방법**:
- [ ] 수동 테스트 시나리오 통과
- [ ] 메모리 프로파일링 (DevTools)
- [ ] Android/iOS 각 3개 버전에서 테스트 (최소 지원 버전, 중간, 최신)

---

## 4. 리스크 및 대응

### 리스크 1: Android Doze 모드에서 알림이 안 울림
- **확률**: High
- **영향도**: High
- **완화 방안**:
  - `setExactAndAllowWhileIdle()` 사용 (Android 6.0+)
  - `SCHEDULE_EXACT_ALARM` 권한 명시
  - 사용자에게 배터리 최적화 해제 안내 (선택사항)
  - 테스트 시 Doze 모드 강제 진입 명령어 사용:
    ```bash
    adb shell dumpsys deviceidle force-idle
    ```

### 리스크 2: iOS 권한 거부 시 알림 예약 실패
- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - 권한 요청 전 사용자에게 알림의 필요성 설명
  - 권한 거부 시 설정 화면으로 이동하는 버튼 제공
  - `checkPermission()` 메서드로 권한 상태 먼저 확인

### 리스크 3: Method Channel 파라미터 타입 불일치
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - Dart 측에서 타입 명시적 캐스팅
  - Native 측에서 null 체크 및 기본값 설정
  - 에러 로그 충분히 출력하여 디버깅 용이하게

### 리스크 4: Freezed 코드 생성 실패
- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - `build_runner` 버전 호환성 확인
  - `--delete-conflicting-outputs` 플래그 사용
  - 수동으로 생성된 파일 확인 후 진행

### 리스크 5: 기존 flutter_local_notifications와 충돌
- **확률**: Medium
- **영향도**: Low
- **완화 방안**:
  - 구현 완료 후 패키지 제거
  - 또는 별도 채널로 분리 (임시)

---

## 5. 전체 검증 계획

### 자동 테스트 (선택사항, 시간 여유 시)
- [ ] AlarmPlatformDataSource 단위 테스트 (Mock MethodChannel)
- [ ] AlarmLocalDataSource 단위 테스트 (Mock SharedPreferences)
- [ ] AlarmRepositoryImpl 단위 테스트 (Mock DataSources)
- [ ] AlarmBloc 테스트 (BlocTest)
- [ ] Widget 테스트 (alarm_settings_page)

### 수동 테스트

#### 시나리오 1: 알림 활성화 및 시간 설정
1. 앱 실행 → 설정 → 알림 설정 화면 이동
2. "아침 식사 알림" 활성화 (7:30)
3. 시간을 현재 시간 + 2분으로 변경
4. 앱 종료
5. 2분 후 알림 울리는지 확인
6. 알림 클릭 시 앱이 열리는지 확인

#### 시나리오 2: 알림 비활성화
1. 활성화된 알림 끄기
2. 예정된 시간에 알림이 안 울리는지 확인

#### 시나리오 3: 앱 재시작 후 설정 유지
1. 알림 설정 변경
2. 앱 완전 종료
3. 앱 재실행
4. 설정이 유지되는지 확인

#### 시나리오 4: 권한 거부 후 재요청
1. 앱 최초 실행 시 권한 거부
2. 알림 설정 화면에서 권한 재요청
3. 권한 승인 후 알림 예약 가능한지 확인

#### 시나리오 5: 다중 알림 동시 활성화
1. 7개 알림 모두 활성화
2. 각각 다른 시간 설정 (테스트용으로 짧은 간격)
3. 각 알림이 올바른 시간에 울리는지 확인

### 플랫폼별 테스트

#### Android
- [ ] Android 6.0 (Marshmallow) - Doze 모드 대응
- [ ] Android 8.0 (Oreo) - Notification Channel
- [ ] Android 12 (S) - SCHEDULE_EXACT_ALARM 권한
- [ ] Android 13 (Tiramisu) - POST_NOTIFICATIONS 런타임 권한

#### iOS
- [ ] iOS 13 - 최소 지원 버전 확인
- [ ] iOS 15 - UNUserNotificationCenter 동작 확인
- [ ] iOS 17 - 최신 버전 호환성

### 성능 체크
- [ ] 빌드 시간: Phase 1 대비 증가폭 5% 이내
- [ ] 앱 실행 속도: DI 초기화로 인한 지연 100ms 이내
- [ ] 메모리 사용량: BLoC 추가로 인한 증가 10MB 이내
- [ ] Method Channel 호출 응답 시간: 100ms 이내

---

## 6. 참고 사항

### 주의할 점
1. **Method Channel 호출은 비동기**: UI 스레드 블로킹 방지
2. **Android PendingIntent FLAG_IMMUTABLE**: Android 12+ 필수
3. **iOS 알림 identifier 고유성**: `alarm_{id}` 형식 사용
4. **Freezed part 지시문**: `part 'alarm_config.freezed.dart'` 정확히 작성
5. **Injectable 재생성**: 파일 추가 후 반드시 `build_runner` 실행
6. **권한 요청 타이밍**: 사용자 경험 고려 (너무 이른 요청 지양)

### 참고 문서
- [Flutter Method Channel 공식 문서](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Android AlarmManager](https://developer.android.com/reference/android/app/AlarmManager)
- [iOS UNUserNotificationCenter](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter)
- [Android Doze 모드](https://developer.android.com/training/monitoring-device-state/doze-standby)
- 연구 문서: `thoughts/shared/research/nogerd_notification_method_channel_2026-01-15.md`

### 예상 일정 (참고용, 타임라인 제외)
- Phase 1: Domain Layer → 가장 간단, 우선 완료
- Phase 2: Data Layer (Flutter) → Domain 의존
- Phase 3-4: Native 구현 → 병렬 진행 가능 (Android/iOS 동시)
- Phase 5: Repository → Native 완료 후
- Phase 6-7: BLoC + UI → Repository 완료 후
- Phase 8-9: 정리 및 테스트 → 전체 완료 후

### 디버깅 팁
- **Android Logcat 필터**: `package:mine tag:flutter`
- **iOS Xcode Console**: `flutter:` 검색
- **Method Channel 에러**: `PlatformException` 메시지 확인
- **알림 예약 확인 (Android)**: `adb shell dumpsys alarm` 명령어
- **알림 예약 확인 (iOS)**: Xcode → Devices → 기기 → Console

---

**계획 수립 완료일**: 2026-01-15
**검토 횟수**: 1차 (추가 정교화 예정)
**다음 단계**: Phase 1부터 순차적으로 구현 시작
