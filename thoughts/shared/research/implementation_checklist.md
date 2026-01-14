# NoGERD Supabase 통합 구현 체크리스트

**작성일**: 2026-01-14
**목적**: 단계별 구현 작업 추적

---

## Phase 1: 기초 설정

### 1.1 패키지 설치
- [ ] `flutter pub add supabase_flutter`
- [ ] `flutter pub add flutter_dotenv`
- [ ] `flutter pub add flutter_secure_storage`
- [ ] `flutter pub get`

### 1.2 환경 설정
- [ ] `.env` 파일 생성
- [ ] Supabase URL 추가
- [ ] Supabase Anon Key 추가
- [ ] `.gitignore`에 `.env` 추가
- [ ] `pubspec.yaml`의 assets에 `.env` 추가

### 1.3 Supabase 초기화
- [ ] `main.dart`에 `Supabase.initialize()` 추가
- [ ] `SupabaseModule` 생성 (DI)
- [ ] `build_runner` 실행

### 1.4 스키마 마이그레이션
- [ ] `supabase_migration_script.sql` 검토
- [ ] Supabase SQL Editor에서 실행
- [ ] 마이그레이션 성공 확인

---

## Phase 2: Auth Feature

### 2.1 디렉토리 생성
```bash
mkdir -p lib/features/auth/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets},di}
```

- [ ] 디렉토리 구조 생성 완료

### 2.2 Domain Layer
- [ ] `lib/features/auth/domain/entities/user.dart` 생성
- [ ] `lib/features/auth/domain/repositories/auth_repository.dart` 생성
- [ ] `lib/features/auth/domain/usecases/sign_in_usecase.dart` 생성
- [ ] `lib/features/auth/domain/usecases/sign_up_usecase.dart` 생성
- [ ] `lib/features/auth/domain/usecases/sign_out_usecase.dart` 생성
- [ ] `lib/features/auth/domain/usecases/get_current_user_usecase.dart` 생성
- [ ] Freezed 코드 생성 (`flutter pub run build_runner build`)

### 2.3 Data Layer
- [ ] `lib/features/auth/data/models/user_model.dart` 생성
- [ ] `lib/features/auth/data/datasources/auth_remote_datasource.dart` 생성
- [ ] `lib/features/auth/data/datasources/supabase_auth_datasource.dart` 구현
- [ ] `lib/features/auth/data/repositories/auth_repository_impl.dart` 생성
- [ ] JSON 직렬화 코드 생성

### 2.4 Presentation Layer
- [ ] `lib/features/auth/presentation/bloc/auth_bloc.dart` 생성
- [ ] `lib/features/auth/presentation/bloc/auth_event.dart` 생성
- [ ] `lib/features/auth/presentation/bloc/auth_state.dart` 생성
- [ ] `lib/features/auth/presentation/pages/login_page.dart` 생성
- [ ] `lib/features/auth/presentation/pages/signup_page.dart` 생성
- [ ] `lib/features/auth/presentation/pages/email_verification_page.dart` 생성
- [ ] Freezed 코드 생성

### 2.5 DI 설정
- [ ] `lib/features/auth/di/auth_module.dart` 생성
- [ ] `@injectable` 어노테이션 추가
- [ ] `build_runner` 실행

### 2.6 라우팅
- [ ] `App` 위젯에 `AuthBloc` Provider 추가
- [ ] 초기 라우팅 로직 구현
- [ ] `SplashScreen`에서 인증 상태 확인

### 2.7 테스트
- [ ] 회원가입 테스트
- [ ] 이메일 인증 테스트
- [ ] 로그인 테스트
- [ ] 로그아웃 테스트

---

## Phase 3: Record Feature 통합

### 3.1 Model 생성
- [ ] `lib/features/record/data/models/symptom_record_model.dart`
- [ ] `lib/features/record/data/models/meal_record_model.dart`
- [ ] `lib/features/record/data/models/medication_record_model.dart`
- [ ] `lib/features/record/data/models/lifestyle_record_model.dart`
- [ ] `toEntity()` 메서드 구현
- [ ] `fromEntity()` 메서드 구현
- [ ] Freezed + json_serializable 코드 생성

### 3.2 DataSource
- [ ] `lib/features/record/data/datasources/record_remote_datasource.dart` (Interface)
- [ ] `lib/features/record/data/datasources/supabase_record_datasource.dart` (구현)
- [ ] Symptom CRUD 메서드
- [ ] Meal CRUD 메서드
- [ ] Medication CRUD 메서드
- [ ] Lifestyle CRUD 메서드

### 3.3 Repository 교체
- [ ] `lib/features/record/data/repositories/supabase_record_repository_impl.dart` 생성
- [ ] `AuthRepository` 의존성 주입 (userId 가져오기)
- [ ] Injectable 설정 변경
- [ ] 기존 `RecordRepositoryImpl` 백업

### 3.4 테스트
- [ ] 로그인 후 기록 추가
- [ ] 기록 조회
- [ ] 기록 수정
- [ ] 기록 삭제
- [ ] RLS 확인 (다른 사용자 데이터 접근 불가)

---

## Phase 4: 기존 Features 업데이트

### 4.1 Home Feature
- [ ] `HomeBloc`에서 실제 데이터 로드
- [ ] `RecordRepository` 의존성 주입
- [ ] 샘플 데이터 제거
- [ ] UI 업데이트

### 4.2 Calendar Feature
- [ ] 날짜별 기록 로드
- [ ] 캘린더 마커 표시
- [ ] 날짜 선택 시 기록 표시

### 4.3 Insights Feature
- [ ] 통계 데이터 계산
- [ ] 트렌드 분석
- [ ] 차트 데이터 연동

### 4.4 Settings Feature
- [ ] 사용자 정보 표시
- [ ] 로그아웃 버튼
- [ ] `user_settings` 테이블 연동 (선택사항)

---

## Phase 5: 고급 기능 (선택사항)

### 5.1 오프라인 지원
- [ ] Hive를 캐시로 설정
- [ ] 네트워크 연결 확인
- [ ] Dual Write/Read 로직
- [ ] 동기화 메커니즘

### 5.2 실시간 업데이트
- [ ] Supabase Realtime 구독
- [ ] BLoC에 스트림 연결
- [ ] UI 자동 업데이트

### 5.3 User Settings 동기화
- [ ] `user_settings` CRUD
- [ ] 알림 설정 저장
- [ ] 테마 설정 저장

### 5.4 프로필 기능
- [ ] 프로필 사진 업로드 (Supabase Storage)
- [ ] 사용자 이름 변경
- [ ] 이메일 변경

---

## Phase 6: 테스트 및 최적화

### 6.1 Unit Test
- [ ] AuthRepository 테스트
- [ ] RecordRepository 테스트
- [ ] UseCase 테스트
- [ ] BLoC 테스트

### 6.2 Integration Test
- [ ] 로그인 플로우 테스트
- [ ] 기록 CRUD 플로우 테스트
- [ ] 오프라인 모드 테스트

### 6.3 성능 최적화
- [ ] 쿼리 최적화
- [ ] 페이지네이션 구현
- [ ] 이미지 최적화
- [ ] 캐싱 전략

### 6.4 에러 처리
- [ ] 네트워크 오류 핸들링
- [ ] 사용자 친화적 에러 메시지
- [ ] Retry 로직
- [ ] Timeout 설정

### 6.5 보안 감사
- [ ] RLS 정책 재확인
- [ ] API Key 노출 확인
- [ ] HTTPS 강제 확인
- [ ] 세션 관리 확인

---

## Phase 7: 배포 준비

### 7.1 환경 설정
- [ ] Production Supabase 프로젝트 생성
- [ ] Production `.env` 파일 생성
- [ ] Staging 환경 설정 (선택사항)

### 7.2 Supabase 설정
- [ ] 이메일 템플릿 커스터마이징
- [ ] SMTP 설정 (커스텀 도메인)
- [ ] Rate Limiting 확인
- [ ] 백업 설정

### 7.3 앱 설정
- [ ] Deep Link 설정 (iOS/Android)
- [ ] 앱 아이콘 및 이름 확인
- [ ] 버전 업데이트

### 7.4 문서화
- [ ] API 문서
- [ ] 사용자 가이드
- [ ] 개발자 가이드
- [ ] 변경 로그

### 7.5 릴리스
- [ ] 베타 테스트
- [ ] 앱 스토어 제출
- [ ] Google Play 제출

---

## 코드 생성 명령어 모음

```bash
# Freezed + json_serializable 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# Injectable 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# Watch 모드 (자동 생성)
flutter pub run build_runner watch --delete-conflicting-outputs

# 캐시 클리어 후 재생성
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 유용한 Supabase SQL 쿼리

```sql
-- 모든 사용자 목록
SELECT id, email, email_confirmed_at, created_at FROM auth.users;

-- 특정 사용자의 기록 수
SELECT * FROM get_user_record_count('USER_UUID_HERE');

-- 최근 기록 조회
SELECT * FROM user_recent_records WHERE user_id = 'USER_UUID_HERE' LIMIT 10;

-- RLS 정책 확인
SELECT * FROM pg_policies WHERE schemaname = 'public';

-- 테이블 컬럼 확인
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'symptom_records' AND table_schema = 'public';
```

---

## 트러블슈팅 체크리스트

### 로그인 실패
- [ ] 이메일/비밀번호 정확성 확인
- [ ] 이메일 인증 완료 확인
- [ ] Supabase URL/Key 확인
- [ ] 네트워크 연결 확인

### 기록 추가 실패
- [ ] 로그인 상태 확인
- [ ] RLS 정책 확인
- [ ] user_id 매핑 확인
- [ ] 필수 필드 누락 확인

### 이메일 미수신
- [ ] 스팸 폴더 확인
- [ ] Supabase 이메일 설정 확인
- [ ] SMTP 설정 확인
- [ ] 이메일 주소 정확성 확인

### RLS 오류
- [ ] user_id가 현재 사용자와 일치하는지 확인
- [ ] auth.uid() 사용 확인
- [ ] 정책이 올바르게 설정되었는지 확인

---

## 참고 파일 위치

- 연구 보고서: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/nogerd_supabase_integration_2026-01-14.md`
- 마이그레이션 스크립트: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/supabase_migration_script.sql`
- 구현 체크리스트: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/implementation_checklist.md` (현재 파일)

---

## 진행 상황 추적

### 완료된 작업
- [x] 연구 보고서 작성
- [x] 마이그레이션 스크립트 작성
- [x] 체크리스트 작성

### 진행 중인 작업
- [ ] (작업 시작 시 업데이트)

### 다음 작업
- [ ] Phase 1 시작: 패키지 설치 및 환경 설정

---

**마지막 업데이트**: 2026-01-14
**작성자**: Claude (AI Assistant)
