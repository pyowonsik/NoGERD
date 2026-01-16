import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';

/// 알림 예약 UseCase
@injectable
class ScheduleAlarmUseCase implements UseCase<bool, ScheduleAlarmParams> {
  /// 생성자
  const ScheduleAlarmUseCase(this._repository);
  final AlarmRepository _repository;

  @override
  Future<Either<Failure, bool>> call(ScheduleAlarmParams params) async {
    return _repository.scheduleAlarm(params.config);
  }
}

/// 알림 예약 파라미터
class ScheduleAlarmParams extends Equatable {
  /// 생성자
  const ScheduleAlarmParams(this.config);

  /// 알림 설정
  final AlarmConfig config;

  @override
  List<Object?> get props => [config];
}
