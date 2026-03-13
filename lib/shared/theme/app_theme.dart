import 'package:flutter/material.dart';

/// NoGERD 앱 테마 정의
/// 역류성 식도염 관리 앱에 맞는 차분하고 건강한 느낌의 색상 팔레트
class AppTheme {
  AppTheme._();

  /// 주요 색상 - Teal (치유, 건강)
  static const Color primary = Color(0xFF26A69A);

  /// 주요 색상 - 밝은 버전
  static const Color primaryLight = Color(0xFF80CBC4);

  /// 주요 색상 - 어두운 버전
  static const Color primaryDark = Color(0xFF00897B);

  /// 보조 색상 - Indigo (신뢰, 안정)
  static const Color secondary = Color(0xFF5C6BC0);

  /// 보조 색상 - 밝은 버전
  static const Color secondaryLight = Color(0xFF9FA8DA);

  /// 강조 색상 - Deep Orange (주의, 경고)
  static const Color accent = Color(0xFFFF7043);

  /// 강조 색상 - 밝은 버전
  static const Color accentLight = Color(0xFFFFAB91);

  /// 배경 색상
  static const Color background = Color(0xFFF5F7FA);

  /// 표면 색상
  static const Color surface = Color(0xFFFFFFFF);

  /// 카드 배경 색상
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// 주요 텍스트 색상
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// 보조 텍스트 색상
  static const Color textSecondary = Color(0xFF6B7280);

  /// 세 번째 텍스트 색상
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// 성공 상태 색상
  static const Color success = Color(0xFF4CAF50);

  /// 경고 상태 색상
  static const Color warning = Color(0xFFFFB300);

  /// 에러 상태 색상
  static const Color error = Color(0xFFEF5350);

  /// 정보 상태 색상
  static const Color info = Color(0xFF42A5F5);

  /// 증상 기록 색상 - Red
  static const Color symptomColor = Color(0xFFEF5350);

  /// 식사 기록 색상 - Green
  static const Color mealColor = Color(0xFF66BB6A);

  /// 약물 기록 색상 - Blue
  static const Color medicationColor = Color(0xFF42A5F5);

  /// 생활습관 기록 색상 - Purple
  static const Color lifestyleColor = Color(0xFFAB47BC);

  /// 주요 그라데이션
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF26A69A), Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 증상 그라데이션
  static const LinearGradient symptomGradient = LinearGradient(
    colors: [Color(0xFFFF7043), Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 식사 그라데이션
  static const LinearGradient mealGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 약물 그라데이션
  static const LinearGradient medicationGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 생활습관 그라데이션
  static const LinearGradient lifestyleGradient = LinearGradient(
    colors: [Color(0xFFAB47BC), Color(0xFF8E24AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 배경 그라데이션
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F7FA), Color(0xFFE8F5E9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 카드 그림자
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  /// 버튼 그림자
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// 작은 모서리 반경
  static const double radiusSmall = 8;

  /// 중간 모서리 반경
  static const double radiusMedium = 12;

  /// 큰 모서리 반경
  static const double radiusLarge = 16;

  /// 매우 큰 모서리 반경
  static const double radiusXLarge = 24;

  /// 매우 작은 간격
  static const double spacingXS = 4;

  /// 작은 간격
  static const double spacingS = 8;

  /// 중간 간격
  static const double spacingM = 16;

  /// 큰 간격
  static const double spacingL = 24;

  /// 매우 큰 간격
  static const double spacingXL = 32;

  /// 라이트 테마 데이터
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),
      fontFamily: 'Pretendard',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
