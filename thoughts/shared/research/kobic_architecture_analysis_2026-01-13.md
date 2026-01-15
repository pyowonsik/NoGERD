# KOBIC 프로젝트 아키텍처 분석 리포트

**날짜**: 2026-01-13
**분석 대상**: /Users/pyowonsik/Downloads/workspace/kobic
**목적**: NoGERD 프로젝트 아키텍처 리팩토링 참고

---

## 1. 프로젝트 개요

**KOBIC**은 **Melos 기반 모노레포** 구조의 도서 관련 Flutter 애플리케이션입니다.
Production-level 아키텍처와 확장 가능한 Feature 구성을 보여줍니다.

---

## 2. 프로젝트 구조

```
kobic/
├── app/
│   └── kobic/                      # 메인 Flutter 앱
├── feature/
│   ├── application/                # Feature 모듈들
│   │   ├── ai_chat/
│   │   ├── store/
│   │   ├── my_library/
│   │   ├── chat/
│   │   └── ...
│   ├── common/
│   └── console/
├── package/
│   ├── core/                       # 핵심 비즈니스 로직 & 유틸리티
│   ├── ui_kit/                     # 디자인 시스템 & 공유 컴포넌트
│   ├── open_board/
│   └── pod_service/                # Serverpod 네트워킹 레이어
├── shared/
│   ├── dependencies/               # DI 설정 & 공유 의존성
│   ├── config/                     # 환경 설정
│   ├── flavor/                     # 빌드 플레이버 관리
│   └── i10n/                       # 국제화
├── melos.yaml                      # 모노레포 설정
└── pubspec.yaml                    # 루트 워크스페이스 설정
```

---

## 3. 기술 스택

### 상태 관리
- `flutter_bloc: ^9.1.1`
- `bloc: ^9.0.0`
- `bloc_concurrency: ^0.3.0`

### DI & 코드 생성
- `get_it: ^8.2.0`
- `injectable: ^2.5.2`
- `build_runner: ^2.7.0`

### 데이터 처리
- `fpdart: ^1.1.0` - 함수형 프로그래밍 (Either 타입)
- `freezed_annotation: ^3.1.0`
- `json_annotation: ^4.9.0`

### 네트워킹
- `dio: ^5.9.0`
- `serverpod_flutter: 2.9.2`

---

## 4. 아키텍처 패턴: Clean Architecture

### Feature별 레이어 구조

```
feature/application/ai_chat/
├── lib/src/
│   ├── di/                         # Dependency Injection
│   │   └── injector.dart           # @microPackageInit
│   ├── data/                       # Data Layer
│   │   └── repository/             # Repository 구현체
│   ├── domain/                     # Domain Layer (비즈니스 로직)
│   │   ├── entities/               # 도메인 모델
│   │   ├── repositories/           # Repository 인터페이스 (I*)
│   │   ├── usecases/               # 비즈니스 로직 조율
│   │   ├── failures/               # 에러 처리
│   │   └── exceptions/             # 도메인 예외
│   └── presentation/               # Presentation Layer
│       ├── blocs/                  # BLoC 상태 관리
│       ├── pages/                  # 화면 위젯
│       ├── widget/                 # 재사용 컴포넌트
│       └── util/                   # 프레젠테이션 유틸
├── test/                           # 테스트
└── pubspec.yaml
```

---

## 5. 상태 관리: BLoC 패턴

### BLoC 구현 패턴

```dart
// ai_chat_bloc.dart
class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc() : super(AiChatState.initial()) {
    on<AiChatEventStarted>(_started);
    on<AiChatEventBookLoaded>(_bookLoaded);
    on<AiChatEventMessagesLoaded>(_messagesLoaded);
  }

  Future<void> _bookLoaded(
    AiChatEventBookLoaded event,
    Emitter<AiChatState> emit,
  ) async {
    // 에러 핸들링과 함께 구현
  }
}
```

### Event / State 분리
```dart
// ai_chat_event.dart (part file)
part of 'ai_chat_bloc.dart';

@freezed
class AiChatEvent with _$AiChatEvent {
  const factory AiChatEvent.started() = AiChatEventStarted;
  const factory AiChatEvent.bookLoaded(int bookId) = AiChatEventBookLoaded;
}

// ai_chat_state.dart (part file)
part of 'ai_chat_bloc.dart';

@freezed
class AiChatState with _$AiChatState {
  const factory AiChatState({
    required bool isLoading,
    required List<AiChatMessage> messages,
    required Option<Failure> failure,
  }) = _AiChatState;

  factory AiChatState.initial() => AiChatState(
    isLoading: false,
    messages: [],
    failure: none(),
  );
}
```

### 앱 레벨 BLoC 설정

```dart
// app.dart
List<BlocProvider> _providers = [
  BlocProvider<AuthBloc>(create: (_) => appGetIt<AuthBloc>()),
  BlocProvider<ThemeBloc>(create: (_) => appGetIt<ThemeBloc>()),
  BlocProvider<AppBloc>(create: (_) => appGetIt<AppBloc>()),
];
```

---

## 6. Dependency Injection

### GetIt + Injectable 패턴

```dart
// app_service_locator.dart
@InjectableInit(
  preferRelativeImports: false,
  asExtension: false,
  externalPackageModulesAfter: [
    ExternalModule(AuthPackageModule),
    ExternalModule(AiChatPackageModule),
  ],
)
Future<void> configureAppDependencies(Env env) async {
  await app_config.init(appGetIt, environment: env.name);
}
```

### Feature 모듈 등록

```dart
// feature/ai_chat/lib/src/di/injector.dart
@microPackageInit
void injectorAiChatModule() {}
```

### Repository 등록 (Data Layer)

```dart
@LazySingleton(as: IAiChatRepository)
class AiChatRepository implements IAiChatRepository {
  const AiChatRepository();
  // 구현...
}
```

---

## 7. 에러 핸들링

### Either<Failure, T> 패턴

```dart
Future<Either<Failure, List<Message>>> call(Params params) async {
  try {
    return await repo.getMessages(params.roomId);
  } catch (e, stackTrace) {
    return left(const UnexpectedFailure('메시지 로드 실패'));
  }
}
```

### Failure 계층 구조

```dart
abstract class Failure {
  factory Failure.serverError(StatusCode, String) = ServerFailure;
  factory Failure.noInternetConnection() = NoInternetFailure;
  factory Failure.unexpected(String) = UnexpectedFailure;
  // ...15+ 실패 타입
}
```

---

## 8. UseCase 아키텍처

### 기본 UseCase

```dart
abstract class UseCase<T, Params, Repo> {
  Repo get repo;
  Future<Either<Failure, T>> call(Params param);
}
```

### Auth 필수 UseCase

```dart
abstract class AuthRequiredUseCase<T, Params, Repo>
    extends UseCase<T, Params, Repo>
    with GlobalAuthMixin {

  String get featureName;
  Future<Either<Failure, T>> executeBusinessLogic(Params param);

  @override
  Future<Either<Failure, T>> call(Params param) {
    return executeWithAuth(featureName, () async {
      return await executeBusinessLogic(param);
    });
  }
}
```

### UseCase Parameter 클래스

```dart
class NoParams extends Equatable { /* 파라미터 없음 */ }
class IdParams extends Equatable { final int id; }
class PaginationParams extends Equatable { final int page, limit; }
```

---

## 9. 네이밍 컨벤션

| 타입 | 패턴 | 예시 |
|------|------|------|
| Feature | `snake_case` | `ai_chat`, `my_library` |
| Directory | `snake_case` | `data`, `domain`, `presentation` |
| File | `snake_case` | `ai_chat_bloc.dart` |
| Class | `PascalCase` | `AiChatBloc` |
| Interface | `IPascalCase` | `IAiChatRepository` |
| Variable | `camelCase` | `aiChatMessages` |

---

## 10. NoGERD 적용 권장사항

### Priority 1: 구조 변경
1. **Clean Architecture 적용**: data/domain/presentation 분리
2. **BLoC 패턴 도입**: 모든 Feature에 일관된 상태 관리
3. **GetIt + Injectable DI**: 타입 안전한 의존성 주입

### Priority 2: 코드 구성
1. **Feature 기반 구조**: 각 Feature를 독립적인 모듈로
2. **Interface 분리**: Domain에 인터페이스, Data에 구현체
3. **Failure 계층**: 체계적인 에러 처리

### Priority 3: 패턴 구현
1. **UseCase 표준화**: 기본/Auth 필수 UseCase 클래스
2. **Either 타입**: 함수형 에러 처리
3. **Freezed Event/State**: 불변 상태 관리

### 제안하는 NoGERD 구조

```
lib/
├── core/
│   ├── di/                    # GetIt + Injectable 설정
│   ├── network/               # API 클라이언트
│   ├── error/                 # Failure 정의
│   └── usecase/               # 기본 UseCase 클래스
├── features/
│   ├── record/
│   │   ├── data/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── calendar/
│   ├── insights/
│   └── settings/
├── shared/
│   ├── theme/
│   ├── widgets/
│   └── utils/
└── main.dart
```

---

## 결론

KOBIC은 **Production 수준의 Flutter 아키텍처**를 보여줍니다:
- Clean Architecture를 통한 명확한 관심사 분리
- BLoC 기반의 확장 가능한 상태 관리
- 타입 안전한 의존성 주입
- 함수형 프로그래밍을 활용한 에러 처리

NoGERD 프로젝트에 이 아키텍처를 적용하면 유지보수성, 테스트 가능성, 확장성이 크게 향상됩니다.
