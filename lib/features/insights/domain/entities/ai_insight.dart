import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_insight.freezed.dart';
part 'ai_insight.g.dart';

/// AI 인사이트 응답 엔티티
@freezed
class AIInsight with _$AIInsight {
  /// 생성자
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

  /// JSON 역직렬화
  factory AIInsight.fromJson(Map<String, dynamic> json) =>
      _$AIInsightFromJson(json);
}
