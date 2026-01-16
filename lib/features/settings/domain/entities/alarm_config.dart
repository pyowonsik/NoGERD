import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_config.freezed.dart';
part 'alarm_config.g.dart';

/// 알림 타입 정의
enum AlarmType {
  /// 아침 식사 알림
  breakfast,

  /// 점심 식사 알림
  lunch,

  /// 저녁 식사 알림
  dinner,

  /// 아침 약물 복용 알림
  morningMedicine,

  /// 점심 약물 복용 알림
  lunchMedicine,

  /// 저녁 약물 복용 알림
  dinnerMedicine,

  /// 취침 시간 알림
  bedtime,
}

/// AlarmType 확장 메서드
extension AlarmTypeX on AlarmType {
  /// 알림 ID (네이티브에서 사용)
  int get id {
    switch (this) {
      case AlarmType.breakfast:
        return 1;
      case AlarmType.lunch:
        return 2;
      case AlarmType.dinner:
        return 3;
      case AlarmType.morningMedicine:
        return 4;
      case AlarmType.lunchMedicine:
        return 5;
      case AlarmType.dinnerMedicine:
        return 6;
      case AlarmType.bedtime:
        return 7;
    }
  }

  /// 알림 제목
  String get title {
    switch (this) {
      case AlarmType.breakfast:
        return '아침 식사 시간';
      case AlarmType.lunch:
        return '점심 식사 시간';
      case AlarmType.dinner:
        return '저녁 식사 시간';
      case AlarmType.morningMedicine:
        return '아침 약물 복용 시간';
      case AlarmType.lunchMedicine:
        return '점심 약물 복용 시간';
      case AlarmType.dinnerMedicine:
        return '저녁 약물 복용 시간';
      case AlarmType.bedtime:
        return '취침 시간';
    }
  }

  /// 알림 본문
  String get body {
    switch (this) {
      case AlarmType.breakfast:
        return '아침 식사 시간입니다. 건강한 식사를 하세요!';
      case AlarmType.lunch:
        return '점심 식사 시간입니다. 건강한 식사를 하세요!';
      case AlarmType.dinner:
        return '저녁 식사 시간입니다. 건강한 식사를 하세요!';
      case AlarmType.morningMedicine:
        return '아침 약을 복용할 시간입니다.';
      case AlarmType.lunchMedicine:
        return '점심 약을 복용할 시간입니다.';
      case AlarmType.dinnerMedicine:
        return '저녁 약을 복용할 시간입니다.';
      case AlarmType.bedtime:
        return '취침 시간입니다. 편안한 밤 되세요.';
    }
  }
}

/// 알림 설정 엔티티
@freezed
class AlarmConfig with _$AlarmConfig {
  /// 생성자
  const factory AlarmConfig({
    /// 알림 타입
    required AlarmType type,

    /// 활성화 여부
    required bool enabled,

    /// 시간 (0-23)
    required int hour,

    /// 분 (0-59)
    required int minute,
  }) = _AlarmConfig;

  /// JSON에서 생성
  factory AlarmConfig.fromJson(Map<String, dynamic> json) =>
      _$AlarmConfigFromJson(json);

  /// 기본 설정 생성
  factory AlarmConfig.initial(AlarmType type) {
    // 기본 시간 설정
    int defaultHour;
    int defaultMinute;

    switch (type) {
      case AlarmType.breakfast:
        defaultHour = 7;
        defaultMinute = 30;
      case AlarmType.lunch:
        defaultHour = 12;
        defaultMinute = 0;
      case AlarmType.dinner:
        defaultHour = 18;
        defaultMinute = 0;
      case AlarmType.morningMedicine:
        defaultHour = 8;
        defaultMinute = 0;
      case AlarmType.lunchMedicine:
        defaultHour = 12;
        defaultMinute = 30;
      case AlarmType.dinnerMedicine:
        defaultHour = 18;
        defaultMinute = 30;
      case AlarmType.bedtime:
        defaultHour = 22;
        defaultMinute = 0;
    }

    return AlarmConfig(
      type: type,
      enabled: false,
      hour: defaultHour,
      minute: defaultMinute,
    );
  }
}
