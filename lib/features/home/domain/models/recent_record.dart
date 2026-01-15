import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_record.freezed.dart';

/// 최근 기록 아이템
@freezed
class RecentRecord with _$RecentRecord {
  /// 생성자
  const factory RecentRecord({
    /// 제목
    required String title,

    /// 부제목
    required String subtitle,

    /// 시간
    required String time,

    /// 이모지
    required String emoji,

    /// 색상 값 (ARGB)
    required int colorValue,

    /// 원본 엔티티 (상세보기에 사용)
    dynamic originalEntity,
  }) = _RecentRecord;

  /// 초기값
  factory RecentRecord.initial() => const RecentRecord(
        title: '',
        subtitle: '',
        time: '',
        emoji: '',
        colorValue: 0,
        originalEntity: null,
      );
}
