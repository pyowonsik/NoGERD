part of 'calendar_bloc.dart';

/// Calendar State
@freezed
class CalendarState with _$CalendarState {
  /// 생성자
  const factory CalendarState({
    /// 로딩 상태
    required bool isLoading,

    /// 포커스된 날짜 (캘린더에서 보이는 월)
    required DateTime focusedDay,

    /// 선택된 날짜
    DateTime? selectedDay,

    /// 캘린더 포맷 (월/주/2주)
    required CalendarFormat calendarFormat,

    /// 월간 기록 데이터 (날짜별로 그룹화)
    required Map<DateTime, Map<String, dynamic>> monthRecords,

    /// 선택된 날짜의 기록
    Map<String, dynamic>? selectedDayRecords,

    /// 에러
    required Option<Failure> failure,
  }) = _CalendarState;

  /// 초기 상태
  factory CalendarState.initial() {
    final now = DateTime.now();
    return CalendarState(
      isLoading: false,
      focusedDay: now,
      selectedDay: now,
      calendarFormat: CalendarFormat.month,
      monthRecords: {},
      selectedDayRecords: null,
      failure: none(),
    );
  }
}
