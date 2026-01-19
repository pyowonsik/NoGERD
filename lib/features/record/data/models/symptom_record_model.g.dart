// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SymptomRecordModelImpl _$$SymptomRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SymptomRecordModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.parse(json['record_datetime'] as String),
      symptoms:
          (json['symptoms'] as List<dynamic>).map((e) => e as String).toList(),
      severity: (json['severity'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      notes: json['notes'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SymptomRecordModelImplToJson(
        _$SymptomRecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'record_datetime': instance.recordedAt.toIso8601String(),
      'symptoms': instance.symptoms,
      'severity': instance.severity,
      'created_at': instance.createdAt.toIso8601String(),
      'notes': instance.notes,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
