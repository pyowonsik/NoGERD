// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerd_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GerdRecordImpl _$$GerdRecordImplFromJson(Map<String, dynamic> json) =>
    _$GerdRecordImpl(
      date: json['date'] as String,
      symptoms:
          (json['symptoms'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$$GerdRecordImplToJson(_$GerdRecordImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'symptoms': instance.symptoms,
      'status': instance.status,
      'notes': instance.notes,
    };
