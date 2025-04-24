import 'package:flutter/material.dart';

class StatusUtil {
  // 색상 상수 정의
  static const Color primaryColor = Color(0xFF1E88E5); // 메인 파란색
  static const Color successColor = Color(0xFF66BB6A); // 초록색
  static const Color warningColor = Color(0xFFFFCA28); // 주황색
  static const Color dangerColor = Color(0xFFEF5350); // 빨간색

  // 상태에 따른 색상 반환
  static Color getStatusColor(String status) {
    switch (status) {
      case '좋음':
        return successColor;
      case '보통':
        return warningColor;
      case '나쁨':
        return dangerColor;
      default:
        return primaryColor;
    }
  }

  // 상태에 따른 아이콘 반환
  static IconData getStatusIcon(String status) {
    switch (status) {
      case '좋음':
        return Icons.sentiment_very_satisfied;
      case '보통':
        return Icons.sentiment_neutral;
      case '나쁨':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
