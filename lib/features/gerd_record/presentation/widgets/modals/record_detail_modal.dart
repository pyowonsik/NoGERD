import 'package:flutter/material.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/presentation/viewmodels/gerd_view_model.dart';
import 'package:no_gerd/utils/status_util.dart';

class RecordDetailModal extends StatelessWidget {
  final GerdRecord record;
  final GerdViewModel viewModel;

  const RecordDetailModal({
    super.key,
    required this.record,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      '기록 상세',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 날짜 표시
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E88E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF1E88E5),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        record.date,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 증상 목록
                _buildSectionTitle('증상', Icons.healing),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: record.symptoms.map((symptom) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E88E5).withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        symptom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 상태 표시
                _buildSectionTitle('상태', Icons.sentiment_satisfied_alt),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: StatusUtil.getStatusColor(record.status),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: StatusUtil.getStatusColor(record.status)
                            .withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          StatusUtil.getStatusIcon(record.status),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        record.status,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 메모 표시
                if (record.notes.isNotEmpty) ...[
                  _buildSectionTitle('메모', Icons.note_alt),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF66BB6A).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      record.notes,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF424242),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],

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

                // // 버튼 영역
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _buildActionButton(
                //       '수정하기',
                //       Icons.edit,
                //       const Color(0xFF1E88E5),
                //       () {
                //         // 수정 기능 구현
                //         Navigator.pop(context);
                //         // 수정 모달 표시 로직 추가
                //       },
                //     ),
                //     const SizedBox(width: 12),
                //     _buildActionButton(
                //       '삭제하기',
                //       Icons.delete,
                //       const Color(0xFFEF5350),
                //       () {
                //         // 삭제 기능 구현
                //         showDialog(
                //           context: context,
                //           builder: (context) => AlertDialog(
                //             title: const Text('기록 삭제'),
                //             content: const Text('이 기록을 삭제하시겠습니까?'),
                //             actions: [
                //               TextButton(
                //                 onPressed: () => Navigator.pop(context),
                //                 child: const Text('취소'),
                //               ),
                //               TextButton(
                //                 onPressed: () {
                //                   // viewModel.deleteRecord(record.id);
                //                   Navigator.pop(context); // 확인 다이얼로그 닫기
                //                   Navigator.pop(context); // 상세 모달 닫기
                //                 },
                //                 child: const Text('삭제'),
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     ),
                //   ],
                // ),
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
                color: const Color(0xFF1E88E5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(0.3),
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
                Icons.article,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          // 닫기 버튼
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

  // 섹션 타이틀 위젯
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF66BB6A),
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
      ],
    );
  }

  // 액션 버튼 위젯
  // Widget _buildActionButton(
  //   String text,
  //   IconData icon,
  //   Color color,
  //   VoidCallback onPressed,
  // ) {
  //   return InkWell(
  //     onTap: onPressed,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: color.withOpacity(0.3),
  //             blurRadius: 4,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             icon,
  //             color: Colors.white,
  //             size: 16,
  //           ),
  //           const SizedBox(width: 8),
  //           Text(
  //             text,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
