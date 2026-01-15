import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_summary.freezed.dart';

/// 오늘의 기록 요약
@freezed
class RecordSummary with _$RecordSummary {
  /// 생성자
  const factory RecordSummary({
    /// 라벨 (증상, 식사, 약물, 수면 등)
    required String label,

    /// 값 (2회, 3회, 7시간 등)
    required String value,

    /// 부가 설명 (가벼움, 정상, 양호 등)
    required String subValue,

    /// 아이콘 코드
    required int iconCode,

    /// 색상 값 (ARGB)
    required int colorValue,
  }) = _RecordSummary;

  /// 초기값
  factory RecordSummary.initial() => const RecordSummary(
        label: '',
        value: '0',
        subValue: '',
        iconCode: 0,
        colorValue: 0,
      );
}
