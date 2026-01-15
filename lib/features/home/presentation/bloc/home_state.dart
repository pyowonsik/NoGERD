part of 'home_bloc.dart';

/// Home State
@freezed
class HomeState with _$HomeState {
  /// 생성자
  const factory HomeState({
    /// 로딩 중 여부
    required bool isLoading,

    /// 건강 점수
    required int healthScore,

    /// 이전 건강 점수
    required int previousScore,

    /// 오늘의 요약
    required List<RecordSummary> todaySummary,

    /// 최근 기록 (홈 화면 표시용, 최대 5개)
    required List<RecentRecord> recentRecords,

    /// 전체 최근 기록 (전체보기 모달용, 최대 20개)
    required List<RecentRecord> allRecentRecords,

    /// 에러
    required Option<Failure> failure,
  }) = _HomeState;

  /// 초기 상태
  factory HomeState.initial() => HomeState(
        isLoading: false,
        healthScore: 0,
        previousScore: 0,
        todaySummary: [],
        recentRecords: [],
        allRecentRecords: [],
        failure: none(),
      );
}
