import 'package:flutter/material.dart';

class SymptomsUtil {
  // 색상 상수 정의
  static const List<String> symptoms = [
    '가슴 쓰림',
    '역류',
    '소화불량',
    '목 아픔',
    '복부 팽만감',
    '기침',
    '쉰 목소리',
    '기타',
  ];
  static const Map<String, Color> symptomColors = {
    '가슴 쓰림': Color(0xFF1E88E5),
    '역류': Color(0xFF66BB6A),
    '소화불량': Color(0xFFFFB74D),
    '목 아픔': Color(0xFF9C27B0),
    '복부 팽만감': Color(0xFFE91E63),
    '기침': Color(0xFF009688),
    '쉰 목소리': Color(0xFF795548),
    '기타': Color(0xFF607D8B),
  };
}
