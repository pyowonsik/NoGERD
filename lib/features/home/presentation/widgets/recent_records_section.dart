import 'package:flutter/material.dart';

import 'package:no_gerd/features/home/domain/models/recent_record.dart';
import 'package:no_gerd/shared/shared.dart';

/// 최근 기록 섹션
class RecentRecordsSection extends StatelessWidget {
  /// 최근 기록 데이터
  final List<RecentRecord> records;

  /// 생성자
  const RecentRecordsSection({
    required this.records,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '최근 기록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: 전체보기 화면으로 이동
              },
              child: const Text(
                '전체보기',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 기록 목록
        if (records.isEmpty)
          const GlassCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '아직 기록이 없습니다',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          )
        else
          ...records.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RecentRecordItem(data: record),
            ),
          ),
      ],
    );
  }
}

class _RecentRecordItem extends StatelessWidget {
  final RecentRecord data;

  const _RecentRecordItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final color = Color(data.colorValue);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: () {
        // TODO: 상세보기 화면으로 이동
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                data.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.time,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
