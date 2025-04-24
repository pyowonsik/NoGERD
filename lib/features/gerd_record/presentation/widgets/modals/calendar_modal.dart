import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/presentation/viewmodels/gerd_view_model.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/modals/record_detail_modal.dart';
import 'package:no_gerd/utils/status_util.dart';

class CalendarModal extends StatefulWidget {
  final GerdViewModel viewModel;

  const CalendarModal({super.key, required this.viewModel});

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    // viewModel에서 전체 기록 가져오기
    final records = widget.viewModel.currentRecords;

    // "yyyy년 MM월 dd일" 포맷을 DateTime 객체로 변환
    final recordDates = records.map((record) {
      final parsedDate = DateFormat('yyyy년 MM월 dd일').parse(record.date);
      // 시간 부분을 00:00으로 설정
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    }).toSet();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '달력 보기',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: StatusUtil.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    // 선택된 날짜의 기록 찾기
                    final selectedDate =
                        DateFormat('yyyy년 MM월 dd일').format(selectedDay);

                    try {
                      final selectedRecord =
                          widget.viewModel.currentRecords.firstWhere(
                        (record) => record.date == selectedDate,
                      );

                      // 기록이 있으면 상세 모달 표시
                      showDialog(
                        context: context,
                        builder: (context) => RecordDetailModal(
                          record: selectedRecord,
                          viewModel: widget.viewModel,
                        ),
                      );
                    } catch (e) {
                      // 예외가 발생하면 모달을 띄우지 않음
                      // print('선택된 날짜에 해당하는 기록이 없습니다: $e');
                    }
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: StatusUtil.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: StatusUtil.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                    defaultTextStyle: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: StatusUtil.primaryColor,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: StatusUtil.primaryColor,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = DateFormat.E('ko_KR').format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: day.weekday == DateTime.sunday
                                ? Colors.red
                                : day.weekday == DateTime.saturday
                                    ? Colors.blue
                                    : Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    // Marker (점) 표시
                    markerBuilder: (context, date, events) {
                      final normalizedDate =
                          DateTime(date.year, date.month, date.day);

                      try {
                        // 해당 날짜의 기록 찾기
                        final selectedRecord =
                            widget.viewModel.currentRecords.firstWhere(
                          (record) =>
                              record.date ==
                              DateFormat('yyyy년 MM월 dd일').format(date),
                        );

                        // 상태에 맞는 색상 및 아이콘을 가져오기
                        Color statusColor =
                            StatusUtil.getStatusColor(selectedRecord.status);

                        return Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: statusColor, // 상태에 맞는 색상 적용
                            shape: BoxShape.circle,
                          ),
                        );
                      } catch (e) {
                        // 예외가 발생하면 기록이 없는 것으로 간주하고, 점을 표시하지 않음
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  locale: 'ko_KR',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('닫기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
