# NoGERD Supabase 통합 코드 예시

**작성일**: 2026-01-14
**목적**: 복사해서 바로 사용 가능한 코드 예시 제공

---

## 1. 환경 설정

### .env 파일
```env
# .env
SUPABASE_URL=https://sdapwfjvppusvatzvmdl.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNkYXB3Zmp2cHB1c3ZhdHp2bWRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMjcwNzcsImV4cCI6MjA4MzkwMzA3N30.8-X1ZXlz42P3VLWJ1W2pJ3Ntq7aLvlJjH_rXSrbsyCw
```

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter

  # 기존 패키지들...
  flutter_bloc: ^8.1.6
  injectable: ^2.4.4
  fpdart: ^1.1.0
  freezed_annotation: ^2.4.1

  # 새로 추가
  supabase_flutter: ^2.5.0
  flutter_dotenv: ^5.1.0
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  freezed: ^2.5.2
  json_serializable: ^6.7.1
  injectable_generator: ^2.6.2

flutter:
  uses-material-design: true
  assets:
    - .env  # ← 추가
    - assets/icon.png
```

### .gitignore 수정
```
# .gitignore (기존에 추가)
.env
.env.local
.env.*.local
```

---

## 2. main.dart 수정

```dart
// lib/main.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:no_gerd/app.dart';
import 'package:no_gerd/core/di/injection.dart';

/// 플러터 로컬 알림 플러그인
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

  log('Supabase initialized');

  // Hive 초기화
  await Hive.initFlutter();
  // TODO: Record 모델 Adapter 등록 (Hive 저장소 구현 시)

  // Timezone DB 초기화
  tz.initializeTimeZones();

  // 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR', null);

  // 로컬 타임존 설정
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // 알림 초기화
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  // DI 초기화 (새로운 Injectable 기반)
  await configureDependencies();

  // ⚠️ 실제 서비스에서는 권한 승인 이후 호출 권장
  await scheduleDailyNotification();

  runApp(const App());
}

/// 매일 알림 예약
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

  log('Scheduling notification for $scheduledTime');

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

tz.TZDateTime _nextInstanceOfNinePM() {
  final now = tz.TZDateTime.now(tz.local);

  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    21, // 오후 9시
  );

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  log('Next notification scheduled for $scheduledDate');
  return scheduledDate;
}
```

---

## 3. DI 모듈

### lib/core/di/supabase_module.dart (새로 생성)
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

---

## 4. Auth Feature

### User Entity
```dart
// lib/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// 사용자 Entity
@freezed
class User with _$User {
  const factory User({
    /// 사용자 ID (UUID)
    required String id,

    /// 이메일
    required String email,

    /// 이메일 인증 여부
    required bool emailConfirmed,

    /// 생성 시간
    required DateTime createdAt,

    /// 수정 시간
    DateTime? updatedAt,
  }) = _User;
}
```

### User Model
```dart
// lib/features/auth/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:no_gerd/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 사용자 Model (Data Layer)
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

  /// Supabase User에서 생성
  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      emailConfirmedAt: user.emailConfirmedAt,
      createdAt: user.createdAt ?? DateTime.now(),
      updatedAt: user.updatedAt,
    );
  }

  /// Entity로 변환
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

### Auth Repository Interface
```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';

/// 인증 Repository Interface
abstract class IAuthRepository {
  /// 이메일/비밀번호로 회원가입
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
}
```

### Auth DataSource
```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:no_gerd/features/auth/data/models/user_model.dart';

/// Auth DataSource Interface
abstract class AuthRemoteDataSource {
  Future<void> signUp({required String email, required String password});
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
  Future<void> resendVerificationEmail();
  Future<void> sendPasswordResetEmail(String email);
}

/// Supabase Auth DataSource 구현
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
      );

      if (response.user == null) {
        throw Exception('회원가입 실패');
      }
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('회원가입 중 오류 발생: ${e.toString()}');
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
    } catch (e) {
      throw AuthDataSourceException('로그인 중 오류 발생: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('로그아웃 중 오류 발생: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw AuthDataSourceException('사용자 정보 조회 실패: ${e.toString()}');
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
    } catch (e) {
      throw AuthDataSourceException('인증 이메일 발송 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('비밀번호 재설정 이메일 발송 실패: ${e.toString()}');
    }
  }
}

/// Auth DataSource Exception
class AuthDataSourceException implements Exception {
  final String message;
  AuthDataSourceException(this.message);

  @override
  String toString() => 'AuthDataSourceException: $message';
}
```

### Auth Repository Implementation
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
      return Left(_handleAuthError(e.message));
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
      return Left(_handleAuthError(e.message));
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

  /// Auth 에러를 Failure로 변환
  Failure _handleAuthError(String message) {
    if (message.contains('Email not confirmed')) {
      return const Failure.validation('이메일 인증이 필요합니다');
    }
    if (message.contains('Invalid login credentials')) {
      return const Failure.validation('이메일 또는 비밀번호가 잘못되었습니다');
    }
    if (message.contains('User already registered')) {
      return const Failure.validation('이미 가입된 이메일입니다');
    }
    return Failure.unexpected(message);
  }
}
```

### UseCases
```dart
// lib/features/auth/domain/usecases/sign_in_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// 로그인 UseCase
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

/// 로그인 파라미터
class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
```

```dart
// lib/features/auth/domain/usecases/sign_up_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// 회원가입 UseCase
@injectable
class SignUpUseCase implements UseCase<Unit, SignUpParams> {
  final IAuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SignUpParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}

/// 회원가입 파라미터
class SignUpParams {
  final String email;
  final String password;

  SignUpParams({
    required this.email,
    required this.password,
  });
}
```

```dart
// lib/features/auth/domain/usecases/sign_out_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// 로그아웃 UseCase
@injectable
class SignOutUseCase implements UseCase<Unit, NoParams> {
  final IAuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.signOut();
  }
}
```

```dart
// lib/features/auth/domain/usecases/get_current_user_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/domain/repositories/auth_repository.dart';

/// 현재 사용자 조회 UseCase
@injectable
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final IAuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
```

---

## 5. Record Feature Model 예시

### SymptomRecordModel
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
    required List<String> symptoms,
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
  factory SymptomRecordModel.fromEntity(
    SymptomRecord entity,
    String userId,
  ) {
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

---

## 6. 유용한 헬퍼 함수

### Supabase 에러 핸들러
```dart
// lib/core/utils/supabase_error_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:no_gerd/core/error/failures.dart';

/// Supabase 에러를 Failure로 변환
Failure handleSupabaseError(Object error) {
  if (error is PostgrestException) {
    return Failure.database(error.message);
  }
  if (error is AuthException) {
    return Failure.unexpected(error.message);
  }
  return Failure.unexpected(error.toString());
}
```

### 날짜 유틸리티
```dart
// lib/core/utils/date_utils.dart
/// 날짜를 시작 시간으로 변환 (00:00:00)
DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// 날짜를 종료 시간으로 변환 (23:59:59)
DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59);
}

/// 다음 날
DateTime nextDay(DateTime date) {
  return startOfDay(date).add(const Duration(days: 1));
}
```

---

## 7. 코드 생성 후 확인 사항

### 생성해야 할 파일들
```bash
# Freezed 파일들
*.freezed.dart

# JSON Serialization 파일들
*.g.dart

# Injectable 파일
injection.config.dart
```

### build_runner 명령어
```bash
# 전체 재생성
flutter pub run build_runner build --delete-conflicting-outputs

# Watch 모드 (개발 중)
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

**작성자**: Claude (AI Assistant)
**용도**: 복사-붙여넣기 가능한 코드 예시
**참조**: nogerd_supabase_integration_2026-01-14.md
