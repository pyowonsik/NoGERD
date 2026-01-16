import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'symptom_record.freezed.dart';

/// 증상 기록 Entity
@freezed
class SymptomRecord with _$SymptomRecord {
  /// 생성자
  const factory SymptomRecord({
    /// 고유 ID
    required String id,

    /// 기록 시간
    required DateTime recordedAt,

    /// 증상 목록
    required List<GerdSymptom> symptoms,

    /// 심각도 (1-10)
    required int severity,

    /// 생성 시간
    required DateTime createdAt,

    /// 메모
    String? notes,

    /// 수정 시간
    DateTime? updatedAt,
  }) = _SymptomRecord;
}
