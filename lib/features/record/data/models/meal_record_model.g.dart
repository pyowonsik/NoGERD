// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealRecordModelImpl _$$MealRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MealRecordModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.parse(json['record_datetime'] as String),
      mealType: json['meal_type'] as String,
      foods: (json['foods'] as List<dynamic>).map((e) => e as String).toList(),
      triggerCategories: (json['trigger_categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      fullnessLevel: (json['fullness_level'] as num).toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MealRecordModelImplToJson(
        _$MealRecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'record_datetime': instance.recordedAt.toIso8601String(),
      'meal_type': instance.mealType,
      'foods': instance.foods,
      'trigger_categories': instance.triggerCategories,
      'fullness_level': instance.fullnessLevel,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
