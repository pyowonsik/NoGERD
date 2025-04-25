import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/utils/symptoms_util.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.records});

  final List<GerdRecord> records;

  List<Map<String, dynamic>> _processRecords() {
    // 최근 7일의 날짜 목록 생성
    final now = DateTime.now();
    final dates = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateFormat('yyyy년 MM월 dd일').format(date);
    });

    // 각 날짜별 증상 카운트 계산
    return dates.map((date) {
      final dateRecords =
          records.where((record) => record.date == date).toList();

      // 각 증상별 카운트 계산
      final symptomCounts = SymptomsUtil.symptoms.map((symptom) {
        return dateRecords
            .where((record) => record.symptoms.contains(symptom))
            .length;
      }).toList();

      // 날짜 문자열을 DateTime으로 변환
      final dateParts = date.split(RegExp(r'[년월일]'));
      final year = int.parse(dateParts[0].trim());
      final month = int.parse(dateParts[1].trim());
      final day = int.parse(dateParts[2].trim());
      final dateTime = DateTime(year, month, day);

      return {
        'date': DateFormat('M/d').format(dateTime),
        'counts': symptomCounts,
      };
    }).toList();
  }

  // 차트 바
  Widget _buildChartBar(Map<String, dynamic> data) {
    final List<int> counts = data['counts'] as List<int>;
    // 고정된 스케일 값으로 나누어 비율 계산 (각 증상의 높이를 20으로 나눔)
    const scale = 16.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: SymptomsUtil.symptoms.asMap().entries.map((entry) {
        final index = entry.key;
        final symptom = entry.value;
        // final isFirst = index == 0;
        // final isLast = index == symptoms.length - 1;

        return Container(
          width: 24,
          height: counts[index] * scale,
          decoration: BoxDecoration(
            color: SymptomsUtil.symptomColors[symptom],
            borderRadius: const BorderRadius.vertical(
                // top: isFirst ? const Radius.circular(4) : Radius.zero,
                // bottom: isLast ? const Radius.circular(4) : Radius.zero,
                ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final processedData = _processRecords();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: processedData.map((data) {
                return _buildChartBar(data);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: processedData.map((data) {
              return Text(
                data['date'],
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // 범례 추가
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: SymptomsUtil.symptoms.map((symptom) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: SymptomsUtil.symptomColors[symptom],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    symptom,
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
