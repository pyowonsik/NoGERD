part of 'insights_bloc.dart';

/// Insights Event
@freezed
class InsightsEvent with _$InsightsEvent {
  /// 데이터 로드 (기간 변경 시)
  const factory InsightsEvent.loadData(int days) = InsightsEventLoadData;

  /// 새로고침
  const factory InsightsEvent.refresh() = InsightsEventRefresh;

  /// AI 인사이트 생성 요청
  const factory InsightsEvent.loadAIInsights() = InsightsEventLoadAIInsights;

  /// 저장된 AI 리포트 로드
  const factory InsightsEvent.loadSavedInsight() = InsightsEventLoadSavedInsight;
}
