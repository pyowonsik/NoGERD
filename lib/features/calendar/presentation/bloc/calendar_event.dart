part of 'calendar_bloc.dart';

/// Calendar Event
@freezed
class CalendarEvent with _$CalendarEvent {
  /// 월 로드 (특정 월의 모든 기록 조회)
  const factory CalendarEvent.loadMonth(DateTime month) =
      CalendarEventLoadMonth;

  /// 날짜 선택
  const factory CalendarEvent.selectDay(DateTime day) =
      CalendarEventSelectDay;

  /// 오늘로 이동
  const factory CalendarEvent.goToToday() = CalendarEventGoToToday;

  /// 캘린더 포맷 변경
  const factory CalendarEvent.formatChanged(CalendarFormat format) =
      CalendarEventFormatChanged;
}
