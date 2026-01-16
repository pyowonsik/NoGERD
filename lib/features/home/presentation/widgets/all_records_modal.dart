import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:no_gerd/features/home/domain/models/recent_record.dart';
import 'package:no_gerd/shared/shared.dart';

/// 전체 기록 보기 모달
class AllRecordsModal extends StatefulWidget {
  const AllRecordsModal({
    required this.records,
    super.key,
  });

  /// 전체 기록 데이터 (최대 20개)
  final List<RecentRecord> records;

  @override
  State<AllRecordsModal> createState() => _AllRecordsModalState();
}

class _AllRecordsModalState extends State<AllRecordsModal> {
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  int get _totalPages => (widget.records.length / _itemsPerPage).ceil();

  List<RecentRecord> get _currentPageRecords {
    final start = _currentPage * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, widget.records.length);
    return widget.records.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  '전체 기록',
                  style: TextStyle(
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
                      return _RecordItem(data: _currentPageRecords[index]);
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
  const _RecordItem({required this.data});
  final RecentRecord data;

  @override
  Widget build(BuildContext context) {
    final color = Color(data.colorValue);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: () {
        if (data.originalEntity != null) {
          context.push('/record/detail', extra: data.originalEntity);
        }
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
