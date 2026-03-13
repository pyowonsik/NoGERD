import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_meal_symptom_correlation_usecase.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// AI 원격 데이터소스
@lazySingleton
class AIRemoteDataSource {
  /// 생성자
  AIRemoteDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _lastGeneratedKey = 'ai_last_generated';
  static const _savedInsightKey = 'ai_saved_insight';

  /// 이번 주 월요일 날짜 계산
  DateTime _getMondayOfThisWeek() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1(월) ~ 7(일)
    final monday = now.subtract(Duration(days: weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// 다음 월요일 날짜 계산
  DateTime getNextMonday() {
    final now = DateTime.now();
    final daysUntilMonday = (8 - now.weekday) % 7;
    final nextMonday =
        now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
    return DateTime(nextMonday.year, nextMonday.month, nextMonday.day);
  }

  /// 이번 주에 이미 생성했는지 확인
  bool canGenerateThisWeek() {
    final lastGenerated = _prefs.getString(_lastGeneratedKey);
    if (lastGenerated == null) return true;

    final lastDate = DateTime.parse(lastGenerated);
    final monday = _getMondayOfThisWeek();

    // 마지막 생성일이 이번 주 월요일 이전이면 생성 가능
    return lastDate.isBefore(monday);
  }

  /// 저장된 리포트 로드
  AIInsight? getSavedInsight() {
    final savedJson = _prefs.getString(_savedInsightKey);
    if (savedJson == null) return null;

    try {
      final json = jsonDecode(savedJson) as Map<String, dynamic>;
      final insight = AIInsight.fromJson(json);

      // 이번 주 월요일 이후에 생성된 것만 유효
      final monday = _getMondayOfThisWeek();
      if (insight.generatedAt.isAfter(monday) ||
          insight.generatedAt.isAtSameMomentAs(monday)) {
        return insight;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 실제 Gemini API 사용
  static const _useMockData = false;

  // 주 1회 제한 활성화
  static const _bypassWeeklyLimit = false;

  /// AI 인사이트 생성 (Gemini API 호출)
  /// 1. 주 1회 생성 제한 체크
  /// 2. 지난주 기록 데이터로 프롬프트 생성
  /// 3. Gemini API 호출 및 JSON 응답 파싱
  Future<Either<Failure, AIInsight>> generateInsight(
    InsightsState state,
  ) async {
    // 1. 주 1회 제한 체크 - API 비용 절감
    if (!_bypassWeeklyLimit && !canGenerateThisWeek()) {
      return left(
        const Failure.validation(
          '이번 주 리포트는 이미 생성했습니다. 다음 주 월요일에 새 리포트를 받아보세요.',
        ),
      );
    }

    // 2. 지난주 데이터 유효성 체크 (최소 3일 이상 기록 필요)
    final lastWeekRecordedDays =
        state.lastWeekSymptomTrends.where((t) => t.count > 0).length;

    if (lastWeekRecordedDays < 3) {
      return left(
        Failure.validation(
          '지난주 기록이 부족합니다. (현재 $lastWeekRecordedDays일 / 최소 3일 필요)\n'
          '더 정확한 분석을 위해 증상을 꾸준히 기록해주세요.',
        ),
      );
    }

    _printDataLog(state);

    try {
      late AIInsight insight;

      if (_useMockData) {
        await Future<void>.delayed(const Duration(seconds: 2));
        insight = AIInsight(
          summary: '지난 주 건강 상태가 양호했습니다! 증상 발생이 적고 '
              '전반적으로 잘 관리하고 계세요. 이 좋은 습관을 유지해주세요.',
          dietAdvice: '저녁 식사량을 조금 줄이고, 식사 후 2시간은 눕지 않는 것이 좋아요. '
              '카페인과 탄산음료는 가급적 피해주세요.',
          lifestyleAdvice: '규칙적인 수면 패턴을 유지하고, 취침 3시간 전에는 식사를 '
              '마무리하세요. 가벼운 산책이 소화에 도움이 됩니다.',
          triggerWarning: '매운 음식과 기름진 음식이 증상을 유발할 수 있으니 '
              '주의해주세요.',
          generatedAt: DateTime.now(),
        );
      } else {
        // 3. Gemini API 호출
        final gemini = Gemini.instance;
        // 4. 지난주 기록 데이터로 프롬프트 생성
        final prompt = _buildPrompt(state);

        if (kDebugMode) {
          debugPrint('\n${'=' * 60}');
          debugPrint('🤖 Gemini에 보내는 프롬프트:');
          debugPrint('=' * 60);
          debugPrint(prompt);
          debugPrint('${'=' * 60}\n');
        }

        // 5. Gemini API 호출 - 프롬프트 전송 및 응답 수신
        final response = await gemini.prompt(
          parts: [Part.text(prompt)],
          model: 'gemini-2.5-flash-lite', // 무료 티어 모델 사용
        );

        if (response?.output == null) {
          return left(const Failure.unexpected('AI 응답을 받지 못했습니다.'));
        }

        // 6. JSON 응답 파싱하여 AIInsight 객체로 변환
        insight = _parseResponse(response!.output!);
      }

      // 7. 생성 시간 저장 (주 1회 제한용)
      await _prefs.setString(
        _lastGeneratedKey,
        DateTime.now().toIso8601String(),
      );

      // 8. 리포트 JSON 저장 (캐싱)
      await _prefs.setString(
        _savedInsightKey,
        jsonEncode(insight.toJson()),
      );

      return right(insight);
    } catch (e) {
      return left(Failure.unexpected('AI 리포트 생성 실패: $e'));
    }
  }

  /// 디버그 로그 출력
  void _printDataLog(InsightsState state) {
    // Release 빌드에서는 로그 출력 안 함
    if (!kDebugMode) return;

    final divider = '=' * 60;
    final subDivider = '-' * 40;

    debugPrint('\n$divider');
    debugPrint('📊 주간 리포트 생성 - 데이터 로그');
    debugPrint(divider);

    // ===== 이번 주 데이터 (UI 표시용) =====
    debugPrint('\n🟢 이번 주 데이터 (UI 표시용)');
    debugPrint(subDivider);

    // 증상 추이
    final thisWeekSymptomCount = state.symptomTrends.fold<int>(
      0,
      (sum, t) => sum + t.count,
    );
    final thisWeekRecordedDays =
        state.symptomTrends.where((t) => t.count > 0).length;
    debugPrint(
      '증상 추이: 총 ${thisWeekSymptomCount}회 (기록일: ${thisWeekRecordedDays}일)',
    );

    // 증상 분포
    if (state.symptomDistribution.isNotEmpty) {
      debugPrint('🩺 증상 분포:');
      for (final d in state.symptomDistribution.take(3)) {
        debugPrint('   - ${d.symptom.label}: ${d.count}회');
      }
    }

    // 트리거 음식
    if (state.triggerAnalysis.isNotEmpty) {
      debugPrint('🍔 트리거 음식:');
      for (final t in state.triggerAnalysis.take(3)) {
        debugPrint('   - ${t.category.label}: ${t.count}회');
      }
    }

    // 식사별 증상
    debugPrint('🍽️ 식사별 증상 발생률:');
    for (final c in state.mealSymptomCorrelation) {
      debugPrint('   - ${c.mealType.label}: ${c.percentage}%');
    }

    // 생활습관
    if (state.lifestyleImpacts.isNotEmpty) {
      debugPrint('💪 생활습관:');
      for (final l in state.lifestyleImpacts) {
        debugPrint('   - ${l.lifestyleType.label}: ${l.statusLabel}');
      }
    }

    // ===== 지난 주 데이터 (AI 분석용) =====
    debugPrint('\n🔴 지난 주 데이터 (AI 분석용)');
    debugPrint(subDivider);

    // 증상 추이
    final lastWeekSymptomCount = state.lastWeekSymptomTrends.fold<int>(
      0,
      (sum, t) => sum + t.count,
    );
    final lastWeekRecordedDays =
        state.lastWeekSymptomTrends.where((t) => t.count > 0).length;
    debugPrint(
      '증상 추이: 총 ${lastWeekSymptomCount}회 (기록일: ${lastWeekRecordedDays}일)',
    );

    // 증상 분포
    if (state.lastWeekSymptomDistribution.isNotEmpty) {
      debugPrint('🩺 증상 분포:');
      for (final d in state.lastWeekSymptomDistribution.take(3)) {
        debugPrint('   - ${d.symptom.label}: ${d.count}회');
      }
    }

    // 트리거 음식
    if (state.lastWeekTriggerAnalysis.isNotEmpty) {
      debugPrint('🍔 트리거 음식:');
      for (final t in state.lastWeekTriggerAnalysis.take(3)) {
        debugPrint('   - ${t.category.label}: ${t.count}회');
      }
    }

    // 식사별 증상
    debugPrint('🍽️ 식사별 증상 발생률:');
    for (final c in state.lastWeekMealSymptomCorrelation) {
      debugPrint('   - ${c.mealType.label}: ${c.percentage}%');
    }

    // 생활습관
    if (state.lastWeekLifestyleImpacts.isNotEmpty) {
      debugPrint('💪 생활습관:');
      for (final l in state.lastWeekLifestyleImpacts) {
        debugPrint('   - ${l.lifestyleType.label}: ${l.statusLabel}');
      }
    }

    debugPrint('\n$divider');
    debugPrint('🤖 Gemini에게 지난 주 데이터로 분석 요청 중...');
    debugPrint('$divider\n');
  }

  /// 프롬프트 빌드 (지난 주 데이터 사용)
  /// 지난주 증상, 트리거 음식, 식사별 증상 발생률, 생활습관 데이터를
  /// Gemini가 이해할 수 있는 프롬프트로 변환
  String _buildPrompt(InsightsState state) {
    // 지난 주 증상 총 횟수 계산
    final totalSymptoms = state.lastWeekSymptomTrends.fold<int>(
      0,
      (sum, t) => sum + t.count,
    );

    // 지난 주 주요 증상 (상위 3개)
    final topSymptoms = state.lastWeekSymptomDistribution
        .take(3)
        .map((d) => d.symptom.label)
        .join(', ');

    // 지난 주 트리거 음식 (상위 3개)
    final topTriggers = state.lastWeekTriggerAnalysis
        .take(3)
        .map((t) => '- ${t.category.label}: ${t.count}회')
        .join('\n');

    // 지난 주 식사별 증상 발생률
    int getPercentage(MealType type) {
      final correlation = state.lastWeekMealSymptomCorrelation.firstWhere(
        (c) => c.mealType == type,
        orElse: () => MealSymptomCorrelation(
          mealType: type,
          symptomCount: 0,
          totalMealCount: 0,
        ),
      );
      return correlation.percentage;
    }

    // 지난 주 생활습관 상태
    final lifestyleStatus = state.lastWeekLifestyleImpacts
        .map((l) => '- ${l.lifestyleType.label}: ${l.statusLabel}')
        .join('\n');

    return '''
당신은 GERD(역류성 식도염) 전문 건강 어시스턴트입니다.
사용자의 지난 한 주간 기록을 분석하여 주간 건강 리포트를 작성해주세요.

## 지난 주 건강 기록

### 증상 현황
- 총 증상 발생: $totalSymptoms회
- 주요 증상: ${topSymptoms.isEmpty ? '기록 없음' : topSymptoms}

### 트리거 음식 (상위 3개)
${topTriggers.isEmpty ? '- 기록 없음' : topTriggers}

### 식사 후 증상 발생률
- 아침 식사 후: ${getPercentage(MealType.breakfast)}%
- 점심 식사 후: ${getPercentage(MealType.lunch)}%
- 저녁 식사 후: ${getPercentage(MealType.dinner)}%

### 생활습관 현황
${lifestyleStatus.isEmpty ? '- 기록 없음' : lifestyleStatus}

## 요청사항
위 기록을 바탕으로 다음 형식의 JSON 응답을 제공해주세요:
{
  "summary": "지난 주 건강 상태 총평 (2-3문장, 격려하는 톤으로)",
  "dietAdvice": "이번 주 식단 관련 구체적인 조언 (2-3문장)",
  "lifestyleAdvice": "이번 주 생활습관 개선 조언 (2-3문장)",
  "triggerWarning": "특히 주의해야 할 음식이나 상황 (1-2문장)"
}

한국어로 친근하고 격려하는 톤으로 작성해주세요.
기록된 데이터를 구체적으로 언급하며 분석해주세요.
반드시 JSON 형식만 출력하세요.
''';
  }

  /// Gemini 응답 파싱
  /// JSON 형식의 응답에서 summary, dietAdvice, lifestyleAdvice, triggerWarning 추출
  AIInsight _parseResponse(String output) {
    try {
      // 1. 정규식으로 JSON 추출 (마크다운 코드블록 처리)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(output);
      if (jsonMatch == null) throw const FormatException('No JSON found');

      // 2. JSON 파싱
      final json = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;

      // 3. AIInsight 객체로 변환
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
