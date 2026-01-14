import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'meal_record.freezed.dart';

/// 식사 기록 Entity
@freezed
class MealRecord with _$MealRecord {
  /// 생성자
  const factory MealRecord({
    /// 고유 ID
    required String id,

    /// 기록 시간
    required DateTime recordedAt,

    /// 식사 유형
    required MealType mealType,

    /// 음식 목록
    required List<String> foods,

    /// 트리거 음식 카테고리
    List<TriggerFoodCategory>? triggerCategories,

    /// 포만감 (1-10)
    required int fullnessLevel,

    /// 메모
    String? notes,

    /// 생성 시간
    required DateTime createdAt,

    /// 수정 시간
    DateTime? updatedAt,
  }) = _MealRecord;
}
