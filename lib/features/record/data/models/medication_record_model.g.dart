// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicationRecordModelImpl _$$MedicationRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MedicationRecordModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.parse(json['record_datetime'] as String),
      isTaken: json['is_taken'] as bool? ?? true,
      medicationTypes: (json['medication_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      medicationName: json['medication_name'] as String?,
      dosage: json['dosage'] as String?,
      purpose: json['purpose'] as String?,
      effectiveness: (json['effectiveness'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MedicationRecordModelImplToJson(
        _$MedicationRecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'record_datetime': instance.recordedAt.toIso8601String(),
      'is_taken': instance.isTaken,
      'medication_types': instance.medicationTypes,
      'medication_name': instance.medicationName,
      'dosage': instance.dosage,
      'purpose': instance.purpose,
      'effectiveness': instance.effectiveness,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
