import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';

/// 알림 취소 UseCase
@injectable
class CancelAlarmUseCase implements UseCase<bool, CancelAlarmParams> {
  /// 생성자
  const CancelAlarmUseCase(this._repository);
  final AlarmRepository _repository;

  @override
  Future<Either<Failure, bool>> call(CancelAlarmParams params) async {
    return _repository.cancelAlarm(params.id);
  }
}

/// 알림 취소 파라미터
class CancelAlarmParams extends Equatable {
  /// 생성자
  const CancelAlarmParams(this.id);

  /// 알림 ID
  final int id;

  @override
  List<Object?> get props => [id];
}
