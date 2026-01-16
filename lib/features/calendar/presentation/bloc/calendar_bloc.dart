import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/calendar/domain/usecases/get_records_for_month_usecase.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_bloc.freezed.dart';
part 'calendar_event.dart';
part 'calendar_state.dart';

/// Calendar BLoC
@injectable
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  /// 생성자
  CalendarBloc(
    this._getRecordsForMonthUseCase,
  ) : super(CalendarState.initial()) {
    on<CalendarEventLoadMonth>(_onLoadMonth);
    on<CalendarEventSelectDay>(_onSelectDay);
    on<CalendarEventGoToToday>(_onGoToToday);
    on<CalendarEventFormatChanged>(_onFormatChanged);
  }

  final GetRecordsForMonthUseCase _getRecordsForMonthUseCase;

  Future<void> _onLoadMonth(
    CalendarEventLoadMonth event,
    Emitter<CalendarState> emit,
  ) async {
    print('🔥 [CalendarBloc] _onLoadMonth 시작: ${event.month}');
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _getRecordsForMonthUseCase(event.month);

    result.fold(
      (failure) {
        print('❌ [CalendarBloc] 데이터 로드 실패: $failure');
        emit(
          state.copyWith(
            isLoading: false,
            failure: some(failure),
          ),
        );
      },
      (monthRecords) {
        print('✅ [CalendarBloc] 데이터 로드 성공: ${monthRecords.length}개 날짜');

        // 선택된 날짜가 있으면 해당 날짜의 기록도 업데이트
        Map<String, dynamic>? selectedDayRecords;
        if (state.selectedDay != null) {
          final normalizedDay = DateTime(
            state.selectedDay!.year,
            state.selectedDay!.month,
            state.selectedDay!.day,
          );
          selectedDayRecords = monthRecords[normalizedDay];
          print(
              '🔥 [CalendarBloc] 선택된 날짜 기록 업데이트: ${selectedDayRecords != null ? "있음" : "없음"}');
        }

        emit(
          state.copyWith(
            isLoading: false,
            focusedDay: event.month,
            monthRecords: monthRecords,
            selectedDayRecords: selectedDayRecords,
          ),
        );
      },
    );
  }

  Future<void> _onSelectDay(
    CalendarEventSelectDay event,
    Emitter<CalendarState> emit,
  ) async {
    final normalizedDay =
        DateTime(event.day.year, event.day.month, event.day.day);

    // 선택된 날짜의 기록 가져오기
    final selectedDayRecords = state.monthRecords[normalizedDay];

    emit(
      state.copyWith(
        selectedDay: event.day,
        focusedDay: event.day,
        selectedDayRecords: selectedDayRecords,
      ),
    );
  }

  Future<void> _onGoToToday(
    CalendarEventGoToToday event,
    Emitter<CalendarState> emit,
  ) async {
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);

    // 현재 월이 아니면 새로 로드
    if (state.focusedDay.month != now.month ||
        state.focusedDay.year != now.year) {
      add(CalendarEvent.loadMonth(now));
    }

    final selectedDayRecords = state.monthRecords[normalizedNow];

    emit(
      state.copyWith(
        selectedDay: now,
        focusedDay: now,
        selectedDayRecords: selectedDayRecords,
      ),
    );
  }

  Future<void> _onFormatChanged(
    CalendarEventFormatChanged event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(calendarFormat: event.format));
  }
}
