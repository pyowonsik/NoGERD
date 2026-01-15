import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'meal_record_model.freezed.dart';
part 'meal_record_model.g.dart';

@freezed
class MealRecordModel with _$MealRecordModel {
  const factory MealRecordModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'record_datetime') required DateTime recordedAt,
    @JsonKey(name: 'meal_type') required String mealType,
    required List<String> foods,
    @JsonKey(name: 'trigger_categories') List<String>? triggerCategories,
    @JsonKey(name: 'fullness_level') required int fullnessLevel,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MealRecordModel;

  const MealRecordModel._();

  factory MealRecordModel.fromJson(Map<String, dynamic> json) =>
      _$MealRecordModelFromJson(json);

  MealRecord toEntity() {
    return MealRecord(
      id: id,
      recordedAt: recordedAt,
      mealType: MealType.values.firstWhere(
        (e) => e.name == mealType,
        orElse: () => MealType.snack,
      ),
      foods: foods,
      triggerCategories: triggerCategories
          ?.map((t) => TriggerFoodCategory.values.firstWhere(
                (e) => e.name == t,
                orElse: () => TriggerFoodCategory.fatty,
              ))
          .toList(),
      fullnessLevel: fullnessLevel,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory MealRecordModel.fromEntity(MealRecord entity, String userId) {
    return MealRecordModel(
      id: entity.id,
      userId: userId,
      recordedAt: entity.recordedAt,
      mealType: entity.mealType.name,
      foods: entity.foods,
      triggerCategories: entity.triggerCategories?.map((t) => t.name).toList(),
      fullnessLevel: entity.fullnessLevel,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
