import 'package:flutter/material.dart';

import 'package:no_gerd/features/record/domain/entities/gerd_record.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.records});

  final List<GerdRecord> records;

  @override
  Widget build(BuildContext context) {
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
              children: [
                _buildChartBar(['4/10', 3, 2, 1]),
                _buildChartBar(['4/11', 2, 1, 0]),
                _buildChartBar(['4/12', 2, 3, 2]),
                _buildChartBar(['4/13', 3, 2, 1]),
                _buildChartBar(['4/14', 1, 0, 0]),
                _buildChartBar(['4/15', 2, 1, 1]),
                _buildChartBar(['4/16', 3, 2, 2]),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('4/10',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text('4/11',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text('4/12',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text('4/13',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text('4/14',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text('4/15',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text('4/16',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}

// 차트 바
Widget _buildChartBar(List<dynamic> data) {
  String date = data[0] as String;
  int value1 = data[1] as int;
  int value2 = data[2] as int;
  int value3 = data[3] as int;

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 24,
        height: value1 * 20.0,
        decoration: const BoxDecoration(
          color: Color(0xFF1E88E5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ),
      Container(
        width: 24,
        height: value2 * 20.0,
        decoration: const BoxDecoration(
          color: Color(0xFF66BB6A),
        ),
      ),
      Container(
        width: 24,
        height: value3 * 20.0,
        decoration: const BoxDecoration(
          color: Color(0xFFFFB74D),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
        ),
      ),
    ],
  );
}
