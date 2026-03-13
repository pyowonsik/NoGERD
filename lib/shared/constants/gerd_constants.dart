import 'package:flutter/material.dart';

import 'package:no_gerd/shared/theme/app_theme.dart';

/// 증상 강도 레벨
enum SeverityLevel {
  /// 약함 (1-3)
  mild(1, '약함', Color(0xFF81C784)),

  /// 보통 (4-6)
  moderate(2, '보통', Color(0xFFFFB74D)),

  /// 심함 (7-10)
  severe(3, '심함', Color(0xFFE57373));

  const SeverityLevel(this.value, this.label, this.color);

  /// 숫자 값
  final int value;

  /// 라벨
  final String label;

  /// 색상
  final Color color;

  /// 숫자 값으로 SeverityLevel 가져오기
  static SeverityLevel fromValue(int value) {
    if (value <= 3) return SeverityLevel.mild;
    if (value <= 6) return SeverityLevel.moderate;
    return SeverityLevel.severe;
  }
}

/// GERD 증상 타입
enum GerdSymptom {
  /// 가슴쓰림
  heartburn('가슴쓰림', '🔥', '가슴 부위가 타는 듯한 느낌'),

  /// 산역류
  acidReflux('산역류', '💧', '신맛이 올라오는 느낌'),

  /// 역류
  regurgitation('역류', '⬆️', '음식물이 올라오는 느낌'),

  /// 흉통
  chestPain('흉통', '💔', '가슴 통증'),

  /// 연하곤란
  dysphagia('연하곤란', '😣', '삼키기 어려움'),

  /// 만성기침
  chronicCough('만성기침', '😷', '지속적인 기침'),

  /// 목쉼
  hoarseness('목쉼', '🗣️', '쉰 목소리'),

  /// 인후통
  throatPain('인후통', '😫', '목 아픔'),

  /// 목이물감
  globusSensation('목이물감', '⭕', '목에 뭔가 걸린 느낌'),

  /// 메스꺼움
  nausea('메스꺼움', '🤢', '속이 울렁거림'),

  /// 복부팽만
  bloating('복부팽만', '🎈', '배가 부풀어 오르는 느낌'),

  /// 트림
  burping('트림', '💨', '잦은 트림');

  const GerdSymptom(this.label, this.emoji, this.description);

  /// 라벨
  final String label;

  /// 이모지
  final String emoji;

  /// 설명
  final String description;
}

/// 트리거 음식 카테고리
enum TriggerFoodCategory {
  /// 기름진 음식
  fatty('기름진 음식', '🍟', ['튀김', '패스트푸드', '삼겹살']),

  /// 산성 음식
  acidic('산성 음식', '🍋', ['오렌지', '레몬', '토마토']),

  /// 매운 음식
  spicy('매운 음식', '🌶️', ['고추', '마라', '김치찌개']),

  /// 카페인
  caffeine('카페인', '☕', ['커피', '에너지드링크', '녹차']),

  /// 술
  alcohol('술', '🍺', ['맥주', '소주', '와인']),

  /// 탄산음료
  carbonated('탄산음료', '🥤', ['콜라', '사이다', '탄산수']),

  /// 초콜릿
  chocolate('초콜릿', '🍫', ['초콜릿', '코코아', '초코우유']),

  /// 민트
  mint('민트', '🌿', ['페퍼민트', '민트차']);

  const TriggerFoodCategory(this.label, this.emoji, this.examples);

  /// 라벨
  final String label;

  /// 이모지
  final String emoji;

  /// 예시 음식들
  final List<String> examples;
}

/// 약물 종류
enum MedicationType {
  /// PPI (양성자펌프억제제)
  ppi('PPI (양성자펌프억제제)', '💊', ['오메프라졸', '란소프라졸', '에소메프라졸']),

  /// H2 차단제
  h2Blocker('H2 차단제', '💉', ['라니티딘', '파모티딘', '시메티딘']),

  /// 제산제
  antacid('제산제', '🧴', ['겔포스', '탈시드', '알마겔']),

  /// 위장운동촉진제
  prokinetic('위장운동촉진제', '⚡', ['돔페리돈', '모사프리드', '이토프리드']);

  const MedicationType(this.label, this.emoji, this.examples);

  /// 라벨
  final String label;

  /// 이모지
  final String emoji;

  /// 예시 약물들
  final List<String> examples;
}

/// 기록 유형
enum RecordType {
  /// 증상
  symptom('증상', Icons.local_fire_department_rounded, AppTheme.symptomColor),

  /// 식사
  meal('식사', Icons.restaurant_rounded, AppTheme.mealColor),

  /// 약물
  medication('약물', Icons.medication_rounded, AppTheme.medicationColor),

  /// 생활습관
  lifestyle('생활습관', Icons.self_improvement_rounded, AppTheme.lifestyleColor);

  const RecordType(this.label, this.icon, this.color);

  /// 라벨
  final String label;

  /// 아이콘
  final IconData icon;

  /// 색상
  final Color color;
}

/// 식사 유형
enum MealType {
  /// 아침
  breakfast('아침', '🌅'),

  /// 점심
  lunch('점심', '☀️'),

  /// 저녁
  dinner('저녁', '🌙'),

  /// 간식
  snack('간식', '🍪'),

  /// 야식
  lateNight('야식', '🌃');

  const MealType(this.label, this.emoji);

  /// 라벨
  final String label;

  /// 이모지
  final String emoji;
}

/// 생활습관 유형
enum LifestyleType {
  /// 수면
  sleep('수면', '😴', '수면 시간 및 질'),

  /// 운동
  exercise('운동', '🏃', '운동 종류 및 강도'),

  /// 스트레스
  stress('스트레스', '😰', '스트레스 수준'),

  /// 흡연
  smoking('흡연', '🚬', '흡연 여부'),

  /// 자세
  posture('자세', '🧘', '식후 자세');

  const LifestyleType(this.label, this.emoji, this.description);

  /// 라벨
  final String label;

  /// 이모지
  final String emoji;

  /// 설명
  final String description;
}
