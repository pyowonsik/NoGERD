# NoGERD AI 인사이트 리포트 구현 연구

**날짜**: 2026-01-15
**분석 대상**: AI 인사이트 리포트 구현 방법

---

## 1. 현재 상태 분석

### 1.1 기존 인사이트 기능 (완료됨)

| UseCase                            | 기능             | 데이터                  |
| ---------------------------------- | ---------------- | ----------------------- |
| `CalculateHealthScoreUseCase`      | 건강 점수 계산   | 7일 기록 기반 0-100점   |
| `GetSymptomTrendsUseCase`          | 증상 추이        | 날별 증상 횟수/심각도   |
| `AnalyzeTriggersUseCase`           | 트리거 음식      | 30일 식사 기록 분석     |
| `GetSymptomDistributionUseCase`    | 증상 분포        | 증상 종류별 빈도        |
| `GetMealSymptomCorrelationUseCase` | 식사-증상 연관성 | 식사 후 2시간 이내 증상 |
| `GetLifestyleImpactUseCase`        | 생활습관 영향    | 수면/운동/스트레스      |
| `GetWeeklyPatternUseCase`          | 요일별 패턴      | 4주 데이터 분석         |

### 1.2 AI 인사이트 현황

**파일**: `lib/features/insights/presentation/pages/insights_page_v2.dart:912-986`

```dart
class _AIInsights extends StatelessWidget {
  // 현재: "추후 구현 예정" 배지만 표시
  // 3개 카드 (하드코딩된 메시지):
  // 1. 식사 패턴
  // 2. 피해야 할 음식 (triggerAnalysis 기반 일부 동적)
  // 3. 약물 복용
}
```

---

## 2. AI API 옵션 비교

### 2.1 Firebase AI Logic (권장)

**패키지**: `firebase_ai: ^3.6.1`

**장점**:

- Firebase 생태계 통합 (이미 Supabase와 함께 사용 가능)
- API 키 보안 관리 자동화
- 백엔드 서버 불필요
- 최신 Gemini 모델 지원 (2.5 Pro, 2.5 Flash, 3.0 Preview)
- Google 공식 지원, 장기 유지보수

**단점**:

- Firebase 프로젝트 설정 필요
- 현재 프로젝트가 Supabase 기반 (추가 설정 필요)

**초기화 코드**:

```dart
import 'package:firebase_ai/firebase_ai.dart';

await Firebase.initializeApp();
final model = FirebaseAI.googleAI()
  .generativeModel(model: 'gemini-2.5-flash');
```

### 2.2 flutter_gemini (간단한 대안)

**패키지**: `flutter_gemini: ^3.0.0`

**장점**:

- 설정 간단 (API 키만 필요)
- Firebase 없이 독립 사용 가능
- 스트림 API 지원

**단점**:

- API 키 노출 위험 (클라이언트에 저장)
- 커뮤니티 패키지 (공식 지원 아님)
- 13개월 전 마지막 업데이트

**초기화 코드**:

```dart
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: 'YOUR_API_KEY');
  runApp(const MyApp());
}
```

### 2.3 google_generative_ai (Deprecated)

**패키지**: `google_generative_ai: ^0.4.7`

> **주의**: 2024년 11월 30일부터 Deprecated. Firebase SDK로 마이그레이션 권장.

---

## 3. 권장 구현 방안

### 3.1 아키텍처

현재 앱의 Clean Architecture 패턴을 따라 구현:

```
lib/features/insights/
├── data/
│   └── datasources/
│       └── ai_remote_datasource.dart        # NEW: Gemini API 호출
├── domain/
│   ├── entities/
│   │   └── ai_insight.dart                  # NEW: AI 응답 엔티티
│   └── usecases/
│       └── get_ai_insights_usecase.dart     # NEW: AI 인사이트 UseCase
└── presentation/
    └── bloc/
        └── insights_bloc.dart               # 기존 BLoC에 AI 상태 추가
```

### 3.2 구현 단계

#### Phase 1: 패키지 설정

```yaml
# pubspec.yaml
dependencies:
  flutter_gemini: ^3.0.0
  # 또는 Firebase 사용 시
  firebase_ai: ^3.6.1
```

#### Phase 2: 엔티티 정의

```dart
// lib/features/insights/domain/entities/ai_insight.dart
@freezed
class AIInsight with _$AIInsight {
  const factory AIInsight({
    required String summary,           // 전체 요약
    required String dietAdvice,        // 식단 조언
    required String lifestyleAdvice,   // 생활습관 조언
    required String triggerWarning,    // 트리거 경고
    required DateTime generatedAt,     // 생성 시간
  }) = _AIInsight;
}
```

#### Phase 3: 데이터소스 구현

```dart
// lib/features/insights/data/datasources/ai_remote_datasource.dart
@injectable
class AIRemoteDataSource {
  Future<AIInsight> generateInsight(InsightsState state) async {
    final gemini = Gemini.instance;

    final prompt = _buildPrompt(state);
    final response = await gemini.prompt(parts: [Part.text(prompt)]);

    return _parseResponse(response?.output ?? '');
  }

  String _buildPrompt(InsightsState state) {
    return '''
당신은 GERD(역류성 식도염) 전문 건강 어시스턴트입니다.
다음 사용자의 건강 데이터를 분석하고 맞춤형 조언을 제공해주세요.

## 사용자 건강 데이터 (최근 7일)

### 건강 점수: ${state.healthScore}/100점
(이전 대비 ${state.healthScore - state.previousHealthScore}점 변화)

### 증상 현황
- 총 증상 발생: ${state.symptomTrends.fold(0, (sum, t) => sum + t.count)}회
- 주요 증상: ${state.symptomDistribution.take(3).map((d) => d.symptom.label).join(', ')}

### 트리거 음식 (상위 3개)
${state.triggerAnalysis.take(3).map((t) => '- ${t.category.label}: ${t.count}회').join('\n')}

### 식사 후 증상 발생률
- 아침: ${state.mealSymptomCorrelation.firstWhere((c) => c.mealType == MealType.breakfast, orElse: () => MealSymptomCorrelation(mealType: MealType.breakfast, symptomCount: 0, totalMealCount: 0)).percentage}%
- 점심: ${state.mealSymptomCorrelation.firstWhere((c) => c.mealType == MealType.lunch, orElse: () => MealSymptomCorrelation(mealType: MealType.lunch, symptomCount: 0, totalMealCount: 0)).percentage}%
- 저녁: ${state.mealSymptomCorrelation.firstWhere((c) => c.mealType == MealType.dinner, orElse: () => MealSymptomCorrelation(mealType: MealType.dinner, symptomCount: 0, totalMealCount: 0)).percentage}%

### 생활습관
${state.lifestyleImpacts.map((l) => '- ${l.lifestyleType.label}: ${l.statusLabel}').join('\n')}

## 요청사항
다음 형식으로 JSON 응답을 제공해주세요:
{
  "summary": "전반적인 건강 상태 요약 (2-3문장)",
  "dietAdvice": "식단 관련 구체적인 조언 (2-3문장)",
  "lifestyleAdvice": "생활습관 개선 조언 (2-3문장)",
  "triggerWarning": "특히 주의해야 할 음식/상황 (1-2문장)"
}

한국어로 친근하고 격려하는 톤으로 작성해주세요.
''';
  }
}
```

#### Phase 4: UseCase 구현

```dart
// lib/features/insights/domain/usecases/get_ai_insights_usecase.dart
@injectable
class GetAIInsightsUseCase {
  final AIRemoteDataSource _dataSource;

  GetAIInsightsUseCase(this._dataSource);

  Future<Either<Failure, AIInsight>> call(InsightsState state) async {
    try {
      final result = await _dataSource.generateInsight(state);
      return Right(result);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
```

#### Phase 5: BLoC 확장

```dart
// InsightsState에 추가
required Option<AIInsight> aiInsight,
required bool isAILoading,

// InsightsEvent에 추가
const factory InsightsEvent.loadAIInsights() = InsightsEventLoadAIInsights;

// InsightsBloc에 추가
Future<void> _onLoadAIInsights(
  InsightsEventLoadAIInsights event,
  Emitter<InsightsState> emit,
) async {
  emit(state.copyWith(isAILoading: true));

  final result = await _getAIInsightsUseCase(state);

  result.fold(
    (failure) => emit(state.copyWith(
      failure: some(failure),
      isAILoading: false,
    )),
    (insight) => emit(state.copyWith(
      aiInsight: some(insight),
      isAILoading: false,
    )),
  );
}
```

#### Phase 6: UI 연결

```dart
// _AIInsights 위젯 수정
class _AIInsights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsBloc, InsightsState>(
      builder: (context, state) {
        if (state.isAILoading) {
          return const _AILoadingIndicator();
        }

        return state.aiInsight.fold(
          () => _GenerateAIButton(
            onPressed: () => context.read<InsightsBloc>()
              .add(const InsightsEvent.loadAIInsights()),
          ),
          (insight) => _AIInsightCards(insight: insight),
        );
      },
    );
  }
}
```

---

## 4. 프롬프트 설계 가이드

### 4.1 효과적인 프롬프트 구조

```
1. 역할 정의: "당신은 GERD 전문 건강 어시스턴트입니다"
2. 컨텍스트: 사용자 데이터 상세 제공
3. 출력 형식: JSON 구조 명시
4. 톤/스타일: "친근하고 격려하는 톤"
5. 언어: "한국어로 작성"
```

### 4.2 응답 파싱

```dart
AIInsight _parseResponse(String output) {
  try {
    // JSON 추출 (마크다운 코드블록 처리)
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(output);
    if (jsonMatch == null) throw FormatException('No JSON found');

    final json = jsonDecode(jsonMatch.group(0)!);

    return AIInsight(
      summary: json['summary'] ?? '',
      dietAdvice: json['dietAdvice'] ?? '',
      lifestyleAdvice: json['lifestyleAdvice'] ?? '',
      triggerWarning: json['triggerWarning'] ?? '',
      generatedAt: DateTime.now(),
    );
  } catch (e) {
    // 파싱 실패 시 기본 응답
    return AIInsight(
      summary: output,
      dietAdvice: '',
      lifestyleAdvice: '',
      triggerWarning: '',
      generatedAt: DateTime.now(),
    );
  }
}
```

---

## 5. 비용 및 제한사항

### 5.1 Gemini API 가격 (2025년 기준)

| 모델             | 입력 (1M tokens) | 출력 (1M tokens) | 무료 티어    |
| ---------------- | ---------------- | ---------------- | ------------ |
| Gemini 2.5 Flash | $0.10            | $0.40            | 분당 15 요청 |
| Gemini 2.5 Pro   | $1.25            | $5.00            | 분당 2 요청  |

### 5.2 권장 설정

```dart
// 비용 최적화를 위한 설정
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',  // 빠르고 저렴
  generationConfig: GenerationConfig(
    maxOutputTokens: 500,      // 응답 길이 제한
    temperature: 0.7,          // 창의성 조절
  ),
);
```

### 5.3 Rate Limiting

```dart
// 하루 1회 생성 제한 (SharedPreferences 활용)
Future<bool> canGenerateToday() async {
  final prefs = await SharedPreferences.getInstance();
  final lastGenerated = prefs.getString('ai_last_generated');

  if (lastGenerated == null) return true;

  final lastDate = DateTime.parse(lastGenerated);
  final today = DateTime.now();

  return lastDate.day != today.day ||
         lastDate.month != today.month ||
         lastDate.year != today.year;
}
```

---

## 6. 보안 고려사항

### 6.1 API 키 관리

**권장 방법 (Firebase 사용 시)**:

- Firebase AI Logic이 API 키 자동 관리
- 클라이언트에 키 노출 없음

**대안 (flutter_gemini 사용 시)**:

```dart
// .env 파일 사용
GEMINI_API_KEY=your_api_key_here

// flutter_dotenv로 로드
final apiKey = dotenv.env['GEMINI_API_KEY']!;
Gemini.init(apiKey: apiKey);
```

### 6.2 개인정보 보호

- 사용자 식별 정보 전송 금지
- 민감한 건강 데이터 익명화
- 로컬에서 집계된 통계만 전송

---

## 7. 구현 우선순위

### 권장 접근법

1. **MVP (빠른 구현)**: `flutter_gemini` 패키지로 프로토타입
2. **프로덕션**: Firebase AI Logic으로 마이그레이션

### 파일 생성 순서

1. `ai_insight.dart` - 엔티티
2. `ai_remote_datasource.dart` - API 호출
3. `get_ai_insights_usecase.dart` - UseCase
4. BLoC 수정 - 상태/이벤트 추가
5. UI 수정 - `_AIInsights` 위젯

---

## 8. 참고 자료

- [Firebase AI Logic 공식 문서](https://firebase.google.com/docs/ai-logic/get-started)
- [flutter_gemini 패키지](https://pub.dev/packages/flutter_gemini)
- [Gemini API 가격](https://ai.google.dev/pricing)
- [Flutter AI Toolkit](https://docs.flutter.dev/ai/ai-toolkit)
