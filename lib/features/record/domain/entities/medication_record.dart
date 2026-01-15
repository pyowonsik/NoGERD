import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'medication_record.freezed.dart';

/// 약물 기록 Entity
@freezed
class MedicationRecord with _$MedicationRecord {
  /// 생성자
  const factory MedicationRecord({
    /// 고유 ID
    required String id,

    /// 기록 시간
    required DateTime recordedAt,

    /// 약물 복용 여부 (true: 복용함, false: 복용 안함)
    @Default(true) bool isTaken,

    /// 약물 종류 목록 (복용 안함일 경우 null, 여러 종류 선택 가능)
    List<MedicationType>? medicationTypes,

    /// 약물 이름 (복용 안함일 경우 null)
    String? medicationName,

    /// 용량 (복용 안함일 경우 null)
    String? dosage,

    /// 복용 목적
    String? purpose,

    /// 효과 평가 (1-10)
    int? effectiveness,

    /// 메모
    String? notes,

    /// 생성 시간
    required DateTime createdAt,

    /// 수정 시간
    DateTime? updatedAt,
  }) = _MedicationRecord;
}
