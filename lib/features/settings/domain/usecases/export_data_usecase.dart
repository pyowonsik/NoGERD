import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 데이터 내보내기 UseCase
@injectable
class ExportDataUseCase implements UseCase<String, NoParams> {
  final SettingsRepository _repository;

  /// 생성자
  const ExportDataUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return _repository.exportData();
  }
}
