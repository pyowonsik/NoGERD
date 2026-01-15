import 'package:flutter/material.dart';

import 'package:no_gerd/features/home/domain/models/record_summary.dart';
import 'package:no_gerd/shared/shared.dart';

/// 오늘 요약 섹션
class TodaySummarySection extends StatelessWidget {
  /// 요약 데이터
  final List<RecordSummary> summary;

  /// 생성자
  const TodaySummarySection({
    required this.summary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '오늘 요약',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildSummaryGrid(),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    // 2x2 그리드로 표시
    final rows = <Widget>[];
    for (var i = 0; i < summary.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _SummaryItem(data: summary[i])),
            if (i + 1 < summary.length) ...[
              const SizedBox(width: 12),
              Expanded(child: _SummaryItem(data: summary[i + 1])),
            ],
          ],
        ),
      );
      if (i + 2 < summary.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }
}

class _SummaryItem extends StatelessWidget {
  final RecordSummary data;

  const _SummaryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final icon = IconData(
      data.iconCode,
      fontFamily: 'MaterialIcons',
    );
    final color = Color(data.colorValue);

    return GlassCard(
      padding: const EdgeInsets.all(14),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  data.subValue,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
