// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIInsightImpl _$$AIInsightImplFromJson(Map<String, dynamic> json) =>
    _$AIInsightImpl(
      summary: json['summary'] as String,
      dietAdvice: json['dietAdvice'] as String,
      lifestyleAdvice: json['lifestyleAdvice'] as String,
      triggerWarning: json['triggerWarning'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$AIInsightImplToJson(_$AIInsightImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'dietAdvice': instance.dietAdvice,
      'lifestyleAdvice': instance.lifestyleAdvice,
      'triggerWarning': instance.triggerWarning,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };
