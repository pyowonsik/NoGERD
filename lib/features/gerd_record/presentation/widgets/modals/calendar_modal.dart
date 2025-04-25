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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // 메인 컨테이너
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 타이틀
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '달력 보기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 달력 설명
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Color(0xFF66BB6A),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '기록이 있는 날짜를 선택하면 상세 정보를 볼 수 있습니다.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 달력
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: TableCalendar(
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
                        color: Color(0xFF1E88E5),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF1E88E5).withOpacity(0.3),
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
                        color: Color(0xFF1E88E5),
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF1E88E5),
                      ),
                      headerPadding: const EdgeInsets.symmetric(vertical: 12),
                      headerMargin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      // Marker (점) 표시
                      markerBuilder: (context, date, events) {
                        try {
                          // 해당 날짜의 기록 찾기
                          final selectedRecord =
                              widget.viewModel.currentRecords.firstWhere(
                            (record) =>
                                record.date ==
                                DateFormat('yyyy년 MM월 dd일').format(date),
                          );

                          // 상태에 맞는 색상 가져오기
                          Color statusColor =
                              StatusUtil.getStatusColor(selectedRecord.status);

                          return Positioned(
                            bottom: 1,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withOpacity(0.3),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
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
                ),
                const SizedBox(height: 24),

                // 범례
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('좋음', const Color(0xFF66BB6A)),
                      _buildLegendItem('보통', const Color(0xFFFFB74D)),
                      _buildLegendItem('나쁨', const Color(0xFFEF5350)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 닫기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 상단 아이콘
          Positioned(
            top: -30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF66BB6A),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF66BB6A).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          // 닫기 버튼 (X)
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF757575),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 범례 아이템 위젯
  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF424242),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
