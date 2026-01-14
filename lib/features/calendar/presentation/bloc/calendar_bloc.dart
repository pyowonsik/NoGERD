import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/calendar/domain/usecases/get_records_for_month_usecase.dart';

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
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _getRecordsForMonthUseCase(event.month);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (monthRecords) {
        emit(
          state.copyWith(
            isLoading: false,
            focusedDay: event.month,
            monthRecords: monthRecords,
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
