# AI 인사이트 리포트 구현 계획

**날짜**: 2026-01-16
**작성자**: Claude
**관련 연구 문서**: `thoughts/shared/research/nogerd_ai_report_implementation_2026-01-15.md`

---

## 1. 요구사항

### 기능 개요

사용자의 GERD 건강 데이터(증상, 식사, 트리거, 생활습관)를 Gemini AI에 전달하여 개인화된 건강 조언을 생성하고 표시하는 기능.

### 목표

- 기존 7개 분석 UseCase의 데이터를 AI에 전달
- Gemini API를 통해 맞춤형 건강 조언 생성
- "추후 구현 예정" 배지를 실제 AI 리포트로 교체

### 성공 기준

- [ ] "AI 리포트 생성" 버튼 클릭 시 Gemini API 호출
- [ ] 로딩 중 스켈레톤/인디케이터 표시
- [ ] AI 응답을 4개 카드(요약, 식단, 생활습관, 트리거 경고)로 표시
- [ ] 에러 발생 시 사용자 친화적 메시지 표시
- [ ] 하루 1회 생성 제한 (비용 최적화)

---

## 2. 기술적 접근

### 아키텍처 선택

기존 Clean Architecture + BLoC 패턴 유지

### 사용할 패키지

```yaml
dependencies:
  flutter_gemini: ^3.0.0  # MVP용 (빠른 구현)
  # 추후: firebase_ai: ^3.6.1 (프로덕션 마이그레이션)
```

### API 키 관리

- `.env` 파일에 `GEMINI_API_KEY` 추가
- `flutter_dotenv`로 로드 (이미 프로젝트에 설정됨)

### 파일 구조

```
lib/features/insights/
├── data/
│   └── datasources/
│       └── ai_remote_datasource.dart           # NEW: Gemini API 호출
├── domain/
│   ├── entities/
│   │   └── ai_insight.dart                     # NEW: AI 응답 엔티티
│   │   └── ai_insight.freezed.dart             # (자동 생성)
│   └── usecases/
│       └── get_ai_insights_usecase.dart        # NEW: AI 인사이트 UseCase
└── presentation/
    └── bloc/
        ├── insights_bloc.dart                  # 수정: AI 이벤트/핸들러 추가
        ├── insights_event.dart                 # 수정: loadAIInsights 이벤트
        ├── insights_state.dart                 # 수정: aiInsight, isAILoading 필드
        └── insights_bloc.freezed.dart          # (재생성 필요)
    └── pages/
        └── insights_page_v2.dart               # 수정: _AIInsights 위젯
```

---

## 3. 구현 단계

### Phase 1: 패키지 및 환경 설정

**목표**: Gemini API 연동을 위한 기반 설정

**작업 목록**:

- [ ] `pubspec.yaml`에 `flutter_gemini: ^3.0.0` 추가
- [ ] `.env` 파일에 `GEMINI_API_KEY=xxx` 추가
- [ ] `main.dart`에서 Gemini 초기화 코드 추가
- [ ] `flutter pub get` 실행

**코드 변경**:

```dart
// main.dart (추가)
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> main() async {
  // ... 기존 코드 ...

  // Gemini 초기화
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);

  runApp(const App());
}
```

**예상 영향**:
- 영향 받는 파일: `pubspec.yaml`, `.env`, `lib/main.dart`
- 의존성: 없음

**검증 방법**:
- [ ] `flutter pub get` 성공
- [ ] 앱 빌드 성공

---

### Phase 2: 도메인 계층 구현

**목표**: AI 응답 엔티티 및 UseCase 정의

**작업 목록**:

- [ ] `AIInsight` 엔티티 생성 (freezed)
- [ ] `GetAIInsightsUseCase` 생성

**파일 1**: `lib/features/insights/domain/entities/ai_insight.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_insight.freezed.dart';
part 'ai_insight.g.dart';

/// AI 인사이트 응답 엔티티
@freezed
class AIInsight with _$AIInsight {
  const factory AIInsight({
    /// 전반적인 건강 상태 요약
    required String summary,

    /// 식단 관련 조언
    required String dietAdvice,

    /// 생활습관 개선 조언
    required String lifestyleAdvice,

    /// 트리거 경고 메시지
    required String triggerWarning,

    /// 생성 시간
    required DateTime generatedAt,
  }) = _AIInsight;

  factory AIInsight.fromJson(Map<String, dynamic> json) =>
      _$AIInsightFromJson(json);
}
```

**파일 2**: `lib/features/insights/domain/usecases/get_ai_insights_usecase.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/insights/data/datasources/ai_remote_datasource.dart';
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';

/// AI 인사이트 생성 UseCase
@injectable
class GetAIInsightsUseCase {
  final AIRemoteDataSource _dataSource;

  const GetAIInsightsUseCase(this._dataSource);

  Future<Either<Failure, AIInsight>> call(InsightsState state) async {
    return _dataSource.generateInsight(state);
  }
}
```

**예상 영향**:
- 영향 받는 파일: 새 파일 2개
- 의존성: Phase 1 완료 필요

**검증 방법**:
- [ ] `flutter pub run build_runner build` 성공
- [ ] freezed 코드 생성 확인

---

### Phase 3: 데이터 계층 구현

**목표**: Gemini API 호출 및 응답 파싱

**작업 목록**:

- [ ] `AIRemoteDataSource` 생성
- [ ] 프롬프트 빌드 함수 구현
- [ ] JSON 응답 파싱 함수 구현
- [ ] 하루 1회 제한 로직 구현

**파일**: `lib/features/insights/data/datasources/ai_remote_datasource.dart`

```dart
import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// AI 원격 데이터소스
@lazySingleton
class AIRemoteDataSource {
  final SharedPreferences _prefs;

  AIRemoteDataSource(this._prefs);

  static const _lastGeneratedKey = 'ai_last_generated';

  /// 오늘 이미 생성했는지 확인
  bool canGenerateToday() {
    final lastGenerated = _prefs.getString(_lastGeneratedKey);
    if (lastGenerated == null) return true;

    final lastDate = DateTime.parse(lastGenerated);
    final today = DateTime.now();

    return lastDate.day != today.day ||
           lastDate.month != today.month ||
           lastDate.year != today.year;
  }

  /// AI 인사이트 생성
  Future<Either<Failure, AIInsight>> generateInsight(InsightsState state) async {
    // 하루 1회 제한 체크
    if (!canGenerateToday()) {
      return left(const Failure.validation('오늘은 이미 AI 리포트를 생성했습니다. 내일 다시 시도해주세요.'));
    }

    try {
      final gemini = Gemini.instance;
      final prompt = _buildPrompt(state);

      final response = await gemini.prompt(parts: [Part.text(prompt)]);

      if (response?.output == null) {
        return left(const Failure.unexpected('AI 응답을 받지 못했습니다.'));
      }

      final insight = _parseResponse(response!.output!);

      // 생성 시간 저장
      await _prefs.setString(_lastGeneratedKey, DateTime.now().toIso8601String());

      return right(insight);
    } catch (e) {
      return left(Failure.unexpected('AI 리포트 생성 실패: ${e.toString()}'));
    }
  }

  /// 프롬프트 빌드
  String _buildPrompt(InsightsState state) {
    // 증상 총 횟수 계산
    final totalSymptoms = state.symptomTrends.fold<int>(0, (sum, t) => sum + t.count);

    // 주요 증상 (상위 3개)
    final topSymptoms = state.symptomDistribution
        .take(3)
        .map((d) => d.symptom.label)
        .join(', ');

    // 트리거 음식 (상위 3개)
    final topTriggers = state.triggerAnalysis
        .take(3)
        .map((t) => '- ${t.category.label}: ${t.count}회')
        .join('\n');

    // 식사별 증상 발생률
    int getPercentage(MealType type) {
      final correlation = state.mealSymptomCorrelation.firstWhere(
        (c) => c.mealType == type,
        orElse: () => MealSymptomCorrelation(
          mealType: type,
          symptomCount: 0,
          totalMealCount: 0,
        ),
      );
      return correlation.percentage;
    }

    // 생활습관 상태
    final lifestyleStatus = state.lifestyleImpacts
        .map((l) => '- ${l.lifestyleType.label}: ${l.statusLabel}')
        .join('\n');

    return '''
당신은 GERD(역류성 식도염) 전문 건강 어시스턴트입니다.
다음 사용자의 건강 데이터를 분석하고 맞춤형 조언을 제공해주세요.

## 사용자 건강 데이터 (최근 7일)

### 건강 점수: ${state.healthScore}/100점
(이전 대비 ${state.healthScore - state.previousHealthScore}점 변화)

### 증상 현황
- 총 증상 발생: $totalSymptoms회
- 주요 증상: ${topSymptoms.isEmpty ? '기록 없음' : topSymptoms}

### 트리거 음식 (상위 3개)
${topTriggers.isEmpty ? '- 기록 없음' : topTriggers}

### 식사 후 증상 발생률
- 아침: ${getPercentage(MealType.breakfast)}%
- 점심: ${getPercentage(MealType.lunch)}%
- 저녁: ${getPercentage(MealType.dinner)}%

### 생활습관
${lifestyleStatus.isEmpty ? '- 기록 없음' : lifestyleStatus}

## 요청사항
다음 형식으로 JSON 응답을 제공해주세요:
{
  "summary": "전반적인 건강 상태 요약 (2-3문장, 격려하는 톤)",
  "dietAdvice": "식단 관련 구체적인 조언 (2-3문장)",
  "lifestyleAdvice": "생활습관 개선 조언 (2-3문장)",
  "triggerWarning": "특히 주의해야 할 음식/상황 (1-2문장)"
}

한국어로 친근하고 격려하는 톤으로 작성해주세요.
반드시 JSON 형식만 출력하세요.
''';
  }

  /// 응답 파싱
  AIInsight _parseResponse(String output) {
    try {
      // JSON 추출 (마크다운 코드블록 처리)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(output);
      if (jsonMatch == null) throw const FormatException('No JSON found');

      final json = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;

      return AIInsight(
        summary: json['summary'] as String? ?? '',
        dietAdvice: json['dietAdvice'] as String? ?? '',
        lifestyleAdvice: json['lifestyleAdvice'] as String? ?? '',
        triggerWarning: json['triggerWarning'] as String? ?? '',
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      // 파싱 실패 시 전체 응답을 요약으로 사용
      return AIInsight(
        summary: output,
        dietAdvice: '',
        lifestyleAdvice: '',
        triggerWarning: '',
        generatedAt: DateTime.now(),
      );
    }
  }
}
```

**예상 영향**:
- 영향 받는 파일: 새 파일 1개
- 의존성: Phase 2 완료 필요, SharedPreferences (이미 등록됨)

**검증 방법**:
- [ ] DI 등록 확인 (`@lazySingleton`)
- [ ] 프롬프트 빌드 테스트

---

### Phase 4: BLoC 계층 수정

**목표**: AI 인사이트 상태 및 이벤트 추가

**작업 목록**:

- [ ] `InsightsState`에 `aiInsight`, `isAILoading` 필드 추가
- [ ] `InsightsEvent`에 `loadAIInsights` 이벤트 추가
- [ ] `InsightsBloc`에 `GetAIInsightsUseCase` 주입 및 핸들러 추가
- [ ] `build_runner` 실행

**파일 1 수정**: `lib/features/insights/presentation/bloc/insights_state.dart`

```dart
part of 'insights_bloc.dart';

/// Insights State
@freezed
class InsightsState with _$InsightsState {
  const factory InsightsState({
    // 기존 필드들...
    required bool isLoading,
    required int selectedDays,
    required int healthScore,
    required int previousHealthScore,
    required List<SymptomTrend> symptomTrends,
    required List<TriggerAnalysis> triggerAnalysis,
    required List<WeeklyPattern> weeklyPatterns,
    required List<SymptomDistribution> symptomDistribution,
    required List<MealSymptomCorrelation> mealSymptomCorrelation,
    required List<LifestyleImpact> lifestyleImpacts,
    required Option<Failure> failure,

    // NEW: AI 인사이트 필드
    /// AI 인사이트 로딩 상태
    required bool isAILoading,

    /// AI 인사이트 결과
    required Option<AIInsight> aiInsight,
  }) = _InsightsState;

  factory InsightsState.initial() => InsightsState(
        isLoading: false,
        selectedDays: 7,
        healthScore: 0,
        previousHealthScore: 0,
        symptomTrends: [],
        triggerAnalysis: [],
        weeklyPatterns: [],
        symptomDistribution: [],
        mealSymptomCorrelation: [],
        lifestyleImpacts: [],
        failure: none(),
        // NEW
        isAILoading: false,
        aiInsight: none(),
      );
}
```

**파일 2 수정**: `lib/features/insights/presentation/bloc/insights_event.dart`

```dart
part of 'insights_bloc.dart';

/// Insights Event
@freezed
class InsightsEvent with _$InsightsEvent {
  /// 데이터 로드 (기간 변경 시)
  const factory InsightsEvent.loadData(int days) = InsightsEventLoadData;

  /// 새로고침
  const factory InsightsEvent.refresh() = InsightsEventRefresh;

  // NEW: AI 인사이트 생성
  /// AI 인사이트 생성 요청
  const factory InsightsEvent.loadAIInsights() = InsightsEventLoadAIInsights;
}
```

**파일 3 수정**: `lib/features/insights/presentation/bloc/insights_bloc.dart`

```dart
// import 추가
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_ai_insights_usecase.dart';

@injectable
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  InsightsBloc(
    this._calculateHealthScoreUseCase,
    this._analyzeTriggersUseCase,
    this._getSymptomTrendsUseCase,
    this._getWeeklyPatternUseCase,
    this._getSymptomDistributionUseCase,
    this._getMealSymptomCorrelationUseCase,
    this._getLifestyleImpactUseCase,
    this._getAIInsightsUseCase,  // NEW
  ) : super(InsightsState.initial()) {
    on<InsightsEventLoadData>(_onLoadData);
    on<InsightsEventRefresh>(_onRefresh);
    on<InsightsEventLoadAIInsights>(_onLoadAIInsights);  // NEW
  }

  // 기존 UseCase들...
  final CalculateHealthScoreUseCase _calculateHealthScoreUseCase;
  final AnalyzeTriggersUseCase _analyzeTriggersUseCase;
  final GetSymptomTrendsUseCase _getSymptomTrendsUseCase;
  final GetWeeklyPatternUseCase _getWeeklyPatternUseCase;
  final GetSymptomDistributionUseCase _getSymptomDistributionUseCase;
  final GetMealSymptomCorrelationUseCase _getMealSymptomCorrelationUseCase;
  final GetLifestyleImpactUseCase _getLifestyleImpactUseCase;

  // NEW: AI UseCase
  final GetAIInsightsUseCase _getAIInsightsUseCase;

  // 기존 핸들러들...

  // NEW: AI 인사이트 핸들러
  Future<void> _onLoadAIInsights(
    InsightsEventLoadAIInsights event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(isAILoading: true, failure: none()));

    final result = await _getAIInsightsUseCase(state);

    result.fold(
      (failure) => emit(state.copyWith(
        isAILoading: false,
        failure: some(failure),
      )),
      (insight) => emit(state.copyWith(
        isAILoading: false,
        aiInsight: some(insight),
        failure: none(),
      )),
    );
  }
}
```

**예상 영향**:
- 영향 받는 파일: 3개 (state, event, bloc)
- 의존성: Phase 3 완료 필요

**검증 방법**:
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` 성공
- [ ] DI 자동 등록 확인 (`injection.config.dart` 확인)

---

### Phase 5: UI 계층 수정

**목표**: AI 인사이트 UI 구현

**작업 목록**:

- [ ] `_AIInsights` 위젯 수정
- [ ] AI 생성 버튼 추가
- [ ] 로딩 인디케이터 추가
- [ ] AI 응답 카드 4개 표시
- [ ] 에러 메시지 표시

**파일 수정**: `lib/features/insights/presentation/pages/insights_page_v2.dart`

`_AIInsights` 위젯 전체 교체:

```dart
/// AI 인사이트
class _AIInsights extends StatelessWidget {
  final InsightsState state;

  const _AIInsights({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'AI 인사이트',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // AI 로딩 중
        if (state.isAILoading)
          const _AILoadingIndicator()
        // AI 결과 있음
        else if (state.aiInsight.isSome())
          _AIInsightCards(insight: state.aiInsight.toNullable()!)
        // AI 결과 없음 - 생성 버튼 표시
        else
          _GenerateAIButton(
            onPressed: () {
              context.read<InsightsBloc>().add(const InsightsEvent.loadAIInsights());
            },
          ),
      ],
    );
  }
}

/// AI 로딩 인디케이터
class _AILoadingIndicator extends StatelessWidget {
  const _AILoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const CircularProgressIndicator(color: AppTheme.primary),
            const SizedBox(height: 16),
            Text(
              'AI가 건강 데이터를 분석하고 있어요...',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI 생성 버튼
class _GenerateAIButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GenerateAIButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Icon(
            Icons.psychology_rounded,
            size: 48,
            color: AppTheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 12),
          const Text(
            '나만의 AI 건강 리포트를 받아보세요',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '최근 7일간의 기록을 바탕으로 맞춤 조언을 드려요',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('AI 리포트 생성'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '하루에 1번 생성할 수 있어요',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// AI 인사이트 카드들
class _AIInsightCards extends StatelessWidget {
  final AIInsight insight;

  const _AIInsightCards({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 요약 카드
        _AIInsightCard(
          icon: Icons.summarize_rounded,
          title: '오늘의 건강 요약',
          message: insight.summary,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 10),

        // 식단 조언
        _AIInsightCard(
          icon: Icons.restaurant_menu_rounded,
          title: '식단 조언',
          message: insight.dietAdvice,
          color: AppTheme.mealColor,
        ),
        const SizedBox(height: 10),

        // 생활습관 조언
        _AIInsightCard(
          icon: Icons.self_improvement_rounded,
          title: '생활습관 조언',
          message: insight.lifestyleAdvice,
          color: AppTheme.lifestyleColor,
        ),
        const SizedBox(height: 10),

        // 트리거 경고
        if (insight.triggerWarning.isNotEmpty)
          _AIInsightCard(
            icon: Icons.warning_amber_rounded,
            title: '주의 사항',
            message: insight.triggerWarning,
            color: AppTheme.warning,
          ),

        // 생성 시간
        const SizedBox(height: 12),
        Text(
          '${_formatDate(insight.generatedAt)}에 생성됨',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일 ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// AI 인사이트 개별 카드 (기존 _InsightCard 재사용)
class _AIInsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const _AIInsightCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**예상 영향**:
- 영향 받는 파일: `insights_page_v2.dart`
- 의존성: Phase 4 완료 필요

**검증 방법**:
- [ ] 화면 렌더링 정상
- [ ] 버튼 클릭 시 API 호출
- [ ] 로딩 표시
- [ ] 결과 카드 표시

---

### Phase 6: 에러 처리 및 UI 피드백

**목표**: 에러 발생 시 사용자 친화적 메시지 표시

**작업 목록**:

- [ ] `insights_page_v2.dart`에 BlocListener 추가
- [ ] 에러 시 SnackBar 표시
- [ ] 하루 제한 초과 시 안내 메시지

**코드 추가**: `_InsightsPageV2Content` 위젯에 BlocListener 추가

```dart
// _InsightsPageV2Content의 build 메서드 수정
@override
Widget build(BuildContext context) {
  return BlocListener<InsightsBloc, InsightsState>(
    listenWhen: (prev, curr) => prev.failure != curr.failure,
    listener: (context, state) {
      state.failure.fold(
        () => null,
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.displayMessage),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    },
    child: Container(
      // 기존 UI 코드...
    ),
  );
}
```

**예상 영향**:
- 영향 받는 파일: `insights_page_v2.dart`
- 의존성: Phase 5 완료 필요

**검증 방법**:
- [ ] 에러 발생 시 SnackBar 표시
- [ ] 하루 제한 초과 시 메시지 표시

---

### Phase 7: 테스트 및 마무리

**목표**: 전체 기능 검증 및 코드 정리

**작업 목록**:

- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` 실행
- [ ] 앱 빌드 및 실행 테스트
- [ ] AI 리포트 생성 E2E 테스트
- [ ] 에러 케이스 테스트

**검증 방법**:
- [ ] 분석 탭에서 AI 리포트 생성 버튼 표시
- [ ] 버튼 클릭 시 로딩 인디케이터 표시
- [ ] API 응답 후 4개 카드 표시
- [ ] 같은 날 재클릭 시 "내일 다시 시도" 메시지
- [ ] 네트워크 에러 시 에러 메시지 표시

---

## 4. 리스크 및 대응

### 리스크 1: Gemini API 키 노출

- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - `.env` 파일을 `.gitignore`에 추가 (이미 되어 있음)
  - 추후 Firebase AI Logic으로 마이그레이션하여 키 노출 방지

### 리스크 2: API 호출 실패

- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - 적절한 에러 메시지 표시
  - 재시도 버튼 제공 (하루 제한 내)
  - 타임아웃 설정

### 리스크 3: 비용 초과

- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - 하루 1회 생성 제한
  - `gemini-2.5-flash` 모델 사용 (저렴)
  - 토큰 제한 설정

### 리스크 4: JSON 파싱 실패

- **확률**: Medium
- **영향도**: Low
- **완화 방안**:
  - 정규식으로 JSON 추출
  - 파싱 실패 시 전체 응답을 요약으로 표시

---

## 5. 전체 검증 계획

### 자동 테스트

- [ ] `AIInsight` 엔티티 JSON 직렬화 테스트
- [ ] `AIRemoteDataSource._parseResponse` 유닛 테스트
- [ ] `GetAIInsightsUseCase` 유닛 테스트

### 수동 테스트

- [ ] 시나리오 1: 첫 AI 리포트 생성
  1. 분석 탭 이동
  2. "AI 리포트 생성" 버튼 클릭
  3. 로딩 인디케이터 확인
  4. 4개 카드 표시 확인

- [ ] 시나리오 2: 하루 제한 테스트
  1. AI 리포트 생성 완료
  2. 다시 버튼 클릭 (만약 버튼이 있다면)
  3. "내일 다시 시도" 메시지 확인

- [ ] 시나리오 3: 네트워크 에러
  1. 비행기 모드 활성화
  2. AI 리포트 생성 시도
  3. 에러 메시지 확인

### 성능 체크

- [ ] API 응답 시간 (목표: 5초 이내)
- [ ] 메모리 사용량 변화 없음

---

## 6. 파일 변경 요약

### 새로 생성할 파일

| 파일 경로 | 설명 |
|-----------|------|
| `lib/features/insights/domain/entities/ai_insight.dart` | AI 응답 엔티티 |
| `lib/features/insights/domain/usecases/get_ai_insights_usecase.dart` | AI UseCase |
| `lib/features/insights/data/datasources/ai_remote_datasource.dart` | Gemini API 호출 |

### 수정할 파일

| 파일 경로 | 변경 내용 |
|-----------|----------|
| `pubspec.yaml` | `flutter_gemini` 패키지 추가 |
| `.env` | `GEMINI_API_KEY` 추가 |
| `lib/main.dart` | Gemini 초기화 코드 |
| `lib/features/insights/presentation/bloc/insights_state.dart` | `isAILoading`, `aiInsight` 필드 |
| `lib/features/insights/presentation/bloc/insights_event.dart` | `loadAIInsights` 이벤트 |
| `lib/features/insights/presentation/bloc/insights_bloc.dart` | AI UseCase 주입, 핸들러 |
| `lib/features/insights/presentation/pages/insights_page_v2.dart` | `_AIInsights` 위젯 교체 |

---

## 7. 참고 사항

### Gemini API 키 발급

1. [Google AI Studio](https://aistudio.google.com/) 접속
2. "Get API key" 클릭
3. 새 프로젝트 생성 또는 기존 프로젝트 선택
4. API 키 복사하여 `.env`에 저장

### 추후 마이그레이션

프로덕션 배포 시 `flutter_gemini` → `firebase_ai`로 마이그레이션 권장:

1. Firebase 프로젝트 설정
2. AI Logic 활성화
3. `firebase_ai` 패키지로 교체
4. API 키 관리 자동화

---

**작성 완료**: 2026-01-16
**다음 단계**: `/implement-plan` 스킬을 사용하여 Phase 1부터 구현 시작
