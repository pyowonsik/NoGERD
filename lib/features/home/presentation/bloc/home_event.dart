part of 'home_bloc.dart';

/// Home Event
@freezed
class HomeEvent with _$HomeEvent {
  /// 시작 이벤트
  const factory HomeEvent.started() = HomeEventStarted;

  /// 새로고침 이벤트
  const factory HomeEvent.refreshed() = HomeEventRefreshed;

  /// 날짜 변경 이벤트
  const factory HomeEvent.dateChanged(DateTime date) = HomeEventDateChanged;
}
