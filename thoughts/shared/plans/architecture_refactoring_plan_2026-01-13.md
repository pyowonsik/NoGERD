# NoGERD 아키텍처 리팩토링 구현 계획

**날짜**: 2026-01-13
**작성자**: Claude
**관련 연구 문서**: `thoughts/shared/research/kobic_architecture_analysis_2026-01-13.md`

---

## 1. 요구사항

### 기능 개요
KOBIC 프로젝트의 아키텍처 패턴을 참고하여 NoGERD 프로젝트를 리팩토링합니다.
- Clean Architecture 적용
- BLoC 상태 관리 도입
- GetIt + Injectable DI 설정
- Either<Failure, T> 에러 처리 패턴

### 목표
- 유지보수성 향상
- 테스트 가능성 확보
- 일관된 코드 구조
- 확장 가능한 Feature 기반 아키텍처

### 성공 기준
- [ ] 모든 Feature가 Clean Architecture 레이어 분리
- [ ] BLoC으로 상태 관리 통일
- [ ] Injectable로 DI 자동화
- [ ] Failure 기반 에러 처리 적용
- [ ] 기존 UI 기능 유지 (회귀 없음)

---

## 2. 기술적 접근

### 현재 상태 분석

```
현재 구조:
lib/
├── features/gerd_record/         # 기존 Clean Architecture (부분)
│   ├── data/                     # ✅ 유지
│   └── domain/                   # ✅ 유지
├── screens/                      # 새로운 UI (setState 기반)
│   ├── home/
│   ├── calendar/
│   ├── insights/
│   ├── settings/
│   ├── record/
│   └── theme/
├── injection.dart                # GetIt (수동 등록)
└── main.dart
```

### 목표 구조

```
lib/
├── core/
│   ├── di/
│   │   ├── injection.dart        # @InjectableInit
│   │   └── injection.config.dart # 생성됨
│   ├── error/
│   │   ├── failures.dart         # Failure 클래스들
│   │   └── exceptions.dart       # Exception 클래스들
│   ├── usecase/
│   │   └── usecase.dart          # 기본 UseCase 인터페이스
│   └── utils/
│       └── extensions.dart       # 유틸리티 확장
│
├── features/
│   ├── home/
│   │   ├── di/
│   │   │   └── home_module.dart  # @module
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── home_bloc.dart
│   │       │   ├── home_event.dart
│   │       │   └── home_state.dart
│   │       ├── pages/
│   │       │   └── home_page.dart
│   │       └── widgets/
│   │           ├── health_score_card.dart
│   │           ├── today_summary_card.dart
│   │           └── ...
│   │
│   ├── record/
│   │   ├── di/
│   │   │   └── record_module.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── record_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── record_model.dart
│   │   │   └── repositories/
│   │   │       └── record_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── symptom_record.dart
│   │   │   │   ├── meal_record.dart
│   │   │   │   ├── medication_record.dart
│   │   │   │   └── lifestyle_record.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_record_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_symptom_record_usecase.dart
│   │   │       ├── get_records_by_date_usecase.dart
│   │   │       └── ...
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── record_bloc.dart
│   │       ├── pages/
│   │       │   ├── symptom_record_page.dart
│   │       │   ├── meal_record_page.dart
│   │       │   └── ...
│   │       └── widgets/
│   │
│   ├── calendar/
│   │   ├── di/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── get_records_for_month_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │
│   ├── insights/
│   │   ├── di/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── calculate_health_score_usecase.dart
│   │   │       ├── analyze_triggers_usecase.dart
│   │   │       └── get_symptom_trends_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │
│   └── settings/
│       ├── di/
│       └── presentation/
│           ├── bloc/
│           └── pages/
│
├── shared/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   ├── cards/
│   │   ├── buttons/
│   │   └── inputs/
│   └── constants/
│       └── gerd_constants.dart   # 증상, 트리거 음식 등
│
├── app.dart                      # MaterialApp + MultiBlocProvider
└── main.dart                     # 부트스트랩
```

### 추가할 패키지

```yaml
dependencies:
  # 상태 관리
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4

  # DI 코드 생성
  injectable: ^2.4.4

  # 함수형 에러 처리
  fpdart: ^1.1.0

  # 이미 있음 (유지)
  freezed_annotation: ^2.4.1
  get_it: ^8.0.3

dev_dependencies:
  # DI 코드 생성
  injectable_generator: ^2.6.2

  # BLoC 테스트
  bloc_test: ^9.1.7

  # 이미 있음 (유지)
  build_runner: ^2.4.8
  freezed: ^2.5.2
```

---

## 3. 구현 단계

### Phase 1: 기반 설정 (Core Layer)
**목표**: 핵심 인프라 및 의존성 설정

**작업 목록**:
- [ ] 1.1. pubspec.yaml에 새 패키지 추가
- [ ] 1.2. `lib/core/di/` 폴더 생성 및 Injectable 설정
- [ ] 1.3. `lib/core/error/failures.dart` - Failure 클래스 정의
- [ ] 1.4. `lib/core/error/exceptions.dart` - Exception 클래스 정의
- [ ] 1.5. `lib/core/usecase/usecase.dart` - 기본 UseCase 인터페이스
- [ ] 1.6. build_runner 실행하여 DI 코드 생성

**상세 구현**:

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();
```

```dart
// lib/core/error/failures.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.database(String message) = DatabaseFailure;
  const factory Failure.validation(String message) = ValidationFailure;
  const factory Failure.notFound(String message) = NotFoundFailure;
  const factory Failure.unexpected(String message) = UnexpectedFailure;
}
```

```dart
// lib/core/usecase/usecase.dart
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
```

**예상 영향**:
- 영향 받는 파일: `pubspec.yaml`, `lib/core/` (새 폴더)
- 의존성: 없음

**검증 방법**:
- [ ] `flutter pub get` 성공
- [ ] `dart run build_runner build` 성공
- [ ] `injection.config.dart` 생성 확인

---

### Phase 2: Shared 레이어 정리
**목표**: 공유 리소스 구조화

**작업 목록**:
- [ ] 2.1. `lib/shared/theme/` - 기존 app_theme.dart 이동
- [ ] 2.2. `lib/shared/widgets/` - 기존 공통 위젯 이동
- [ ] 2.3. `lib/shared/constants/gerd_constants.dart` - 상수 정리
- [ ] 2.4. 기존 `screens/theme/`, `screens/widgets/` 경로 참조 업데이트

**파일 이동 매핑**:
```
screens/theme/app_theme.dart → shared/theme/app_theme.dart
screens/widgets/cards/ → shared/widgets/cards/
screens/widgets/buttons/ → shared/widgets/buttons/
screens/widgets/inputs/ → shared/widgets/inputs/
```

**예상 영향**:
- 영향 받는 파일: 모든 위젯 import 경로
- 의존성: Phase 1 완료

**검증 방법**:
- [ ] 모든 import 경로 에러 없음
- [ ] 앱 빌드 성공

---

### Phase 3: Home Feature 구현 (BLoC 적용)
**목표**: 첫 번째 Feature에 BLoC 패턴 적용

**작업 목록**:
- [ ] 3.1. `lib/features/home/` 폴더 구조 생성
- [ ] 3.2. HomeBloc, HomeEvent, HomeState 생성 (Freezed)
- [ ] 3.3. 기존 home_screen.dart → home_page.dart 마이그레이션
- [ ] 3.4. 위젯들 이동 및 BlocBuilder 적용
- [ ] 3.5. DI 모듈 등록

**상세 구현**:

```dart
// lib/features/home/presentation/bloc/home_event.dart
part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = HomeEventStarted;
  const factory HomeEvent.refreshed() = HomeEventRefreshed;
  const factory HomeEvent.dateChanged(DateTime date) = HomeEventDateChanged;
}
```

```dart
// lib/features/home/presentation/bloc/home_state.dart
part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool isLoading,
    required int healthScore,
    required int previousScore,
    required List<RecordSummary> todaySummary,
    required List<RecentRecord> recentRecords,
    required Option<Failure> failure,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
    isLoading: false,
    healthScore: 0,
    previousScore: 0,
    todaySummary: [],
    recentRecords: [],
    failure: none(),
  );
}
```

```dart
// lib/features/home/presentation/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEventStarted>(_onStarted);
    on<HomeEventRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    HomeEventStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    // 데이터 로드 로직
    emit(state.copyWith(
      isLoading: false,
      healthScore: 78,
      previousScore: 72,
    ));
  }

  Future<void> _onRefreshed(
    HomeEventRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    // 새로고침 로직
  }
}
```

**예상 영향**:
- 영향 받는 파일: `lib/features/home/`, `lib/app.dart`
- 의존성: Phase 1, 2 완료

**검증 방법**:
- [ ] HomeBloc 단위 테스트 통과
- [ ] 홈 화면 UI 정상 동작
- [ ] BlocProvider 연결 확인

---

### Phase 4: Record Feature 구현 (Full Clean Architecture)
**목표**: 완전한 Clean Architecture 적용

**작업 목록**:
- [ ] 4.1. Entity 정의 (SymptomRecord, MealRecord, MedicationRecord, LifestyleRecord)
- [ ] 4.2. Repository Interface 정의 (IRecordRepository)
- [ ] 4.3. Repository Implementation 구현
- [ ] 4.4. UseCase 구현 (AddRecord, GetRecords, DeleteRecord, UpdateRecord)
- [ ] 4.5. RecordBloc 구현
- [ ] 4.6. 기존 quick_record_modal.dart 내 화면들 분리 및 마이그레이션
- [ ] 4.7. DI 모듈 등록

**Entity 설계**:

```dart
// lib/features/record/domain/entities/symptom_record.dart
@freezed
class SymptomRecord with _$SymptomRecord {
  const factory SymptomRecord({
    required String id,
    required DateTime recordedAt,
    required List<GerdSymptom> symptoms,
    required int severity,
    String? notes,
  }) = _SymptomRecord;
}

// lib/features/record/domain/entities/meal_record.dart
@freezed
class MealRecord with _$MealRecord {
  const factory MealRecord({
    required String id,
    required DateTime recordedAt,
    required MealType mealType,
    required List<String> foods,
    required List<TriggerFoodCategory> triggers,
    String? notes,
  }) = _MealRecord;
}
```

**Repository Interface**:

```dart
// lib/features/record/domain/repositories/i_record_repository.dart
abstract class IRecordRepository {
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(DateTime date);
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record);
  Future<Either<Failure, List<MealRecord>>> getMealRecords(DateTime date);
  Future<Either<Failure, Unit>> addMealRecord(MealRecord record);
  // ... 더 많은 메서드
}
```

**예상 영향**:
- 영향 받는 파일: `lib/features/record/`
- 의존성: Phase 3 완료

**검증 방법**:
- [ ] 모든 UseCase 단위 테스트
- [ ] Repository 모킹 테스트
- [ ] 기록 저장/조회 E2E 테스트

---

### Phase 5: Calendar Feature 구현
**목표**: 캘린더 기능 BLoC 적용

**작업 목록**:
- [ ] 5.1. CalendarBloc 구현 (날짜 선택, 기록 로드)
- [ ] 5.2. GetRecordsForMonth UseCase 구현
- [ ] 5.3. 기존 calendar_screen.dart 마이그레이션
- [ ] 5.4. DI 등록

**예상 영향**:
- 영향 받는 파일: `lib/features/calendar/`
- 의존성: Phase 4 완료 (Record Repository 사용)

**검증 방법**:
- [ ] 날짜 선택 시 해당 날짜 기록 표시
- [ ] 월 이동 시 데이터 로드

---

### Phase 6: Insights Feature 구현
**목표**: 분석/인사이트 기능 구현

**작업 목록**:
- [ ] 6.1. InsightsBloc 구현
- [ ] 6.2. UseCase 구현
  - CalculateHealthScoreUseCase
  - AnalyzeTriggersUseCase
  - GetSymptomTrendsUseCase
  - GetWeeklyPatternUseCase
- [ ] 6.3. 기존 insights_screen.dart 마이그레이션
- [ ] 6.4. DI 등록

**예상 영향**:
- 영향 받는 파일: `lib/features/insights/`
- 의존성: Phase 4 완료

**검증 방법**:
- [ ] 건강 점수 계산 로직 테스트
- [ ] 트리거 분석 알고리즘 테스트
- [ ] 차트 데이터 정확성 확인

---

### Phase 7: Settings Feature 구현
**목표**: 설정 기능 BLoC 적용

**작업 목록**:
- [ ] 7.1. SettingsBloc 구현
- [ ] 7.2. 알림 설정 UseCase
- [ ] 7.3. 데이터 관리 UseCase (백업, 내보내기, 삭제)
- [ ] 7.4. 기존 settings_screen.dart 마이그레이션
- [ ] 7.5. DI 등록

**예상 영향**:
- 영향 받는 파일: `lib/features/settings/`
- 의존성: Phase 1 완료

**검증 방법**:
- [ ] 설정 변경 사항 저장 확인
- [ ] 데이터 내보내기 기능 테스트

---

### Phase 8: App 통합 및 라우팅
**목표**: 전체 앱 통합

**작업 목록**:
- [ ] 8.1. `lib/app.dart` 생성 - MultiBlocProvider 설정
- [ ] 8.2. 라우팅 구조 정리 (go_router 활용)
- [ ] 8.3. `lib/main.dart` 리팩토링 - 부트스트랩 로직
- [ ] 8.4. 기존 screens/ 폴더 삭제
- [ ] 8.5. 기존 features/gerd_record/ 폴더 통합 또는 삭제

**App 구조**:

```dart
// lib/app.dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeBloc>()),
        BlocProvider(create: (_) => getIt<RecordBloc>()),
        BlocProvider(create: (_) => getIt<CalendarBloc>()),
        BlocProvider(create: (_) => getIt<InsightsBloc>()),
        BlocProvider(create: (_) => getIt<SettingsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'NoGERD',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
```

**예상 영향**:
- 영향 받는 파일: 전체 앱 구조
- 의존성: Phase 1-7 완료

**검증 방법**:
- [ ] 모든 화면 네비게이션 정상 동작
- [ ] 딥링크 테스트
- [ ] 앱 시작/종료 안정성

---

### Phase 9: 테스트 및 최적화
**목표**: 품질 확보 및 성능 최적화

**작업 목록**:
- [ ] 9.1. 단위 테스트 작성 (UseCase, Repository)
- [ ] 9.2. BLoC 테스트 작성 (bloc_test)
- [ ] 9.3. 위젯 테스트 작성
- [ ] 9.4. const 최적화
- [ ] 9.5. 불필요한 리빌드 제거
- [ ] 9.6. Lint 에러 해결

**예상 영향**:
- 영향 받는 파일: `test/` 폴더
- 의존성: Phase 8 완료

**검증 방법**:
- [ ] 테스트 커버리지 70% 이상
- [ ] CI/CD 파이프라인 통과
- [ ] 프로파일링 결과 확인

---

## 4. 리스크 및 대응

### 리스크 1: 기존 데이터 호환성
- **확률**: Medium
- **영향도**: High
- **설명**: 기존 Hive 데이터 구조와 새 Entity 구조 불일치
- **완화 방안**:
  - 마이그레이션 스크립트 작성
  - 기존 모델을 래핑하는 어댑터 패턴 적용
  - 버전 체크 후 마이그레이션 실행

### 리스크 2: 기능 회귀
- **확률**: Medium
- **영향도**: Medium
- **설명**: 리팩토링 중 기존 기능이 깨질 수 있음
- **완화 방안**:
  - Phase별 검증 철저히 수행
  - 기능별 체크리스트 작성
  - Git 브랜치 전략 (feature 브랜치)

### 리스크 3: 빌드 시간 증가
- **확률**: Low
- **영향도**: Low
- **설명**: 코드 생성 패키지 추가로 빌드 시간 증가
- **완화 방안**:
  - `build_runner watch` 사용
  - 필요한 파일만 생성하도록 설정

---

## 5. 전체 검증 계획

### 자동 테스트
- [ ] UseCase 단위 테스트 (각 UseCase별)
- [ ] Repository 단위 테스트 (모킹)
- [ ] BLoC 테스트 (bloc_test 사용)
- [ ] 위젯 테스트 (주요 화면)

### 수동 테스트
- [ ] 시나리오 1: 앱 시작 → 홈 화면 표시 → 건강 점수 확인
- [ ] 시나리오 2: 증상 기록 → 저장 → 캘린더에서 확인
- [ ] 시나리오 3: 식사 기록 → 트리거 선택 → 인사이트에서 분석 확인
- [ ] 시나리오 4: 설정 변경 → 앱 재시작 → 설정 유지 확인
- [ ] 시나리오 5: 데이터 내보내기 → 파일 확인

### 성능 체크
- [ ] 앱 시작 시간 3초 이내
- [ ] 화면 전환 60fps 유지
- [ ] 메모리 사용량 150MB 이하

---

## 6. 일정 추정

| Phase | 작업 내용 | 예상 작업량 |
|-------|----------|------------|
| Phase 1 | Core Layer 설정 | 소 |
| Phase 2 | Shared Layer 정리 | 소 |
| Phase 3 | Home Feature | 중 |
| Phase 4 | Record Feature | 대 |
| Phase 5 | Calendar Feature | 중 |
| Phase 6 | Insights Feature | 중 |
| Phase 7 | Settings Feature | 소 |
| Phase 8 | App 통합 | 중 |
| Phase 9 | 테스트 & 최적화 | 중 |

---

## 7. 참고 사항

### 주의할 점
- 각 Phase는 순서대로 진행 (의존성 존재)
- build_runner 실행 후 생성 파일 확인 필수
- Phase 4 (Record)가 가장 복잡하므로 충분한 시간 할당
- 기존 Hive 데이터 마이그레이션 신중히 처리

### 참고 문서
- KOBIC 아키텍처 분석: `thoughts/shared/research/kobic_architecture_analysis_2026-01-13.md`
- Flutter BLoC 공식 문서: https://bloclibrary.dev/
- Injectable 패키지: https://pub.dev/packages/injectable
- fpdart 패키지: https://pub.dev/packages/fpdart

### 명령어 참고
```bash
# 패키지 설치
flutter pub get

# 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 코드 생성 (watch 모드)
dart run build_runner watch --delete-conflicting-outputs

# 테스트 실행
flutter test

# 테스트 커버리지
flutter test --coverage
```
