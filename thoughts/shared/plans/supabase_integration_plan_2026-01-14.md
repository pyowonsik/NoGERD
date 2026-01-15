# NoGERD Supabase 백엔드 통합 구현 계획

**작성일**: 2026-01-14
**프로젝트**: NoGERD (역류성 식도염 기록 앱)
**목적**: Supabase 백엔드 통합 및 이메일 인증 시스템 구현

---

## 📋 개요

### 프로젝트 목표
- 현재 인메모리 저장소를 Supabase PostgreSQL 백엔드로 전환
- 이메일 인증 기반 사용자 인증 시스템 구축
- Clean Architecture 원칙 유지
- 기존 코드 최소 변경으로 통합

### 주요 변경사항
- 인증 시스템 추가 (Auth Feature)
- 데이터 레이어 교체 (인메모리 → Supabase)
- 사용자별 데이터 격리 (RLS)
- 실시간 동기화 지원

### 예상 소요 시간
- **핵심 기능**: 7-10일
- **고급 기능**: 추가 2-3일
- **테스트 및 최적화**: 2-3일
- **총계**: 11-16일

---

## 🎯 Phase 1: 기초 설정 및 환경 구성

**소요 시간**: 1일
**목표**: Supabase 연결 및 스키마 마이그레이션 완료

### 1.1 패키지 설치

```bash
flutter pub add supabase_flutter
flutter pub add flutter_dotenv
flutter pub add flutter_secure_storage
flutter pub get
```

**체크리스트**:
- [ ] `supabase_flutter` 패키지 추가
- [ ] `flutter_dotenv` 패키지 추가
- [ ] `flutter_secure_storage` 패키지 추가
- [ ] `flutter pub get` 실행

### 1.2 환경 설정

**파일**: `.env`
```env
SUPABASE_URL=https://sdapwfjvppusvatzvmdl.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNkYXB3Zmp2cHB1c3ZhdHp2bWRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMjcwNzcsImV4cCI6MjA4MzkwMzA3N30.8-X1ZXlz42P3VLWJ1W2pJ3Ntq7aLvlJjH_rXSrbsyCw
```

**파일**: `pubspec.yaml`
```yaml
flutter:
  assets:
    - .env
    - assets/icon.png
```

**파일**: `.gitignore`
```
.env
.env.local
.env.*.local
```

**체크리스트**:
- [ ] `.env` 파일 생성 및 Supabase 자격 증명 추가
- [ ] `pubspec.yaml`의 assets에 `.env` 추가
- [ ] `.gitignore`에 `.env` 추가
- [ ] Git에 `.env` 커밋되지 않는지 확인

### 1.3 Supabase 초기화

**파일**: `lib/main.dart`
```dart
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
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
      persistSession: true,
    ),
  );

  // 기존 초기화 코드...
  await Hive.initFlutter();
  // ...

  await configureDependencies();
  runApp(const App());
}
```

**파일**: `lib/core/di/supabase_module.dart` (신규 생성)
```dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
```

**체크리스트**:
- [ ] `main.dart`에 Supabase 초기화 코드 추가
- [ ] `supabase_module.dart` 생성
- [ ] `build_runner` 실행: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] 앱 실행하여 초기화 오류 없는지 확인

### 1.4 스키마 마이그레이션

**파일**: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/supabase_migration_script.sql`

Supabase SQL Editor에서 실행:
1. Supabase Dashboard → SQL Editor
2. 마이그레이션 스크립트 복사
3. "Run" 클릭
4. 성공 메시지 확인

**주요 변경사항**:
- 모든 테이블에 `updated_at` 컬럼 추가
- `meal_records`: `fullness_level`, `notes` 추가
- `medication_records`: `dosage`, `purpose`, `notes` 추가, `effectiveness` 타입 변경
- `lifestyle_records`: `notes` 추가
- 자동 `updated_at` 갱신 트리거 생성

**체크리스트**:
- [ ] 마이그레이션 스크립트 검토
- [ ] Supabase SQL Editor에서 실행
- [ ] 마이그레이션 성공 확인
- [ ] 테이블 구조 확인 (updated_at 컬럼 존재 여부)

**검증**:
```sql
-- 테이블 컬럼 확인
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'symptom_records' AND table_schema = 'public';
```

---

## 🔐 Phase 2: Auth Feature 구현

**소요 시간**: 2-3일
**목표**: 이메일 인증 기반 로그인 시스템 완성

### 2.1 디렉토리 생성

```bash
mkdir -p lib/features/auth/data/datasources
mkdir -p lib/features/auth/data/models
mkdir -p lib/features/auth/data/repositories
mkdir -p lib/features/auth/domain/entities
mkdir -p lib/features/auth/domain/repositories
mkdir -p lib/features/auth/domain/usecases
mkdir -p lib/features/auth/presentation/bloc
mkdir -p lib/features/auth/presentation/pages
mkdir -p lib/features/auth/presentation/widgets
mkdir -p lib/features/auth/di
```

**체크리스트**:
- [ ] 디렉토리 구조 생성 완료

### 2.2 Domain Layer 구현

#### User Entity

**파일**: `lib/features/auth/domain/entities/user.dart`
```dart
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

#### Auth Repository Interface

**파일**: `lib/features/auth/domain/repositories/auth_repository.dart`
```dart
import 'package:fpdart/fpdart.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, User?>> getCurrentUser();

  Stream<User?> authStateChanges();

  Future<Either<Failure, Unit>> resendVerificationEmail();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);
}
```

#### UseCases

**파일**: `lib/features/auth/domain/usecases/sign_in_usecase.dart`
```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

@injectable
class SignInUseCase implements UseCase<User, SignInParams> {
  final IAuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
```

**체크리스트**:
- [ ] `user.dart` Entity 생성
- [ ] `auth_repository.dart` Interface 생성
- [ ] `sign_in_usecase.dart` 생성
- [ ] `sign_up_usecase.dart` 생성
- [ ] `sign_out_usecase.dart` 생성
- [ ] `get_current_user_usecase.dart` 생성
- [ ] Freezed 코드 생성: `flutter pub run build_runner build --delete-conflicting-outputs`

### 2.3 Data Layer 구현

#### User Model

**파일**: `lib/features/auth/data/models/user_model.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:no_gerd/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'email_confirmed_at') DateTime? emailConfirmedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email!,
      emailConfirmedAt: user.emailConfirmedAt,
      createdAt: user.createdAt!,
      updatedAt: user.updatedAt,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      emailConfirmed: emailConfirmedAt != null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

#### Auth DataSource

**파일**: `lib/features/auth/data/datasources/auth_remote_datasource.dart`

자세한 코드는 `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/nogerd_supabase_integration_2026-01-14.md` 4.4절 참조

**체크리스트**:
- [ ] `user_model.dart` 생성
- [ ] `auth_remote_datasource.dart` (Interface) 생성
- [ ] `supabase_auth_datasource.dart` (구현) 생성
- [ ] `auth_repository_impl.dart` 생성
- [ ] Freezed + json_serializable 코드 생성

#### Auth Repository Implementation

**파일**: `lib/features/auth/data/repositories/auth_repository_impl.dart`

연구 보고서 4.5절 참조

**체크리스트**:
- [ ] Repository 구현 완료
- [ ] 에러 처리 구현 (AuthDataSourceException → Failure 변환)

### 2.4 Presentation Layer 구현

#### Auth BLoC

**파일**: `lib/features/auth/presentation/bloc/auth_event.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkStatus() = AuthEventCheckStatus;
  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = AuthEventSignIn;
  const factory AuthEvent.signUp({
    required String email,
    required String password,
  }) = AuthEventSignUp;
  const factory AuthEvent.signOut() = AuthEventSignOut;
  const factory AuthEvent.resendVerification() = AuthEventResendVerification;
}
```

**파일**: `lib/features/auth/presentation/bloc/auth_state.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.emailVerificationRequired(String email) =
      _EmailVerificationRequired;
  const factory AuthState.error(Failure failure) = _Error;
}
```

**파일**: `lib/features/auth/presentation/bloc/auth_bloc.dart`

연구 보고서 4.6절 참조

**체크리스트**:
- [ ] `auth_event.dart` 생성
- [ ] `auth_state.dart` 생성
- [ ] `auth_bloc.dart` 생성
- [ ] Freezed 코드 생성

#### UI Pages

**파일**: `lib/features/auth/presentation/pages/login_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (user) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                },
                emailVerificationRequired: (email) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EmailVerificationPage(email: email),
                    ),
                  );
                },
                error: (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(failure.message)),
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 로고
                        const Icon(
                          Icons.favorite_rounded,
                          size: 80,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'NoGERD',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '역류성 식도염 관리 도우미',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // 이메일 입력
                        GlassCard(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: '이메일',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '이메일을 입력해주세요';
                              }
                              if (!value.contains('@')) {
                                return '올바른 이메일 형식이 아닙니다';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 비밀번호 입력
                        GlassCard(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '비밀번호',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '비밀번호를 입력해주세요';
                              }
                              if (value.length < 8) {
                                return '비밀번호는 8자 이상이어야 합니다';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 로그인 버튼
                        GradientButton(
                          onPressed: isLoading ? null : _handleLogin,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('로그인'),
                        ),
                        const SizedBox(height: 16),

                        // 회원가입 링크
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text('계정이 없으신가요? 회원가입'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEvent.signIn(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

**체크리스트**:
- [ ] `login_page.dart` 생성
- [ ] `signup_page.dart` 생성 (유사한 구조)
- [ ] `email_verification_page.dart` 생성
- [ ] UI 테스트 (디자인 확인)

### 2.5 DI 설정

**파일**: `lib/features/auth/di/auth_module.dart`
```dart
// Injectable이 자동으로 생성하므로 별도 파일 불필요
// 각 클래스에 @injectable 어노테이션만 추가하면 됨
```

**체크리스트**:
- [ ] 모든 클래스에 `@injectable` 또는 `@lazySingleton` 어노테이션 추가
- [ ] `build_runner` 실행
- [ ] `injection.config.dart` 파일에 Auth 관련 의존성 등록 확인

### 2.6 라우팅 설정

**파일**: `lib/app.dart` (수정)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/home/presentation/bloc/home_bloc.dart';
import 'package:no_gerd/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:no_gerd/screens/splash/splash_screen.dart';
import 'package:no_gerd/shared/shared.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(const AuthEvent.checkStatus()),
        ),
        BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
        BlocProvider<CalendarBloc>(create: (_) => getIt<CalendarBloc>()),
        BlocProvider<InsightsBloc>(create: (_) => getIt<InsightsBloc>()),
        BlocProvider<SettingsBloc>(create: (_) => getIt<SettingsBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NoGERD',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
```

**파일**: `lib/screens/splash/splash_screen.dart` (수정)
```dart
// _navigateToHome() 메서드 수정
void _navigateToHome() {
  Future.delayed(const Duration(milliseconds: 2800), () {
    if (mounted) {
      // AuthBloc 상태 확인
      final authState = context.read<AuthBloc>().state;

      Widget nextScreen;
      authState.maybeWhen(
        authenticated: (_) => nextScreen = const MainScreen(),
        orElse: () => nextScreen = const LoginPage(),
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  });
}
```

**체크리스트**:
- [ ] `App` 위젯에 `AuthBloc` Provider 추가
- [ ] `SplashScreen`에서 인증 상태 확인 로직 추가
- [ ] 라우팅 테스트 (로그인 → 홈, 미로그인 → 로그인 페이지)

### 2.7 테스트

**체크리스트**:
- [ ] 회원가입 테스트 (이메일 발송 확인)
- [ ] 이메일 인증 테스트 (링크 클릭)
- [ ] 로그인 테스트
- [ ] 로그아웃 테스트
- [ ] 세션 유지 테스트 (앱 재시작)

**Supabase Dashboard 확인**:
- Authentication → Users에서 사용자 생성 확인
- email_confirmed_at 필드 확인

---

## 💾 Phase 3: Record Feature 통합

**소요 시간**: 3-4일
**목표**: 기록 데이터를 Supabase에 저장 및 조회

### 3.1 Model 생성

#### SymptomRecordModel

**파일**: `lib/features/record/data/models/symptom_record_model.dart`
```dart
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
    required List<String> symptoms,
    required int severity,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SymptomRecordModel;

  const SymptomRecordModel._();

  factory SymptomRecordModel.fromJson(Map<String, dynamic> json) =>
      _$SymptomRecordModelFromJson(json);

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

**체크리스트**:
- [ ] `symptom_record_model.dart` 생성
- [ ] `meal_record_model.dart` 생성
- [ ] `medication_record_model.dart` 생성
- [ ] `lifestyle_record_model.dart` 생성
- [ ] `toEntity()` 메서드 구현 (DB → Domain)
- [ ] `fromEntity()` 메서드 구현 (Domain → DB)
- [ ] Freezed + json_serializable 코드 생성

**중요**: Enum 매핑 주의
- `GerdSymptom.heartburn` → `"heartburn"` (String)
- `MealType.breakfast` → `"breakfast"`
- 등등

### 3.2 DataSource 구현

**파일**: `lib/features/record/data/datasources/record_remote_datasource.dart`
```dart
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';

abstract class RecordRemoteDataSource {
  // Symptom Records
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date);
  Future<void> addSymptomRecord(SymptomRecordModel record);
  Future<void> updateSymptomRecord(SymptomRecordModel record);
  Future<void> deleteSymptomRecord(String id);

  // Meal Records
  Future<List<MealRecordModel>> getMealRecords(DateTime date);
  Future<void> addMealRecord(MealRecordModel record);
  Future<void> updateMealRecord(MealRecordModel record);
  Future<void> deleteMealRecord(String id);

  // Medication Records
  Future<List<MedicationRecordModel>> getMedicationRecords(DateTime date);
  Future<void> addMedicationRecord(MedicationRecordModel record);
  Future<void> updateMedicationRecord(MedicationRecordModel record);
  Future<void> deleteMedicationRecord(String id);

  // Lifestyle Records
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date);
  Future<void> addLifestyleRecord(LifestyleRecordModel record);
  Future<void> updateLifestyleRecord(LifestyleRecordModel record);
  Future<void> deleteLifestyleRecord(String id);
}
```

**파일**: `lib/features/record/data/datasources/supabase_record_datasource.dart`

연구 보고서 5.1절 참조 (코드 예시 있음)

**체크리스트**:
- [ ] `record_remote_datasource.dart` Interface 생성
- [ ] `supabase_record_datasource.dart` 구현
- [ ] Symptom CRUD 메서드 구현
- [ ] Meal CRUD 메서드 구현
- [ ] Medication CRUD 메서드 구현
- [ ] Lifestyle CRUD 메서드 구현
- [ ] `RecordDataSourceException` 정의

### 3.3 Repository 교체

**파일**: `lib/features/record/data/repositories/supabase_record_repository_impl.dart`

연구 보고서 5.3절 참조

**주요 로직**:
```dart
@override
Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record) async {
  try {
    // 1. 현재 사용자 ID 가져오기
    final userResult = await _authRepository.getCurrentUser();
    final userId = userResult.fold(
      (failure) => throw Exception('사용자 정보를 가져올 수 없습니다'),
      (user) => user?.id ?? throw Exception('로그인이 필요합니다'),
    );

    // 2. Entity → Model 변환 (userId 추가)
    final model = SymptomRecordModel.fromEntity(record, userId);

    // 3. DataSource를 통해 저장
    await _remoteDataSource.addSymptomRecord(model);

    return const Right(unit);
  } on RecordDataSourceException catch (e) {
    return Left(Failure.database(e.message));
  } catch (e) {
    return Left(Failure.unexpected(e.toString()));
  }
}
```

**파일**: `lib/core/di/injection.dart` (수정)
```dart
// 기존 RecordRepositoryImpl을 주석 처리하고 새 구현 사용
// @LazySingleton(as: IRecordRepository)
// class RecordRepositoryImpl implements IRecordRepository { ... }

// 새 구현이 자동으로 등록됨
```

**체크리스트**:
- [ ] `supabase_record_repository_impl.dart` 생성
- [ ] `IAuthRepository` 의존성 주입 (userId 가져오기)
- [ ] 모든 CRUD 메서드 구현
- [ ] `getAllRecords()` 메서드 구현 (4가지 타입 통합 조회)
- [ ] Injectable 설정 변경 (기존 구현 비활성화)
- [ ] 기존 `RecordRepositoryImpl` 백업 또는 삭제

### 3.4 테스트

**시나리오 1: 기록 추가**
1. 로그인
2. 증상 기록 추가
3. Supabase Dashboard에서 데이터 확인

**시나리오 2: 기록 조회**
1. 홈 화면에서 오늘 기록 확인
2. 캘린더에서 날짜별 기록 확인

**시나리오 3: RLS 확인**
1. 계정 A로 기록 추가
2. 로그아웃 후 계정 B로 로그인
3. 계정 A의 기록이 보이지 않는지 확인

**체크리스트**:
- [ ] 로그인 후 증상 기록 추가 테스트
- [ ] 식사 기록 추가 테스트
- [ ] 약물 기록 추가 테스트
- [ ] 생활습관 기록 추가 테스트
- [ ] 기록 조회 테스트
- [ ] 기록 수정 테스트
- [ ] 기록 삭제 테스트
- [ ] RLS 확인 (다른 계정 데이터 격리)

**Supabase SQL로 확인**:
```sql
-- 특정 사용자의 기록 수
SELECT user_id, COUNT(*)
FROM symptom_records
GROUP BY user_id;

-- 모든 기록 조회 (RLS 적용됨)
SELECT * FROM symptom_records;
```

---

## 🔄 Phase 4: 기존 Features 업데이트

**소요 시간**: 1-2일
**목표**: 홈, 캘린더, 인사이트 페이지에 실제 데이터 연동

### 4.1 Home Feature

**파일**: `lib/features/home/presentation/bloc/home_bloc.dart` (수정)

**변경사항**:
- 샘플 데이터 제거
- `RecordRepository`에서 실제 데이터 로드

```dart
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IRecordRepository _recordRepository; // 이미 주입되어 있음

  HomeBloc(this._recordRepository) : super(const HomeState()) {
    on<HomeEventLoad>(_onLoad);
  }

  Future<void> _onLoad(HomeEventLoad event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));

    final today = DateTime.now();

    // 실제 데이터 로드
    final result = await _recordRepository.getAllRecords(today);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (records) {
        // 건강 점수 계산, 요약 생성 등
        final healthScore = _calculateHealthScore(records);
        final summary = _generateSummary(records);

        emit(state.copyWith(
          isLoading: false,
          healthScore: healthScore,
          todaySummary: summary,
          recentRecords: records,
        ));
      },
    );
  }

  // ...
}
```

**체크리스트**:
- [ ] `HomeBloc`에서 실제 데이터 로드
- [ ] 샘플 데이터 제거
- [ ] UI 테스트 (기록 표시 확인)

### 4.2 Calendar Feature

**파일**: `lib/features/calendar/presentation/bloc/calendar_bloc.dart` (수정)

**변경사항**:
- 월별 데이터 로드
- 날짜별 마커 표시

**체크리스트**:
- [ ] 날짜별 기록 로드 구현
- [ ] 캘린더 마커 표시
- [ ] 날짜 선택 시 상세 기록 표시

### 4.3 Insights Feature

**파일**: `lib/features/insights/presentation/bloc/insights_bloc.dart` (수정)

**변경사항**:
- 통계 데이터 계산
- 트렌드 분석

**체크리스트**:
- [ ] 통계 데이터 계산
- [ ] 트렌드 분석
- [ ] 차트 데이터 연동

### 4.4 Settings Feature

**파일**: `lib/features/settings/presentation/pages/settings_page.dart` (수정)

**추가 기능**:
- 사용자 정보 표시
- 로그아웃 버튼

```dart
// 사용자 정보 섹션 추가
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    return state.maybeWhen(
      authenticated: (user) => GlassCard(
        child: Column(
          children: [
            const Text('로그인 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user.email, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            GradientButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEvent.signOut());
              },
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  },
),
```

**체크리스트**:
- [ ] 사용자 정보 표시
- [ ] 로그아웃 버튼 추가
- [ ] (선택) `user_settings` 테이블 연동

---

## 🚀 Phase 5: 고급 기능 (선택사항)

**소요 시간**: 2-3일
**목표**: 오프라인 지원, 실시간 업데이트 등

### 5.1 오프라인 지원

**전략**: Hive를 캐시로 사용

**파일**: `lib/features/record/data/repositories/hybrid_record_repository.dart`
```dart
@LazySingleton(as: IRecordRepository)
class HybridRecordRepository implements IRecordRepository {
  final RecordRemoteDataSource _remote;
  final RecordLocalDataSource _local; // Hive

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  ) async {
    try {
      // 1. 원격에서 가져오기 시도
      final remoteRecords = await _remote.getSymptomRecords(date);

      // 2. 로컬 캐시 업데이트
      await _local.cacheSymptomRecords(date, remoteRecords);

      return Right(remoteRecords.map((m) => m.toEntity()).toList());
    } on SocketException {
      // 3. 네트워크 오류 시 로컬 캐시 사용
      try {
        final localRecords = await _local.getSymptomRecords(date);
        return Right(localRecords.map((m) => m.toEntity()).toList());
      } catch (e) {
        return const Left(Failure.network('인터넷 연결을 확인해주세요'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record) async {
    try {
      // 1. 로컬에 먼저 저장 (즉시 UI 업데이트)
      await _local.addSymptomRecord(record);

      // 2. 원격에 동기화
      await _remote.addSymptomRecord(SymptomRecordModel.fromEntity(record, userId));

      return const Right(unit);
    } on SocketException {
      // 3. 네트워크 오류 시 동기화 대기열에 추가
      await _local.addToPendingSync(record);
      return const Right(unit);
    }
  }
}
```

**체크리스트**:
- [ ] Hive DataSource 구현
- [ ] Hybrid Repository 구현
- [ ] 네트워크 연결 확인 로직
- [ ] 동기화 메커니즘 (백그라운드 작업)

### 5.2 실시간 업데이트

**Supabase Realtime** 사용:

```dart
// BLoC에서 실시간 스트림 구독
final subscription = _supabase
    .from('symptom_records')
    .stream(primaryKey: ['id'])
    .listen((records) {
      // UI 자동 업데이트
      add(HomeEventRecordsUpdated(records));
    });
```

**체크리스트**:
- [ ] Supabase Realtime 구독 구현
- [ ] BLoC에 스트림 연결
- [ ] UI 자동 업데이트 테스트

### 5.3 User Settings 동기화

**파일**: `lib/features/settings/data/datasources/settings_remote_datasource.dart`

```dart
@LazySingleton(as: SettingsRemoteDataSource)
class SupabaseSettingsDataSource implements SettingsRemoteDataSource {
  final SupabaseClient _supabase;

  @override
  Future<SettingsModel> loadSettings() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('로그인이 필요합니다');

    final response = await _supabase
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .single();

    return SettingsModel.fromJson(response);
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('로그인이 필요합니다');

    await _supabase.from('user_settings').upsert({
      'user_id': userId,
      ...settings.toJson(),
    });
  }
}
```

**체크리스트**:
- [ ] `user_settings` CRUD 구현
- [ ] 알림 설정 저장
- [ ] 테마 설정 저장

### 5.4 프로필 기능

**Supabase Storage** 사용:

```dart
// 프로필 사진 업로드
Future<String> uploadProfilePhoto(File file) async {
  final userId = _supabase.auth.currentUser!.id;
  final path = 'profiles/$userId/avatar.jpg';

  await _supabase.storage.from('avatars').upload(path, file);

  final url = _supabase.storage.from('avatars').getPublicUrl(path);
  return url;
}
```

**체크리스트**:
- [ ] 프로필 사진 업로드 (Supabase Storage)
- [ ] 사용자 이름 변경
- [ ] 이메일 변경

---

## 🧪 Phase 6: 테스트 및 최적화

**소요 시간**: 2-3일
**목표**: 품질 보증 및 성능 최적화

### 6.1 Unit Test

**파일**: `test/features/auth/data/repositories/auth_repository_impl_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:no_gerd/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('signIn', () {
    test('성공 시 User를 반환해야 함', () async {
      // Arrange
      final userModel = UserModel(...);
      when(() => mockDataSource.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => userModel);

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isRight(), true);
    });

    test('실패 시 Failure를 반환해야 함', () async {
      // Arrange
      when(() => mockDataSource.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(AuthDataSourceException('Invalid credentials'));

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'wrong',
      );

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
```

**체크리스트**:
- [ ] AuthRepository 테스트
- [ ] RecordRepository 테스트
- [ ] UseCase 테스트
- [ ] BLoC 테스트 (bloc_test 사용)

### 6.2 Integration Test

**파일**: `integration_test/auth_flow_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:no_gerd/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('로그인 플로우 테스트', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 로그인 페이지 진입
    expect(find.text('NoGERD'), findsOneWidget);

    // 이메일 입력
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');

    // 비밀번호 입력
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // 로그인 버튼 클릭
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    // 홈 화면 진입 확인
    expect(find.text('건강 현황'), findsOneWidget);
  });
}
```

**체크리스트**:
- [ ] 로그인 플로우 테스트
- [ ] 기록 CRUD 플로우 테스트
- [ ] (선택) 오프라인 모드 테스트

### 6.3 성능 최적화

**쿼리 최적화**:
```sql
-- 인덱스 확인
SELECT * FROM pg_indexes WHERE tablename = 'symptom_records';

-- 쿼리 성능 분석
EXPLAIN ANALYZE
SELECT * FROM symptom_records
WHERE user_id = 'xxx' AND record_datetime >= '2026-01-01';
```

**페이지네이션**:
```dart
Future<List<SymptomRecordModel>> getSymptomRecords({
  required DateTime startDate,
  required DateTime endDate,
  int limit = 20,
  int offset = 0,
}) async {
  final response = await _supabase
      .from('symptom_records')
      .select()
      .gte('record_datetime', startDate.toIso8601String())
      .lt('record_datetime', endDate.toIso8601String())
      .order('record_datetime', ascending: false)
      .range(offset, offset + limit - 1);

  return (response as List).map((json) => SymptomRecordModel.fromJson(json)).toList();
}
```

**체크리스트**:
- [ ] 쿼리 최적화 (인덱스 활용)
- [ ] 페이지네이션 구현
- [ ] 이미지 최적화 (프로필 사진 등)
- [ ] 캐싱 전략 검토

### 6.4 에러 처리

**네트워크 오류**:
```dart
try {
  final records = await _remoteDataSource.getSymptomRecords(date);
  return Right(records.map((m) => m.toEntity()).toList());
} on SocketException {
  return const Left(Failure.network('인터넷 연결을 확인해주세요'));
} on PostgrestException catch (e) {
  if (e.code == '23505') {
    return const Left(Failure.database('이미 존재하는 데이터입니다'));
  }
  return Left(Failure.database(e.message));
} on TimeoutException {
  return const Left(Failure.network('요청 시간이 초과되었습니다'));
} catch (e) {
  return Left(Failure.unexpected(e.toString()));
}
```

**체크리스트**:
- [ ] 네트워크 오류 핸들링
- [ ] 사용자 친화적 에러 메시지
- [ ] Retry 로직 (선택)
- [ ] Timeout 설정

### 6.5 보안 감사

**체크리스트**:
- [ ] RLS 정책 재확인 (모든 테이블)
- [ ] API Key 노출 확인 (.env 파일, .gitignore)
- [ ] HTTPS 강제 확인
- [ ] 세션 관리 확인 (자동 갱신, 만료 처리)
- [ ] SQL Injection 방어 확인 (Supabase는 자동 방어)

**Supabase Dashboard 확인**:
- Authentication → Settings → Password Policy
- Database → Policies (RLS 활성화 확인)
- API Settings → Rate Limiting

---

## 📦 Phase 7: 배포 준비 (선택사항)

**소요 시간**: 1-2일

### 7.1 환경 설정

**Production Supabase 프로젝트 생성**:
1. Supabase Dashboard → New Project
2. Production용 프로젝트 생성
3. 스키마 마이그레이션 실행

**환경별 .env 파일**:
- `.env.dev` (개발)
- `.env.prod` (프로덕션)

### 7.2 Supabase 설정

**이메일 템플릿 커스터마이징**:
- Authentication → Email Templates
- Confirmation, Password Reset 템플릿 수정

**SMTP 설정** (커스텀 도메인):
- Authentication → Settings → SMTP Settings
- 커스텀 SMTP 서버 설정

### 7.3 앱 설정

**Deep Link 설정**:
- iOS: `info.plist`
- Android: `AndroidManifest.xml`

**체크리스트**:
- [ ] Deep Link 설정
- [ ] 앱 아이콘 확인
- [ ] 앱 이름 확인
- [ ] 버전 업데이트 (pubspec.yaml)

### 7.4 문서화

**체크리스트**:
- [ ] API 문서 작성
- [ ] 사용자 가이드 작성
- [ ] 개발자 가이드 작성
- [ ] 변경 로그 작성

---

## 📊 진행 상황 추적

### 완료된 작업
- [x] 연구 보고서 작성
- [x] 마이그레이션 스크립트 작성
- [x] 구현 체크리스트 작성
- [x] 구현 계획 작성

### 진행 중인 작업
- [ ] (작업 시작 시 업데이트)

### 다음 작업
- [ ] Phase 1 시작: 패키지 설치 및 환경 설정

---

## 🔍 트러블슈팅 가이드

### 이메일 인증 문제

**증상**: 사용자가 이메일을 받지 못함

**해결**:
1. Supabase Dashboard → Authentication → Email Templates 확인
2. SMTP 설정 확인
3. 스팸 폴더 확인
4. 개발 중에는 SQL로 수동 인증:
```sql
UPDATE auth.users SET email_confirmed_at = NOW() WHERE email = 'test@example.com';
```

### RLS 정책 오류

**증상**: "Row level security policy violation"

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

### Enum 매핑 오류

**증상**: DB의 String 값과 Dart Enum 불일치

**해결**:
```dart
// safe mapping
GerdSymptom fromString(String value) {
  try {
    return GerdSymptom.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return GerdSymptom.heartburn; // fallback
  }
}
```

### 네트워크 오류

**증상**: 인터넷 연결 없음

**해결**:
```dart
try {
  final records = await _remoteDataSource.getSymptomRecords(date);
  return Right(records);
} on SocketException {
  return const Left(Failure.network('인터넷 연결을 확인해주세요'));
}
```

---

## 📚 참고 자료

### 파일 위치
- 연구 보고서: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/nogerd_supabase_integration_2026-01-14.md`
- 마이그레이션 스크립트: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/supabase_migration_script.sql`
- 구현 체크리스트: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/implementation_checklist.md`
- 코드 예시: `/Users/pyowonsik/Downloads/workspace/NoGERD/thoughts/shared/research/code_examples.md`

### 외부 문서
- [Supabase Flutter 공식 문서](https://supabase.com/docs/reference/dart/introduction)
- [Supabase Auth 가이드](https://supabase.com/docs/guides/auth)
- [Row Level Security 가이드](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter Clean Architecture 예제](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)

---

## 🎯 핵심 원칙

1. **Clean Architecture 유지**: 기존 구조를 최대한 유지하면서 Data Layer만 교체
2. **점진적 마이그레이션**: Auth → Record → 기타 Features 순서로
3. **보안 우선**: RLS, 환경 변수, HTTPS 등
4. **사용자 경험**: 이메일 인증, 에러 메시지, 오프라인 지원

---

**마지막 업데이트**: 2026-01-14
**작성자**: Claude (AI Assistant)
**검토 필요**: 각 Phase 시작 전 체크리스트 확인
