import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 설정 저장 UseCase
@injectable
class SaveSettingsUseCase implements UseCase<Unit, AppSettings> {
  /// 생성자
  const SaveSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AppSettings params) async {
    return _repository.saveSettings(params);
  }
}
