import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 설정 로드 UseCase
@injectable
class LoadSettingsUseCase implements UseCase<AppSettings, NoParams> {
  /// 생성자
  const LoadSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    return _repository.loadSettings();
  }
}
