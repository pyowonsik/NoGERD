import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';

/// 모든 알림 설정 조회 UseCase
@injectable
class GetAlarmConfigsUseCase implements UseCase<List<AlarmConfig>, NoParams> {
  /// 생성자
  const GetAlarmConfigsUseCase(this._repository);
  final AlarmRepository _repository;

  @override
  Future<Either<Failure, List<AlarmConfig>>> call(NoParams params) async {
    return _repository.getAllAlarmConfigs();
  }
}
