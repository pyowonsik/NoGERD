// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlarmConfigImpl _$$AlarmConfigImplFromJson(Map<String, dynamic> json) =>
    _$AlarmConfigImpl(
      type: $enumDecode(_$AlarmTypeEnumMap, json['type']),
      enabled: json['enabled'] as bool,
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
    );

Map<String, dynamic> _$$AlarmConfigImplToJson(_$AlarmConfigImpl instance) =>
    <String, dynamic>{
      'type': _$AlarmTypeEnumMap[instance.type]!,
      'enabled': instance.enabled,
      'hour': instance.hour,
      'minute': instance.minute,
    };

const _$AlarmTypeEnumMap = {
  AlarmType.breakfast: 'breakfast',
  AlarmType.lunch: 'lunch',
  AlarmType.dinner: 'dinner',
  AlarmType.morningMedicine: 'morningMedicine',
  AlarmType.lunchMedicine: 'lunchMedicine',
  AlarmType.dinnerMedicine: 'dinnerMedicine',
  AlarmType.bedtime: 'bedtime',
};
