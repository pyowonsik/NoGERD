# NoGERD 설정 탭 재기획 - 코드베이스 연구

**날짜**: 2026-01-15
**분석 대상**: Settings 모듈 전체 (재기획 대응)
**분석자**: Claude Code

---

## 1. 재기획 요구사항

### 변경 전 (현재 구조)
```
설정
├── 프로필 섹션 (로그아웃)
├── 알림 설정 (일일 기록, 알림 시간, 약 복용)
├── 앱 설정 (다크 모드, 언어)
├── 데이터 관리 (백업, 내보내기, 삭제)
├── 건강 정보 (역류성 식도염, 피해야 할 음식, 생활 수칙)
└── 앱 정보 (버전, 이용약관, 개인정보 처리방침, 문의하기)
```

### 변경 후 (재기획)
```
설정
├── 프로필 섹션 (로그아웃) ✅ 유지
├── [알림 설정 제거] → 별도 알림 탭으로 이동 ⚠️
├── 앱 설정 (다크 모드만 유지, 언어 제거) ⚠️
├── 데이터 관리 (백업 제거, 내보내기/삭제만 구현) ⚠️
├── 건강 정보 ✅ 유지
└── 앱 정보 ✅ 유지
```

---

## 2. 프로젝트 개요

**프로젝트명**: NoGERD (역류성 식도염 관리 앱)
**아키텍처**: Clean Architecture + BLoC 패턴
**상태 관리**: flutter_bloc + freezed
**DI**: injectable + get_it
**로컬 저장소**: SharedPreferences (Hive 마이그레이션 예정)

---

## 3. 현재 Settings 모듈 구조 분석

### 3.1 디렉토리 구조

```
lib/features/settings/
├── di/
│   └── settings_module.dart                    # DI 모듈 등록
├── domain/
│   ├── entities/
│   │   └── app_settings.dart                   # AppSettings 엔티티 (freezed)
│   └── usecases/
│       ├── load_settings_usecase.dart          # 설정 로드 (미완성)
│       ├── save_settings_usecase.dart          # 설정 저장 (미완성)
│       ├── backup_data_usecase.dart            # 백업 (미완성)
│       ├── export_data_usecase.dart            # CSV 내보내기 (미완성)
│       └── delete_all_data_usecase.dart        # 전체 삭제 (미완성)
└── presentation/
    ├── bloc/
    │   ├── settings_bloc.dart                  # BLoC 로직
    │   ├── settings_event.dart                 # 이벤트 정의
    │   └── settings_state.dart                 # 상태 정의
    ├── pages/
    │   ├── settings_page.dart                  # 메인 설정 페이지
    │   └── alarm_settings_page.dart            # 알림 설정 페이지 (StatefulWidget)
    └── widgets/
        └── setting_tile.dart                   # 재사용 UI 컴포넌트
```

**특징:**
- ✅ Presentation Layer: 완성도 높음
- ⚠️ Domain Layer: UseCase 구조만 존재, 실제 구현 미완성 (TODO)
- ❌ Data Layer: 미구현 (Repository, DataSource 없음)

---

## 4. 핵심 컴포넌트 분석

### 4.1 AppSettings 엔티티 (Domain)

**파일**: `lib/features/settings/domain/entities/app_settings.dart`

```dart
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool dailyReminderEnabled,        // ⚠️ 제거 대상 (알림 탭 이동)
    required TimeOfDay reminderTime,           // ⚠️ 제거 대상
    required bool medicationReminderEnabled,   // ⚠️ 제거 대상
    required bool darkModeEnabled,             // ✅ 유지 (앱 설정)
    required String languageCode,              // ⚠️ 제거 대상 (언어 설정 제외)
  }) = _AppSettings;

  factory AppSettings.initial() => const AppSettings(
    dailyReminderEnabled: true,
    reminderTime: TimeOfDay(hour: 21, minute: 0),
    medicationReminderEnabled: true,
    darkModeEnabled: false,
    languageCode: 'ko',
  );
}
```

**수정 방향:**
```dart
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool darkModeEnabled,             // ✅ 유지
    // 알림 관련 필드 모두 제거
    // languageCode 제거
  }) = _AppSettings;

  factory AppSettings.initial() => const AppSettings(
    darkModeEnabled: false,
  );
}
```

---

### 4.2 SettingsEvent (Presentation/BLoC)

**파일**: `lib/features/settings/presentation/bloc/settings_event.dart`

```dart
@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = SettingsEventLoadSettings;

  // ⚠️ 제거 대상 (알림 탭으로 이동)
  const factory SettingsEvent.updateDailyReminder(bool enabled) = ...;
  const factory SettingsEvent.updateReminderTime(TimeOfDay time) = ...;
  const factory SettingsEvent.updateMedicationReminder(bool enabled) = ...;

  // ✅ 유지
  const factory SettingsEvent.updateDarkMode(bool enabled) = ...;

  // ⚠️ 제거 대상
  const factory SettingsEvent.updateLanguage(String languageCode) = ...;
  const factory SettingsEvent.backupData() = ...;  // 백업 기능 제거

  // ✅ 구현 필요
  const factory SettingsEvent.exportData() = ...;  // CSV 내보내기
  const factory SettingsEvent.deleteAllData() = ...; // 전체 삭제
}
```

**수정 방향:**
```dart
@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = SettingsEventLoadSettings;
  const factory SettingsEvent.updateDarkMode(bool enabled) = SettingsEventUpdateDarkMode;
  const factory SettingsEvent.exportData() = SettingsEventExportData;
  const factory SettingsEvent.deleteAllData() = SettingsEventDeleteAllData;
}
```

---

### 4.3 SettingsState (Presentation/BLoC)

**파일**: `lib/features/settings/presentation/bloc/settings_state.dart`

```dart
@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required bool isLoading,              // 로딩 여부
    required bool isProcessing,           // 백업, 내보내기, 삭제 진행 중
    required AppSettings settings,        // 현재 설정값
    required Option<String> message,      // 성공/안내 메시지
    required Option<Failure> failure,     // 에러 정보
  }) = _SettingsState;
}
```

**수정 필요 여부**: ❌ 없음 (AppSettings 엔티티가 축소되면 자동으로 반영됨)

---

### 4.4 SettingsBloc (Presentation/BLoC)

**파일**: `lib/features/settings/presentation/bloc/settings_bloc.dart`

**현재 이벤트 핸들러:**
```dart
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<SettingsEventLoadSettings>(_onLoadSettings);           // ✅ 유지
    on<SettingsEventUpdateDailyReminder>(_onUpdateDailyReminder);     // ⚠️ 제거
    on<SettingsEventUpdateReminderTime>(_onUpdateReminderTime);       // ⚠️ 제거
    on<SettingsEventUpdateMedicationReminder>(_onUpdateMedicationReminder); // ⚠️ 제거
    on<SettingsEventUpdateDarkMode>(_onUpdateDarkMode);       // ✅ 유지
    on<SettingsEventUpdateLanguage>(_onUpdateLanguage);       // ⚠️ 제거
    on<SettingsEventBackupData>(_onBackupData);               // ⚠️ 제거
    on<SettingsEventExportData>(_onExportData);               // ✅ 구현 필요
    on<SettingsEventDeleteAllData>(_onDeleteAllData);         // ✅ 구현 필요
  }
}
```

**중요 문제점:**
```dart
Future<void> _onUpdateDarkMode(...) async {
  // TODO: SaveSettingsUseCase 호출 필요
  emit(state.copyWith(
    settings: state.settings.copyWith(darkModeEnabled: enabled),
  ));
}
```
- 현재 상태만 업데이트하고 **실제 저장 로직이 없음**
- UseCase가 구현되지 않아 **데이터 영속성 없음**

---

### 4.5 SettingsPage (Presentation/UI)

**파일**: `lib/features/settings/presentation/pages/settings_page.dart`

**현재 UI 섹션:**
```dart
Column(
  children: [
    _buildProfileSection(context),              // ✅ 유지

    _buildSectionTitle('알림 설정'),            // ⚠️ 전체 제거
    _buildNotificationSettings(context, state), // ⚠️ 전체 제거

    _buildSectionTitle('앱 설정'),              // ✅ 유지
    _buildAppSettings(context, state),          // ⚠️ 언어 항목만 제거

    _buildSectionTitle('데이터 관리'),          // ✅ 유지
    _buildDataSettings(context, state),         // ⚠️ 백업 항목 제거

    _buildSectionTitle('건강 정보'),            // ✅ 유지
    _buildHealthInfo(context),                  // ✅ 유지

    _buildSectionTitle('정보'),                 // ✅ 유지
    _buildAppInfo(context),                     // ✅ 유지
  ],
)
```

**제거할 위젯 메서드:**
```dart
Widget _buildNotificationSettings(BuildContext context, SettingsState state) {
  return GlassCard(
    child: Column(
      children: [
        SettingTile(title: '일일 기록 알림', ...),  // ⚠️ 제거
        SettingTile(title: '알림 시간', ...),       // ⚠️ 제거
        SettingTile(title: '약 복용 알림', ...),    // ⚠️ 제거
      ],
    ),
  );
}
```

**수정할 위젯 메서드:**
```dart
Widget _buildAppSettings(BuildContext context, SettingsState state) {
  return GlassCard(
    child: Column(
      children: [
        SettingTile(title: '다크 모드', ...),      // ✅ 유지
        SettingTile(title: '언어', ...),           // ⚠️ 제거
      ],
    ),
  );
}

Widget _buildDataSettings(BuildContext context, SettingsState state) {
  return GlassCard(
    child: Column(
      children: [
        SettingTile(title: '데이터 백업', ...),    // ⚠️ 제거
        SettingTile(title: '데이터 내보내기', ...), // ✅ 유지
        SettingTile(title: '데이터 삭제', ...),    // ✅ 유지
      ],
    ),
  );
}
```

---

### 4.6 AlarmSettingsPage (Presentation/UI)

**파일**: `lib/features/settings/presentation/pages/alarm_settings_page.dart`

**특징:**
- StatefulWidget으로 구현 (BLoC 미사용)
- SharedPreferences와 직접 연동
- 3개 섹션: 식사 알림, 약물 알림, 생활습관 알림

**재기획 대응:**
- 이 페이지는 **별도의 "알림 탭"**으로 이동 (GoRouter 라우트 추가)
- `settings_page.dart`에서 완전히 분리

**현재 네비게이션:**
```dart
// BottomNavigationBar에서 접근 필요
// 현재는 SettingsPage 내부에서 접근하지 않음 (독립적 페이지)
```

---

## 5. UseCase 계층 분석

### 5.1 현재 UseCase 목록

| UseCase | 역할 | 구현 상태 | 재기획 대응 |
|---------|------|-----------|-------------|
| LoadSettingsUseCase | 설정 로드 | TODO | ✅ 구현 필요 |
| SaveSettingsUseCase | 설정 저장 | TODO | ✅ 구현 필요 |
| BackupDataUseCase | 클라우드 백업 | TODO | ⚠️ 제거 |
| ExportDataUseCase | CSV 내보내기 | TODO | ✅ 구현 필요 |
| DeleteAllDataUseCase | 전체 데이터 삭제 | TODO | ✅ 구현 필요 |

### 5.2 구현 필요 UseCase 상세

#### a) LoadSettingsUseCase

**현재 코드:**
```dart
@injectable
class LoadSettingsUseCase implements UseCase<AppSettings, NoParams> {
  const LoadSettingsUseCase();

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    try {
      // TODO: SharedPreferences 또는 Hive에서 로드
      return right(AppSettings.initial());
    } catch (e) {
      return left(Failure.database('설정 로드 실패: $e'));
    }
  }
}
```

**구현 방향:**
```dart
@injectable
class LoadSettingsUseCase implements UseCase<AppSettings, NoParams> {
  final SharedPreferences _prefs;

  const LoadSettingsUseCase(this._prefs);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    try {
      final darkModeEnabled = _prefs.getBool('dark_mode_enabled') ?? false;

      return right(AppSettings(
        darkModeEnabled: darkModeEnabled,
      ));
    } catch (e) {
      return left(Failure.database('설정 로드 실패: $e'));
    }
  }
}
```

#### b) SaveSettingsUseCase

**구현 방향:**
```dart
@injectable
class SaveSettingsUseCase implements UseCase<Unit, AppSettings> {
  final SharedPreferences _prefs;

  const SaveSettingsUseCase(this._prefs);

  @override
  Future<Either<Failure, Unit>> call(AppSettings params) async {
    try {
      await _prefs.setBool('dark_mode_enabled', params.darkModeEnabled);
      return right(unit);
    } catch (e) {
      return left(Failure.database('설정 저장 실패: $e'));
    }
  }
}
```

#### c) ExportDataUseCase (CSV 내보내기)

**필요 패키지:**
```yaml
dependencies:
  csv: ^6.0.0
  path_provider: ^2.1.0
  permission_handler: ^11.0.0  # Android 저장소 권한
```

**구현 방향:**
```dart
@injectable
class ExportDataUseCase implements UseCase<String, NoParams> {
  final HiveBox<DailyRecord> _recordBox;  // Hive 박스 주입 필요

  const ExportDataUseCase(this._recordBox);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    try {
      // 1. 모든 기록 가져오기
      final records = _recordBox.values.toList();

      // 2. CSV 데이터 생성
      List<List<dynamic>> rows = [
        ['날짜', '증상', '식사', '약물', '생활습관', '메모'],
      ];

      for (var record in records) {
        rows.add([
          record.date.toIso8601String(),
          record.symptom?.toString() ?? '',
          record.meals.join(', '),
          record.medications.join(', '),
          record.lifestyle?.toString() ?? '',
          record.memo ?? '',
        ]);
      }

      // 3. CSV 파일 생성
      final csv = const ListToCsvConverter().convert(rows);

      // 4. 파일 저장
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/nogerd_data_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(path);
      await file.writeAsString(csv);

      return right(path);
    } catch (e) {
      return left(Failure.unexpected('데이터 내보내기 실패: $e'));
    }
  }
}
```

#### d) DeleteAllDataUseCase

**구현 방향:**
```dart
@injectable
class DeleteAllDataUseCase implements UseCase<Unit, NoParams> {
  final HiveBox<DailyRecord> _recordBox;

  const DeleteAllDataUseCase(this._recordBox);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      await _recordBox.clear();
      return right(unit);
    } catch (e) {
      return left(Failure.database('데이터 삭제 실패: $e'));
    }
  }
}
```

---

## 6. Data Layer 설계 (현재 미구현)

### 6.1 Repository 패턴 도입 필요

**새로 생성할 파일:**
```
lib/features/settings/
├── data/
│   ├── repositories/
│   │   └── settings_repository_impl.dart       # Repository 구현체
│   ├── datasources/
│   │   └── settings_local_data_source.dart     # SharedPreferences 래핑
│   └── models/
│       └── app_settings_model.dart             # JSON 직렬화 모델
└── domain/
    └── repositories/
        └── settings_repository.dart             # Repository 인터페이스
```

### 6.2 Repository 인터페이스 설계

**파일**: `lib/features/settings/domain/repositories/settings_repository.dart`

```dart
abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> loadSettings();
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings);
  Future<Either<Failure, String>> exportData();
  Future<Either<Failure, Unit>> deleteAllData();
}
```

### 6.3 DataSource 설계

**파일**: `lib/features/settings/data/datasources/settings_local_data_source.dart`

```dart
abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> setSettings(AppSettings settings);
}

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    final darkMode = _prefs.getBool('dark_mode_enabled') ?? false;
    return AppSettings(darkModeEnabled: darkMode);
  }

  @override
  Future<void> setSettings(AppSettings settings) async {
    await _prefs.setBool('dark_mode_enabled', settings.darkModeEnabled);
  }
}
```

---

## 7. DI 모듈 수정 필요사항

### 7.1 SharedPreferences 등록

**파일**: `lib/core/di/injection.dart`

```dart
@module
abstract class CoreModule {
  @preResolve  // 비동기 초기화
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

### 7.2 Hive 박스 등록 (데이터 내보내기/삭제용)

```dart
@module
abstract class DatabaseModule {
  @lazySingleton
  Box<DailyRecord> get recordBox => Hive.box<DailyRecord>('daily_records');
}
```

---

## 8. UI 수정 계획

### 8.1 제거할 코드 목록

**settings_page.dart:**
```dart
// 라인 95-98: 알림 설정 섹션 전체 제거
_buildSectionTitle('알림 설정'),
_buildNotificationSettings(context, state),

// 라인 285-340: _buildNotificationSettings 메서드 전체 제거
Widget _buildNotificationSettings(...) { ... }

// 라인 361-367: 언어 설정 타일 제거
SettingTile(
  icon: Icons.language_rounded,
  title: '언어',
  ...
),

// 라인 378-386: 데이터 백업 타일 제거
SettingTile(
  icon: Icons.cloud_upload_rounded,
  title: '데이터 백업',
  ...
),

// 라인 494-518: _showBackupDialog 메서드 제거
void _showBackupDialog(...) { ... }
```

### 8.2 수정할 코드

**settings_page.dart - _buildAppSettings:**
```dart
Widget _buildAppSettings(BuildContext context, SettingsState state) {
  return GlassCard(
    padding: EdgeInsets.zero,
    child: SettingTile(
      icon: Icons.dark_mode_rounded,
      iconColor: AppTheme.lifestyleColor,
      title: '다크 모드',
      subtitle: '어두운 테마 사용',
      trailing: Switch(
        value: state.settings.darkModeEnabled,
        onChanged: (v) => context
            .read<SettingsBloc>()
            .add(SettingsEvent.updateDarkMode(v)),
        activeColor: AppTheme.primary,
      ),
    ),
  );
}
```

**settings_page.dart - _buildDataSettings:**
```dart
Widget _buildDataSettings(BuildContext context, SettingsState state) {
  return GlassCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        SettingTile(
          icon: Icons.file_download_rounded,
          iconColor: AppTheme.info,
          title: '데이터 내보내기',
          subtitle: 'CSV 파일로 내보내기',
          onTap: () {
            context.read<SettingsBloc>().add(
                  const SettingsEvent.exportData(),
                );
          },
        ),
        const Divider(height: 1, indent: 56),
        SettingTile(
          icon: Icons.delete_outline_rounded,
          iconColor: AppTheme.error,
          title: '데이터 삭제',
          subtitle: '모든 기록 삭제',
          onTap: () {
            _showDeleteConfirmDialog(context);
          },
        ),
      ],
    ),
  );
}
```

### 8.3 BlocListener에 내보내기 성공 처리 추가

```dart
BlocListener<SettingsBloc, SettingsState>(
  listenWhen: (prev, curr) => prev.message != curr.message,
  listener: (context, state) {
    state.message.fold(
      () => null,
      (msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            action: msg.contains('내보내기')
                ? SnackBarAction(
                    label: '열기',
                    onPressed: () {
                      // TODO: 파일 열기 (OpenFile 패키지 사용)
                    },
                  )
                : null,
          ),
        );
      },
    );
  },
  child: ...,
)
```

---

## 9. 라우팅 변경 (알림 탭 분리)

### 9.1 GoRouter 라우트 추가

**파일**: `lib/core/router/app_router.dart` (추정)

```dart
final goRouter = GoRouter(
  routes: [
    // ... 기존 라우트들

    // 알림 설정 페이지를 독립 탭으로
    GoRoute(
      path: '/alarms',
      name: 'alarms',
      builder: (context, state) => const AlarmSettingsPage(),
    ),
  ],
);
```

### 9.2 BottomNavigationBar 탭 구성 변경

```dart
// 기존 (추정)
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icons.home, label: '홈'),
    BottomNavigationBarItem(icon: Icons.calendar_today, label: '기록'),
    BottomNavigationBarItem(icon: Icons.settings, label: '설정'),
  ],
)

// 변경 후
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icons.home, label: '홈'),
    BottomNavigationBarItem(icon: Icons.calendar_today, label: '기록'),
    BottomNavigationBarItem(icon: Icons.notifications, label: '알림'),  // 신규
    BottomNavigationBarItem(icon: Icons.settings, label: '설정'),
  ],
)
```

---

## 10. 구현 순서 (추천)

### Phase 1: 준비 단계
1. ✅ `AppSettings` 엔티티에서 알림/언어 필드 제거
2. ✅ `SettingsEvent`에서 불필요한 이벤트 제거
3. ✅ `BackupDataUseCase` 파일 삭제

### Phase 2: Data Layer 구현
4. ✅ `SettingsRepository` 인터페이스 생성
5. ✅ `SettingsLocalDataSource` 구현
6. ✅ `SettingsRepositoryImpl` 구현
7. ✅ DI 모듈에 SharedPreferences 등록
8. ✅ Hive 박스 DI 등록 (데이터 내보내기/삭제용)

### Phase 3: UseCase 구현
9. ✅ `LoadSettingsUseCase` 구현 (SharedPreferences 연동)
10. ✅ `SaveSettingsUseCase` 구현
11. ✅ `ExportDataUseCase` 구현 (CSV 생성)
12. ✅ `DeleteAllDataUseCase` 구현

### Phase 4: BLoC 수정
13. ✅ `SettingsBloc`에서 UseCase 호출 로직 추가
14. ✅ 이벤트 핸들러에서 실제 저장/로드 연동
15. ✅ 내보내기 성공 시 파일 경로 메시지 처리

### Phase 5: UI 수정
16. ✅ `settings_page.dart`에서 알림 섹션 제거
17. ✅ `_buildAppSettings`에서 언어 타일 제거
18. ✅ `_buildDataSettings`에서 백업 타일 제거
19. ✅ BlocListener에 내보내기 성공 처리 추가

### Phase 6: 라우팅 변경
20. ✅ GoRouter에 알림 탭 라우트 추가
21. ✅ BottomNavigationBar 탭 항목 추가
22. ✅ 알림 페이지 접근 테스트

### Phase 7: 테스트 및 마무리
23. ✅ 다크 모드 토글 동작 확인
24. ✅ 데이터 내보내기 CSV 생성 확인
25. ✅ 데이터 삭제 동작 확인
26. ✅ 앱 재시작 시 설정 로드 확인

---

## 11. 주의사항 및 리스크

### 11.1 다크 모드 구현 시 고려사항

**현재 AppTheme:**
```dart
class AppTheme {
  static const Color primary = Color(0xFF6366F1);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color background = Color(0xFFF9FAFB);
  // ...
}
```

**다크 모드 구현 방식:**

**방식 1: MaterialApp에서 themeMode 제어 (권장)**
```dart
// main.dart
BlocProvider<SettingsBloc>(
  create: (_) => getIt<SettingsBloc>()..add(const SettingsEvent.loadSettings()),
  child: BlocBuilder<SettingsBloc, SettingsState>(
    builder: (context, state) {
      return MaterialApp.router(
        themeMode: state.settings.darkModeEnabled
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: ThemeData.light().copyWith(...),
        darkTheme: ThemeData.dark().copyWith(...),
        routerConfig: goRouter,
      );
    },
  ),
)
```

**방식 2: AppTheme에서 동적 색상 제공**
```dart
class AppTheme {
  static Color getTextPrimary(BuildContext context) {
    final isDark = context.read<SettingsBloc>().state.settings.darkModeEnabled;
    return isDark ? Colors.white : Color(0xFF1F2937);
  }
}
```

### 11.2 CSV 내보내기 권한 처리

**Android 13 이상:**
```dart
// Android 13+ 는 MANAGE_EXTERNAL_STORAGE 불필요
// getApplicationDocumentsDirectory()로 충분
```

**Android 12 이하:**
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="32" />
```

### 11.3 Hive 박스 의존성

**주의:** `ExportDataUseCase`와 `DeleteAllDataUseCase`는 Hive 박스에 의존합니다.

**필요한 Hive 박스:**
```dart
Box<DailyRecord> recordBox = Hive.box<DailyRecord>('daily_records');
```

**DI 등록 시점:**
```dart
// main.dart
await Hive.initFlutter();
Hive.registerAdapter(DailyRecordAdapter());
await Hive.openBox<DailyRecord>('daily_records');

await configureDependencies();  // 이후에 DI 초기화
```

---

## 12. 테스트 계획

### 12.1 단위 테스트

```dart
// test/features/settings/domain/usecases/save_settings_usecase_test.dart
void main() {
  late SaveSettingsUseCase useCase;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    useCase = SaveSettingsUseCase(mockPrefs);
  });

  test('다크 모드 설정이 SharedPreferences에 저장되어야 함', () async {
    // Arrange
    final settings = AppSettings(darkModeEnabled: true);
    when(() => mockPrefs.setBool('dark_mode_enabled', true))
        .thenAnswer((_) async => true);

    // Act
    final result = await useCase(settings);

    // Assert
    expect(result.isRight(), true);
    verify(() => mockPrefs.setBool('dark_mode_enabled', true)).called(1);
  });
}
```

### 12.2 통합 테스트

```dart
// integration_test/settings_flow_test.dart
void main() {
  testWidgets('설정 페이지에서 다크 모드를 토글하면 저장되어야 함', (tester) async {
    await tester.pumpWidget(const MyApp());

    // 설정 탭 이동
    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();

    // 다크 모드 스위치 찾기
    final darkModeSwitch = find.byType(Switch).first;

    // 스위치 토글
    await tester.tap(darkModeSwitch);
    await tester.pumpAndSettle();

    // 앱 재시작 후 설정 유지 확인
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(darkModeSwitch).value, true);
  });
}
```

---

## 13. 마이그레이션 체크리스트

### Domain Layer
- [ ] `AppSettings` 엔티티에서 알림/언어 필드 제거
- [ ] `SettingsEvent`에서 5개 이벤트 제거
- [ ] `BackupDataUseCase` 파일 삭제
- [ ] `SettingsRepository` 인터페이스 생성
- [ ] `LoadSettingsUseCase` 구현
- [ ] `SaveSettingsUseCase` 구현
- [ ] `ExportDataUseCase` 구현 (CSV)
- [ ] `DeleteAllDataUseCase` 구현

### Data Layer
- [ ] `SettingsLocalDataSource` 생성
- [ ] `SettingsRepositoryImpl` 생성
- [ ] `AppSettingsModel` 생성 (JSON 직렬화)

### Presentation Layer
- [ ] `SettingsBloc`에서 5개 이벤트 핸들러 제거
- [ ] `SettingsBloc`에 UseCase 호출 로직 추가
- [ ] `settings_page.dart`에서 알림 섹션 제거
- [ ] `_buildAppSettings`에서 언어 타일 제거
- [ ] `_buildDataSettings`에서 백업 타일 제거
- [ ] BlocListener에 내보내기 성공 처리 추가

### DI
- [ ] `CoreModule`에 SharedPreferences 등록
- [ ] `DatabaseModule`에 Hive 박스 등록

### Routing
- [ ] GoRouter에 `/alarms` 라우트 추가
- [ ] BottomNavigationBar에 알림 탭 추가

### Testing
- [ ] LoadSettingsUseCase 단위 테스트
- [ ] SaveSettingsUseCase 단위 테스트
- [ ] ExportDataUseCase 단위 테스트
- [ ] DeleteAllDataUseCase 단위 테스트
- [ ] 다크 모드 토글 통합 테스트
- [ ] 데이터 내보내기 통합 테스트

---

## 14. 참고 자료

### 관련 파일 경로
```
lib/features/settings/
├── domain/entities/app_settings.dart:15              # AppSettings 엔티티
├── presentation/bloc/settings_event.dart:7           # SettingsEvent
├── presentation/bloc/settings_state.dart:7           # SettingsState
├── presentation/bloc/settings_bloc.dart:11           # SettingsBloc
├── presentation/pages/settings_page.dart:14          # SettingsPage
├── presentation/pages/alarm_settings_page.dart:13    # AlarmSettingsPage
├── domain/usecases/load_settings_usecase.dart:8      # LoadSettingsUseCase
├── domain/usecases/save_settings_usecase.dart:8      # SaveSettingsUseCase
├── domain/usecases/export_data_usecase.dart:8        # ExportDataUseCase
└── domain/usecases/delete_all_data_usecase.dart:8    # DeleteAllDataUseCase
```

### 패키지 의존성
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  freezed_annotation: ^2.4.1
  injectable: ^2.3.2
  get_it: ^7.6.4
  shared_preferences: ^2.2.2
  fpdart: ^1.1.0
  csv: ^6.0.0                  # CSV 생성 (신규)
  path_provider: ^2.1.0        # 파일 경로 (신규)

dev_dependencies:
  freezed: ^2.4.5
  build_runner: ^2.4.6
  injectable_generator: ^2.4.1
```

---

## 15. 최종 정리

### 핵심 변경 사항
1. **알림 설정 분리**: SettingsPage → 독립 알림 탭
2. **AppSettings 축소**: 5개 필드 → 1개 필드 (darkModeEnabled만)
3. **데이터 관리 단순화**: 백업 제거, 내보내기/삭제만 유지
4. **Data Layer 구축**: Repository + DataSource 패턴 도입
5. **UseCase 구현**: SharedPreferences, Hive, CSV 파일 연동

### 예상 소요 시간 (개발 시간 기준)
- Phase 1-2 (준비 + Data Layer): 2-3시간
- Phase 3 (UseCase 구현): 3-4시간
- Phase 4 (BLoC 수정): 1-2시간
- Phase 5-6 (UI + 라우팅): 2-3시간
- Phase 7 (테스트): 2-3시간
- **총 예상**: 10-15시간

### 우선순위 (리스크 기준)
1. **High**: Data Layer 구축 (모든 기능의 기반)
2. **High**: UseCase 구현 (데이터 영속성 필수)
3. **Medium**: UI 수정 (사용자 경험 개선)
4. **Low**: 라우팅 변경 (알림 탭 분리)

---

**작성 완료**: 2026-01-15
**다음 단계**: `/create-plan` 스킬을 사용하여 구현 계획 수립
