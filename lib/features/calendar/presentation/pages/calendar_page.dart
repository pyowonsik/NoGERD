import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:no_gerd/features/calendar/presentation/widgets/calendar_records_modal.dart';
import 'package:no_gerd/features/record/presentation/bloc/record_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

/// 캘린더 페이지 (BLoC 통합)
class CalendarPage extends StatefulWidget {
  /// 생성자
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 현재 월 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CalendarBloc>().add(
              CalendarEvent.loadMonth(DateTime.now()),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        // RecordBloc에서 성공 메시지가 있으면 CalendarBloc을 새로고침
        state.successMessage.fold(
          () {},
          (_) {
            final currentMonth = context.read<CalendarBloc>().state.focusedDay;
            context.read<CalendarBloc>().add(
                  CalendarEvent.loadMonth(currentMonth),
                );
          },
        );
      },
      child: const _CalendarPageContent(),
    );
  }
}

class _CalendarPageContent extends StatelessWidget {
  const _CalendarPageContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                '기록 캘린더',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.today_rounded),
                  onPressed: () {
                    context.read<CalendarBloc>().add(
                          const CalendarEvent.goToToday(),
                        );
                  },
                ),
              ],
            ),

            // Calendar & Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<CalendarBloc, CalendarState>(
                  buildWhen: (previous, current) {
                    return previous.selectedDay != current.selectedDay ||
                        previous.focusedDay != current.focusedDay ||
                        previous.monthRecords != current.monthRecords ||
                        previous.calendarFormat != current.calendarFormat ||
                        previous.isLoading != current.isLoading;
                  },
                  builder: (context, state) {

                    // 로딩 중일 때 표시
                    if (state.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // 캘린더
                        GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: state.focusedDay,
                            calendarFormat: state.calendarFormat,
                            selectedDayPredicate: (day) =>
                                isSameDay(state.selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              context.read<CalendarBloc>().add(
                                    CalendarEvent.selectDay(selectedDay),
                                  );
                            },
                            onPageChanged: (focusedDay) {
                              context.read<CalendarBloc>().add(
                                    CalendarEvent.loadMonth(focusedDay),
                                  );
                            },
                            onFormatChanged: (format) {
                              context.read<CalendarBloc>().add(
                                    CalendarEvent.formatChanged(format),
                                  );
                            },
                            eventLoader: (day) {
                              final normalizedDay = DateTime(
                                day.year,
                                day.month,
                                day.day,
                              );
                              final dayRecords =
                                  state.monthRecords[normalizedDay];
                              if (dayRecords == null) return [];

                              // 각 타입별로 마커 표시를 위한 더미 리스트
                              final markers = <String>[];
                              if ((dayRecords['symptoms'] as List).isNotEmpty) {
                                markers.add('symptom');
                              }
                              if ((dayRecords['meals'] as List).isNotEmpty) {
                                markers.add('meal');
                              }
                              if ((dayRecords['medications'] as List)
                                  .isNotEmpty) {
                                markers.add('medication');
                              }
                              if ((dayRecords['lifestyles'] as List)
                                  .isNotEmpty) {
                                markers.add('lifestyle');
                              }
                              return markers;
                            },
                            locale: 'ko_KR',
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              leftChevronIcon: Icon(
                                Icons.chevron_left_rounded,
                                color: AppTheme.primary,
                              ),
                              rightChevronIcon: Icon(
                                Icons.chevron_right_rounded,
                                color: AppTheme.primary,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                              weekendStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.error.withValues(alpha: 0.7),
                              ),
                            ),
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              todayDecoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              selectedDecoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              markerDecoration: const BoxDecoration(
                                color: AppTheme.accent,
                                shape: BoxShape.circle,
                              ),
                              markerSize: 6,
                            ),
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                if (events.isEmpty) return null;
                                return Positioned(
                                  bottom: 1,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: events.take(4).map((event) {
                                      Color color;
                                      switch (event) {
                                        case 'symptom':
                                          color = AppTheme.symptomColor;
                                        case 'meal':
                                          color = AppTheme.mealColor;
                                        case 'medication':
                                          color = AppTheme.medicationColor;
                                        case 'lifestyle':
                                          color = AppTheme.lifestyleColor;
                                        default:
                                          color = AppTheme.accent;
                                      }
                                      return Container(
                                        width: 6,
                                        height: 6,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 월간 통계
                        _buildMonthlyStats(state),

                        const SizedBox(height: 20),

                        // 선택된 날짜의 기록
                        _buildSelectedDayRecords(context, state),

                        const SizedBox(height: 100),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyStats(CalendarState state) {
    // 증상 타입별로 집계
    var symptomCounts = <GerdSymptom, int>{};

    for (final records in state.monthRecords.values) {
      // 증상 기록에서 각 증상 타입별로 카운트
      final symptoms = records['symptoms'] as List;
      for (final symptomRecord in symptoms) {
        final symptomList = symptomRecord.symptoms as List<GerdSymptom>;
        for (final symptom in symptomList) {
          symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
        }
      }
    }

    // 0회가 아닌 증상만 필터링 및 정렬 (건수 많은 순)
    final nonZeroSymptoms = symptomCounts.entries
        .where((entry) => entry.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                '${state.focusedDay.month}월 요약',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 증상별 통계
          if (nonZeroSymptoms.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: nonZeroSymptoms.map((entry) {
                return _SymptomStatChip(
                  symptom: entry.key,
                  count: entry.value,
                );
              }).toList(),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '증상 기록이 없습니다',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayRecords(BuildContext context, CalendarState state) {
    final selectedDay = state.selectedDay;
    final records = state.selectedDayRecords;

    if (selectedDay == null) {
      return const SizedBox.shrink();
    }

    final dateStr = '${selectedDay.month}월 ${selectedDay.day}일';

    // 모든 기록을 하나의 리스트로 합치기
    final allRecords = <Map<String, dynamic>>[];

    if (records != null) {
      for (final symptom in records['symptoms'] as List) {
        allRecords.add({
          'type': 'symptom',
          'data': symptom,
        });
      }
      for (final meal in records['meals'] as List) {
        allRecords.add({
          'type': 'meal',
          'data': meal,
        });
      }
      for (final medication in records['medications'] as List) {
        allRecords.add({
          'type': 'medication',
          'data': medication,
        });
      }
      for (final lifestyle in records['lifestyles'] as List) {
        allRecords.add({
          'type': 'lifestyle',
          'data': lifestyle,
        });
      }
    }

    // 시간순 정렬 (최신순)
    allRecords.sort(
      (a, b) => (b['data'].recordedAt as DateTime)
          .compareTo(a['data'].recordedAt as DateTime),
    );

    // 전체보기 모달용 데이터 (최대 20개)
    final allRecordsForModal = allRecords.take(20).toList();

    // 화면 표시용 데이터 (최대 5개)
    final displayRecords = allRecords.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$dateStr 기록',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '${allRecords.length}건',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            if (allRecords.length > 5) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (context, scrollController) =>
                          CalendarRecordsModal(
                        records: allRecordsForModal,
                        date: selectedDay,
                      ),
                    ),
                  );
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        if (allRecords.isEmpty)
          const GlassCard(
            child: Center(
              child: Column(
                children: [
                  Text('📝', style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text(
                    '기록이 없습니다',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...displayRecords.map(
            (record) {
              final type = record['type'] as String;
              Color color;
              IconData icon;
              String typeLabel;

              switch (type) {
                case 'symptom':
                  color = AppTheme.symptomColor;
                  icon = Icons.local_fire_department_rounded;
                  typeLabel = '증상';
                case 'meal':
                  color = AppTheme.mealColor;
                  icon = Icons.restaurant_rounded;
                  typeLabel = '식사';
                case 'medication':
                  color = AppTheme.medicationColor;
                  icon = Icons.medication_rounded;
                  typeLabel = '약물';
                case 'lifestyle':
                  color = AppTheme.lifestyleColor;
                  icon = Icons.self_improvement_rounded;
                  typeLabel = '생활습관';
                default:
                  color = AppTheme.accent;
                  icon = Icons.circle;
                  typeLabel = '기타';
              }

              final data = record['data'];
              final recordedAt = data.recordedAt as DateTime;
              final hourStr = recordedAt.hour.toString().padLeft(2, '0');
              final minStr = recordedAt.minute.toString().padLeft(2, '0');
              final timeStr = '$hourStr:$minStr';

              // 제목 생성 (타입별로 다르게)
              String title;
              if (type == 'symptom') {
                final symptoms = data.symptoms as List;
                title = symptoms.isNotEmpty
                    ? symptoms.first.label.toString()
                    : '증상 기록';
              } else if (type == 'meal') {
                title = data.mealType.label.toString();
              } else if (type == 'medication') {
                title = (data.medicationName as String?) ?? '약물 기록';
              } else {
                title = data.lifestyleType.label.toString();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () {
                    context.push('/record/detail', extra: data);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              typeLabel,
                              style: TextStyle(
                                fontSize: 13,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 증상 통계 칩 위젯
class _SymptomStatChip extends StatelessWidget {
  const _SymptomStatChip({
    required this.symptom,
    required this.count,
  });
  final GerdSymptom symptom;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.symptomColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.symptomColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(symptom.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            symptom.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count회',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.symptomColor,
            ),
          ),
        ],
      ),
    );
  }
}
