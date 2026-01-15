import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'lifestyle_record.freezed.dart';

/// 생활습관 기록 Entity
@freezed
class LifestyleRecord with _$LifestyleRecord {
  /// 생성자
  const factory LifestyleRecord({
    /// 고유 ID
    required String id,

    /// 기록 시간
    required DateTime recordedAt,

    /// 생활습관 유형
    required LifestyleType lifestyleType,

    /// 상세 정보 (JSON 형태로 저장)
    /// 예: 수면 - {"duration": 7, "quality": 8}
    /// 예: 운동 - {"type": "걷기", "duration": 30, "intensity": 5}
    /// 예: 스트레스 - {"level": 7}
    required Map<String, dynamic> details,

    /// 메모
    String? notes,

    /// 생성 시간
    required DateTime createdAt,

    /// 수정 시간
    DateTime? updatedAt,
  }) = _LifestyleRecord;
}
