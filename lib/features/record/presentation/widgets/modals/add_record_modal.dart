import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:no_gerd/features/record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/record/presentation/viewmodels/gred_view_model.dart';

class AddRecordModal extends StatefulWidget {
  final GerdViewModel viewModel;

  const AddRecordModal({super.key, required this.viewModel});

  @override
  State<AddRecordModal> createState() => _AddRecordModalState();
}

class _AddRecordModalState extends State<AddRecordModal> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String _selectedStatus = '보통';
  final List<String> _selectedSymptoms = [];

  // 색상 상수 정의
  static const Color _primaryColor = Color(0xFF1E88E5); // 메인 파란색
  static const Color _successColor = Color(0xFF66BB6A); // 초록색
  static const Color _warningColor = Color(0xFFFFCA28); // 주황색
  static const Color _dangerColor = Color(0xFFEF5350); // 빨간색
  static const Color _backgroundColor = Color(0xFFF5F5F5); // 연한 회색 배경

  final List<String> _symptoms = [
    '가슴 쓰림',
    '역류',
    '소화불량',
    '목 아픔',
    '복부 팽만감',
  ];

  final List<String> _statuses = [
    '좋음',
    '보통',
    '나쁨',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '오늘의 증상 기록',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // 증상 선택
                  Text(
                    '증상',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptoms.map((symptom) {
                      return FilterChip(
                        label: Text(symptom),
                        selected: _selectedSymptoms.contains(symptom),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSymptoms.add(symptom);
                            } else {
                              _selectedSymptoms.remove(symptom);
                            }
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: _primaryColor.withOpacity(0.15),
                        checkmarkColor: _primaryColor,
                        labelStyle: TextStyle(
                          color: _selectedSymptoms.contains(symptom)
                              ? _primaryColor
                              : Colors.grey.shade700,
                          fontWeight: _selectedSymptoms.contains(symptom)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _selectedSymptoms.contains(symptom)
                                ? _primaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 상태 선택
                  Text(
                    '오늘의 상태',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _statuses.map((status) {
                      final isSelected = _selectedStatus == status;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _getStatusColor(status).withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? _getStatusColor(status)
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: _getStatusColor(status)
                                          .withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: isSelected
                                  ? _getStatusColor(status)
                                  : Colors.grey.shade700,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 메모 입력
                  Text(
                    '메모',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '오늘의 증상에 대해 자세히 기록해주세요',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _primaryColor),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 버튼
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
                          child: const Text('취소'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _selectedSymptoms.isNotEmpty) {
                              // 새로운 GerdRecord 생성
                              final newRecord = GerdRecord(
                                date: DateFormat('yyyy년 MM월 dd일')
                                    .format(DateTime.now()),
                                symptoms: _selectedSymptoms,
                                status: _selectedStatus,
                                notes: _notesController.text,
                              );

                              final viewModel = widget.viewModel;
                              viewModel.addRecord(
                                  newRecord); // Add the new record to the ViewModel

                              // 모달 닫기
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('저장'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '좋음':
        return _successColor;
      case '보통':
        return _warningColor;
      case '나쁨':
        return _dangerColor;
      default:
        return _primaryColor;
    }
  }
}
