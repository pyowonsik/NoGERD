# NoGERD Supabase 백엔드 구현 계획

**날짜**: 2026-01-13
**작성자**: Claude
**관련 연구 문서**: `thoughts/shared/research/NoGERD_supabase_erd_2026-01-13.md`

---

## 1. 요구사항

### 기능 개요
현재 Hive(로컬 DB) 기반 앱을 Supabase 백엔드로 전환하여 클라우드 동기화 및 사용자 인증 기능을 추가합니다.

### 목표
- Supabase 인증 (이메일/소셜 로그인) 구현
- 4가지 기록 유형의 CRUD 기능을 Supabase로 전환
- 기존 로컬 데이터와 클라우드 데이터 동기화
- 오프라인 지원 (로컬 캐시)

### 성공 기준
- [ ] Supabase 인증 (회원가입/로그인/로그아웃) 동작
- [ ] 증상/식사/약물/생활습관 기록 CRUD 동작
- [ ] 오프라인 상태에서도 기록 조회 가능
- [ ] 기존 Hive 데이터 마이그레이션 완료

---

## 2. 현재 상태 분석

### 기존 아키텍처
```
lib/
├── core/
│   ├── di/           - GetIt 의존성 주입
│   ├── error/        - Failure 타입 (fpdart Either)
│   └── usecase/      - UseCase 베이스 클래스
├── features/
│   └── gerd_record/
│       ├── data/
│       │   ├── datasources/  - Hive LocalDataSource
│       │   ├── models/       - HiveType 모델
│       │   └── repositories/ - Repository 구현
│       ├── domain/
│       │   ├── entities/     - Freezed 엔티티
│       │   ├── repositories/ - Repository 인터페이스
│       │   └── usecases/     - UseCase 구현
│       └── presentation/     - BLoC, 위젯
└── shared/
    └── constants/            - enum 정의 (GerdSymptom 등)
```

### 기존 패키지
- **상태 관리**: flutter_bloc
- **DI**: get_it, injectable
- **로컬 DB**: hive, hive_flutter
- **함수형**: fpdart (Either 패턴)
- **코드 생성**: freezed, json_serializable

### 기존 코드 특징
- Clean Architecture 구조
- `Either<Failure, T>` 에러 처리
- Freezed 불변 엔티티
- UseCase 패턴

---

## 3. 기술적 접근

### 추가할 패키지
```yaml
dependencies:
  supabase_flutter: ^2.8.0   # Supabase SDK
  connectivity_plus: ^6.0.0   # 네트워크 상태 확인
```

### 아키텍처 변경
```
기존: UI → BLoC → UseCase → Repository → LocalDataSource (Hive)

변경: UI → BLoC → UseCase → Repository → RemoteDataSource (Supabase)
                                       ↘ LocalDataSource (Hive - 캐시)
```

### 새로운 파일 구조
```
lib/
├── core/
│   ├── di/
│   ├── error/
│   │   ├── failures.dart          (기존)
│   │   └── exceptions.dart        (기존)
│   ├── usecase/
│   ├── network/
│   │   └── network_info.dart      (신규)
│   └── supabase/
│       └── supabase_client.dart   (신규)
│
├── features/
│   ├── auth/                      (신규 - 인증)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       └── sign_out_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── auth_bloc.dart
│   │       └── pages/
│   │           └── login_page.dart
│   │
│   ├── symptom/                   (신규 - 증상 기록)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── symptom_remote_datasource.dart
│   │   │   │   └── symptom_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── symptom_record_model.dart
│   │   │   └── repositories/
│   │   │       └── symptom_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── symptom_record_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── symptom_repository.dart
│   │   │   └── usecases/
│   │   └── presentation/
│   │
│   ├── meal/                      (신규 - 식사 기록)
│   │   └── (symptom과 동일 구조)
│   │
│   ├── medication/                (신규 - 약물 기록)
│   │   └── (symptom과 동일 구조)
│   │
│   ├── lifestyle/                 (신규 - 생활습관 기록)
│   │   └── (symptom과 동일 구조)
│   │
│   └── settings/                  (신규 - 사용자 설정)
│       └── (symptom과 동일 구조)
```

---

## 4. 구현 단계

### Phase 1: 기반 설정 (Supabase 연동 기초)
**목표**: Supabase 연결 및 코어 인프라 구축

**작업 목록**:
- [ ] `pubspec.yaml`에 `supabase_flutter`, `connectivity_plus` 추가
- [ ] `lib/core/supabase/supabase_client.dart` 생성
- [ ] `lib/core/network/network_info.dart` 생성
- [ ] `lib/core/error/failures.dart`에 네트워크/서버 Failure 추가
- [ ] `main.dart`에서 Supabase 초기화
- [ ] 환경변수 파일 (`.env`) 설정

**생성할 파일**:
```
lib/core/supabase/supabase_client.dart
lib/core/network/network_info.dart
```

**수정할 파일**:
```
pubspec.yaml
lib/main.dart
lib/core/error/failures.dart
```

**검증 방법**:
- [ ] `flutter pub get` 성공
- [ ] Supabase 연결 테스트 (ping)
- [ ] 빌드 성공

---

### Phase 2: 인증 기능 구현
**목표**: Supabase Auth를 이용한 사용자 인증

**작업 목록**:
- [ ] `lib/features/auth/domain/entities/user_entity.dart` 생성
- [ ] `lib/features/auth/domain/repositories/auth_repository.dart` 생성
- [ ] `lib/features/auth/domain/usecases/` (sign_in, sign_up, sign_out) 생성
- [ ] `lib/features/auth/data/models/user_model.dart` 생성
- [ ] `lib/features/auth/data/datasources/auth_remote_datasource.dart` 생성
- [ ] `lib/features/auth/data/repositories/auth_repository_impl.dart` 생성
- [ ] `lib/features/auth/presentation/bloc/auth_bloc.dart` 생성
- [ ] `lib/features/auth/presentation/pages/login_page.dart` 생성
- [ ] DI 등록 (`injection.dart`)

**파일 구조**:
```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       ├── sign_out_usecase.dart
│       └── get_current_user_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    └── pages/
        ├── login_page.dart
        └── signup_page.dart
```

**검증 방법**:
- [ ] 회원가입 후 Supabase 대시보드에서 사용자 확인
- [ ] 로그인/로그아웃 동작 확인
- [ ] 인증 상태 유지 확인 (앱 재시작)

---

### Phase 3: 증상 기록 기능 (Symptom)
**목표**: 증상 기록 CRUD를 Supabase로 구현

**작업 목록**:
- [ ] `lib/features/symptom/domain/entities/symptom_record_entity.dart`
- [ ] `lib/features/symptom/domain/repositories/symptom_repository.dart`
- [ ] `lib/features/symptom/domain/usecases/` (CRUD)
- [ ] `lib/features/symptom/data/models/symptom_record_model.dart`
- [ ] `lib/features/symptom/data/datasources/symptom_remote_datasource.dart`
- [ ] `lib/features/symptom/data/datasources/symptom_local_datasource.dart`
- [ ] `lib/features/symptom/data/repositories/symptom_repository_impl.dart`
- [ ] DI 등록
- [ ] 기존 SymptomRecordScreen 연결

**Entity 설계**:
```dart
@freezed
class SymptomRecordEntity with _$SymptomRecordEntity {
  const factory SymptomRecordEntity({
    String? id,
    required DateTime recordDatetime,
    required List<String> symptoms,
    required int severity,
    String? notes,
    DateTime? createdAt,
  }) = _SymptomRecordEntity;
}
```

**Repository 인터페이스**:
```dart
abstract class SymptomRepository {
  Future<Either<Failure, List<SymptomRecordEntity>>> getRecords(DateRangeParams params);
  Future<Either<Failure, SymptomRecordEntity>> addRecord(SymptomRecordEntity record);
  Future<Either<Failure, SymptomRecordEntity>> updateRecord(SymptomRecordEntity record);
  Future<Either<Failure, Unit>> deleteRecord(String id);
}
```

**검증 방법**:
- [ ] 증상 기록 추가 → Supabase에서 확인
- [ ] 기록 목록 조회 동작
- [ ] 오프라인 캐싱 동작

---

### Phase 4: 식사 기록 기능 (Meal)
**목표**: 식사 기록 CRUD를 Supabase로 구현

**작업 목록**:
- [ ] `lib/features/meal/domain/entities/meal_record_entity.dart`
- [ ] `lib/features/meal/domain/repositories/meal_repository.dart`
- [ ] `lib/features/meal/domain/usecases/`
- [ ] `lib/features/meal/data/models/meal_record_model.dart`
- [ ] `lib/features/meal/data/datasources/`
- [ ] `lib/features/meal/data/repositories/meal_repository_impl.dart`
- [ ] DI 등록
- [ ] 기존 MealRecordScreen 연결

**Entity 설계**:
```dart
@freezed
class MealRecordEntity with _$MealRecordEntity {
  const factory MealRecordEntity({
    String? id,
    required DateTime recordDatetime,
    required String mealType,  // breakfast/lunch/dinner/snack
    required List<String> foods,
    List<String>? triggers,
    DateTime? createdAt,
  }) = _MealRecordEntity;
}
```

**검증 방법**:
- [ ] 식사 기록 CRUD 동작
- [ ] 트리거 음식 태그 저장 확인

---

### Phase 5: 약물 복용 기록 기능 (Medication)
**목표**: 약물 복용 기록 CRUD를 Supabase로 구현

**작업 목록**:
- [ ] `lib/features/medication/domain/entities/medication_record_entity.dart`
- [ ] `lib/features/medication/domain/repositories/medication_repository.dart`
- [ ] `lib/features/medication/domain/usecases/`
- [ ] `lib/features/medication/data/models/medication_record_model.dart`
- [ ] `lib/features/medication/data/datasources/`
- [ ] `lib/features/medication/data/repositories/medication_repository_impl.dart`
- [ ] DI 등록
- [ ] 기존 MedicationRecordScreen 연결

**Entity 설계**:
```dart
@freezed
class MedicationRecordEntity with _$MedicationRecordEntity {
  const factory MedicationRecordEntity({
    String? id,
    required DateTime recordDatetime,
    required String medicationType,  // ppi/h2_blocker/antacid/prokinetic
    required String medicationName,
    String? effectiveness,  // good/moderate/poor
    DateTime? createdAt,
  }) = _MedicationRecordEntity;
}
```

**검증 방법**:
- [ ] 약물 복용 기록 CRUD 동작
- [ ] 효과 평가 저장 확인

---

### Phase 6: 생활습관 기록 기능 (Lifestyle)
**목표**: 생활습관 기록 CRUD를 Supabase로 구현

**작업 목록**:
- [ ] `lib/features/lifestyle/domain/entities/lifestyle_record_entity.dart`
- [ ] `lib/features/lifestyle/domain/repositories/lifestyle_repository.dart`
- [ ] `lib/features/lifestyle/domain/usecases/`
- [ ] `lib/features/lifestyle/data/models/lifestyle_record_model.dart`
- [ ] `lib/features/lifestyle/data/datasources/`
- [ ] `lib/features/lifestyle/data/repositories/lifestyle_repository_impl.dart`
- [ ] DI 등록
- [ ] 기존 LifestyleRecordScreen 연결

**Entity 설계**:
```dart
@freezed
class LifestyleRecordEntity with _$LifestyleRecordEntity {
  const factory LifestyleRecordEntity({
    String? id,
    required DateTime recordDatetime,
    required String category,  // sleep/stress/activity
    // 수면
    double? sleepHours,
    String? sleepPosition,
    bool? lateNightMeal,
    // 스트레스
    int? stressLevel,
    // 활동
    bool? exercised,
    DateTime? createdAt,
  }) = _LifestyleRecordEntity;
}
```

**검증 방법**:
- [ ] 생활습관 기록 CRUD 동작
- [ ] 카테고리별 데이터 저장 확인

---

### Phase 7: 사용자 설정 기능 (Settings)
**목표**: 사용자 설정 동기화

**작업 목록**:
- [ ] `lib/features/settings/domain/entities/user_settings_entity.dart`
- [ ] `lib/features/settings/domain/repositories/settings_repository.dart`
- [ ] `lib/features/settings/domain/usecases/`
- [ ] `lib/features/settings/data/`
- [ ] DI 등록
- [ ] 기존 설정 화면 연결

**검증 방법**:
- [ ] 설정 저장/조회 동작
- [ ] 앱 재시작 후 설정 유지

---

### Phase 8: 데이터 마이그레이션 및 동기화
**목표**: 기존 Hive 데이터를 Supabase로 마이그레이션

**작업 목록**:
- [ ] 마이그레이션 유틸리티 생성
- [ ] 기존 `gerd_records` Hive 데이터 변환
- [ ] 사용자 최초 로그인 시 마이그레이션 실행
- [ ] 마이그레이션 완료 플래그 저장
- [ ] 기존 `gerd_record` feature 정리 (deprecated)

**마이그레이션 로직**:
```dart
class DataMigrationService {
  Future<void> migrateLocalToRemote() async {
    // 1. 기존 Hive 데이터 조회
    // 2. 새로운 Entity로 변환
    // 3. Supabase에 업로드
    // 4. 완료 플래그 저장
  }
}
```

**검증 방법**:
- [ ] 기존 데이터 마이그레이션 성공
- [ ] 마이그레이션 후 기존 데이터 조회 가능

---

### Phase 9: UI 통합 및 라우팅 수정
**목표**: 전체 앱 플로우 통합

**작업 목록**:
- [ ] 인증 상태에 따른 라우팅 수정 (go_router)
- [ ] 로그인 화면 → 메인 화면 플로우
- [ ] 기록 화면들에 BLoC 연결
- [ ] 홈 화면 데이터 연동

**검증 방법**:
- [ ] 앱 전체 플로우 테스트
- [ ] 비로그인 시 로그인 화면 이동
- [ ] 로그인 후 데이터 조회

---

### Phase 10: 오프라인 지원 및 최적화
**목표**: 오프라인 동작 및 성능 최적화

**작업 목록**:
- [ ] 네트워크 상태 감지
- [ ] 오프라인 시 로컬 캐시 사용
- [ ] 온라인 복귀 시 동기화
- [ ] 에러 처리 강화
- [ ] 로딩 상태 UI 개선

**검증 방법**:
- [ ] 비행기 모드에서 기록 조회
- [ ] 온라인 복귀 후 자동 동기화
- [ ] 에러 발생 시 적절한 메시지 표시

---

## 5. 리스크 및 대응

### 리스크 1: Supabase 연결 실패
- **확률**: Low
- **영향도**: High
- **완화 방안**: 오프라인 모드 지원, 재시도 로직 구현

### 리스크 2: 데이터 마이그레이션 실패
- **확률**: Medium
- **영향도**: High
- **완화 방안**: 마이그레이션 전 백업, 롤백 로직 구현

### 리스크 3: 인증 토큰 만료
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**: 토큰 갱신 로직, 자동 재로그인 구현

### 리스크 4: 대량 데이터 동기화 성능
- **확률**: Low
- **영향도**: Medium
- **완화 방안**: 페이지네이션, 백그라운드 동기화

---

## 6. 검증 계획

### 단위 테스트
- [ ] Repository 테스트 (mocktail 사용)
- [ ] UseCase 테스트
- [ ] Model fromJson/toJson 테스트

### 통합 테스트
- [ ] 인증 플로우 테스트
- [ ] CRUD 플로우 테스트
- [ ] 오프라인 → 온라인 동기화 테스트

### 수동 테스트
- [ ] 시나리오 1: 신규 사용자 회원가입 → 기록 추가 → 조회
- [ ] 시나리오 2: 기존 사용자 로그인 → 마이그레이션 → 데이터 확인
- [ ] 시나리오 3: 오프라인 상태 → 기록 조회 → 온라인 복귀 → 동기화

---

## 7. Supabase 설정 가이드

### Supabase 프로젝트 생성
1. https://supabase.com 접속
2. 새 프로젝트 생성
3. Project URL, anon key 복사

### 테이블 생성
연구 문서의 SQL 스크립트 실행:
- `thoughts/shared/research/NoGERD_supabase_erd_2026-01-13.md` 참조

### 환경 변수
```
# .env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

---

## 8. 참고 사항

- 기존 Clean Architecture 패턴 유지
- `Either<Failure, T>` 에러 처리 패턴 유지
- Freezed 불변 엔티티 패턴 유지
- 각 Phase는 독립적으로 테스트 가능하도록 구현
- Phase 완료 후 다음 Phase 진행 전 코드 리뷰

---

## 9. 예상 파일 목록

### 신규 생성 (약 50개 파일)
```
lib/core/
├── supabase/supabase_client.dart
└── network/network_info.dart

lib/features/auth/ (약 10개)
lib/features/symptom/ (약 10개)
lib/features/meal/ (약 10개)
lib/features/medication/ (약 10개)
lib/features/lifestyle/ (약 10개)
lib/features/settings/ (약 5개)
```

### 수정 (약 10개 파일)
```
pubspec.yaml
lib/main.dart
lib/injection.dart
lib/core/error/failures.dart
lib/screens/record/quick_record_modal.dart
lib/screens/settings/settings_screen.dart
lib/screens/home/home_screen.dart
```
