import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_gerd/shared/shared.dart';

/// 캘린더 날짜별 전체 기록 모달
class CalendarRecordsModal extends StatefulWidget {
  /// 기록 데이터 (최대 20개)
  final List<Map<String, dynamic>> records;

  /// 선택된 날짜
  final DateTime date;

  const CalendarRecordsModal({
    required this.records,
    required this.date,
    super.key,
  });

  @override
  State<CalendarRecordsModal> createState() => _CalendarRecordsModalState();
}

class _CalendarRecordsModalState extends State<CalendarRecordsModal> {
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  int get _totalPages => (widget.records.length / _itemsPerPage).ceil();

  List<Map<String, dynamic>> get _currentPageRecords {
    final start = _currentPage * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, widget.records.length);
    return widget.records.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${widget.date.month}월 ${widget.date.day}일';

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  '$dateStr 기록',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '총 ${widget.records.length}건',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // 기록 리스트
          Expanded(
            child: widget.records.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        '기록이 없습니다',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _currentPageRecords.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _RecordItem(
                        data: _currentPageRecords[index],
                      );
                    },
                  ),
          ),

          // 페이지네이션 (항상 하단에 고정)
          if (_totalPages > 1)
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalPages, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _currentPage = index),
                        child: Container(
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecordItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const _RecordItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String;
    final record = data['data'];

    Color color;
    IconData icon;
    String typeLabel;
    String title;

    switch (type) {
      case 'symptom':
        color = AppTheme.symptomColor;
        icon = Icons.local_fire_department_rounded;
        typeLabel = '증상';
        final symptoms = record.symptoms as List;
        title = symptoms.isNotEmpty
            ? symptoms.first.label.toString()
            : '증상 기록';
        break;
      case 'meal':
        color = AppTheme.mealColor;
        icon = Icons.restaurant_rounded;
        typeLabel = '식사';
        title = record.mealType.label.toString();
        break;
      case 'medication':
        color = AppTheme.medicationColor;
        icon = Icons.medication_rounded;
        typeLabel = '약물';
        title = (record.medicationName as String?) ?? '약물 기록';
        break;
      case 'lifestyle':
        color = AppTheme.lifestyleColor;
        icon = Icons.self_improvement_rounded;
        typeLabel = '생활습관';
        title = record.lifestyleType.label.toString();
        break;
      default:
        color = AppTheme.accent;
        icon = Icons.circle;
        typeLabel = '기타';
        title = '기록';
    }

    final recordedAt = record.recordedAt as DateTime;
    final timeStr =
        '${recordedAt.hour.toString().padLeft(2, '0')}:${recordedAt.minute.toString().padLeft(2, '0')}';

    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: () {
        context.push('/record/detail', extra: record);
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
    );
  }
}
