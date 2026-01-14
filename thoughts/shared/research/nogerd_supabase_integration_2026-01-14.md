# NoGERD Supabase 백엔드 통합 연구 보고서

**작성일**: 2026-01-14
**프로젝트**: NoGERD (역류성 식도염 기록 앱)
**목적**: Supabase 백엔드 통합 및 이메일 인증 시스템 구현 계획 수립

---

## 목차
1. [현재 상태 분석](#1-현재-상태-분석)
2. [Supabase 스키마 분석](#2-supabase-스키마-분석)
3. [아키텍처 설계](#3-아키텍처-설계)
4. [이메일 인증 구현 계획](#4-이메일-인증-구현-계획)
5. [데이터 레이어 통합](#5-데이터-레이어-통합)
6. [필요한 패키지 및 설정](#6-필요한-패키지-및-설정)
7. [단계별 구현 가이드](#7-단계별-구현-가이드)
8. [마이그레이션 전략](#8-마이그레이션-전략)
9. [보안 고려사항](#9-보안-고려사항)

---

## 1. 현재 상태 분석

### 1.1 앱 아키텍처 현황

NoGERD 앱은 **Clean Architecture** 원칙을 따르는 잘 구조화된 Flutter 앱입니다.

#### 디렉토리 구조
```
lib/
├── core/
│   ├── di/              # Dependency Injection (Injectable)
│   ├── error/           # Failure 정의 (Freezed)
│   ├── usecase/         # Base UseCase
│   └── ...
├── features/
│   ├── record/          # 기록 Feature (메인)
│   │   ├── data/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       └── bloc/
│   ├── home/            # 홈 Feature
│   ├── calendar/        # 캘린더 Feature
│   ├── insights/        # 인사이트 Feature
│   └── settings/        # 설정 Feature
└── shared/              # 공유 리소스
    ├── constants/
    └── theme/
```

#### 현재 사용 중인 기술 스택
- **상태 관리**: flutter_bloc (8.1.6)
- **DI**: Injectable (2.4.4) + GetIt (8.0.3)
- **함수형 프로그래밍**: fpdart (1.1.0) - Either<Failure, T> 패턴
- **코드 생성**: Freezed (2.5.2), json_serializable
- **로컬 저장소**: Hive (2.2.3) - 현재 미사용, 인메모리 저장소 사용 중
- **라우팅**: 없음 (직접 네비게이션 사용)

### 1.2 현재 데이터 저장 방식

**현재 상태**: 인메모리 저장소 사용 (휘발성)

```dart
// lib/features/record/data/repositories/record_repository_impl.dart
@LazySingleton(as: IRecordRepository)
class RecordRepositoryImpl implements IRecordRepository {
  final List<SymptomRecord> _symptomRecords = [];
  final List<MealRecord> _mealRecords = [];
  final List<MedicationRecord> _medicationRecords = [];
  final List<LifestyleRecord> _lifestyleRecords = [];

  // 인메모리에서 CRUD 작업 수행
}
```

**문제점**:
- 앱 재시작 시 데이터 소실
- 기기 간 동기화 불가
- 백업/복구 불가
- 사용자 인증 없음

### 1.3 Entity 구조 분석

앱은 4가지 핵심 Entity를 사용합니다:

#### SymptomRecord (증상 기록)
```dart
@freezed
class SymptomRecord {
  const factory SymptomRecord({
    required String id,              // UUID
    required DateTime recordedAt,    // 기록 시간
    required List<GerdSymptom> symptoms,  // 증상 목록 (Enum)
    required int severity,           // 심각도 (1-10)
    String? notes,                   // 메모
    required DateTime createdAt,     // 생성 시간
    DateTime? updatedAt,             // 수정 시간
  }) = _SymptomRecord;
}
```

#### MealRecord (식사 기록)
```dart
@freezed
class MealRecord {
  const factory MealRecord({
    required String id,
    required DateTime recordedAt,
    required MealType mealType,      // breakfast/lunch/dinner/snack/lateNight
    required List<String> foods,     // 음식 목록
    List<TriggerFoodCategory>? triggerCategories,  // 트리거 음식 카테고리
    required int fullnessLevel,      // 포만감 (1-10)
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MealRecord;
}
```

#### MedicationRecord (약물 기록)
```dart
@freezed
class MedicationRecord {
  const factory MedicationRecord({
    required String id,
    required DateTime recordedAt,
    required MedicationType medicationType,  // PPI/H2차단제/제산제/위장운동촉진제
    required String medicationName,
    required String dosage,          // 용량
    String? purpose,                 // 복용 목적
    int? effectiveness,              // 효과 (1-10)
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MedicationRecord;
}
```

#### LifestyleRecord (생활습관 기록)
```dart
@freezed
class LifestyleRecord {
  const factory LifestyleRecord({
    required String id,
    required DateTime recordedAt,
    required LifestyleType lifestyleType,  // sleep/exercise/stress/smoking/posture
    required Map<String, dynamic> details,  // 유연한 상세 정보 (JSON)
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LifestyleRecord;
}
```

### 1.4 Repository 패턴 분석

```dart
// Domain Layer - Interface
abstract class IRecordRepository {
  // Symptom Records
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(DateTime date);
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record);
  Future<Either<Failure, Unit>> updateSymptomRecord(SymptomRecord record);
  Future<Either<Failure, Unit>> deleteSymptomRecord(String id);

  // Meal Records (유사한 패턴)
  // Medication Records (유사한 패턴)
  // Lifestyle Records (유사한 패턴)

  // All Records
  Future<Either<Failure, Map<String, dynamic>>> getAllRecords(DateTime date);
}
```

**특징**:
- Either<Failure, T> 패턴으로 에러 처리
- 날짜 기반 쿼리
- 타입별 CRUD 분리
- Clean Architecture 준수

---

## 2. Supabase 스키마 분석

### 2.1 데이터베이스 스키마 개요

Supabase 스키마는 `/Users/pyowonsik/Downloads/workspace/NoGERD/supabase/schema.sql`에 정의되어 있습니다.

#### 테이블 구조

##### 1) symptom_records (증상 기록)
```sql
CREATE TABLE symptom_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  symptoms TEXT[] NOT NULL,
  severity INTEGER NOT NULL CHECK (severity >= 1 AND severity <= 10),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

##### 2) meal_records (식사 기록)
```sql
CREATE TABLE meal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  foods TEXT[] NOT NULL,
  triggers TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

##### 3) medication_records (약물 기록)
```sql
CREATE TABLE medication_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  medication_type TEXT NOT NULL CHECK (medication_type IN ('ppi', 'h2_blocker', 'antacid', 'prokinetic')),
  medication_name TEXT NOT NULL,
  effectiveness TEXT CHECK (effectiveness IN ('good', 'moderate', 'poor')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

##### 4) lifestyle_records (생활습관 기록)
```sql
CREATE TABLE lifestyle_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('sleep', 'stress', 'activity')),
  -- 수면
  sleep_hours DECIMAL(3,1),
  sleep_position TEXT,
  late_night_meal BOOLEAN,
  -- 스트레스
  stress_level INTEGER,
  -- 활동
  exercised BOOLEAN,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

##### 5) user_settings (사용자 설정)
```sql
CREATE TABLE user_settings (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  notification_enabled BOOLEAN DEFAULT true,
  notification_time TIME DEFAULT '21:00',
  theme TEXT DEFAULT 'system',
  language TEXT DEFAULT 'ko',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 2.2 Entity와 DB 스키마 매핑 분석

#### 매핑 호환성 체크

| Entity 필드 | DB 컬럼 | 매핑 상태 | 비고 |
|------------|---------|----------|------|
| **SymptomRecord** |
| id | id | OK | UUID |
| recordedAt | record_datetime | OK | DateTime → TIMESTAMPTZ |
| symptoms (List<GerdSymptom>) | symptoms (TEXT[]) | 변환 필요 | Enum → String 변환 |
| severity | severity | OK | int (1-10) |
| notes | notes | OK | String? |
| createdAt | created_at | OK | DateTime |
| updatedAt | - | 추가 필요 | DB에 컬럼 없음 |
| - | user_id | 추가 필요 | Entity에 필드 없음 |

| Entity 필드 | DB 컬럼 | 매핑 상태 | 비고 |
|------------|---------|----------|------|
| **MealRecord** |
| id | id | OK | |
| recordedAt | record_datetime | OK | |
| mealType | meal_type | 변환 필요 | Enum → String |
| foods | foods | OK | List<String> → TEXT[] |
| triggerCategories | triggers | 변환 필요 | Enum → String |
| fullnessLevel | - | 추가 필요 | DB에 없음 |
| notes | - | 추가 필요 | DB에 없음 |
| createdAt | created_at | OK | |
| updatedAt | - | 추가 필요 | |
| - | user_id | 추가 필요 | |

| Entity 필드 | DB 컬럼 | 매핑 상태 | 비고 |
|------------|---------|----------|------|
| **MedicationRecord** |
| id | id | OK | |
| recordedAt | record_datetime | OK | |
| medicationType | medication_type | 변환 필요 | Enum → String |
| medicationName | medication_name | OK | |
| dosage | - | 추가 필요 | DB에 없음 |
| purpose | - | 추가 필요 | DB에 없음 |
| effectiveness (int?) | effectiveness (TEXT) | 타입 불일치 | int → 'good'/'moderate'/'poor' |
| notes | - | 추가 필요 | |
| createdAt | created_at | OK | |
| updatedAt | - | 추가 필요 | |
| - | user_id | 추가 필요 | |

| Entity 필드 | DB 컬럼 | 매핑 상태 | 비고 |
|------------|---------|----------|------|
| **LifestyleRecord** |
| id | id | OK | |
| recordedAt | record_datetime | OK | |
| lifestyleType | category | 변환 필요 | Enum 값 차이 |
| details (Map) | sleep_hours, sleep_position, etc | 재구조화 필요 | JSON → 개별 컬럼 |
| notes | - | 추가 필요 | |
| createdAt | created_at | OK | |
| updatedAt | - | 추가 필요 | |
| - | user_id | 추가 필요 | |

### 2.3 스키마 수정 필요사항

#### Option A: Entity 우선 (추천)
Entity 구조를 유지하고 DB 스키마를 수정합니다.

**스키마 마이그레이션 SQL**:
```sql
-- 1. 모든 테이블에 updated_at 추가
ALTER TABLE symptom_records ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE meal_records ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE medication_records ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE lifestyle_records ADD COLUMN updated_at TIMESTAMPTZ;

-- 2. MealRecord 필드 추가
ALTER TABLE meal_records ADD COLUMN fullness_level INTEGER CHECK (fullness_level >= 1 AND fullness_level <= 10);
ALTER TABLE meal_records ADD COLUMN notes TEXT;

-- 3. MedicationRecord 필드 추가
ALTER TABLE medication_records ADD COLUMN dosage TEXT NOT NULL DEFAULT '';
ALTER TABLE medication_records ADD COLUMN purpose TEXT;
ALTER TABLE medication_records ADD COLUMN notes TEXT;
-- effectiveness를 integer로 변경
ALTER TABLE medication_records DROP COLUMN effectiveness;
ALTER TABLE medication_records ADD COLUMN effectiveness INTEGER CHECK (effectiveness >= 1 AND effectiveness <= 10);

-- 4. LifestyleRecord 재설계
ALTER TABLE lifestyle_records ADD COLUMN notes TEXT;
-- category 값을 Entity의 LifestyleType enum과 일치시키기
-- 'activity' → 'exercise' 매핑 필요

-- 5. updated_at 자동 갱신 트리거
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_symptom_records_updated_at BEFORE UPDATE ON symptom_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_meal_records_updated_at BEFORE UPDATE ON meal_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_medication_records_updated_at BEFORE UPDATE ON medication_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lifestyle_records_updated_at BEFORE UPDATE ON lifestyle_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

#### Option B: DB 스키마 우선
DB 스키마를 유지하고 Entity를 수정합니다. (권장하지 않음 - Entity가 이미 앱 전체에서 사용 중)

### 2.4 RLS (Row Level Security) 분석

**현재 설정**:
```sql
ALTER TABLE symptom_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users CRUD own symptom_records" ON symptom_records
  FOR ALL USING (auth.uid() = user_id);
```

**의미**:
- 모든 테이블에서 RLS 활성화됨
- 사용자는 자신의 데이터만 읽기/쓰기/수정/삭제 가능
- `auth.uid()`는 현재 인증된 사용자의 UUID 반환
- `user_id` 컬럼이 외래키로 `auth.users(id)`를 참조

**보안 이점**:
- 백엔드 로직 없이도 데이터 격리 보장
- SQL Injection 방어
- 멀티테넌시 지원

### 2.5 인덱스 분석

```sql
CREATE INDEX idx_symptom_records_user_datetime ON symptom_records(user_id, record_datetime DESC);
```

**최적화**:
- `user_id`와 `record_datetime` 복합 인덱스
- DESC 정렬로 최신 기록 빠른 조회
- 날짜별 쿼리 성능 향상

---

## 3. 아키텍처 설계

### 3.1 레이어 구조 (Clean Architecture 유지)

```
┌─────────────────────────────────────────────────────┐
│              Presentation Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │  BLoC    │  │  Pages   │  │ Widgets  │         │
│  └──────────┘  └──────────┘  └──────────┘         │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│               Domain Layer                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │ Entities │  │ UseCases │  │Repository│         │
│  │          │  │          │  │Interface │         │
│  └──────────┘  └──────────┘  └──────────┘         │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│                Data Layer                            │
│  ┌──────────────────┐  ┌──────────────────┐       │
│  │ Repository Impl  │  │  DataSources     │       │
│  │                  │  │                   │       │
│  │ ┌──────────────┐ │  │ ┌──────────────┐ │      │
│  │ │  Mapper      │ │  │ │   Supabase   │ │      │
│  │ │Entity<->Model│ │  │ │  DataSource  │ │      │
│  │ └──────────────┘ │  │ └──────────────┘ │      │
│  │                  │  │                   │       │
│  │ ┌──────────────┐ │  │ ┌──────────────┐ │      │
│  │ │   Cache      │ │  │ │     Hive     │ │      │
│  │ │   (선택)     │ │  │ │  DataSource  │ │      │
│  │ └──────────────┘ │  │ └──────────────┘ │      │
│  └──────────────────┘  └──────────────────┘       │
└─────────────────────────────────────────────────────┘
```

### 3.2 데이터 흐름

#### 3.2.1 기록 추가 플로우
```
User Input (UI)
    ↓
BLoC Event (AddSymptomRecord)
    ↓
UseCase (AddSymptomRecordUseCase)
    ↓
Repository Interface (IRecordRepository)
    ↓
Repository Implementation (SupabaseRecordRepository)
    ↓
DataSource (SupabaseRecordDataSource)
    ↓
Supabase Client
    ↓
PostgreSQL Database
    ↓ (RLS 확인)
Success/Failure
    ↓
BLoC State Update
    ↓
UI Update
```

#### 3.2.2 인증 플로우
```
Login Screen
    ↓
AuthBloc Event (SignInWithEmail)
    ↓
UseCase (SignInUseCase)
    ↓
AuthRepository (IAuthRepository)
    ↓
SupabaseAuthRepository
    ↓
Supabase Auth (auth.signInWithPassword)
    ↓
Session Token 저장 (Hive)
    ↓
AuthState Update (Authenticated)
    ↓
Navigate to Home
```

### 3.3 새로운 Feature: Auth

Auth Feature를 추가해야 합니다.

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
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       ├── sign_out_usecase.dart
│       ├── get_current_user_usecase.dart
│       ├── verify_email_usecase.dart
│       └── reset_password_usecase.dart
├── presentation/
│   ├── bloc/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   └── pages/
│       ├── login_page.dart
│       ├── signup_page.dart
│       ├── email_verification_page.dart
│       └── forgot_password_page.dart
└── di/
    └── auth_module.dart
```

---

## 4. 이메일 인증 구현 계획

### 4.1 Supabase Auth 개요

Supabase는 PostgreSQL 기반의 인증 시스템을 제공합니다.

#### 지원 기능
- 이메일/비밀번호 인증
- 소셜 로그인 (Google, Apple 등)
- 매직 링크 (비밀번호 없는 로그인)
- 이메일 인증
- 비밀번호 재설정
- JWT 세션 관리

#### auth.users 테이블 구조
Supabase가 자동 관리하는 테이블:
```sql
auth.users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE,
  encrypted_password TEXT,
  email_confirmed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ,
  ...
)
```

### 4.2 Entity 설계

#### User Entity
```dart
// lib/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required bool emailConfirmed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _User;
}
```

#### AuthState
```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.emailVerificationRequired(String email) = _EmailVerificationRequired;
  const factory AuthState.error(Failure failure) = _Error;
}
```

### 4.3 Repository Interface

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  /// 이메일/비밀번호로 회원가입
  /// - 자동으로 인증 이메일 발송
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
  });

  /// 이메일/비밀번호로 로그인
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  /// 로그아웃
  Future<Either<Failure, Unit>> signOut();

  /// 현재 인증된 사용자 가져오기
  Future<Either<Failure, User?>> getCurrentUser();

  /// 세션 스트림 (인증 상태 변경 감지)
  Stream<User?> authStateChanges();

  /// 이메일 인증 재발송
  Future<Either<Failure, Unit>> resendVerificationEmail();

  /// 비밀번호 재설정 이메일 발송
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  /// 비밀번호 재설정 (토큰 사용)
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  });
}
```

### 4.4 DataSource 구현

```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:no_gerd/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp({required String email, required String password});
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
  Future<void> resendVerificationEmail();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> resetPassword({required String token, required String newPassword});
}

@LazySingleton(as: AuthRemoteDataSource)
class SupabaseAuthDataSource implements AuthRemoteDataSource {
  final SupabaseClient _supabase;

  SupabaseAuthDataSource(this._supabase);

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null, // 웹 앱의 경우 리다이렉트 URL
      );

      if (response.user == null) {
        throw Exception('회원가입 실패');
      }
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('로그인 실패');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw AuthDataSourceException(e.toString());
    }
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: user.email!,
      );
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }
}

class AuthDataSourceException implements Exception {
  final String message;
  AuthDataSourceException(this.message);
}
```

### 4.5 Repository 구현

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signUp(email: email, password: password);
      return const Right(unit);
    } on AuthDataSourceException catch (e) {
      return Left(Failure.unexpected(e.message));
    } catch (e) {
      return Left(Failure.unexpected('회원가입 중 오류 발생: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthDataSourceException catch (e) {
      if (e.message.contains('Email not confirmed')) {
        return const Left(Failure.validation('이메일 인증이 필요합니다'));
      }
      if (e.message.contains('Invalid login credentials')) {
        return const Left(Failure.validation('이메일 또는 비밀번호가 잘못되었습니다'));
      }
      return Left(Failure.unexpected(e.message));
    } catch (e) {
      return Left(Failure.unexpected('로그인 중 오류 발생: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('로그아웃 중 오류 발생: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      if (userModel == null) return const Right(null);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(Failure.unexpected('사용자 정보 조회 실패: ${e.toString()}'));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map((userModel) {
      return userModel?.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> resendVerificationEmail() async {
    try {
      await _remoteDataSource.resendVerificationEmail();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('인증 이메일 발송 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('비밀번호 재설정 이메일 발송 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected('비밀번호 재설정 실패: ${e.toString()}'));
    }
  }
}
```

### 4.6 BLoC 설계

```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthEventCheckStatus>(_onCheckStatus);
    on<AuthEventSignIn>(_onSignIn);
    on<AuthEventSignUp>(_onSignUp);
    on<AuthEventSignOut>(_onSignOut);
  }

  Future<void> _onCheckStatus(
    AuthEventCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) {
        if (user == null) {
          emit(const AuthState.unauthenticated());
        } else if (!user.emailConfirmed) {
          emit(AuthState.emailVerificationRequired(user.email));
        } else {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }

  Future<void> _onSignIn(
    AuthEventSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (user) {
        if (!user.emailConfirmed) {
          emit(AuthState.emailVerificationRequired(user.email));
        } else {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }

  Future<void> _onSignUp(
    AuthEventSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _signUpUseCase(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) => emit(AuthState.emailVerificationRequired(event.email)),
    );
  }

  Future<void> _onSignOut(
    AuthEventSignOut event,
    Emitter<AuthState> emit,
  ) async {
    await _signOutUseCase(NoParams());
    emit(const AuthState.unauthenticated());
  }
}
```

### 4.7 UI 플로우

#### 앱 시작 시
```
SplashScreen
    ↓
AuthBloc.checkStatus()
    ↓
┌─────────────────────────────────┐
│  AuthState                       │
├─────────────────────────────────┤
│  Authenticated → HomeScreen     │
│  Unauthenticated → LoginPage    │
│  EmailVerification → VerifyPage │
└─────────────────────────────────┘
```

#### 로그인 플로우
```
LoginPage
    ↓
[이메일/비밀번호 입력]
    ↓
AuthBloc.signIn(email, password)
    ↓
┌─────────────────────────────────┐
│  결과                            │
├─────────────────────────────────┤
│  성공 → HomeScreen              │
│  이메일 미인증 → VerifyPage      │
│  실패 → 에러 메시지 표시         │
└─────────────────────────────────┘
```

#### 회원가입 플로우
```
SignUpPage
    ↓
[이메일/비밀번호 입력]
    ↓
AuthBloc.signUp(email, password)
    ↓
[이메일 발송 완료]
    ↓
EmailVerificationPage
    ↓
[이메일에서 링크 클릭]
    ↓
자동으로 email_confirmed_at 업데이트
    ↓
[앱으로 돌아와서 "인증 완료" 버튼]
    ↓
LoginPage
```

---

## 5. 데이터 레이어 통합

### 5.1 DataSource 설계

#### Record DataSource Interface
```dart
// lib/features/record/data/datasources/record_remote_datasource.dart
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';
// ... other imports

abstract class RecordRemoteDataSource {
  // Symptom Records
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date);
  Future<void> addSymptomRecord(SymptomRecordModel record);
  Future<void> updateSymptomRecord(SymptomRecordModel record);
  Future<void> deleteSymptomRecord(String id);

  // Meal Records
  Future<List<MealRecordModel>> getMealRecords(DateTime date);
  Future<void> addMealRecord(MealRecordModel record);
  // ... 기타

  // Medication Records
  // ... 기타

  // Lifestyle Records
  // ... 기타
}
```

#### Supabase 구현
```dart
@LazySingleton(as: RecordRemoteDataSource)
class SupabaseRecordDataSource implements RecordRemoteDataSource {
  final SupabaseClient _supabase;

  SupabaseRecordDataSource(this._supabase);

  @override
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('symptom_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) => SymptomRecordModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw RecordDataSourceException(e.message);
    } catch (e) {
      throw RecordDataSourceException('증상 기록 조회 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> addSymptomRecord(SymptomRecordModel record) async {
    try {
      await _supabase.from('symptom_records').insert(record.toJson());
    } on PostgrestException catch (e) {
      throw RecordDataSourceException(e.message);
    } catch (e) {
      throw RecordDataSourceException('증상 기록 추가 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> updateSymptomRecord(SymptomRecordModel record) async {
    try {
      await _supabase
          .from('symptom_records')
          .update(record.toJson())
          .eq('id', record.id);
    } on PostgrestException catch (e) {
      throw RecordDataSourceException(e.message);
    } catch (e) {
      throw RecordDataSourceException('증상 기록 수정 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSymptomRecord(String id) async {
    try {
      await _supabase.from('symptom_records').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw RecordDataSourceException(e.message);
    } catch (e) {
      throw RecordDataSourceException('증상 기록 삭제 실패: ${e.toString()}');
    }
  }

  // Meal, Medication, Lifestyle Records도 유사하게 구현
}

class RecordDataSourceException implements Exception {
  final String message;
  RecordDataSourceException(this.message);
}
```

### 5.2 Model 설계

#### SymptomRecordModel
```dart
// lib/features/record/data/models/symptom_record_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'symptom_record_model.freezed.dart';
part 'symptom_record_model.g.dart';

@freezed
class SymptomRecordModel with _$SymptomRecordModel {
  const factory SymptomRecordModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'record_datetime') required DateTime recordedAt,
    required List<String> symptoms,  // DB에서는 String[]
    required int severity,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SymptomRecordModel;

  const SymptomRecordModel._();

  factory SymptomRecordModel.fromJson(Map<String, dynamic> json) =>
      _$SymptomRecordModelFromJson(json);

  /// Entity로 변환
  SymptomRecord toEntity() {
    return SymptomRecord(
      id: id,
      recordedAt: recordedAt,
      symptoms: symptoms
          .map((s) => GerdSymptom.values.firstWhere(
                (e) => e.name == s,
                orElse: () => GerdSymptom.heartburn,
              ))
          .toList(),
      severity: severity,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Entity에서 생성
  factory SymptomRecordModel.fromEntity(SymptomRecord entity, String userId) {
    return SymptomRecordModel(
      id: entity.id,
      userId: userId,
      recordedAt: entity.recordedAt,
      symptoms: entity.symptoms.map((s) => s.name).toList(),
      severity: entity.severity,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
```

### 5.3 Repository 수정

```dart
// lib/features/record/data/repositories/supabase_record_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';
import 'package:no_gerd/features/record/data/datasources/record_remote_datasource.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

@LazySingleton(as: IRecordRepository)
class SupabaseRecordRepositoryImpl implements IRecordRepository {
  final RecordRemoteDataSource _remoteDataSource;
  final IAuthRepository _authRepository;

  SupabaseRecordRepositoryImpl(
    this._remoteDataSource,
    this._authRepository,
  );

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  ) async {
    try {
      final models = await _remoteDataSource.getSymptomRecords(date);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record) async {
    try {
      // 현재 사용자 ID 가져오기
      final userResult = await _authRepository.getCurrentUser();
      final userId = userResult.fold(
        (failure) => throw Exception('사용자 정보를 가져올 수 없습니다'),
        (user) => user?.id ?? throw Exception('로그인이 필요합니다'),
      );

      final model = SymptomRecordModel.fromEntity(record, userId);
      await _remoteDataSource.addSymptomRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSymptomRecord(SymptomRecord record) async {
    try {
      final userResult = await _authRepository.getCurrentUser();
      final userId = userResult.fold(
        (failure) => throw Exception('사용자 정보를 가져올 수 없습니다'),
        (user) => user?.id ?? throw Exception('로그인이 필요합니다'),
      );

      final model = SymptomRecordModel.fromEntity(record, userId);
      await _remoteDataSource.updateSymptomRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSymptomRecord(String id) async {
    try {
      await _remoteDataSource.deleteSymptomRecord(id);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // Meal, Medication, Lifestyle Records도 유사하게 구현...
}
```

### 5.4 Entity 수정 필요사항

현재 Entity에는 `userId`가 없습니다. 두 가지 선택지가 있습니다.

#### Option A: Entity에 userId 추가 (권장하지 않음)
- Domain Layer가 인증에 의존하게 됨
- Clean Architecture 원칙 위반

#### Option B: Repository에서 처리 (권장)
- Entity는 그대로 유지
- Repository에서 현재 사용자 ID를 Model에 추가
- 위 코드에서 채택한 방식

---

## 6. 필요한 패키지 및 설정

### 6.1 pubspec.yaml 수정

```yaml
dependencies:
  # 기존 패키지들...

  # Supabase
  supabase_flutter: ^2.5.0  # 최신 버전 확인

  # 환경 변수 (선택사항)
  flutter_dotenv: ^5.1.0

  # 보안 저장소 (세션 토큰 저장)
  flutter_secure_storage: ^9.0.0
```

### 6.2 Supabase 초기화

#### main.dart 수정
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,  // PKCE 플로우 사용 (보안 강화)
      autoRefreshToken: true,
      persistSession: true,
    ),
  );

  // Hive 초기화
  await Hive.initFlutter();

  // Timezone 초기화
  tz.initializeTimeZones();
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // 한국어 날짜 포맷
  await initializeDateFormatting('ko_KR', null);

  // 알림 초기화
  await _initializeNotifications();

  // DI 초기화
  await configureDependencies();

  // 알림 예약
  await scheduleDailyNotification();

  runApp(const App());
}
```

#### DI 모듈에 Supabase 등록
```dart
// lib/core/di/supabase_module.dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
```

### 6.3 .env 파일 설정

```env
# .env
SUPABASE_URL=https://sdapwfjvppusvatzvmdl.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNkYXB3Zmp2cHB1c3ZhdHp2bWRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMjcwNzcsImV4cCI6MjA4MzkwMzA3N30.8-X1ZXlz42P3VLWJ1W2pJ3Ntq7aLvlJjH_rXSrbsyCw
```

**주의**: `.env` 파일을 `.gitignore`에 추가하세요!

```
# .gitignore
.env
.env.local
.env.*.local
```

### 6.4 Supabase 대시보드 설정

#### 이메일 인증 활성화
1. Supabase Dashboard → Authentication → Settings
2. "Enable email confirmations" 체크
3. Email Templates에서 확인 이메일 커스터마이징

#### 이메일 템플릿 예시
```html
<h2>이메일 인증</h2>
<p>NoGERD 회원가입을 환영합니다!</p>
<p>아래 버튼을 클릭하여 이메일을 인증해주세요:</p>
<a href="{{ .ConfirmationURL }}">이메일 인증하기</a>
```

#### Deep Link 설정 (모바일)
iOS: `info.plist`에 URL Scheme 추가
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>no-gerd</string>
    </array>
  </dict>
</array>
```

Android: `AndroidManifest.xml`에 Intent Filter 추가
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="no-gerd" />
</intent-filter>
```

---

## 7. 단계별 구현 가이드

### Phase 1: 기초 설정 (1일)

#### 1.1 패키지 설치
```bash
flutter pub add supabase_flutter flutter_dotenv flutter_secure_storage
flutter pub get
```

#### 1.2 환경 설정
- `.env` 파일 생성 및 Supabase 자격 증명 추가
- `.gitignore`에 `.env` 추가
- `pubspec.yaml`에 `.env` assets 추가

```yaml
flutter:
  assets:
    - .env
    - assets/icon.png
```

#### 1.3 Supabase 초기화
- `main.dart`에 초기화 코드 추가
- DI 모듈에 `SupabaseClient` 등록

#### 1.4 스키마 마이그레이션
- Supabase SQL Editor에서 스키마 수정 SQL 실행
- `updated_at` 컬럼 추가
- 누락된 필드 추가

### Phase 2: Auth Feature 구현 (2-3일)

#### 2.1 디렉토리 구조 생성
```bash
mkdir -p lib/features/auth/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets},di}
```

#### 2.2 Domain Layer
- `User` Entity 생성
- `IAuthRepository` Interface 생성
- UseCases 생성 (SignIn, SignUp, SignOut, GetCurrentUser)

#### 2.3 Data Layer
- `UserModel` 생성 (Freezed + json_serializable)
- `AuthRemoteDataSource` Interface 및 구현
- `AuthRepositoryImpl` 구현

#### 2.4 Presentation Layer
- `AuthBloc`, `AuthEvent`, `AuthState` 생성
- `LoginPage`, `SignUpPage`, `EmailVerificationPage` 생성

#### 2.5 DI 설정
- `auth_module.dart` 생성
- Injectable 어노테이션 추가
- `build_runner` 실행

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2.6 라우팅 설정
- `App` 위젯에 `AuthBloc` 추가
- 초기 라우팅 로직 구현 (Authenticated → Home, Unauthenticated → Login)

### Phase 3: Record Feature 통합 (3-4일)

#### 3.1 Model 생성
- `SymptomRecordModel` (Freezed + json_serializable)
- `MealRecordModel`
- `MedicationRecordModel`
- `LifestyleRecordModel`

#### 3.2 DataSource 구현
- `RecordRemoteDataSource` Interface
- `SupabaseRecordDataSource` 구현
- 각 기록 타입별 CRUD 메서드

#### 3.3 Repository 교체
- 기존 `RecordRepositoryImpl` → `SupabaseRecordRepositoryImpl`
- Injectable 설정 변경
- `AuthRepository` 의존성 주입 (userId 가져오기)

#### 3.4 테스트
- 로그인 후 기록 추가 테스트
- 기록 조회 테스트
- 기록 수정/삭제 테스트
- 다른 계정에서 데이터 격리 확인

### Phase 4: 기존 Features 업데이트 (1-2일)

#### 4.1 Home Feature
- `HomeBloc`에서 실제 데이터 로드
- RecordRepository 의존성 주입
- 샘플 데이터 제거

#### 4.2 Calendar Feature
- 날짜별 기록 로드
- 캘린더 마커 표시

#### 4.3 Insights Feature
- 통계 데이터 계산
- 트렌드 분석

### Phase 5: 고급 기능 (선택사항, 2-3일)

#### 5.1 오프라인 지원
- Hive를 캐시로 사용
- 네트워크 연결 확인
- 동기화 로직

#### 5.2 실시간 업데이트
```dart
// Supabase Realtime 사용
_supabase
  .from('symptom_records')
  .stream(primaryKey: ['id'])
  .listen((records) {
    // UI 업데이트
  });
```

#### 5.3 User Settings 동기화
- `user_settings` 테이블 활용
- 알림 설정, 테마 등 서버 저장

### Phase 6: 테스트 및 최적화 (2-3일)

#### 6.1 Unit Test
- Repository 테스트 (Mocktail)
- UseCase 테스트
- BLoC 테스트 (bloc_test)

#### 6.2 Integration Test
- 로그인 플로우 테스트
- 기록 CRUD 테스트

#### 6.3 성능 최적화
- 쿼리 최적화 (인덱스 활용)
- 페이지네이션 (무한 스크롤)
- 이미지 최적화 (프로필 사진 등)

#### 6.4 에러 처리
- 네트워크 오류 핸들링
- 사용자 친화적 에러 메시지
- Retry 로직

---

## 8. 마이그레이션 전략

### 8.1 기존 사용자 데이터 마이그레이션

현재는 인메모리 저장소이므로 기존 데이터가 없습니다. 하지만 향후를 위한 전략:

#### Hive → Supabase 마이그레이션 (향후)
```dart
Future<void> migrateLocalDataToSupabase() async {
  // 1. 로컬 Hive 데이터 읽기
  final box = await Hive.openBox('records');
  final localRecords = box.values.toList();

  // 2. Supabase로 업로드
  for (final record in localRecords) {
    await _recordRepository.addSymptomRecord(record);
  }

  // 3. 로컬 데이터 삭제
  await box.clear();
}
```

### 8.2 점진적 배포 전략

#### 단계 1: Dual Write
- 로컬(Hive)과 원격(Supabase) 동시 저장
- 읽기는 로컬에서

#### 단계 2: Dual Read
- 로컬에서 읽고, 없으면 원격에서
- 쓰기는 양쪽

#### 단계 3: Remote Only
- 원격만 사용
- 로컬은 캐시로만 활용

### 8.3 Feature Flag

```dart
class FeatureFlags {
  static const bool useSupabase = true;
  static const bool useLocalCache = true;
}

@LazySingleton(as: IRecordRepository)
class HybridRecordRepository implements IRecordRepository {
  final SupabaseRecordRepository _remote;
  final HiveRecordRepository _local;

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  ) async {
    if (FeatureFlags.useSupabase) {
      return _remote.getSymptomRecords(date);
    } else {
      return _local.getSymptomRecords(date);
    }
  }
}
```

---

## 9. 보안 고려사항

### 9.1 RLS (Row Level Security)

**현재 정책**:
```sql
CREATE POLICY "Users CRUD own symptom_records" ON symptom_records
  FOR ALL USING (auth.uid() = user_id);
```

**확인 사항**:
- 모든 테이블에 RLS 활성화됨
- 사용자는 자신의 데이터만 접근 가능
- `user_id` 컬럼이 반드시 필요

**추가 권장 정책**:
```sql
-- INSERT 시 user_id 자동 설정
CREATE POLICY "Users insert own records" ON symptom_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- UPDATE/DELETE 시 본인 확인
CREATE POLICY "Users update own records" ON symptom_records
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users delete own records" ON symptom_records
  FOR DELETE USING (auth.uid() = user_id);
```

### 9.2 API Key 보안

**절대 노출 금지**:
- Service Role Key: 서버에서만 사용, 절대 클라이언트 노출 금지
- Anon Key: 클라이언트에서 사용 가능 (RLS로 보호됨)

**현재 사용**:
```dart
// .env 파일에서 로드
SUPABASE_ANON_KEY=eyJhbG...  // ← 클라이언트에서 사용 OK
```

### 9.3 비밀번호 정책

Supabase Dashboard → Authentication → Settings:
- 최소 길이: 8자
- 복잡도 요구사항 설정
- 비밀번호 재설정 토큰 만료 시간

### 9.4 Rate Limiting

Supabase는 기본적으로 Rate Limiting을 제공합니다:
- 익명 사용자: 낮은 제한
- 인증된 사용자: 높은 제한

추가 설정:
```sql
-- 사용자별 요청 제한 (선택사항)
CREATE EXTENSION IF NOT EXISTS pg_cron;
```

### 9.5 HTTPS 강제

모든 Supabase API는 HTTPS를 사용합니다. HTTP 요청은 자동으로 리다이렉트됩니다.

### 9.6 세션 관리

```dart
// 세션 자동 갱신 (기본 활성화)
authOptions: const FlutterAuthClientOptions(
  autoRefreshToken: true,
  persistSession: true,
),
```

**세션 만료 처리**:
```dart
// AuthBloc에서 세션 스트림 구독
_supabase.auth.onAuthStateChange.listen((state) {
  if (state.event == AuthChangeEvent.signedOut) {
    // 로그아웃 처리
  } else if (state.event == AuthChangeEvent.tokenRefreshed) {
    // 토큰 갱신됨
  }
});
```

---

## 10. 예상 문제 및 해결 방안

### 10.1 이메일 인증 문제

**문제**: 사용자가 이메일을 받지 못함

**해결**:
- Supabase Dashboard → Authentication → Email Templates 확인
- SMTP 설정 확인 (커스텀 SMTP 사용 시)
- 스팸 폴더 확인
- 개발 중에는 이메일 인증 비활성화 옵션

```sql
-- 개발용: 이메일 인증 스킵 (프로덕션에서는 절대 사용 금지!)
UPDATE auth.users SET email_confirmed_at = NOW() WHERE email = 'test@example.com';
```

### 10.2 RLS 정책 오류

**문제**: "Row level security policy violation"

**원인**:
- `user_id`가 현재 사용자와 다름
- RLS 정책 설정 오류

**해결**:
```dart
// 항상 현재 사용자 ID 사용
final userId = _supabase.auth.currentUser?.id;
if (userId == null) {
  throw Exception('로그인이 필요합니다');
}
```

### 10.3 Enum 매핑 오류

**문제**: DB의 String 값과 Dart Enum 불일치

**해결**:
```dart
// safe mapping
GerdSymptom fromString(String value) {
  try {
    return GerdSymptom.values.firstWhere((e) => e.name == value);
  } catch (e) {
    // fallback
    return GerdSymptom.heartburn;
  }
}
```

### 10.4 네트워크 오류

**문제**: 인터넷 연결 없음

**해결**:
```dart
try {
  final records = await _remoteDataSource.getSymptomRecords(date);
  return Right(records);
} on SocketException {
  return const Left(Failure.network('인터넷 연결을 확인해주세요'));
} on PostgrestException catch (e) {
  return Left(Failure.database(e.message));
}
```

---

## 11. 결론

### 11.1 주요 포인트

1. **Clean Architecture 유지**: 기존 구조를 최대한 유지하면서 Data Layer만 교체
2. **점진적 마이그레이션**: Auth → Record → 기타 Features 순서로
3. **보안 우선**: RLS, 환경 변수, HTTPS 등
4. **사용자 경험**: 이메일 인증, 에러 메시지, 오프라인 지원

### 11.2 예상 일정

| Phase | 작업 | 예상 소요 시간 |
|-------|------|---------------|
| Phase 1 | 기초 설정 | 1일 |
| Phase 2 | Auth Feature | 2-3일 |
| Phase 3 | Record Feature 통합 | 3-4일 |
| Phase 4 | 기존 Features 업데이트 | 1-2일 |
| Phase 5 | 고급 기능 (선택) | 2-3일 |
| Phase 6 | 테스트 및 최적화 | 2-3일 |
| **총계** | | **11-16일** |

### 11.3 다음 단계

1. 스키마 마이그레이션 SQL 검토 및 실행
2. Auth Feature 구현 시작
3. 구현 중 이 문서를 참조하여 진행

### 11.4 추가 리소스

- [Supabase Flutter 공식 문서](https://supabase.com/docs/reference/dart/introduction)
- [Supabase Auth 가이드](https://supabase.com/docs/guides/auth)
- [Row Level Security 가이드](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter Clean Architecture 예제](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)

---

**작성자**: Claude (AI Assistant)
**검토 필요**: Schema 마이그레이션 SQL, Entity 수정 여부, Feature Flag 사용 여부
**업데이트 이력**: 2026-01-14 초안 작성
