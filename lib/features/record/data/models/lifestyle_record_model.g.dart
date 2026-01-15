// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifestyle_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LifestyleRecordModelImpl _$$LifestyleRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LifestyleRecordModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.parse(json['record_datetime'] as String),
      lifestyleType: json['lifestyle_type'] as String,
      details: json['details'] as Map<String, dynamic>,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$LifestyleRecordModelImplToJson(
        _$LifestyleRecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'record_datetime': instance.recordedAt.toIso8601String(),
      'lifestyle_type': instance.lifestyleType,
      'details': instance.details,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
