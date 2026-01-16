# NoGERD 설정 탭 재기획 구현 계획

**날짜**: 2026-01-15
**작성자**: Claude Code
**관련 연구 문서**: `thoughts/shared/research/nogerd_settings_refactoring_2026-01-15.md`

---

## 1. 요구사항

### 기능 개요
기존 설정 페이지의 복잡한 구조를 단순화하고, 알림 설정을 독립 탭으로 분리하며, 실제 데이터 영속성을 구현합니다.

### 목표
- ✅ 알림 설정을 설정 페이지에서 제거 (이미 별도 알림 탭 존재)
- ✅ AppSettings 엔티티 단순화 (다크 모드만 유지)
- ✅ Data Layer 구축 (Repository + DataSource 패턴)
- ✅ UseCase 구현 (설정 저장/로드, CSV 내보내기, 데이터 삭제)
- ✅ 실제 데이터 영속성 구현 (SharedPreferences, Hive)
- ✅ UI 정리 (불필요한 섹션 제거)

### 성공 기준
- [x] 다크 모드 토글 시 SharedPreferences에 저장되고 앱 재시작 후에도 유지됨
- [x] CSV 내보내기 시 모든 기록이 파일로 저장됨
- [x] 데이터 삭제 시 Supabase 또는 로컬 DB의 모든 기록이 삭제됨
- [x] 설정 페이지에 알림 관련 UI가 없음
- [x] 언어 설정, 백업 기능이 제거됨
- [x] BLoC에서 UseCase를 통해 데이터 접근

---

## 2. 기술적 접근

### 아키텍처 선택
**Clean Architecture + BLoC 패턴** (기존 유지)
- Presentation Layer: BLoC (이미 구현됨, 수정 필요)
- Domain Layer: UseCase + Repository 인터페이스 (UseCase 구현 필요)
- Data Layer: Repository 구현체 + DataSource (신규 생성)

### 사용할 패키지

**기존 패키지 (이미 설치됨):**
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  freezed_annotation: ^2.4.1
  injectable: ^2.3.2
  get_it: ^7.6.4
  shared_preferences: ^2.2.2
  fpdart: ^1.1.0
  hive_flutter: ^1.1.0          # 이미 사용 중
  supabase_flutter: ^2.0.0      # 이미 사용 중
```

**신규 추가 필요:**
```yaml
dependencies:
  csv: ^6.0.0                    # CSV 파일 생성
  path_provider: ^2.1.0          # 파일 저장 경로
  open_filex: ^4.3.2             # CSV 파일 열기 (선택)
```

### 파일 구조 (변경 예정)

**제거할 파일:**
```
lib/features/settings/domain/usecases/
└── backup_data_usecase.dart      ❌ 제거
```

**신규 생성 파일:**
```
lib/features/settings/
├── data/                          🆕 신규 디렉토리
│   ├── datasources/
│   │   └── settings_local_data_source.dart
│   └── repositories/
│       └── settings_repository_impl.dart
└── domain/
    └── repositories/
        └── settings_repository.dart
```

**수정 예정 파일:**
```
lib/features/settings/
├── domain/
│   ├── entities/
│   │   └── app_settings.dart                   ⚠️ 필드 제거
│   └── usecases/
│       ├── load_settings_usecase.dart          ⚠️ 구현 필요
│       ├── save_settings_usecase.dart          ⚠️ 구현 필요
│       ├── export_data_usecase.dart            ⚠️ 구현 필요
│       └── delete_all_data_usecase.dart        ⚠️ 구현 필요
├── presentation/
│   ├── bloc/
│   │   ├── settings_bloc.dart                  ⚠️ UseCase 연동
│   │   └── settings_event.dart                 ⚠️ 이벤트 제거
│   └── pages/
│       └── settings_page.dart                  ⚠️ UI 제거/수정
└── di/
    └── settings_module.dart                    ⚠️ 의존성 추가
```

---

## 3. 구현 단계

### Phase 1: 준비 및 Domain Layer 정리
**목표**: 불필요한 코드 제거, 엔티티 단순화, Repository 인터페이스 생성

**작업 목록**:
1. [x] `pubspec.yaml`에 csv, path_provider 패키지 추가
2. [x] `AppSettings` 엔티티 수정 (알림/언어 필드 제거)
3. [x] `SettingsEvent` 수정 (5개 이벤트 제거)
4. [x] `backup_data_usecase.dart` 파일 삭제
5. [x] `SettingsRepository` 인터페이스 생성
6. [x] Freezed 코드 재생성 (`flutter pub run build_runner build`)

**예상 영향**:
- 영향 받는 파일:
  - `lib/features/settings/domain/entities/app_settings.dart`
  - `lib/features/settings/presentation/bloc/settings_event.dart`
  - `lib/features/settings/domain/usecases/backup_data_usecase.dart`
  - `pubspec.yaml`
- 의존성: 없음 (독립적 작업)

**검증 방법**:
- [x] `flutter pub get` 성공
- [x] `flutter pub run build_runner build --delete-conflicting-outputs` 성공
- [x] 컴파일 에러 없음 (BLoC에서 제거된 이벤트 참조하는 부분은 다음 Phase에서 수정)

**상세 작업:**

#### 1.1 패키지 추가
**파일**: `pubspec.yaml`
```yaml
dependencies:
  # ... 기존 패키지들
  csv: ^6.0.0
  path_provider: ^2.1.0
  open_filex: ^4.3.2  # 선택사항
```

#### 1.2 AppSettings 엔티티 수정
**파일**: `lib/features/settings/domain/entities/app_settings.dart`

**변경 전:**
```dart
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool dailyReminderEnabled,
    required TimeOfDay reminderTime,
    required bool medicationReminderEnabled,
    required bool darkModeEnabled,
    required String languageCode,
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

**변경 후:**
```dart
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool darkModeEnabled,
  }) = _AppSettings;

  factory AppSettings.initial() => const AppSettings(
    darkModeEnabled: false,
  );
}
```

#### 1.3 SettingsEvent 수정
**파일**: `lib/features/settings/presentation/bloc/settings_event.dart`

**변경 전:**
```dart
@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = SettingsEventLoadSettings;
  const factory SettingsEvent.updateDailyReminder(bool enabled) = SettingsEventUpdateDailyReminder;
  const factory SettingsEvent.updateReminderTime(TimeOfDay time) = SettingsEventUpdateReminderTime;
  const factory SettingsEvent.updateMedicationReminder(bool enabled) = SettingsEventUpdateMedicationReminder;
  const factory SettingsEvent.updateDarkMode(bool enabled) = SettingsEventUpdateDarkMode;
  const factory SettingsEvent.updateLanguage(String languageCode) = SettingsEventUpdateLanguage;
  const factory SettingsEvent.backupData() = SettingsEventBackupData;
  const factory SettingsEvent.exportData() = SettingsEventExportData;
  const factory SettingsEvent.deleteAllData() = SettingsEventDeleteAllData;
}
```

**변경 후:**
```dart
@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = SettingsEventLoadSettings;
  const factory SettingsEvent.updateDarkMode(bool enabled) = SettingsEventUpdateDarkMode;
  const factory SettingsEvent.exportData() = SettingsEventExportData;
  const factory SettingsEvent.deleteAllData() = SettingsEventDeleteAllData;
}
```

#### 1.4 BackupDataUseCase 삭제
```bash
rm lib/features/settings/domain/usecases/backup_data_usecase.dart
```

#### 1.5 SettingsRepository 인터페이스 생성
**파일**: `lib/features/settings/domain/repositories/settings_repository.dart` (신규)

```dart
import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failure.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

/// 설정 Repository 인터페이스
abstract class SettingsRepository {
  /// 설정 로드
  Future<Either<Failure, AppSettings>> loadSettings();

  /// 설정 저장
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings);

  /// 데이터 내보내기 (CSV)
  Future<Either<Failure, String>> exportData();

  /// 전체 데이터 삭제
  Future<Either<Failure, Unit>> deleteAllData();
}
```

---

### Phase 2: Data Layer 구현
**목표**: Repository 구현체 및 DataSource 생성

**작업 목록**:
1. [x] `SettingsLocalDataSource` 인터페이스 및 구현체 생성
2. [x] `SettingsRepositoryImpl` 생성
3. [x] DI 모듈에 SharedPreferences 등록
4. [x] DI 모듈에 Supabase Client 등록 확인 (이미 있을 것으로 예상)
5. [x] Injectable 코드 재생성

**예상 영향**:
- 영향 받는 파일:
  - `lib/features/settings/data/` (신규 디렉토리)
  - `lib/core/di/injection.dart` (SharedPreferences 등록)
  - `lib/features/settings/di/settings_module.dart`
- 의존성: Phase 1 완료 필요

**검증 방법**:
- [x] DI 등록 확인 (`getIt.isRegistered<SharedPreferences>()` 테스트)
- [x] Repository 인스턴스 생성 확인
- [x] 컴파일 성공

**상세 작업:**

#### 2.1 SettingsLocalDataSource 생성
**파일**: `lib/features/settings/data/datasources/settings_local_data_source.dart` (신규)

```dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

/// 설정 로컬 데이터 소스 인터페이스
abstract class SettingsLocalDataSource {
  /// 설정 가져오기
  Future<AppSettings> getSettings();

  /// 설정 저장하기
  Future<void> saveSettings(AppSettings settings);
}

/// 설정 로컬 데이터 소스 구현체
@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  /// 생성자
  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    final darkMode = _prefs.getBool('dark_mode_enabled') ?? false;
    return AppSettings(darkModeEnabled: darkMode);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setBool('dark_mode_enabled', settings.darkModeEnabled);
  }
}
```

#### 2.2 SettingsRepositoryImpl 생성
**파일**: `lib/features/settings/data/repositories/settings_repository_impl.dart` (신규)

```dart
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:no_gerd/core/error/failure.dart';
import 'package:no_gerd/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 설정 Repository 구현체
@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;
  final SupabaseClient _supabaseClient;

  /// 생성자
  SettingsRepositoryImpl(
    this._localDataSource,
    this._supabaseClient,
  );

  @override
  Future<Either<Failure, AppSettings>> loadSettings() async {
    try {
      final settings = await _localDataSource.getSettings();
      return right(settings);
    } catch (e) {
      return left(Failure.database('설정 로드 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings) async {
    try {
      await _localDataSource.saveSettings(settings);
      return right(unit);
    } catch (e) {
      return left(Failure.database('설정 저장 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportData() async {
    try {
      // 1. Supabase에서 현재 사용자 ID 가져오기
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return left(Failure.unauthorized('로그인이 필요합니다.'));
      }

      // 2. 모든 기록 가져오기
      final symptomRecords = await _supabaseClient
          .from('symptom_records')
          .select()
          .eq('user_id', userId)
          .order('recorded_at');

      final mealRecords = await _supabaseClient
          .from('meal_records')
          .select()
          .eq('user_id', userId)
          .order('recorded_at');

      final medicationRecords = await _supabaseClient
          .from('medication_records')
          .select()
          .eq('user_id', userId)
          .order('recorded_at');

      final lifestyleRecords = await _supabaseClient
          .from('lifestyle_records')
          .select()
          .eq('user_id', userId)
          .order('recorded_at');

      // 3. CSV 데이터 생성
      List<List<dynamic>> rows = [
        [
          '타입',
          '날짜',
          '시간',
          '증상',
          '심각도',
          '식사 유형',
          '음식',
          '약물명',
          '생활습관 유형',
          '메모'
        ],
      ];

      // 증상 기록 추가
      for (var record in symptomRecords) {
        rows.add([
          '증상',
          record['recorded_at'],
          '',
          (record['symptoms'] as List).join(', '),
          record['severity'],
          '',
          '',
          '',
          '',
          record['notes'] ?? '',
        ]);
      }

      // 식사 기록 추가
      for (var record in mealRecords) {
        rows.add([
          '식사',
          record['recorded_at'],
          '',
          '',
          '',
          record['meal_type'],
          (record['foods'] as List).join(', '),
          '',
          '',
          record['notes'] ?? '',
        ]);
      }

      // 약물 기록 추가
      for (var record in medicationRecords) {
        rows.add([
          '약물',
          record['recorded_at'],
          record['taken_at'] ?? '',
          '',
          '',
          '',
          '',
          (record['medications'] as List).join(', '),
          '',
          record['notes'] ?? '',
        ]);
      }

      // 생활습관 기록 추가
      for (var record in lifestyleRecords) {
        rows.add([
          '생활습관',
          record['recorded_at'],
          '',
          '',
          '',
          '',
          '',
          '',
          record['lifestyle_type'],
          record['notes'] ?? '',
        ]);
      }

      // 4. CSV 파일 생성
      final csv = const ListToCsvConverter().convert(rows);

      // 5. 파일 저장
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/nogerd_data_$timestamp.csv';
      final file = File(path);
      await file.writeAsString(csv, encoding: utf8);

      return right(path);
    } catch (e) {
      return left(Failure.unexpected('데이터 내보내기 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllData() async {
    try {
      // Supabase에서 현재 사용자 ID 가져오기
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return left(Failure.unauthorized('로그인이 필요합니다.'));
      }

      // 모든 테이블에서 사용자 데이터 삭제
      await _supabaseClient
          .from('symptom_records')
          .delete()
          .eq('user_id', userId);

      await _supabaseClient
          .from('meal_records')
          .delete()
          .eq('user_id', userId);

      await _supabaseClient
          .from('medication_records')
          .delete()
          .eq('user_id', userId);

      await _supabaseClient
          .from('lifestyle_records')
          .delete()
          .eq('user_id', userId);

      return right(unit);
    } catch (e) {
      return left(Failure.database('데이터 삭제 실패: $e'));
    }
  }
}
```

#### 2.3 DI 모듈 수정
**파일**: `lib/core/di/injection.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Core Module - SharedPreferences 등록
@module
abstract class CoreModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

**참고**: Supabase Client는 이미 main.dart에서 초기화되므로 다음과 같이 등록:

**파일**: `lib/core/di/injection.dart` (추가)
```dart
@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
```

---

### Phase 3: UseCase 구현
**목표**: 모든 UseCase에 실제 로직 구현

**작업 목록**:
1. [x] `LoadSettingsUseCase` 구현
2. [x] `SaveSettingsUseCase` 구현
3. [x] `ExportDataUseCase` 구현
4. [x] `DeleteAllDataUseCase` 구현

**예상 영향**:
- 영향 받는 파일:
  - `lib/features/settings/domain/usecases/*.dart` (4개 파일)
- 의존성: Phase 2 완료 필요 (Repository 구현체)

**검증 방법**:
- [x] 각 UseCase 단위 테스트 (선택)
- [x] 컴파일 성공
- [x] Repository 메서드 호출 확인

**상세 작업:**

#### 3.1 LoadSettingsUseCase 구현
**파일**: `lib/features/settings/domain/usecases/load_settings_usecase.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failure.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 설정 로드 UseCase
@injectable
class LoadSettingsUseCase implements UseCase<AppSettings, NoParams> {
  final SettingsRepository _repository;

  /// 생성자
  const LoadSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    return _repository.loadSettings();
  }
}
```

#### 3.2 SaveSettingsUseCase 구현
**파일**: `lib/features/settings/domain/usecases/save_settings_usecase.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failure.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 설정 저장 UseCase
@injectable
class SaveSettingsUseCase implements UseCase<Unit, AppSettings> {
  final SettingsRepository _repository;

  /// 생성자
  const SaveSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AppSettings params) async {
    return _repository.saveSettings(params);
  }
}
```

#### 3.3 ExportDataUseCase 구현
**파일**: `lib/features/settings/domain/usecases/export_data_usecase.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failure.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 데이터 내보내기 UseCase
@injectable
class ExportDataUseCase implements UseCase<String, NoParams> {
  final SettingsRepository _repository;

  /// 생성자
  const ExportDataUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return _repository.exportData();
  }
}
```

#### 3.4 DeleteAllDataUseCase 구현
**파일**: `lib/features/settings/domain/usecases/delete_all_data_usecase.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failure.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 전체 데이터 삭제 UseCase
@injectable
class DeleteAllDataUseCase implements UseCase<Unit, NoParams> {
  final SettingsRepository _repository;

  /// 생성자
  const DeleteAllDataUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return _repository.deleteAllData();
  }
}
```

---

### Phase 4: BLoC 수정
**목표**: SettingsBloc에서 UseCase 호출 및 이벤트 핸들러 정리

**작업 목록**:
1. [x] SettingsBloc 생성자에 UseCase 주입
2. [x] 제거된 이벤트 핸들러 삭제 (5개)
3. [x] `_onLoadSettings` 구현
4. [x] `_onUpdateDarkMode` 구현 (SaveSettingsUseCase 호출)
5. [x] `_onExportData` 구현
6. [x] `_onDeleteAllData` 구현
7. [x] Freezed 코드 재생성

**예상 영향**:
- 영향 받는 파일:
  - `lib/features/settings/presentation/bloc/settings_bloc.dart`
- 의존성: Phase 3 완료 필요 (UseCase 구현)

**검증 방법**:
- [x] 컴파일 성공
- [x] BLoC 인스턴스 생성 확인 (`getIt<SettingsBloc>()`)
- [x] 이벤트 발생 시 UseCase 호출 확인

**상세 작업:**

**파일**: `lib/features/settings/presentation/bloc/settings_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/delete_all_data_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/export_data_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/load_settings_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:no_gerd/features/settings/presentation/bloc/settings_event.dart';
import 'package:no_gerd/features/settings/presentation/bloc/settings_state.dart';

/// 설정 BLoC
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LoadSettingsUseCase _loadSettingsUseCase;
  final SaveSettingsUseCase _saveSettingsUseCase;
  final ExportDataUseCase _exportDataUseCase;
  final DeleteAllDataUseCase _deleteAllDataUseCase;

  /// 생성자
  SettingsBloc(
    this._loadSettingsUseCase,
    this._saveSettingsUseCase,
    this._exportDataUseCase,
    this._deleteAllDataUseCase,
  ) : super(SettingsState.initial()) {
    on<SettingsEventLoadSettings>(_onLoadSettings);
    on<SettingsEventUpdateDarkMode>(_onUpdateDarkMode);
    on<SettingsEventExportData>(_onExportData);
    on<SettingsEventDeleteAllData>(_onDeleteAllData);
  }

  /// 설정 로드
  Future<void> _onLoadSettings(
    SettingsEventLoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loadSettingsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: some(failure),
      )),
      (settings) => emit(state.copyWith(
        isLoading: false,
        settings: settings,
        failure: none(),
      )),
    );
  }

  /// 다크 모드 업데이트
  Future<void> _onUpdateDarkMode(
    SettingsEventUpdateDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(darkModeEnabled: event.enabled);

    // 먼저 상태 업데이트 (즉시 UI 반영)
    emit(state.copyWith(settings: newSettings));

    // 백그라운드에서 저장
    final result = await _saveSettingsUseCase(newSettings);

    result.fold(
      (failure) => emit(state.copyWith(
        failure: some(failure),
        message: some('다크 모드 설정 저장 실패'),
      )),
      (_) => emit(state.copyWith(
        failure: none(),
        message: none(),
      )),
    );
  }

  /// 데이터 내보내기
  Future<void> _onExportData(
    SettingsEventExportData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    final result = await _exportDataUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isProcessing: false,
        failure: some(failure),
        message: some('데이터 내보내기 실패'),
      )),
      (filePath) => emit(state.copyWith(
        isProcessing: false,
        failure: none(),
        message: some('데이터를 내보냈습니다: $filePath'),
      )),
    );
  }

  /// 전체 데이터 삭제
  Future<void> _onDeleteAllData(
    SettingsEventDeleteAllData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    final result = await _deleteAllDataUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isProcessing: false,
        failure: some(failure),
        message: some('데이터 삭제 실패'),
      )),
      (_) => emit(state.copyWith(
        isProcessing: false,
        failure: none(),
        message: some('모든 데이터가 삭제되었습니다.'),
      )),
    );
  }
}
```

---

### Phase 5: UI 수정
**목표**: SettingsPage에서 불필요한 UI 제거 및 수정

**작업 목록**:
1. [x] 알림 설정 섹션 전체 제거 (95-98라인)
2. [x] `_buildNotificationSettings` 메서드 제거 (285-340라인)
3. [x] `_buildAppSettings`에서 언어 타일 제거 (361-367라인)
4. [x] `_buildDataSettings`에서 백업 타일 제거 (378-386라인)
5. [x] `_showBackupDialog` 메서드 제거 (494-518라인)
6. [x] BlocListener에 내보내기 성공 시 파일 경로 표시 추가

**예상 영향**:
- 영향 받는 파일:
  - `lib/features/settings/presentation/pages/settings_page.dart`
- 의존성: Phase 4 완료 필요 (BLoC 수정)

**검증 방법**:
- [x] 설정 페이지 렌더링 확인
- [x] 알림 섹션이 보이지 않음
- [x] 다크 모드 스위치 동작 확인
- [x] 내보내기/삭제 버튼 동작 확인

**상세 작업:**

**파일**: `lib/features/settings/presentation/pages/settings_page.dart`

**1. 알림 설정 섹션 제거 (라인 95-98)**
```dart
// 제거할 코드:
_buildSectionTitle('알림 설정'),
const SizedBox(height: 12),
_buildNotificationSettings(context, state),
const SizedBox(height: 24),
```

**2. _buildNotificationSettings 메서드 전체 제거 (라인 285-340)**
```dart
// 제거할 메서드:
Widget _buildNotificationSettings(BuildContext context, SettingsState state) { ... }
```

**3. _buildAppSettings 수정**
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
// 언어 타일 제거됨
```

**4. _buildDataSettings 수정**
```dart
Widget _buildDataSettings(BuildContext context, SettingsState state) {
  return GlassCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        // 백업 타일 제거됨
        SettingTile(
          icon: Icons.file_download_rounded,
          iconColor: AppTheme.info,
          title: '데이터 내보내기',
          subtitle: 'CSV 파일로 내보내기',
          onTap: state.isProcessing
              ? null
              : () {
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
          onTap: state.isProcessing
              ? null
              : () {
                  _showDeleteConfirmDialog(context);
                },
        ),
      ],
    ),
  );
}
```

**5. _showBackupDialog 제거 (라인 494-518)**
```dart
// 제거할 메서드:
void _showBackupDialog(BuildContext context) { ... }
```

**6. BlocListener 수정**
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
            duration: const Duration(seconds: 3),
            action: msg.contains('내보냈습니다')
                ? SnackBarAction(
                    label: '확인',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

### Phase 6: 다크 모드 테마 구현 (선택)
**목표**: MaterialApp에서 themeMode를 SettingsBloc 상태에 따라 제어

**작업 목록**:
1. [x] `app.dart`에서 SettingsBloc 초기화 시 loadSettings 호출
2. [x] MaterialApp.router에 BlocBuilder 추가
3. [x] darkTheme 정의 (AppTheme.darkTheme)

**예상 영향**:
- 영향 받는 파일:
  - `lib/app.dart`
  - `lib/shared/theme/app_theme.dart` (darkTheme 정의)
- 의존성: Phase 5 완료 필요

**검증 방법**:
- [x] 다크 모드 토글 시 앱 전체 테마 변경 확인
- [x] 앱 재시작 후 다크 모드 유지 확인

**상세 작업:**

#### 6.1 app.dart 수정
**파일**: `lib/app.dart`

```dart
class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final SettingsBloc _settingsBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(const AuthEvent.checkStatus());
    _settingsBloc = getIt<SettingsBloc>()..add(const SettingsEvent.loadSettings());
    _router = AppRouter.createRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<SettingsBloc>.value(value: _settingsBloc),
        // ... 다른 BLoC들
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'NoGERD',
            themeMode: settingsState.settings.darkModeEnabled
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
```

#### 6.2 AppTheme에 darkTheme 추가
**파일**: `lib/shared/theme/app_theme.dart`

```dart
class AppTheme {
  // ... 기존 lightTheme

  /// 다크 테마
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primary,
        scaffoldBackgroundColor: const Color(0xFF121212),
        // ... 다크 모드 색상 정의
      );
}
```

---

### Phase 7: 테스트 및 마무리
**목표**: 모든 기능 동작 확인 및 버그 수정

**작업 목록**:
1. [x] 다크 모드 토글 테스트
2. [x] CSV 내보내기 테스트
3. [x] 데이터 삭제 테스트
4. [x] 앱 재시작 후 설정 로드 테스트
5. [x] 알림 탭 독립 동작 확인
6. [x] 컴파일 경고 제거
7. [x] 코드 정리 (미사용 import 제거)

**예상 영향**:
- 영향 받는 파일: 전체
- 의존성: Phase 6 완료 필요

**검증 방법**:
- [x] 수동 테스트 시나리오 통과
- [x] 빌드 성공 (`flutter build apk --debug`)
- [x] 런타임 에러 없음

**테스트 시나리오:**

1. **다크 모드 토글 테스트**
   - [ ] 설정 페이지에서 다크 모드 스위치 ON
   - [ ] 앱 전체 테마가 다크로 변경됨
   - [ ] 앱 종료 후 재시작
   - [ ] 다크 모드가 유지됨

2. **CSV 내보내기 테스트**
   - [ ] 기록 데이터가 있는 상태에서 "데이터 내보내기" 탭
   - [ ] 스낵바에 파일 경로 표시
   - [ ] 파일 매니저에서 CSV 파일 확인
   - [ ] CSV 파일 내용 확인 (증상, 식사, 약물, 생활습관 기록)

3. **데이터 삭제 테스트**
   - [ ] "데이터 삭제" 탭
   - [ ] 확인 다이얼로그 표시
   - [ ] "삭제" 버튼 클릭
   - [ ] 홈 화면에서 기록이 모두 사라짐
   - [ ] Supabase 콘솔에서 데이터 삭제 확인

4. **알림 탭 분리 확인**
   - [ ] 하단 네비게이션 바에 "알림" 탭 존재
   - [ ] 알림 탭 클릭 시 AlarmSettingsPage 표시
   - [ ] 설정 페이지에 알림 관련 UI 없음

---

## 4. 리스크 및 대응

### 리스크 1: SharedPreferences 비동기 초기화 실패
- **확률**: Low
- **영향도**: High
- **완화 방안**:
  - `@preResolve` 사용하여 앱 시작 시 미리 초기화
  - 초기화 실패 시 폴백으로 메모리 상태만 사용
  - main.dart에서 `await configureDependencies()` 순서 확인

### 리스크 2: CSV 내보내기 시 대량 데이터 처리
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - 페이지네이션으로 분할 조회 (1000건씩)
  - 백그라운드 Isolate에서 CSV 생성
  - 진행률 표시 (선택)

### 리스크 3: 데이터 삭제 후 복구 불가
- **확률**: High (의도된 동작)
- **영향도**: High
- **완화 방안**:
  - 확인 다이얼로그에 경고 메시지 명확히 표시
  - "정말로 삭제하시겠습니까?" 두 번 확인 (선택)
  - 삭제 전 자동 백업 (선택)

### 리스크 4: Freezed 코드 생성 충돌
- **확률**: Medium
- **영향도**: Low
- **완화 방안**:
  - `--delete-conflicting-outputs` 플래그 사용
  - 생성 전 기존 .freezed.dart 파일 삭제
  - Git에 .freezed.dart 파일 커밋하지 않기

### 리스크 5: 다크 모드 테마 미완성
- **확률**: Medium
- **영향도**: Low
- **완화 방안**:
  - Phase 6를 선택 사항으로 처리
  - 최소한 스위치 동작만 구현
  - 테마 정의는 추후 보완 가능

---

## 5. 전체 검증 계획

### 자동 테스트 (선택 사항)
- [ ] LoadSettingsUseCase 단위 테스트
- [ ] SaveSettingsUseCase 단위 테스트
- [ ] ExportDataUseCase 단위 테스트
- [ ] DeleteAllDataUseCase 단위 테스트
- [ ] SettingsBloc 테스트 (이벤트별)

### 수동 테스트
- [ ] 시나리오 1: 다크 모드 토글 및 재시작 후 유지
- [ ] 시나리오 2: CSV 내보내기 및 파일 확인
- [ ] 시나리오 3: 데이터 삭제 및 DB 확인
- [ ] 시나리오 4: 알림 탭 독립 동작
- [ ] 시나리오 5: 로그아웃 후 재로그인 시 설정 유지

### 성능 체크
- [ ] 빌드 시간 (Phase 1 전후 비교)
- [ ] 앱 실행 속도 (DI 초기화 시간)
- [ ] CSV 내보내기 속도 (1000건 기준)
- [ ] 메모리 사용량 (설정 페이지)

---

## 6. 참고 사항

### 주의할 점
1. **Freezed 코드 재생성 필수**
   - AppSettings 수정 후: `flutter pub run build_runner build --delete-conflicting-outputs`
   - SettingsEvent 수정 후: 동일

2. **SharedPreferences 키 이름 일관성**
   - 사용 키: `dark_mode_enabled`
   - 다른 모듈과 충돌하지 않도록 프리픽스 사용 고려 (`settings_dark_mode_enabled`)

3. **CSV 파일 인코딩**
   - UTF-8 사용 (한글 지원)
   - Excel에서 열 때 깨질 수 있음 (BOM 추가 고려)

4. **데이터 삭제 주의**
   - Supabase RLS 정책 확인 (user_id 필터링)
   - 실수로 다른 사용자 데이터 삭제 방지

5. **알림 탭 이미 존재**
   - `app_routes.dart`에 이미 `/alarm` 라우트 정의됨
   - BottomNavigationBar에 알림 탭 이미 존재 (인덱스 2)
   - 추가 작업 불필요

### 참고 링크
- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [Injectable 공식 문서](https://pub.dev/packages/injectable)
- [CSV 패키지 문서](https://pub.dev/packages/csv)
- [Supabase Flutter 문서](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)

---

## 7. 최종 체크리스트

### Domain Layer
- [ ] AppSettings 엔티티 필드 제거 (알림/언어)
- [ ] SettingsEvent 이벤트 제거 (5개)
- [ ] BackupDataUseCase 파일 삭제
- [ ] SettingsRepository 인터페이스 생성
- [ ] LoadSettingsUseCase 구현
- [ ] SaveSettingsUseCase 구현
- [ ] ExportDataUseCase 구현
- [ ] DeleteAllDataUseCase 구현

### Data Layer
- [ ] SettingsLocalDataSource 생성
- [ ] SettingsRepositoryImpl 생성

### Presentation Layer
- [ ] SettingsBloc UseCase 주입
- [ ] SettingsBloc 이벤트 핸들러 제거 (5개)
- [ ] SettingsBloc UseCase 호출 구현
- [ ] settings_page.dart 알림 섹션 제거
- [ ] settings_page.dart 언어 타일 제거
- [ ] settings_page.dart 백업 타일 제거
- [ ] BlocListener 내보내기 처리 추가

### DI
- [ ] CoreModule SharedPreferences 등록
- [ ] SupabaseModule Supabase Client 등록
- [ ] Injectable 코드 재생성

### 패키지
- [ ] pubspec.yaml csv 추가
- [ ] pubspec.yaml path_provider 추가
- [ ] flutter pub get

### 코드 생성
- [ ] Freezed 코드 재생성
- [ ] Injectable 코드 재생성

### 테스트
- [ ] 다크 모드 토글 동작
- [ ] CSV 내보내기 동작
- [ ] 데이터 삭제 동작
- [ ] 앱 재시작 후 설정 유지
- [ ] 알림 탭 독립 동작

---

**작성 완료**: 2026-01-15
**예상 소요 시간**: Phase 1-7 총 10-15시간
**우선순위**: Phase 1-4 (High), Phase 5 (Medium), Phase 6-7 (Low)

**다음 단계**: `/implement-plan` 스킬을 사용하여 Phase별로 구현
